
use crate::{ControlROM, DEFAULT_CW, IOMessage, IOPorts};
use crate::control_word::ControlWord;
use crate::devices::{GlobalSignalsReceiver, ValueSource};
use crate::runtime_state::BusValues;
use crate::router::DeviceMap;

pub struct Cpu<P> where P: IOPorts {
    devices: DeviceMap<P>,
    control_word: ControlWord,
    bus_values: BusValues,
}


impl<P: IOPorts> Cpu<P> {
    pub fn new(ioports: P) -> Self {
        let devices = DeviceMap::new(ioports);
        let mut bus_values = BusValues::new();
        devices.route_word(&mut bus_values, !DEFAULT_CW, DEFAULT_CW); // Ensure we start from the default state
        Cpu {
            devices,
            control_word: DEFAULT_CW,
            bus_values,
        }
    }

    pub fn apply_control_word(&mut self, new_cw: ControlWord) {
        self.devices.route_word(&mut self.bus_values, self.control_word, new_cw);
        self.bus_values.resolve(&self.devices);
        self.control_word = new_cw;
    }

    pub fn clock_pulse_primary(&mut self) {
        self.devices.broadcast_clock_tick_primary(&mut self.bus_values);
    }

    pub fn clock_pulse_secondary(&mut self) {
        self.devices.broadcast_clock_tick_secondary();
    }

    pub fn clock_tick(&mut self) -> Option<IOMessage> {
        self.clock_pulse_primary();
        self.clock_pulse_secondary();
        self.bus_values.message.take()
    }

    pub fn inject_main_bus_value(&mut self, value: u8) {
        // The injection can come either before or after the control word is applied.
        // Meaning that the bus value might or might not be resolved yet. So we set
        // a value to use for the resolver and also the value directly.
        self.bus_values.injected_main_bus_value = Some(value);
        self.bus_values.main_bus.value = Some(value);
    }

    pub fn inject_address_bus_value(&mut self, value: u16) {
        // Same logic for the timing of the injection as for the main bus value.
        self.bus_values.injected_address_bus_value = Some(value);
        self.bus_values.address_bus.value = Some(value);
    }

    pub fn read_main_bus_value(&self) -> u8 {
        self.bus_values.main_bus.value.unwrap()
    }

    pub fn read_address_bus_value(&self) -> u16 {
        self.bus_values.address_bus.value.unwrap()
    }

    pub fn read_flags_value(&self) -> u8 {
        self.devices.F.get_value(&self.bus_values)
    }

    pub fn read_instruction_register(&self) -> u8 {
        self.devices.IR.get_value(&self.bus_values)
    }

    pub fn reset(&mut self) {
        self.devices.broadcast_reset();
    }

    pub fn clear_injected_values(&mut self) {
        self.bus_values.injected_main_bus_value = None;
        self.bus_values.injected_address_bus_value = None;
    }

    pub fn run_until_message(&mut self) -> Option<IOMessage> {
        //TODO: At the moment there's no "count disable" for the StepCounter and it
        // will keep counting on every clock tick, even if it comes from outside source.
        // A quick fix is to reset the StepCounter before running the program.
        self.devices.StepCounter.on_reset();
        loop {
            let message = self.execute_step();
            if message.is_some() {
                return message;
            }
        }
    }

    fn load_control_word(&self) -> ControlWord {
        let opcode = self.devices.IR.get_value(&self.bus_values) as usize;
        let op_ext = self.devices.StepCounter.get_extended_value();
        let step = self.devices.StepCounter.get_value(&self.bus_values) as usize;
        let flags = ValueSource::<u8>::get_value(&self.devices.F, &self.bus_values) as usize;

        // The Control ROM is addressed by a combination of bits (least-to-most significant):
        // * 3 bits of the step counter
        // * 4 bits of the flags register
        // * 8 bits of the opcode
        // * 1 (or more) bits of the opcode extension

        let rom_addr = (op_ext << 15) | (opcode << 7) | (flags << 3) | step;
        ControlROM::get_value(rom_addr)
    }

    fn execute_step(&mut self) -> Option<IOMessage> {
        let control_word = self.load_control_word();
        self.apply_control_word(control_word);
        self.clock_tick()
    }
}

#[cfg(test)]
mod tests {
    use crate::{control_word::ControlWordBuilder, router::{AddrInc, AddrOutMux, LoadMux, OutMux}, test_helpers::TestIOPorts};
    use super::*;

    #[test]
    fn test_first_fetch_control_word() {
        let mut cpu = Cpu::new(TestIOPorts::new());
        cpu.reset();

        // The first control word after the reset should always be a fetch.
        let control_word = cpu.load_control_word();

        // fetch:
        //   - - PC.out
        //     - PC.inc
        //     - ProgMem.out
        //     - IR.load

        let expected_cw = ControlWordBuilder::default()
            .apply_mux::<AddrOutMux>(AddrOutMux::VALUE_PC_OUT)
            .apply_bit::<AddrInc>()
            .apply_mux::<OutMux>(OutMux::VALUE_MEMORY_OUT)
            .apply_mux::<LoadMux>(LoadMux::VALUE_IR_LOAD)
            .build();

        assert_eq!(control_word, expected_cw);
    }

    #[test]
    fn test_fetch_ldi_a() {
        let mut cpu = Cpu::new(TestIOPorts::new());
        cpu.reset();

        // Reset sets the PC to Reset Vector (currently 0xE000). Changing back to 0x0000 for this test.
        cpu.devices.PC.set_value(0x0000);

        // Load a program consisting of a single instrucion into memory: ldi A, 0x42
        cpu.devices.Ram.set_data(0x0000, &[0x01, 0x42]); // ldi A, 0x42

        cpu.execute_step(); // Fetch

        assert_eq!(cpu.read_instruction_register(), 0x01); // ldi A, 0x42
    }

    #[test]
    fn test_execute_ldi_a_and_break() {
        let mut cpu = Cpu::new(TestIOPorts::new());
        cpu.reset();
        cpu.devices.PC.set_value(0x0000);

        cpu.devices.Ram.set_data(0x0000, &[0x01, 0x42, 0xe4]); // ldi A, 0x42; brk

        let msg = cpu.run_until_message();

        assert_eq!(msg, Some(IOMessage::Brk));
        assert_eq!(cpu.devices.A.get_value(&cpu.bus_values), 0x42);
    }
}

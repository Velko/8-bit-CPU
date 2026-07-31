use crate::devices::BusOutputPin;
use crate::devices::DelayedPin;
use crate::devices::GlobalSignalsReceiver;
use crate::devices::ValueSource;
use crate::router::AddressBusSource;
use crate::runtime_state::BusValues;

pub struct ProgramCounter {
    pub name: &'static str,
    value_primary: u16,
    value_secondary: u16,
    pub out: BusOutputPin<AddressBusSource>,
    pub load: DelayedPin,
    pub inc: DelayedPin,
}

impl ProgramCounter {
    pub fn new(name: &'static str, address_bus_id: AddressBusSource) -> Self {
        Self {
            name,
            value_primary: 0,
            value_secondary: 0,
            out: BusOutputPin::new(address_bus_id),
            load: DelayedPin::new(),
            inc: DelayedPin::new(),
        }
    }

    pub fn set_value(&mut self, value: u16) {
        self.value_primary = value;
        self.value_secondary = value;
    }
}

impl GlobalSignalsReceiver for ProgramCounter {
    fn on_clock_tick_primary(&mut self, bus_values: &BusValues) {
        if self.load.is_enabled() {
            self.value_primary = bus_values.address_bus.value.unwrap();
        } else if self.inc.is_enabled() {
            self.value_primary = self.value_primary.wrapping_add(1);
        }
    }

    fn on_clock_tick_secondary(&mut self) {
        if self.value_primary != self.value_secondary {
            self.value_secondary = self.value_primary;
        }
    }
    fn on_reset(&mut self) {
        self.value_primary = 0xE000;
        self.value_secondary = 0xE000;
    }
}

impl ValueSource<u16> for ProgramCounter {
    fn get_value(&self, _bus_values: &BusValues) -> u16 {
        self.value_secondary
    }
}

#[cfg(test)]
mod tests {
    use crate::test_helpers::TestBench;
    use crate::router::AddrLoadMux;
    use crate::router::AddrInc;
    use crate::router::AddrOutMux;
    use crate::control_word::ControlWordBuilder;
    use crate::router::DEFAULT_CW;

    #[test]
    fn test_program_counter_out_inc() {
        let mut bench = TestBench::new();
        bench.devices.PC.set_value(0x1234);

        let pc_out_inc_cw = ControlWordBuilder::default()
            .apply_mux::<AddrOutMux>(AddrOutMux::VALUE_PC_OUT)
            .apply_bit::<AddrInc>()
            .build(); // Enable PC Out and Inc
        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, pc_out_inc_cw);

        // broadcasts the original value
        bench.bus_values.resolve(&bench.devices);
        assert_eq!(Some(0x1234), bench.bus_values.address_bus.value);

        // incrementing the value should only affect the internal storage
        bench.devices.broadcast_clock_tick_primary(&bench.bus_values);
        assert_eq!(0x1235, bench.devices.PC.value_primary);

        // check if still broadcasts the original value
        bench.bus_values.resolve(&bench.devices);
        assert_eq!(Some(0x1234), bench.bus_values.address_bus.value);
    }

    #[test]
    fn test_program_counter_load() {
        let mut bench = TestBench::new();
        bench.bus_values.address_bus.value = Some(0x5678); // Simulate loading 42 into A

        let pc_load_cw = ControlWordBuilder::default()
            .apply_mux::<AddrLoadMux>(AddrLoadMux::VALUE_PC_LOAD)
            .build(); // Enable PC Load
        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, pc_load_cw);

        bench.devices.broadcast_clock_tick_primary(&bench.bus_values);

        assert_eq!(0x5678, bench.devices.PC.value_primary);
        assert_eq!(0, bench.devices.PC.value_secondary);

        bench.devices.broadcast_clock_tick_secondary();
        assert_eq!(0x5678, bench.devices.PC.value_secondary);
    }
}

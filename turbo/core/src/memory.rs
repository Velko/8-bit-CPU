use crate::devices::BusOutputPin;
use crate::devices::DelayedPin;
use crate::devices::GlobalSignalsReceiver;
use crate::devices::ValueSource;
use crate::router::MainBusSource;
use crate::runtime_state::BusValues;

const ADDRESS_SPACE_SIZE: usize = 0x10000; // 64KB
const ROM_SIZE: usize = 0x2000; // 8KB
const RAM_SIZE: usize = ADDRESS_SPACE_SIZE - ROM_SIZE; // 56KB

pub struct RAM {
    pub name: &'static str,
    pub write: DelayedPin,
    pub out: BusOutputPin<MainBusSource>,
    data: [u8; RAM_SIZE],
}

impl RAM {
    pub fn new(name: &'static str, main_id: MainBusSource) -> Self {
        Self {
            name,
            write: DelayedPin::new(),
            out: BusOutputPin::new(main_id),
            data: [0; RAM_SIZE]
        }
    }

    pub fn set_data(&mut self, address: usize, value: &[u8]) {
        let end_address = address + value.len();
        if end_address > RAM_SIZE {
            panic!("Attempt to write beyond RAM size");
        }
        self.data[address..end_address].copy_from_slice(value);
    }
}
impl GlobalSignalsReceiver for RAM {
        fn on_clock_tick_primary(&mut self, bus_values: &BusValues) {
        if self.write.is_enabled() {
            if let Some(address) = bus_values.address_bus.value {
                let address = address as usize;
                if address < RAM_SIZE {
                    if let Some(value) = bus_values.main_bus.value {
                        self.data[address] = value;
                    }
                }
            }
        }
    }
}

impl ValueSource<u8> for RAM {
    fn get_value(&self, bus_values: &BusValues) -> u8 {
        let address = bus_values.address_bus.value.unwrap() as usize;
        self.data[address]
    }
}

pub struct ROM {
    pub name: &'static str,
    pub out: BusOutputPin<MainBusSource>,
}

impl ROM {
    pub fn new(name: &'static str, main_id: MainBusSource) -> Self {
        Self {
            name,
            out: BusOutputPin::new(main_id),
        }
    }
}
impl GlobalSignalsReceiver for ROM {}
impl ValueSource<u8> for ROM {
    fn get_value(&self, bus_values: &BusValues) -> u8 {
        todo!()
    }
}

#[cfg(test)]
mod tests {
    use crate::{
        control_word::ControlWordBuilder, devices::{ValueSource}, router::{AddrOutMux, DEFAULT_CW, LoadMux, OutMux}, test_helpers::TestBench
    };

    #[test]
    fn test_ram_fetch_instruction() {
        let mut bench = TestBench::new();
        bench.devices.Ram.set_data(0x0000, &[1, 2, 3, 4]);
        bench.devices.PC.set_value(2);

        let fetch_cw = ControlWordBuilder::default()
            .apply_mux::<OutMux>(OutMux::VALUE_MEMORY_OUT)
            .apply_mux::<AddrOutMux>(AddrOutMux::VALUE_PC_OUT)
            .apply_mux::<LoadMux>(LoadMux::VALUE_IR_LOAD)
            .build();

        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, fetch_cw);

        bench.bus_values.resolve(&bench.devices);

        assert_eq!(bench.bus_values.main_bus.value, Some(3));

        bench.devices.broadcast_clock_tick_primary(&bench.bus_values);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(bench.devices.IR.get_value(&bench.bus_values), 3);
    }

    #[test]
    fn test_ram_write() {
        let mut bench = TestBench::new();
        bench.devices.PC.set_value(2);
        bench.devices.A.set_value(42);

        // a bit unusual combination to write @ PC, but for now that is my only
        // working Address register
        let write_at_pc_cw = ControlWordBuilder::default()
            .apply_mux::<OutMux>(OutMux::VALUE_A_OUT)
            .apply_mux::<AddrOutMux>(AddrOutMux::VALUE_PC_OUT)
            .apply_mux::<LoadMux>(LoadMux::VALUE_RAM_WRITE)
            .build();

        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, write_at_pc_cw);
        bench.bus_values.resolve(&bench.devices);

        bench.devices.broadcast_clock_tick_primary(&bench.bus_values);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(bench.devices.Ram.data[2], 42);
    }
}

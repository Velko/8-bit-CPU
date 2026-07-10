use std::cell::Cell;
use crate::devices::OutReceiver;
use crate::devices::ClockReceiver;
use crate::devices::ValueSource;
use crate::router::DeviceMap;
use crate::router::MainBusSource;
use crate::runtime_state::{ArgValues, ArgSources};

const ADDRESS_SPACE_SIZE: usize = 0x10000; // 64KB
const ROM_SIZE: usize = 0x2000; // 8KB
const RAM_SIZE: usize = ADDRESS_SPACE_SIZE - ROM_SIZE; // 56KB

pub struct RAM {
    pub name: &'static str,
    write_enable: Cell<bool>,
    main_id: MainBusSource,
    data: [u8; RAM_SIZE],
}

impl OutReceiver for RAM {
    fn on_out_change(&self, args: &mut ArgSources, enable: bool) {
        args.main_bus_source = if enable { Some(self.main_id) } else { None };
    }
}

impl RAM {
    pub fn new(name: &'static str, main_id: MainBusSource) -> Self {
        Self {
            name,
            write_enable: Cell::new(false),
            main_id,
            data: [0; RAM_SIZE]
        }
    }
    pub fn on_write_change(&self, _args: &mut ArgSources, enable: bool) {
        self.write_enable.set(enable);
    }

    pub fn set_data(&mut self, address: usize, value: &[u8]) {
        let end_address = address + value.len();
        if end_address > RAM_SIZE {
            panic!("Attempt to write beyond RAM size");
        }
        self.data[address..end_address].copy_from_slice(value);
    }
}
impl ClockReceiver for RAM {
        fn on_clock_tick_primary(&mut self, args: &ArgValues) {
        if self.write_enable.get() {
            if let Some(address) = args.address_bus_value {
                let address = address as usize;
                if address < RAM_SIZE {
                    if let Some(value) = args.main_bus_value {
                        self.data[address] = value;
                    }
                }
            }
        }
    }
}

impl ValueSource<u8> for RAM {
    fn get_value(&self, devices: &DeviceMap, args: &ArgSources) -> u8 {
        let address = args.address_bus_source.map(|source| devices.get_address_bus_value(source, args)).unwrap() as usize;
        self.data[address]
    }
}

pub struct ROM {
    pub name: &'static str,
}
impl OutReceiver for ROM {}
impl ROM {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
}
impl ClockReceiver for ROM {}


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

        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, fetch_cw);

        let values = bench.sources.resolve(&bench.devices);

        assert_eq!(values.main_bus_value, Some(3));

        bench.devices.broadcast_clock_tick_primary(&values);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(bench.devices.IR.get_value(&bench.devices, &bench.sources), 3);
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

        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, write_at_pc_cw);
        let values = bench.sources.resolve(&bench.devices);

        bench.devices.broadcast_clock_tick_primary(&values);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(bench.devices.Ram.data[2], 42);
    }
}

use std::cell::Cell;
use crate::devices::OutReceiver;
use crate::devices::LoadReceiver;
use crate::devices::ClockReceiver;
use crate::devices::IncReceiver;
use crate::devices::ValueSource;
use crate::router::AddressBusSource;
use crate::router::DeviceMap;
use crate::runtime_state::{ArgSources, ArgValues};

pub struct ProgramCounter {
    pub name: &'static str,
    value_primary: u16,
    value_secondary: u16,
    address_bus_id: AddressBusSource,
    out_enabled: Cell<bool>,
    load_enabled: Cell<bool>,
    inc_enabled: Cell<bool>,
}

impl ProgramCounter {
    pub fn new(name: &'static str, address_bus_id: AddressBusSource) -> Self {
        Self {
            name,
            value_primary: 0,
            value_secondary: 0,
            address_bus_id,
            out_enabled: Cell::new(false),
            load_enabled: Cell::new(false),
            inc_enabled: Cell::new(false),
        }
    }

    pub fn set_value(&mut self, value: u16) {
        self.value_primary = value;
        self.value_secondary = value;
    }
}

impl OutReceiver for ProgramCounter {
    fn on_out_change(&self, args: &mut ArgSources, enable: bool) {
        println!("ProgramCounter {} Out changed to: {}", self.name, enable);
        args.address_bus_source = if enable {
            Some(self.address_bus_id)
        } else {
            None
        };
        //self.out_enabled.set(enable);
    }
}

impl LoadReceiver for ProgramCounter {
    fn on_load_change(&self, args: &mut ArgSources, enable: bool) {
        println!("ProgramCounter {} Load changed to: {}", self.name, enable);
        self.load_enabled.set(enable);
    }
}

impl IncReceiver for ProgramCounter {
    fn on_inc_change(&self, args: &mut ArgSources, enable: bool) {
        println!("ProgramCounter {} Inc changed to: {}", self.name, enable);
        self.inc_enabled.set(enable);
    }
}

impl ClockReceiver for ProgramCounter {
    fn on_clock_tick_primary(&mut self, args: &ArgValues) {
        if self.load_enabled.get() {
            self.value_primary = args.address_bus_value.unwrap();
        } else if self.inc_enabled.get() {
            self.value_primary = self.value_primary.wrapping_add(1);
        }
    }

    fn on_clock_tick_secondary(&mut self) {
        if self.value_primary != self.value_secondary {
            self.value_secondary = self.value_primary;
        }
    }
}

impl ValueSource<u16> for ProgramCounter {
    fn get_value(&self, _devices: &DeviceMap, _args: &ArgSources) -> u16 {
        self.value_secondary
    }
}

#[cfg(test)]
mod tests {
    use super::*;
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
        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, pc_out_inc_cw);

        // broadcasts the original value
        let values = bench.sources.resolve(&bench.devices);
        assert_eq!(Some(0x1234), values.address_bus_value);

        // incrementing the value should only affect the internal storage
        bench.devices.broadcast_clock_tick_primary(&values);
        assert_eq!(0x1235, bench.devices.PC.value_primary);

        // check if still broadcasts the original value
        let values2 = bench.sources.resolve(&bench.devices);
        assert_eq!(Some(0x1234), values2.address_bus_value);
    }

    #[test]
    fn test_program_counter_load() {
        let mut bench = TestBench::new();
        let args = ArgValues {
            main_bus_value: None,
            address_bus_value: Some(0x5678),
            alu_flags_value: None,
        }; // Simulate loading 42 into A

        let pc_load_cw = ControlWordBuilder::default()
            .apply_mux::<AddrLoadMux>(AddrLoadMux::VALUE_PC_LOAD)
            .build(); // Enable PC Load
        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, pc_load_cw);

        bench.devices.broadcast_clock_tick_primary(&args);

        assert_eq!(0x5678, bench.devices.PC.value_primary);
        assert_eq!(0, bench.devices.PC.value_secondary);

        bench.devices.broadcast_clock_tick_secondary();
        assert_eq!(0x5678, bench.devices.PC.value_secondary);
    }
}

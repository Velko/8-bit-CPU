use std::cell::Cell;
use crate::devices::RuntimeState;
use crate::devices::OutReceiver;
use crate::devices::LoadReceiver;
use crate::devices::ClockReceiver;
use crate::devices::IncReceiver;
use crate::devices::ValueSource;
use crate::router::AddressBusSource;
use crate::router::DeviceMap;
use crate::runtime_state::ArgValues;

pub struct ProgramCounter {
    pub name: &'static str,
    value_primary: u16,
    value_secondary: u16,
    out_enabled: Cell<bool>,
    load_enabled: Cell<bool>,
    inc_enabled: Cell<bool>,
}

impl ProgramCounter {
    pub fn new(name: &'static str, _address_bus_id: AddressBusSource) -> Self {
        Self {
            name,
            value_primary: 0,
            value_secondary: 0,
            out_enabled: Cell::new(false),
            load_enabled: Cell::new(false),
            inc_enabled: Cell::new(false),
        }
    }

    pub fn set_value(&mut self, state: &mut RuntimeState, value: u16) {
        self.value_primary = value;
        self.value_secondary = value;
    }
}

impl OutReceiver for ProgramCounter {
    fn on_out_change(&self, state: &mut RuntimeState, enable: bool) {
        println!("ProgramCounter {} Out changed to: {}", self.name, enable);
        state.address_bus = if enable {
            Some(self.value_secondary)
        } else {
            None
        };
        self.out_enabled.set(enable);
    }
}

impl LoadReceiver for ProgramCounter {
    fn on_load_change(&self, _state: &mut RuntimeState, enable: bool) {
        println!("ProgramCounter {} Load changed to: {}", self.name, enable);
        self.load_enabled.set(enable);
    }
}

impl IncReceiver for ProgramCounter {
    fn on_inc_change(&self, _state: &mut RuntimeState, enable: bool) {
        println!("ProgramCounter {} Inc changed to: {}", self.name, enable);
        self.inc_enabled.set(enable);
    }
}

impl ClockReceiver for ProgramCounter {
    fn on_clock_tick_primary(&mut self, args: &ArgValues) {
        // if self.load_enabled.get() {
        //     self.value_primary = args.resolve_address_bus().unwrap_or(0);
        // } else if self.inc_enabled.get() {
        //     self.value_primary = self.value_primary.wrapping_add(1);
        // }
    }

    fn on_clock_tick_secondary(&mut self) {
        if self.value_primary != self.value_secondary {
            self.value_secondary = self.value_primary;
        }
    }
}

impl ValueSource<u16> for ProgramCounter {
    fn get_value(&self, _devices: &DeviceMap) -> u16 {
        self.value_secondary
    }
}

#[cfg(false)]
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
        bench.devices.PC.set_value(&mut bench.state, 0x1234);

        let pc_out_inc_cw = ControlWordBuilder::default()
            .apply_mux::<AddrOutMux>(AddrOutMux::VALUE_PC_OUT)
            .apply_bit::<AddrInc>()
            .build(); // Enable PC Out and Inc
        bench.devices.route_word(&mut bench.state, DEFAULT_CW, pc_out_inc_cw);

        assert_eq!(Some(0x1234), bench.state.address_bus);

        bench.devices.broadcast_clock_tick_primary(&bench.state);
        assert_eq!(0x1235, bench.devices.PC.value_primary);
        assert_eq!(Some(0x1234), bench.state.address_bus);
    }

    #[test]
    fn test_program_counter_load() {
        let mut bench = TestBench::new();
        bench.state.address_bus = Some(0x5678);

        let pc_load_cw = ControlWordBuilder::default()
            .apply_mux::<AddrLoadMux>(AddrLoadMux::VALUE_PC_LOAD)
            .build(); // Enable PC Load
        bench.devices.route_word(&mut bench.state, DEFAULT_CW, pc_load_cw);
        bench.devices.broadcast_clock_tick_primary(&bench.state);

        assert_eq!(0x5678, bench.devices.PC.value_primary);
        assert_eq!(0, bench.devices.PC.value_secondary);

        bench.devices.broadcast_clock_tick_secondary();
        assert_eq!(0x5678, bench.devices.PC.value_secondary);
    }
}

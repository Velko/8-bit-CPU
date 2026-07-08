use std::cell::Cell;
use crate::devices::Buses;
use crate::devices::MainBusValue;
use crate::devices::OutReceiver;
use crate::devices::LoadReceiver;
use crate::devices::ClockReceiver;
 use crate::devices::IncReceiver;
use crate::devices::Peek;
use crate::router::DeviceMap;

pub struct ProgramCounter {
    pub name: &'static str,
    value_primary: u16,
    value_secondary: u16,
    out_enabled: Cell<bool>,
    load_enabled: Cell<bool>,
    inc_enabled: Cell<bool>,
}

impl ProgramCounter {
    pub fn new(name: &'static str) -> Self {
        Self {
            name,
            value_primary: 0,
            value_secondary: 0,
            out_enabled: Cell::new(false),
            load_enabled: Cell::new(false),
            inc_enabled: Cell::new(false),
        }
    }

    pub fn set_value(&mut self, buses: &mut Buses, value: u16) {
        self.value_primary = value;
        self.value_secondary = !value;
        self.on_clock_tick_primary(buses);
        self.on_clock_tick_secondary(buses);
    }
}

impl OutReceiver for ProgramCounter {
    fn on_out_change(&self, buses: &mut Buses, new_state: bool) {
        println!("ProgramCounter {} Out changed to: {}", self.name, new_state);
        buses.address_bus = if new_state {
            Some(self.value_secondary)
        } else {
            None
        };
        self.out_enabled.set(new_state);
    }
}

impl LoadReceiver for ProgramCounter {
    fn on_load_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("ProgramCounter {} Load changed to: {}", self.name, new_state);
        self.load_enabled.set(new_state);
    }
}

impl IncReceiver for ProgramCounter {
    fn on_inc_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("ProgramCounter {} Inc changed to: {}", self.name, new_state);
        self.inc_enabled.set(new_state);
    }
}

impl ClockReceiver for ProgramCounter {
    fn on_clock_tick_primary(&mut self, buses: &mut Buses) {
        if self.load_enabled.get() {
            self.value_primary = buses.address_bus.unwrap_or(0);
        } else if self.inc_enabled.get() {
            self.value_primary = self.value_primary.wrapping_add(1);
        }
    }

    fn on_clock_tick_secondary(&mut self, buses: &mut Buses) {
        if self.value_primary != self.value_secondary {
            if self.out_enabled.get() {
                buses.address_bus = Some(self.value_secondary);
            }
            self.value_secondary = self.value_primary;
        }
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

    #[test]
    fn test_program_counter_out_inc() {
        let mut bench = TestBench::new();
        bench.devices.PC.set_value(&mut bench.buses, 0x1234);

        let pc_out_inc_cw = ControlWordBuilder::default()
            .apply_mux::<AddrOutMux>(AddrOutMux::VALUE_PC_OUT)
            .apply_bit::<AddrInc>()
            .build(); // Enable PC Out and Inc
        bench.devices.route_word(&mut bench.buses, TestBench::DEFAULT_CW, pc_out_inc_cw);

        assert_eq!(Some(0x1234), bench.buses.address_bus);

        bench.devices.broadcast_clock_tick_primary(&mut bench.buses);
        assert_eq!(0x1235, bench.devices.PC.value_primary);
        assert_eq!(Some(0x1234), bench.buses.address_bus);
    }

    #[test]
    fn test_program_counter_load() {
        let mut bench = TestBench::new();
        bench.buses.address_bus = Some(0x5678);

        let pc_load_cw = ControlWordBuilder::default()
            .apply_mux::<AddrLoadMux>(AddrLoadMux::VALUE_PC_LOAD)
            .build(); // Enable PC Load
        bench.devices.route_word(&mut bench.buses, TestBench::DEFAULT_CW, pc_load_cw);
        bench.devices.broadcast_clock_tick_primary(&mut bench.buses);

        assert_eq!(0x5678, bench.devices.PC.value_primary);
        assert_eq!(0, bench.devices.PC.value_secondary);

        bench.devices.broadcast_clock_tick_secondary(&mut bench.buses);
        assert_eq!(0x5678, bench.devices.PC.value_secondary);
    }
}

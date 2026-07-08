use std::cell::Cell;
use crate::devices::Buses;
use crate::devices::MainBusValue;
use crate::devices::LoadReceiver;
use crate::devices::ClockReceiver;
use crate::devices::Peek;
use crate::router::DeviceMap;

pub struct TempRegister {
    pub name: &'static str,
    value_primary: u8,
    value_secondary: u8,
    load_enabled: Cell<bool>,
    arg_r_enabled: Cell<bool>,

}
impl LoadReceiver for TempRegister {
    fn on_load_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("TempRegister {} Load changed to: {}", self.name, new_state);
        self.load_enabled.set(new_state);
    }
}
impl TempRegister {
    pub fn new(name: &'static str) -> Self {
        Self {
            name,
            value_primary: 0,
            value_secondary: 0,
            load_enabled: Cell::new(false),
            arg_r_enabled: Cell::new(false)
        }
    }
    pub fn on_alu_r_change(&self, buses: &mut Buses, new_state: bool) {
        println!("TempRegister {} ALU R changed to: {}", self.name, new_state);
        self.arg_r_enabled.set(new_state);
        buses.alu_r_bus = if new_state {
            Some(self.value_secondary)
        } else {
            None
        };
    }

    pub fn set_value(&mut self, buses: &mut Buses, value: u8) {
        self.value_primary = value;
        self.value_secondary = !value;
        self.on_clock_tick_primary(buses);
        self.on_clock_tick_secondary(buses);
    }
}

impl ClockReceiver for TempRegister {
    fn on_clock_tick_primary(&mut self, buses: &mut Buses) {
        if self.load_enabled.get() {
            self.value_primary = buses.resolve_main_bus();
        }
    }
    fn on_clock_tick_secondary(&mut self, buses: &mut Buses) {
        if self.value_primary != self.value_secondary {
            if self.arg_r_enabled.get() {
                buses.alu_r_bus = Some(self.value_primary);
            }
            self.value_secondary = self.value_primary;
        }
    }
}

impl Peek<u8> for TempRegister {
    fn peek(&self) -> u8 {
        self.value_secondary
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::test_helpers::TestBench;

    #[test]
    fn test_load_t() {
        let mut bench = TestBench::new();
        let load_t_cw = 0x07ff586f; // load_T

        bench.devices.route_word(&mut bench.buses, TestBench::DEFAULT_CW, load_t_cw);
        bench.buses.main_bus = MainBusValue::Const(42); // Simulate loading 42 into T

        bench.devices.broadcast_clock_tick_primary(&mut bench.buses);

        assert_eq!(42, bench.devices.T.value_primary); // Check if T has the value 42 after clock tick
    }
}

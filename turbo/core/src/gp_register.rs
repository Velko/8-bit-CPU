use std::cell::Cell;
use crate::devices::Buses;
use crate::devices::MainBusValue;
use crate::devices::OutReceiver;
use crate::devices::LoadReceiver;
use crate::devices::ClockReceiver;
use crate::devices::Peek;
use crate::router::DeviceMap;

pub struct GPRegister {
    pub name: &'static str,
    value_primary: u8,
    value_secondary: u8,
    out_enabled: Cell<bool>,
    load_enabled: Cell<bool>,
    arg_l_enabled: Cell<bool>,
    arg_r_enabled: Cell<bool>,
}

impl OutReceiver for GPRegister {
    fn on_out_change(&self, buses: &mut Buses, new_state: bool) {
        println!("GPRegister {} Out changed to: {}", self.name, new_state);
        buses.main_bus = if new_state {
            MainBusValue::Const(self.value_secondary)
        } else {
            MainBusValue::None
        };
        self.out_enabled.set(new_state);
    }
}

impl LoadReceiver for GPRegister {
    fn on_load_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("GPRegister {} Load changed to: {}", self.name, new_state);
        self.load_enabled.set(new_state);
    }
}

impl ClockReceiver for GPRegister {
    fn on_clock_tick_primary(&mut self, buses: &mut Buses) {
        if self.load_enabled.get() {
            self.value_primary = buses.resolve_main_bus();
        }
    }
    fn on_clock_tick_secondary(&mut self, buses: &mut Buses) {
        if self.value_primary != self.value_secondary {
            if self.out_enabled.get() {
                buses.main_bus = MainBusValue::Const(self.value_primary);
            }
            if self.arg_l_enabled.get() {
                buses.alu_l_bus = Some(self.value_primary);
            }
            if self.arg_r_enabled.get() {
                buses.alu_r_bus = Some(self.value_primary);
            }
            self.value_secondary = self.value_primary;
        }
    }
}

impl Peek<u8> for GPRegister {
    fn peek(&self) -> u8 {
        self.value_secondary
    }
}

impl GPRegister {
    pub fn new(name: &'static str) -> Self {
        Self {
            name,
            value_primary: 0,
            value_secondary: 0,
            out_enabled: Cell::new(false),
            load_enabled: Cell::new(false),
            arg_l_enabled: Cell::new(false),
            arg_r_enabled: Cell::new(false),
        }
    }

    pub fn on_alu_l_change(&self, buses: &mut Buses, new_state: bool) {
        println!("GPRegister {} ALU L changed to: {}", self.name, new_state);
        self.arg_l_enabled.set(new_state);
        buses.alu_l_bus = if new_state {
            Some(self.value_secondary)
        } else {
            None
        };
    }
    pub fn on_alu_r_change(&self, buses: &mut Buses, new_state: bool) {
        println!("GPRegister {} ALU R changed to: {}", self.name, new_state);
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


#[cfg(test)]
mod tests {
    use super::*;
    use crate::test_helpers::TestBench;
    use crate::router::{MuxDispatcher, LoadMux, OutMux};
    use crate::control_word::ControlWordBuilder;
    use crate::router::DEFAULT_CW;

    #[test]
    fn test_gp_register() {
        let mut buses = Buses::new();
        let mut gp_reg = GPRegister::new("GP1");

        // Simulate loading a value into the register
        gp_reg.load_enabled.set(true);
        buses.main_bus = MainBusValue::Const(42);
        gp_reg.on_clock_tick_primary(&mut buses);
        assert_eq!(gp_reg.value_primary, 42);

        // Simulate clock tick secondary
        gp_reg.on_clock_tick_secondary(&mut buses);
        assert_eq!(gp_reg.value_secondary, 42);
    }

    #[test]
    fn test_load_a() {
        let mut bench = TestBench::new();
        let load_a_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .build(); // load_A

        bench.devices.route_word(&mut bench.buses, DEFAULT_CW, load_a_cw);
        bench.buses.main_bus = MainBusValue::Const(42); // Simulate loading 42 into A

        bench.devices.broadcast_clock_tick_primary(&mut bench.buses);

        assert_eq!(42, bench.devices.A.value_primary); // Check if A has the value 42 after clock tick
    }

    #[test]
    fn test_output_reg_value() {
        let mut bench = TestBench::new();

        bench.devices.A.set_value(&mut bench.buses, 42);

        let out_a_cw =  ControlWordBuilder::default()
            .apply_mux::<OutMux>(OutMux::VALUE_A_OUT)
            .build(); // out_A
        bench.devices.route_word(&mut bench.buses, DEFAULT_CW, out_a_cw);

        assert_eq!(42, bench.buses.resolve_main_bus()); // Check if the main bus has the value 42 after out_A

        bench.devices.A.set_value(&mut bench.buses, 100); // Change A's value to 100
        assert_eq!(100, bench.buses.resolve_main_bus()); // Check if the main bus reflects the new value of A, since out_A is still active
    }
}

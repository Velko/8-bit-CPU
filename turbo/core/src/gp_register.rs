use std::cell::Cell;
use crate::router::{MainBusSource, ALULSource, ALURSource};
use crate::devices::RuntimeState;
use crate::devices::MainBusValue;
use crate::devices::OutReceiver;
use crate::devices::LoadReceiver;
use crate::devices::ClockReceiver;
use crate::devices::ValueSource;
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
    fn on_out_change(&self, state: &mut RuntimeState, enable: bool) {
        println!("GPRegister {} Out changed to: {}", self.name, enable);
        state.main_bus = if enable {
            MainBusValue::Const(self.value_secondary)
        } else {
            MainBusValue::None
        };
        self.out_enabled.set(enable);
    }
}

impl LoadReceiver for GPRegister {
    fn on_load_change(&self, _state: &mut RuntimeState, enable: bool) {
        println!("GPRegister {} Load changed to: {}", self.name, enable);
        self.load_enabled.set(enable);
    }
}

impl ClockReceiver for GPRegister {
    fn on_clock_tick_primary(&mut self, state: &mut RuntimeState) {
        if self.load_enabled.get() {
            self.value_primary = state.resolve_main_bus();
        }
    }
    fn on_clock_tick_secondary(&mut self, state: &mut RuntimeState) {
        if self.value_primary != self.value_secondary {
            if self.out_enabled.get() {
                state.main_bus = MainBusValue::Const(self.value_primary);
            }
            if self.arg_l_enabled.get() {
                state.alu_l_bus = Some(self.value_primary);
            }
            if self.arg_r_enabled.get() {
                state.alu_r_bus = Some(self.value_primary);
            }
            self.value_secondary = self.value_primary;
        }
    }
}

impl ValueSource<u8> for GPRegister {
    fn get_value(&self) -> u8 {
        self.value_secondary
    }
}

impl GPRegister {
    pub fn new(name: &'static str, _main_id: MainBusSource, _alu_l_id: ALULSource, _alu_r_id: ALURSource) -> Self {
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

    pub fn on_alu_l_change(&self, state: &mut RuntimeState, enable: bool) {
        println!("GPRegister {} ALU L changed to: {}", self.name, enable);
        self.arg_l_enabled.set(enable);
        state.alu_l_bus = if enable {
            Some(self.value_secondary)
        } else {
            None
        };
    }
    pub fn on_alu_r_change(&self, state: &mut RuntimeState, enable: bool) {
        println!("GPRegister {} ALU R changed to: {}", self.name, enable);
        self.arg_r_enabled.set(enable);
        state.alu_r_bus = if enable {
            Some(self.value_secondary)
        } else {
            None
        };
    }

    pub fn set_value(&mut self, state: &mut RuntimeState, value: u8) {
        self.value_primary = value;
        self.value_secondary = !value;
        self.on_clock_tick_primary(state);
        self.on_clock_tick_secondary(state);
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
        let mut state = RuntimeState::new();
        let mut gp_reg = GPRegister::new("GP1", MainBusSource::A, ALULSource::A, ALURSource::A);

        // Simulate loading a value into the register
        gp_reg.load_enabled.set(true);
        state.main_bus = MainBusValue::Const(42);
        gp_reg.on_clock_tick_primary(&mut state);
        assert_eq!(gp_reg.value_primary, 42);

        // Simulate clock tick secondary
        gp_reg.on_clock_tick_secondary(&mut state);
        assert_eq!(gp_reg.value_secondary, 42);
    }

    #[test]
    fn test_load_a() {
        let mut bench = TestBench::new();
        let load_a_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .build(); // load_A

        bench.devices.route_word(&mut bench.state, DEFAULT_CW, load_a_cw);
        bench.state.main_bus = MainBusValue::Const(42); // Simulate loading 42 into A

        bench.devices.broadcast_clock_tick_primary(&mut bench.state);

        assert_eq!(42, bench.devices.A.value_primary); // Check if A has the value 42 after clock tick
    }

    #[test]
    fn test_output_reg_value() {
        let mut bench = TestBench::new();

        bench.devices.A.set_value(&mut bench.state, 42);

        let out_a_cw =  ControlWordBuilder::default()
            .apply_mux::<OutMux>(OutMux::VALUE_A_OUT)
            .build(); // out_A
        bench.devices.route_word(&mut bench.state, DEFAULT_CW, out_a_cw);

        assert_eq!(42, bench.state.resolve_main_bus()); // Check if the main bus has the value 42 after out_A

        bench.devices.A.set_value(&mut bench.state, 100); // Change A's value to 100
        assert_eq!(100, bench.state.resolve_main_bus()); // Check if the main bus reflects the new value of A, since out_A is still active
    }
}

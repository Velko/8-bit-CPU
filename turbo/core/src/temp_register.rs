use std::cell::Cell;
use crate::devices::RuntimeState;
use crate::devices::MainBusValue;
use crate::devices::LoadReceiver;
use crate::devices::ClockReceiver;
use crate::devices::ValueSource;
use crate::router::ALURSource;

pub struct TempRegister {
    pub name: &'static str,
    value_primary: u8,
    value_secondary: u8,
    load_enabled: Cell<bool>,
    arg_r_enabled: Cell<bool>,

}
impl LoadReceiver for TempRegister {
    fn on_load_change(&self, _state: &mut RuntimeState, enable: bool) {
        println!("TempRegister {} Load changed to: {}", self.name, enable);
        self.load_enabled.set(enable);
    }
}
impl TempRegister {
    pub fn new(name: &'static str, _alu_r_id: ALURSource) -> Self {
        Self {
            name,
            value_primary: 0,
            value_secondary: 0,
            load_enabled: Cell::new(false),
            arg_r_enabled: Cell::new(false)
        }
    }
    pub fn on_alu_r_change(&self, state: &mut RuntimeState, enable: bool) {
        println!("TempRegister {} ALU R changed to: {}", self.name, enable);
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

impl ClockReceiver for TempRegister {
    fn on_clock_tick_primary(&mut self, state: &mut RuntimeState) {
        if self.load_enabled.get() {
            self.value_primary = state.resolve_main_bus();
        }
    }
    fn on_clock_tick_secondary(&mut self, state: &mut RuntimeState) {
        if self.value_primary != self.value_secondary {
            if self.arg_r_enabled.get() {
                state.alu_r_bus = Some(self.value_primary);
            }
            self.value_secondary = self.value_primary;
        }
    }
}

impl ValueSource<u8> for TempRegister {
    fn get_value(&self, state: &RuntimeState) -> u8 {
        self.value_secondary
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::test_helpers::TestBench;
    use crate::router::{MuxDispatcher, LoadMux};
    use crate::control_word::ControlWordBuilder;
    use crate::router::DEFAULT_CW;


    #[test]
    fn test_load_t() {
        let mut bench = TestBench::new();
        let load_t_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_T_LOAD)
            .build(); // Enable T Load

        bench.devices.route_word(&mut bench.state, DEFAULT_CW, load_t_cw);
        bench.state.main_bus = MainBusValue::Const(42); // Simulate loading 42 into T

        bench.devices.broadcast_clock_tick_primary(&mut bench.state);
        bench.devices.broadcast_clock_tick_secondary(&mut bench.state);

        assert_eq!(42, bench.devices.T.get_value(&bench.state)); // Check if T has the value 42 after clock tick
    }
}

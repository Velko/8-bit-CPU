use std::cell::Cell;
use crate::devices::MainBusValue;
use crate::devices::LoadReceiver;
use crate::devices::ClockReceiver;
use crate::devices::RuntimeState;
use crate::devices::Peek;

pub struct WORegister {
    pub name: &'static str,
    value_primary: u8,
    value_secondary: u8,
    load_enabled: Cell<bool>,
}

impl WORegister {
    pub fn new(name: &'static str) -> Self {
        Self {
            name,
            value_primary: 0,
            value_secondary: 0,
            load_enabled: Cell::new(false)
        }
    }
}

impl LoadReceiver for WORegister {
    fn on_load_change(&self, _state: &mut RuntimeState, enable: bool) {
        self.load_enabled.set(enable);
    }
}

impl ClockReceiver for WORegister {
        fn on_clock_tick_primary(&mut self, state: &mut RuntimeState) {
        if self.load_enabled.get() {
            self.value_primary = state.resolve_main_bus();
        }
    }

    fn on_clock_tick_secondary(&mut self, state: &mut RuntimeState) {
        if self.value_primary != self.value_secondary {
            self.value_secondary = self.value_primary;
        }
    }
}

impl Peek<u8> for WORegister {
    fn peek(&self) -> u8 {
        self.value_secondary
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
    fn test_load_ir() {
        let mut bench = TestBench::new();
        let load_ir_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_IR_LOAD)
            .build(); // load_IR

        bench.devices.route_word(&mut bench.state, DEFAULT_CW, load_ir_cw);
        bench.state.main_bus = MainBusValue::Const(42); // Simulate loading 42 into IR

        bench.devices.broadcast_clock_tick_primary(&mut bench.state);

        assert_eq!(42, bench.devices.IR.value_primary); // Check if IR has the value 42 after clock tick
        assert_eq!(0, bench.devices.IR.value_secondary); // Secondary value should still be 0

        bench.devices.broadcast_clock_tick_secondary(&mut bench.state);

        assert_eq!(42, bench.devices.IR.value_secondary); // After secondary clock tick, secondary value should be updated to 42
    }
}

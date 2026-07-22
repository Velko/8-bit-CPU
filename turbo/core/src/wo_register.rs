use crate::devices::DelayedPin;
use crate::devices::ClockReceiver;
use crate::devices::ResetReceiver;
use crate::devices::ValueSource;
use crate::runtime_state::BusValues;

pub struct WORegister {
    pub name: &'static str,
    value_primary: u8,
    value_secondary: u8,
    pub load: DelayedPin,
}

impl WORegister {
    pub fn new(name: &'static str) -> Self {
        Self {
            name,
            value_primary: 0,
            value_secondary: 0,
            load: DelayedPin::new()
        }
    }
}

impl ClockReceiver for WORegister {
        fn on_clock_tick_primary(&mut self, bus_values: &BusValues) {
        if self.load.is_enabled() {
            self.value_primary = bus_values.main_bus.value.unwrap();
        }
    }

    fn on_clock_tick_secondary(&mut self) {
        if self.value_primary != self.value_secondary {
            self.value_secondary = self.value_primary;
        }
    }
}

impl ResetReceiver for WORegister {
    fn on_reset(&mut self) {
        self.value_primary = 0;
        self.value_secondary = 0;
    }
}

impl ValueSource<u8> for WORegister {
    fn get_value(&self, _bus_values: &BusValues) -> u8 {
        self.value_secondary
    }
}


#[cfg(test)]
mod tests {
    use crate::test_helpers::TestBench;
    use crate::router::LoadMux;
    use crate::control_word::ControlWordBuilder;
    use crate::router::DEFAULT_CW;

    #[test]
    fn test_load_ir() {
        let mut bench = TestBench::new();
        let load_ir_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_IR_LOAD)
            .build(); // load_IR

        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, load_ir_cw);
        bench.bus_values.main_bus.value = Some(42); // Simulate loading 42 into IR

        bench.devices.broadcast_clock_tick_primary(&bench.bus_values);

        assert_eq!(42, bench.devices.IR.value_primary); // Check if IR has the value 42 after clock tick
        assert_eq!(0, bench.devices.IR.value_secondary); // Secondary value should still be 0

        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(42, bench.devices.IR.value_secondary); // After secondary clock tick, secondary value should be updated to 42
    }
}

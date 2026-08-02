use crate::devices::BusOutputPin;
use crate::devices::DelayedPin;
use crate::devices::GlobalSignalsReceiver;
use crate::devices::ValueSource;
use crate::router::ALURSource;
use crate::runtime_state::BusValues;

pub struct TempRegister {
    pub name: &'static str,
    value_primary: u8,
    value_secondary: u8,
    pub load: DelayedPin,
    pub alu_r: BusOutputPin<ALURSource>,

}

impl TempRegister {
    pub fn new(name: &'static str, alu_r_id: ALURSource) -> Self {
        Self {
            name,
            value_primary: 0,
            value_secondary: 0,
            load: DelayedPin::new(),
            alu_r: BusOutputPin::new(alu_r_id),
        }
    }

    pub fn set_value(&mut self, value: u8) {
        self.value_primary = value;
        self.value_secondary = !value;
    }
}

impl GlobalSignalsReceiver for TempRegister {
    fn on_clock_tick_primary(&mut self, bus_values: &mut BusValues) {
        if self.load.is_enabled() {
            self.value_primary = bus_values.main_bus.value.unwrap();
        }
    }
    fn on_clock_tick_secondary(&mut self) {
        if self.value_primary != self.value_secondary {
            self.value_secondary = self.value_primary;
        }
    }
    fn on_reset(&mut self) {
        self.value_primary = 0;
        self.value_secondary = 0;
    }
}

impl ValueSource<u8> for TempRegister {
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
    fn test_load_t() {
        let mut bench = TestBench::new();
        let load_t_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_T_LOAD)
            .build(); // Enable T Load

        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, load_t_cw);
        bench.bus_values.main_bus.value = Some(42); // Simulate loading 42 into T

        bench.devices.broadcast_clock_tick_primary(&mut bench.bus_values);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(42, bench.devices.T.value_secondary); // Check if T has the value 42 after clock tick
    }
}

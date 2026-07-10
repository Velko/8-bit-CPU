use std::cell::Cell;
use crate::devices::LoadReceiver;
use crate::devices::ClockReceiver;
use crate::devices::ValueSource;
use crate::router::ALURSource;
use crate::router::DeviceMap;
use crate::runtime_state::{ArgValues, ArgSources};

pub struct TempRegister {
    pub name: &'static str,
    value_primary: u8,
    value_secondary: u8,
    load_enabled: Cell<bool>,
    alu_r_id: ALURSource,

}
impl LoadReceiver for TempRegister {
    fn on_load_change(&self, _args: &mut ArgSources, enable: bool) {
        println!("TempRegister {} Load changed to: {}", self.name, enable);
        self.load_enabled.set(enable);
    }
}
impl TempRegister {
    pub fn new(name: &'static str, alu_r_id: ALURSource) -> Self {
        Self {
            name,
            value_primary: 0,
            value_secondary: 0,
            load_enabled: Cell::new(false),
            alu_r_id,
        }
    }
    pub fn on_alu_r_change(&self, args: &mut ArgSources, enable: bool) {
        println!("TempRegister {} ALU R changed to: {}", self.name, enable);
        args.alu_r_source = if enable {
            Some(self.alu_r_id)
        } else {
            None
        };
    }

    pub fn set_value(&mut self, value: u8) {
        self.value_primary = value;
        self.value_secondary = !value;
    }
}

impl ClockReceiver for TempRegister {
    fn on_clock_tick_primary(&mut self, args: &ArgValues) {
        if self.load_enabled.get() {
            self.value_primary = args.main_bus_value.unwrap();
        }
    }
    fn on_clock_tick_secondary(&mut self) {
        if self.value_primary != self.value_secondary {
            self.value_secondary = self.value_primary;
        }
    }
}

impl ValueSource<u8> for TempRegister {
    fn get_value(&self, _devices: &DeviceMap, _args: &ArgSources) -> u8 {
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

        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, load_t_cw);
        let args = ArgValues {
            main_bus_value: Some(42),
            address_bus_value: None,
            alu_flags_value: None,
        }; // Simulate loading 42 into T

        bench.devices.broadcast_clock_tick_primary(&args);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(42, bench.devices.T.value_secondary); // Check if T has the value 42 after clock tick
    }
}

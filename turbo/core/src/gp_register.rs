use std::cell::Cell;
use crate::router::{MainBusSource, ALULSource, ALURSource};
use crate::devices::MainBusValue;
use crate::devices::OutReceiver;
use crate::devices::LoadReceiver;
use crate::devices::ClockReceiver;
use crate::devices::ValueSource;
use crate::router::DeviceMap;
use crate::runtime_state::{ArgSources, ArgValues};

pub struct GPRegister {
    pub name: &'static str,
    value_primary: u8,
    value_secondary: u8,
        load_enabled: Cell<bool>,
    main_id: MainBusSource,
    alu_l_id: ALULSource,
    alu_r_id: ALURSource
}

impl OutReceiver for GPRegister {
    fn on_out_change(&self, args: &mut ArgSources, enable: bool) {
        println!("GPRegister {} Out changed to: {}", self.name, enable);
        args.main_bus_source = if enable {
            Some(self.main_id)
        } else {
            None
        };
    }
}

impl LoadReceiver for GPRegister {
    fn on_load_change(&self, _args: &mut ArgSources, enable: bool) {
        println!("GPRegister {} Load changed to: {}", self.name, enable);
        self.load_enabled.set(enable);
    }
}

impl ClockReceiver for GPRegister {
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

impl ValueSource<u8> for GPRegister {
    fn get_value(&self, _devices: &DeviceMap, _args: &ArgSources) -> u8 {
        self.value_secondary
    }
}

impl GPRegister {
    pub fn new(name: &'static str, main_id: MainBusSource, alu_l_id: ALULSource, alu_r_id: ALURSource) -> Self {
        Self {
            name,
            value_primary: 0,
            value_secondary: 0,
            load_enabled: Cell::new(false),
            main_id,
            alu_l_id,
            alu_r_id,
        }
    }

    pub fn on_alu_l_change(&self, args: &mut ArgSources, enable: bool) {
        println!("GPRegister {} ALU L changed to: {}", self.name, enable);
        args.alu_l_source = if enable {
            Some(self.alu_l_id)
        } else {
            None
        };
    }
    pub fn on_alu_r_change(&self, args: &mut ArgSources, enable: bool) {
        println!("GPRegister {} ALU R changed to: {}", self.name, enable);
        args.alu_r_source = if enable {
            Some(self.alu_r_id)
        } else {
            None
        };
    }

    pub fn set_value(&mut self, value: u8) {
        self.value_primary = value;
        self.value_secondary = value;
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
        let args = ArgValues {
            main_bus_value: Some(42),
            alu_l_value: None,
            alu_r_value: None,
            address_bus_value: None,
        };
        let mut gp_reg = GPRegister::new("GP1", MainBusSource::A, ALULSource::A, ALURSource::A);

        // Simulate loading a value into the register
        gp_reg.load_enabled.set(true);
        gp_reg.on_clock_tick_primary(&args);
        assert_eq!(gp_reg.value_primary, 42);

        // Simulate clock tick secondary
        gp_reg.on_clock_tick_secondary();
        assert_eq!(gp_reg.value_secondary, 42);
    }

    #[test]
    fn test_load_a() {
        let mut bench = TestBench::new();
        let load_a_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .build(); // load_A

        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, load_a_cw);
        let args = ArgValues {
            main_bus_value: Some(42),
            alu_l_value: None,
            alu_r_value: None,
            address_bus_value: None,
        }; // Simulate loading 42 into A

        bench.devices.broadcast_clock_tick_primary(&args);

        assert_eq!(42, bench.devices.A.value_primary); // Check if A has the value 42 after clock tick
    }

    #[test]
    fn test_output_reg_value() {
        let mut bench = TestBench::new();

        bench.devices.A.set_value(42);

        let out_a_cw =  ControlWordBuilder::default()
            .apply_mux::<OutMux>(OutMux::VALUE_A_OUT)
            .build(); // out_A
        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, out_a_cw);

        let values = bench.sources.resolve(&bench.devices);

        assert_eq!(Some(42), values.main_bus_value); // Check if the main bus has the value 42 after out_A
    }

    #[test]
    fn test_copy_a_to_b() {
        let mut bench = TestBench::new();

        // Load 42 into A
        bench.devices.A.set_value(42);

        // Enable A Out and B Load
        let copy_a_to_b_cw = ControlWordBuilder::default()
            .apply_mux::<OutMux>(OutMux::VALUE_A_OUT)
            .apply_mux::<LoadMux>(LoadMux::VALUE_B_LOAD)
            .build();
        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, copy_a_to_b_cw);

        // Simulate clock tick
        let values = bench.sources.resolve(&bench.devices);
        bench.devices.broadcast_clock_tick_primary(&values);

        assert_eq!(42, bench.devices.B.value_primary); // Check if B has the value 42 after clock tick
    }
}

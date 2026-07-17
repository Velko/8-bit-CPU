
use crate::DEFAULT_CW;
use crate::control_word::ControlWord;
use crate::devices::ValueSource;
use crate::runtime_state::BusValues;
use crate::router::DeviceMap;

pub struct Cpu {
    devices: DeviceMap,
    control_word: ControlWord,
    bus_values: BusValues,
}


impl Cpu {
    pub fn new() -> Self {
        let devices = DeviceMap::new();
        let mut bus_values = BusValues::new();
        devices.route_word(&mut bus_values, !DEFAULT_CW, DEFAULT_CW); // Ensure we start from the default state
        Cpu {
            devices,
            control_word: DEFAULT_CW,
            bus_values,
        }
    }

    pub fn apply_control_word(&mut self, new_cw: ControlWord) {
        self.devices.route_word(&mut self.bus_values, self.control_word, new_cw);
        self.bus_values.resolve(&self.devices);
        self.control_word = new_cw;
    }

    pub fn clock_pulse_primary(&mut self) {
        self.devices.broadcast_clock_tick_primary(&mut self.bus_values);
    }

    pub fn clock_pulse_secondary(&mut self) {
        self.devices.broadcast_clock_tick_secondary();
    }

    pub fn clock_tick(&mut self) {
        self.clock_pulse_primary();
        self.clock_pulse_secondary();
    }

    pub fn inject_main_bus_value(&mut self, value: u8) {
        self.bus_values.main_bus.value = Some(value);
    }

    pub fn read_main_bus_value(&self) -> u8 {
        self.bus_values.main_bus.value.unwrap()
    }

    pub fn read_flags_value(&self) -> u8 {
        self.devices.F.get_value(&self.bus_values)
    }
}

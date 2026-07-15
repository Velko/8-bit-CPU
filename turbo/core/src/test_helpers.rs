use crate::router::{DeviceMap, DEFAULT_CW};
use crate::runtime_state::{BusValues};

pub struct TestBench {
    pub devices: DeviceMap,
    pub sources: BusValues,
}


impl TestBench {
    pub fn new() -> Self {
        let devices = DeviceMap::new();
        let mut args = BusValues::new();
        devices.route_word(&mut args, !DEFAULT_CW, DEFAULT_CW); // Ensure we start from the default state

        Self {
            devices,
            sources: args,
        }
    }
}


/// Helper function, allowing to specify a 8-bit value as a signed or unsigned integer. Accepts range -128 to 255
pub fn i16tou8(value: i16) -> u8 {
    if value < 0 {
        (256 + value) as u8
    } else {
        value as u8
    }
}

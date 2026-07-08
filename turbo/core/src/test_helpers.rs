use crate::devices::Buses;
use crate::router::DeviceMap;
use crate::ControlWord;

pub struct TestBench {
    pub devices: DeviceMap,
    pub buses: Buses,
}


impl TestBench {
    pub const DEFAULT_CW: ControlWord = 0x07ff58ff; // default
    pub fn new() -> Self {
        let devices = DeviceMap::new();
        let mut buses = Buses::new();
        devices.route_word(&mut buses, !Self::DEFAULT_CW, Self::DEFAULT_CW); // Ensure we start from the default state

        Self {
            devices,
            buses
        }
    }
}

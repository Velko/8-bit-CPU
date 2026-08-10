use crate::IOPorts;
use crate::router::{DeviceMap, DEFAULT_CW};
use crate::runtime_state::{BusValues};

pub struct TestBench {
    pub devices: DeviceMap<TestIOPorts>,
    pub bus_values: BusValues,
}

pub struct TestIOPorts;

impl TestIOPorts {
    pub fn new() -> Self {
        Self {}
    }
}

impl IOPorts for TestIOPorts {
    fn read_port(&self, port: u8) -> u8 {
        println!("TestIOPorts: read_port({})", port);
        0x42 // Return a dummy value for testing
    }

    fn write_port(&mut self, port: u8, value: u8) -> Option<crate::IOMessage> {
        println!("TestIOPorts: write_port({}, {})", port, value);
        None // No message for testing
    }
}

impl TestBench {
    pub fn new() -> Self {
        let devices = DeviceMap::new(TestIOPorts::new());
        let mut bus_values = BusValues::new();
        devices.route_word(&mut bus_values, !DEFAULT_CW, DEFAULT_CW); // Ensure we start from the default state

        Self {
            devices,
            bus_values,
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

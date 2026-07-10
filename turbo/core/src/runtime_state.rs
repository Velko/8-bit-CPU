use crate::alu;
use crate::flags::Flags;
use crate::router::{MainBusSource, ALULSource, ALURSource, AddressBusSource, FlagsSource};
use crate::router::DeviceMap;

pub struct ArgSources {
    pub main_bus_source: Option<MainBusSource>,
    pub alu_l_source: Option<ALULSource>,
    pub alu_r_source: Option<ALURSource>,
    pub address_bus_source: Option<AddressBusSource>,
    pub flags_source: Option<FlagsSource>,
    pub carry_in: bool,
}

impl ArgSources {
    pub fn new() -> Self {
        Self {
            main_bus_source: None,
            alu_l_source: None,
            alu_r_source: None,
            address_bus_source: None,
            flags_source: None,
            carry_in: false,
        }
    }

    pub fn resolve(&self, devices: &DeviceMap) -> ArgValues {
        let main_bus_value = self.main_bus_source.map(|source| devices.get_main_bus_value(source, self));
        let alu_flags_value = self.flags_source.map(|source| devices.get_flags_value(source, self));
        let address_bus_value = self.address_bus_source.map(|source| devices.get_address_bus_value(source, self));
        ArgValues {
            main_bus_value,
            address_bus_value,
            alu_flags_value,
        }
    }
}

pub struct ArgValues {
    pub main_bus_value: Option<u8>,
    pub alu_flags_value: Option<ALUFlags>,
    pub address_bus_value: Option<u16>,
}

pub struct ALUFlags {
    pub carry: Option<Flags>,
    pub overflow: Option<Flags>,
}

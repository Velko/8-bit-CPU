use crate::flags::Flags;
use crate::router::{MainBusSource, ALULSource, ALURSource, AddressBusSource, FlagsSource};
use crate::router::DeviceMap;

pub struct BusValue<TSource, TValue> {
    pub source: Option<TSource>,
    pub value: Option<TValue>,
}

pub struct BusValues {
    pub main_bus: BusValue<MainBusSource, u8>,
    pub alu_l: BusValue<ALULSource, u8>,
    pub alu_r: BusValue<ALURSource, u8>,
    pub address_bus: BusValue<AddressBusSource, u16>,
    pub flags: BusValue<FlagsSource, ALUFlags>,
    pub carry_in: bool,
}

impl BusValues {
    pub fn new() -> Self {
        Self {
            main_bus: BusValue { source: None, value: None },
            alu_l: BusValue { source: None, value: None },
            alu_r: BusValue { source: None, value: None },
            address_bus: BusValue { source: None, value: None },
            flags: BusValue { source: None, value: None },
            carry_in: false,
        }
    }

    pub fn resolve(&mut self, devices: &DeviceMap) {
        if let Some(source) = self.alu_l.source {
            self.alu_l.value = Some(devices.get_alu_l_value(source, self));
        }
        if let Some(source) = self.alu_r.source {
            self.alu_r.value = Some(devices.get_alu_r_value(source, self));
        }
        if let Some(source) = self.address_bus.source {
            self.address_bus.value = Some(devices.get_address_bus_value(source, self));
        }
        if let Some(source) = self.main_bus.source {
            self.main_bus.value = Some(devices.get_main_bus_value(source, self));
        }
        if let Some(source) = self.flags.source {
            self.flags.value = Some(devices.get_flags_value(source, self));
        }
    }
}

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
        // let main_bus_value = self.main_bus_source.map(|source| devices.get_main_bus_value(source, self));
        // let alu_flags_value = self.flags_source.map(|source| devices.get_flags_value(source, self));
        // let address_bus_value = self.address_bus_source.map(|source| devices.get_address_bus_value(source, self));
        // ArgValues {
        //     main_bus_value,
        //     address_bus_value,
        //     alu_flags_value,
        // }
        todo!()
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

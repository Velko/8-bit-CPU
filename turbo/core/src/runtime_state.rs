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

pub struct ALUFlags {
    pub carry: Option<Flags>,
    pub overflow: Option<Flags>,
}

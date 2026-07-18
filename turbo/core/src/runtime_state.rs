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
    pub injected_main_bus_value: Option<u8>,
    pub injected_address_bus_value: Option<u16>,
}

impl BusValues {
    pub fn new() -> Self {
        Self {
            main_bus: BusValue { source: None, value: None },
            alu_l: BusValue { source: None, value: None },
            alu_r: BusValue { source: None, value: None },
            address_bus: BusValue { source: None, value: None },
            flags: BusValue { source: None, value: None },
            injected_main_bus_value: None,
            injected_address_bus_value: None,
        }
    }

    pub fn resolve(&mut self, devices: &DeviceMap) {
        self.alu_l.value = self.alu_l.source.map(|source| devices.get_alu_l_value(source, self));
        self.alu_r.value = self.alu_r.source.map(|source| devices.get_alu_r_value(source, self));
        self.address_bus.value = self.injected_address_bus_value.or_else(|| self.address_bus.source.map(|source| devices.get_address_bus_value(source, self)));
        self.main_bus.value = self.injected_main_bus_value.or_else(|| self.main_bus.source.map(|source| devices.get_main_bus_value(source, self)));
        self.flags.value = self.flags.source.map(|source| devices.get_flags_value(source, self));
    }
}

pub struct ALUFlags {
    pub carry: Option<Flags>,
    pub overflow: Option<Flags>,
}

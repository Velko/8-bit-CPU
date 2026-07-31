use crate::{BusValues, devices::{BusOutputPin, DelayedPin, GlobalSignalsReceiver, ValueSource}, router::AddressBusSource};

pub struct AddressRegister {
    pub name: &'static str,
    pub out: BusOutputPin<AddressBusSource>,
    pub load: DelayedPin,
}
impl AddressRegister {
    pub fn new(name: &'static str, address_bus_id: AddressBusSource) -> Self {
        Self {
            name,
            out: BusOutputPin::new(address_bus_id),
            load: DelayedPin::new()
        }
    }
}

impl ValueSource<u16> for AddressRegister {
    fn get_value(&self, _bus_values: &BusValues) -> u16 {
        todo!()
    }
}


impl GlobalSignalsReceiver for AddressRegister {}

use crate::{BusValues, devices::{BusOutputPin, DelayedPin, GlobalSignalsReceiver, ValueSource}, router::AddressBusSource};

pub struct AddressCalculator {
    pub name: &'static str,
    pub out: BusOutputPin<AddressBusSource>,
    pub load: DelayedPin,
    pub signed: DelayedPin,
}

impl AddressCalculator {
    pub fn new(name: &'static str, address_bus_id: AddressBusSource) -> Self {
        Self {
            name,
            out: BusOutputPin::new(address_bus_id),
            load: DelayedPin::new(),
            signed: DelayedPin::new()
        }
    }
}
impl GlobalSignalsReceiver for AddressCalculator {}
impl ValueSource<u16> for AddressCalculator {
    fn get_value(&self, _bus_values: &BusValues) -> u16 {
        todo!()
    }
}

use crate::{BusValues, devices::{BusOutputPin, DelayedPin, GlobalSignalsReceiver, ValueSource}, router::AddressBusSource};

pub struct AddressRegister {
    pub name: &'static str,
    pub out: BusOutputPin<AddressBusSource>,
    pub load: DelayedPin,
    value: u16,
}
impl AddressRegister {
    pub fn new(name: &'static str, address_bus_id: AddressBusSource) -> Self {
        Self {
            name,
            out: BusOutputPin::new(address_bus_id),
            load: DelayedPin::new(),
            value: 0,
        }
    }
}

impl ValueSource<u16> for AddressRegister {
    fn get_value(&self, _bus_values: &BusValues) -> u16 {
        self.value
    }
}

impl GlobalSignalsReceiver for AddressRegister {
    fn on_clock_tick_primary(&mut self, bus_values: &mut BusValues) {
        if self.load.is_enabled() {
            let value = bus_values.address_bus.value.unwrap();
            self.value = value;
        }
    }
    fn on_reset(&mut self) {
        self.value = 0;
    }
}

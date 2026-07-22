use crate::devices::{BusOutputPin, DelayedPin, GlobalSignalsReceiver, ValueSource};

pub struct TransferRegister<TBusSource> {
    pub name: &'static str,
    pub out: BusOutputPin<TBusSource>,
    pub load: DelayedPin,
}

impl<TBusSource> TransferRegister<TBusSource> {
    pub fn new(name: &'static str, bus_id: TBusSource) -> Self {
        Self {
            name,
            out: BusOutputPin::new(bus_id),
            load: DelayedPin::new(),
        }
    }
}

impl<TBusSource> GlobalSignalsReceiver for TransferRegister<TBusSource> {}

impl<TBusSource> ValueSource<u8> for TransferRegister<TBusSource> {
    fn get_value(&self, _bus_values: &crate::BusValues) -> u8 {
        println!("TransferRegister {}: get_value called", self.name);
        todo!()
    }
}

impl<TBusSource> ValueSource<u16> for TransferRegister<TBusSource> {
    fn get_value(&self, _bus_values: &crate::BusValues) -> u16 {
        println!("TransferRegister {}: get_value called", self.name);
        todo!()
    }
}

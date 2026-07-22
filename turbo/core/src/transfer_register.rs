use crate::devices::{ClockReceiver, DelayedPin, OutReceiver, ResetReceiver, ValueSource};

pub struct TransferRegister<TBusSource> {
    pub name: &'static str,
    bus_id: TBusSource,
    pub load: DelayedPin,
}

impl<TBusSource> TransferRegister<TBusSource> {
    pub fn new(name: &'static str, bus_id: TBusSource) -> Self {
        Self {
            name,
            bus_id,
            load: DelayedPin::new(),
        }
    }
}

impl<TBusSource> OutReceiver for TransferRegister<TBusSource> {
    fn on_out_change(&self, _bus_values: &mut crate::BusValues, _enable: bool) {
        println!("TransferRegister {}: Out change detected, enable={}", self.name, _enable);
    }
}

impl<TBusSource> ClockReceiver for TransferRegister<TBusSource> {}
impl<TBusSource> ResetReceiver for TransferRegister<TBusSource> {}

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

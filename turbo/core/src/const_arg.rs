use crate::{BusValues, devices::BusOutputPin, router::ALURSource};
use crate::devices::{ValueSource, GlobalSignalsReceiver};

pub struct ConstArg<const V: u8> {
    pub name: &'static str,
    pub alu_r: BusOutputPin<ALURSource>,
}


impl<const V: u8> ValueSource<u8> for ConstArg<V> {
    fn get_value(&self, _bus_values: &BusValues) -> u8 {
        V
    }
}

impl<const V: u8> GlobalSignalsReceiver for ConstArg<V> {}

impl<const V: u8> ConstArg<V> {
    pub fn new(name: &'static str, alu_r_id: ALURSource) -> Self {
        Self {
            name,
            alu_r: BusOutputPin::new(alu_r_id),
        }
    }
}

use crate::{BusValues, devices::{BusOutputPin, DelayedPin, GlobalSignalsReceiver, ValueSource}, router::MainBusSource};

pub struct IOController {
    pub name: &'static str,
    pub from_dev: BusOutputPin<MainBusSource>,
    pub to_dev: DelayedPin,
    pub laddr: DelayedPin,
}
impl IOController {
    pub fn new(name: &'static str, main_id: MainBusSource) -> Self {
        Self {
            name,
            from_dev: BusOutputPin::new(main_id),
            to_dev: DelayedPin::new(),
            laddr: DelayedPin::new()
        }
    }
}

impl ValueSource<u8> for IOController {
    fn get_value(&self, _bus_values: &BusValues) -> u8 {
        todo!()
    }
}

impl GlobalSignalsReceiver for IOController {
    fn on_clock_tick_primary(&mut self, _bus_values: &BusValues) {
    }
}

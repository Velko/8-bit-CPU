use crate::{BusValues, devices::{DelayedPin, GlobalSignalsReceiver}};

pub struct IOController {
    pub name: &'static str,
    pub to_dev: DelayedPin,
    pub laddr: DelayedPin,
}
impl IOController {
    pub fn new(name: &'static str) -> Self {
        Self { name,
            to_dev: DelayedPin::new(),
            laddr: DelayedPin::new()
        }
    }
    pub fn on_from_dev_change(&self, _bus_values: &mut BusValues, _enable: bool) {}
}
impl GlobalSignalsReceiver for IOController {}

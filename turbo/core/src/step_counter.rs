use crate::{BusValues, devices::GlobalSignalsReceiver};

pub struct StepCounter {
    pub name: &'static str,
}

impl StepCounter {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_reset_change(&self, _bus_values: &mut BusValues, _enable: bool) {}
    pub fn on_extended_change(&self, _bus_values: &mut BusValues, _enable: bool) {}
}
impl GlobalSignalsReceiver for StepCounter {}

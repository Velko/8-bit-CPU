use crate::{BusValues, devices::GlobalSignalsReceiver};

pub struct Clock {
    pub name: &'static str,
}
impl Clock {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_halt_change(&self, _bus_values: &mut BusValues, _enable: bool) {}
    pub fn on_brk_change(&self, _bus_values: &mut BusValues, _enable: bool) {}
}
impl GlobalSignalsReceiver for Clock {}

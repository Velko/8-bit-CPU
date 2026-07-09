use std::cell::Cell;
use crate::devices::RuntimeState;
use crate::devices::MainBusValue;
use crate::devices::OutReceiver;
use crate::devices::LoadReceiver;
use crate::devices::ClockReceiver;

pub struct RAM {
    pub name: &'static str,
}
impl OutReceiver for RAM {}
impl RAM {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_write_change(&self, _state: &mut RuntimeState, _new_state: bool) {}
}
impl ClockReceiver for RAM {}

pub struct ROM {
    pub name: &'static str,
}
impl OutReceiver for ROM {}
impl ROM {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
}
impl ClockReceiver for ROM {}

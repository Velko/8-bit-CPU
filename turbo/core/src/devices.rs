pub use crate::gp_register::GPRegister;
pub use crate::temp_register::TempRegister;
pub use crate::program_counter::ProgramCounter;
pub use crate::alu::ALU;
pub use crate::flags::{Flags, FlagsRegister};
pub use crate::wo_register::WORegister;
pub use crate::memory::{RAM, ROM};

pub use crate::runtime_state::{RuntimeState, MainBusValue};

use std::cell::Cell;


pub trait OutReceiver {
    fn on_out_change(&self, _state: &mut RuntimeState, enable: bool) {}
}
pub trait LoadReceiver {
    fn on_load_change(&self, _state: &mut RuntimeState, _enable: bool) {}
}
pub trait IncReceiver {
    fn on_inc_change(&self, _state: &mut RuntimeState, _enable: bool) {}
}
pub trait DecReceiver {
    fn on_dec_change(&self, _state: &mut RuntimeState, _enable: bool) {}
}
pub trait ClockReceiver {
    fn on_clock_tick_primary(&mut self, _state: &mut RuntimeState) {}
    fn on_clock_tick_secondary(&mut self, _state: &mut RuntimeState) {}
}
pub trait Peek<T> {
    fn peek(&self) -> T;
}

pub struct Clock {
    pub name: &'static str,
}
impl Clock {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_halt_change(&self, _state: &mut RuntimeState, _enable: bool) {}
    pub fn on_brk_change(&self, _state: &mut RuntimeState, _enable: bool) {}
}
impl ClockReceiver for Clock {}

pub struct StepCounter {
    pub name: &'static str,
}

impl StepCounter {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_reset_change(&self, _state: &mut RuntimeState, _enable: bool) {}
    pub fn on_extended_change(&self, _state: &mut RuntimeState, _enable: bool) {}
}
impl ClockReceiver for StepCounter {}

pub struct TransferRegister {
    pub name: &'static str,
}
impl TransferRegister {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
}
impl OutReceiver for TransferRegister {}
impl LoadReceiver for TransferRegister {}
impl ClockReceiver for TransferRegister {}

pub struct StackPointer {
    pub name: &'static str,
}
impl StackPointer {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
}
impl OutReceiver for StackPointer {}
impl LoadReceiver for StackPointer {}
impl IncReceiver for StackPointer {}
impl DecReceiver for StackPointer {}
impl ClockReceiver for StackPointer {}

pub struct AddressRegister {
    pub name: &'static str,
}
impl AddressRegister {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
}
impl OutReceiver for AddressRegister {}
impl LoadReceiver for AddressRegister {}
impl ClockReceiver for AddressRegister {}

pub struct AddressCalculator {
    pub name: &'static str,
}
impl OutReceiver for AddressCalculator {}
impl LoadReceiver for AddressCalculator {}
impl AddressCalculator {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_signed_change(&self, _state: &mut RuntimeState, _enable: bool) {}
}
impl ClockReceiver for AddressCalculator {}

pub struct IOController {
    pub name: &'static str,
}
impl IOController {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_laddr_change(&self, _state: &mut RuntimeState, _enable: bool) {}
    pub fn on_to_dev_change(&self, _state: &mut RuntimeState, _enable: bool) {}
    pub fn on_from_dev_change(&self, _state: &mut RuntimeState, _enable: bool) {}
}
impl ClockReceiver for IOController {}

#[cfg(test)]
mod tests {
    use rstest::rstest;
    use super::*;
    use crate::router::DeviceMap;
}

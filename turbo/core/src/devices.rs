pub use crate::gp_register::GPRegister;
use crate::runtime_state::BusValues;
pub use crate::temp_register::TempRegister;
pub use crate::program_counter::ProgramCounter;
pub use crate::alu::ALU;
pub use crate::flags::{FlagsRegister};
pub use crate::wo_register::WORegister;
pub use crate::memory::{RAM, ROM};
pub use crate::transfer_register::TransferRegister;
use crate::router::{AddressBusSource};

pub trait OutReceiver {
    fn on_out_change(&self, _bus_values: &mut BusValues, _enable: bool) {}
}
pub trait LoadReceiver {
    fn on_load_change(&self, _bus_values: &mut BusValues, _enable: bool) {}
}
pub trait IncReceiver {
    fn on_inc_change(&self, _bus_values: &mut BusValues, _enable: bool) {}
}
pub trait DecReceiver {
    fn on_dec_change(&self, _bus_values: &mut BusValues, _enable: bool) {}
}
pub trait ClockReceiver {
    fn on_clock_tick_primary(&mut self, _bus_values: &BusValues) {}
    fn on_clock_tick_secondary(&mut self) {}
}

pub trait ResetReceiver {
    fn on_reset(&mut self) {}
}

pub trait ValueSource<T> {
    fn get_value(&self, _bus_values: &BusValues) -> T;
}

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
impl ClockReceiver for Clock {}
impl ResetReceiver for Clock {}

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
impl ClockReceiver for StepCounter {}
impl ResetReceiver for StepCounter {}

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
impl ResetReceiver for StackPointer {}

pub struct AddressRegister {
    pub name: &'static str,
}
impl AddressRegister {
    pub fn new(name: &'static str, _address_bus_id: AddressBusSource) -> Self {
        Self { name }
    }
}
impl OutReceiver for AddressRegister {}
impl LoadReceiver for AddressRegister {}
impl ClockReceiver for AddressRegister {}
impl ResetReceiver for AddressRegister {}
impl ValueSource<u16> for AddressRegister {
    fn get_value(&self, _bus_values: &BusValues) -> u16 {
        todo!()
    }
}

pub struct AddressCalculator {
    pub name: &'static str,
}
impl OutReceiver for AddressCalculator {}
impl LoadReceiver for AddressCalculator {}
impl AddressCalculator {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_signed_change(&self, _bus_values: &mut BusValues, _enable: bool) {}
}
impl ClockReceiver for AddressCalculator {}
impl ResetReceiver for AddressCalculator {}

pub struct IOController {
    pub name: &'static str,
}
impl IOController {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_laddr_change(&self, _bus_values: &mut BusValues, _enable: bool) {}
    pub fn on_to_dev_change(&self, _bus_values: &mut BusValues, _enable: bool) {}
    pub fn on_from_dev_change(&self, _bus_values: &mut BusValues, _enable: bool) {}
}
impl ClockReceiver for IOController {}
impl ResetReceiver for IOController {}

#[cfg(test)]
mod tests {
}

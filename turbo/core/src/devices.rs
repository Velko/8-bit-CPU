use std::cell::Cell;

pub use crate::gp_register::GPRegister;
use crate::runtime_state::BusValues;
pub use crate::temp_register::TempRegister;
pub use crate::program_counter::ProgramCounter;
pub use crate::alu::{ALU, AddSub, AndOr, XorNot, ShiftSwap};
pub use crate::flags::{FlagsRegister};
pub use crate::wo_register::WORegister;
pub use crate::memory::{RAM, ROM};
pub use crate::transfer_register::{TransferRegister, TransferRegisterBehavior, MainBusBehavior, AddressBusBehavior};
use crate::router::{ALULSource, ALURSource, AddressBusSource, MainBusSource};

pub struct DelayedPin{
    enabled: Cell<bool>,
}

impl DelayedPin {
    pub fn new() -> Self {
        Self {
            enabled: Cell::new(false),
        }
    }

    pub fn change<D>(&self, _device: &D, _bus_values: &mut BusValues, enable: bool) {
        self.enabled.set(enable);
    }

    pub fn is_enabled(&self) -> bool {
        self.enabled.get()
    }
}

pub trait BusOutputPinChange {
    fn change(&self, bus_values: &mut BusValues, enable: bool);
}

pub struct BusOutputPin<BusSource> {
    pub source: BusSource,
}

impl<BusSource> BusOutputPin<BusSource> {
    pub fn new(source: BusSource) -> Self {
        Self {
            source
        }
    }
}

impl BusOutputPinChange for BusOutputPin<MainBusSource> {
    fn change(&self, bus_values: &mut BusValues, enable: bool) {
        bus_values.main_bus.source = if enable {
            Some(self.source)
        } else {
            None
        };
    }
}

impl BusOutputPinChange for BusOutputPin<AddressBusSource> {
    fn change(&self, bus_values: &mut BusValues, enable: bool) {
        bus_values.address_bus.source = if enable {
            Some(self.source)
        } else {
            None
        };
    }
}

impl BusOutputPinChange for BusOutputPin<ALULSource> {
    fn change(&self, bus_values: &mut BusValues, enable: bool) {
        bus_values.alu_l.source = if enable {
            Some(self.source)
        } else {
            None
        };
    }
}

impl BusOutputPinChange for BusOutputPin<ALURSource> {
    fn change(&self, bus_values: &mut BusValues, enable: bool) {
        bus_values.alu_r.source = if enable {
            Some(self.source)
        } else {
            None
        };
    }
}


pub trait GlobalSignalsReceiver {
    fn on_clock_tick_primary(&mut self, _bus_values: &BusValues) {}
    fn on_clock_tick_secondary(&mut self) {}
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
impl GlobalSignalsReceiver for Clock {}

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

pub struct StackPointer {
    pub name: &'static str,
    pub out: BusOutputPin<AddressBusSource>,
    pub load: DelayedPin,
    pub inc: DelayedPin,
    pub dec: DelayedPin,
}
impl StackPointer {
    pub fn new(name: &'static str, address_bus_id: AddressBusSource) -> Self {
        Self {
            name,
            out: BusOutputPin::new(address_bus_id),
            load: DelayedPin::new(),
            inc: DelayedPin::new(),
            dec: DelayedPin::new(),
        }
    }
}

impl GlobalSignalsReceiver for StackPointer {}

impl ValueSource<u16> for StackPointer {
    fn get_value(&self, _bus_values: &BusValues) -> u16 {
        todo!()
    }
}

pub struct AddressRegister {
    pub name: &'static str,
    pub out: BusOutputPin<AddressBusSource>,
    pub load: DelayedPin,
}
impl AddressRegister {
    pub fn new(name: &'static str, address_bus_id: AddressBusSource) -> Self {
        Self {
            name,
            out: BusOutputPin::new(address_bus_id),
            load: DelayedPin::new()
        }
    }
}

impl ValueSource<u16> for AddressRegister {
    fn get_value(&self, _bus_values: &BusValues) -> u16 {
        todo!()
    }
}


impl GlobalSignalsReceiver for AddressRegister {}

pub struct AddressCalculator {
    pub name: &'static str,
    pub out: BusOutputPin<AddressBusSource>,
    pub load: DelayedPin,
    pub signed: DelayedPin,
}

impl AddressCalculator {
    pub fn new(name: &'static str, address_bus_id: AddressBusSource) -> Self {
        Self {
            name,
            out: BusOutputPin::new(address_bus_id),
            load: DelayedPin::new(),
            signed: DelayedPin::new()
        }
    }
}
impl GlobalSignalsReceiver for AddressCalculator {}
impl ValueSource<u16> for AddressCalculator {
    fn get_value(&self, _bus_values: &BusValues) -> u16 {
        todo!()
    }
}


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

#[cfg(test)]
mod tests {
}

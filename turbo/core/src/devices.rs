use std::cell::Cell;

pub use crate::gp_register::GPRegister;
use crate::runtime_state::BusValues;
pub use crate::temp_register::TempRegister;
pub use crate::program_counter::ProgramCounter;
pub use crate::alu::{ALU, AddSub, AndOr, XorNot, ShiftSwap};
pub use crate::flags::{FlagsRegister};
pub use crate::wo_register::WORegister;
pub use crate::memory::{Memory, NullSource};
pub use crate::stack_pointer::StackPointer;
pub use crate::transfer_register::{TransferRegister, TransferRegisterBehavior, MainBusBehavior, AddressBusBehavior};
pub use crate::clock::Clock;
pub use crate::step_counter::StepCounter;
pub use crate::address_register::AddressRegister;
pub use crate::address_calculator::AddressCalculator;
pub use crate::io_controller::IOController;
use crate::router::{ALULSource, ALURSource, AddressBusSource, MainBusSource};

/// Pin that, when enabled, does not have an immediate effect, but instead will be checked by a
/// device when time comes for it to act. Typically that happens on the clock tick event. This
/// is used for pins that load values into registers, for example.
pub struct DelayedPin{
    enabled: Cell<bool>,
}

impl DelayedPin {
    pub fn new() -> Self {
        Self {
            enabled: Cell::new(false),
        }
    }

    pub fn change(&self, _bus_values: &mut BusValues, enable: bool) {
        self.enabled.set(enable);
    }

    pub fn is_enabled(&self) -> bool {
        self.enabled.get()
    }
}

/// Pin that when enabled has an effect of putting a value from the device's internal state onto
/// the bus. This is used for pins that output values from registers, for example.
/// Note that this still does not mean that the value will be immediately available on the bus, as
/// it merely sets the source of the value, not the value itself. The values will be resolved
/// by a dedicated resolver that will be invoked after all pins have been configured.
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

/// Trait for devices that can receive global signals, such as clock ticks or reset events.
pub trait GlobalSignalsReceiver {
    fn on_clock_tick_primary(&mut self, _bus_values: &mut BusValues) {}
    fn on_clock_tick_secondary(&mut self) {}
    fn on_reset(&mut self) {}
}

/// Trait for devices that can provide a value of a specific type, used for registers or other
/// components that acts as a source of values for one of the buses. The value could be retrieved
/// from the device's internal state or computed based on the current bus values.
pub trait ValueSource<T> {
    fn get_value(&self, _bus_values: &BusValues) -> T;
}









#[cfg(test)]
mod tests {
}

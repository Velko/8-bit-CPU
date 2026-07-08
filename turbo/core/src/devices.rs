pub use crate::gp_register::GPRegister;
pub use crate::temp_register::TempRegister;
pub use crate::program_counter::ProgramCounter;
pub use crate::alu::ALU;
pub use crate::flags::{Flags, FlagsRegister};

use std::cell::Cell;

pub enum MainBusValue {
    None,
    Const(u8),
    Add,
    Subtract,
    And,
    Or,
    Xor,
    Not,
    Shr,
    Swap,
}

pub struct Buses {
    pub main_bus: MainBusValue,
    pub address_bus: Option<u16>,
    pub alu_l_bus: Option<u8>,
    pub alu_r_bus: Option<u8>,
    pub carry_in: bool,
}

impl Buses {
    pub fn new() -> Self {
        Buses {
            main_bus: MainBusValue::None,
            address_bus: None,
            alu_l_bus: None,
            alu_r_bus: None,
            carry_in: false,
        }
    }

    pub fn resolve_main_bus(&self) -> u8 {

        match self.main_bus {
            MainBusValue::None => panic!("Bus value is None"),
            MainBusValue::Const(value) => value,
            MainBusValue::Add => {
                let l = self.alu_l_bus.unwrap_or(0);
                let r = self.alu_r_bus.unwrap_or(0);
                let carry = if self.carry_in { 1 } else { 0 };
                l.wrapping_add(r).wrapping_add(carry)
            }
            MainBusValue::Subtract => {
                let l = self.alu_l_bus.unwrap_or(0);
                let r = self.alu_r_bus.unwrap_or(0);
                let carry = if self.carry_in { 1 } else { 0 };
                l.wrapping_sub(r).wrapping_sub(carry)
            },
            MainBusValue::And => {
                let l = self.alu_l_bus.unwrap_or(0);
                let r = self.alu_r_bus.unwrap_or(0);
                l & r
            },
            MainBusValue::Or => {
                let l = self.alu_l_bus.unwrap_or(0);
                let r = self.alu_r_bus.unwrap_or(0);
                l | r
            },
            MainBusValue::Xor => {
                let l = self.alu_l_bus.unwrap_or(0);
                let r = self.alu_r_bus.unwrap_or(0);
                l ^ r
            },
            MainBusValue::Not => {
                let l = self.alu_l_bus.unwrap_or(0);
                !l
            },
            MainBusValue::Shr => {
                let l = self.alu_l_bus.unwrap_or(0);
                l >> 1
            },
            MainBusValue::Swap => {
                let l = self.alu_l_bus.unwrap_or(0);
                (l << 4) | (l >> 4)
            }
        }
    }

    pub fn resolve_alu_flags(&self) -> (Option<Flags>, Option<Flags>) {
        let l = self.alu_l_bus.unwrap_or(0) as u16;
        let r = self.alu_r_bus.unwrap_or(0) as u16;
        let carry = if self.carry_in { 1 } else { 0 };
        match self.main_bus {
            MainBusValue::Add => {
                let sum = l.wrapping_add(r).wrapping_add(carry);
                let overflow = if ((l ^ sum) & (r ^ sum) & 0x80) != 0  { Flags::V } else { Flags::EMPTY };
                let carry_out = if (l + r + carry) > 0xFF { Flags::C } else { Flags::EMPTY };
                (Some(carry_out), Some(overflow))
            }
            MainBusValue::Subtract => {
                let diff = l.wrapping_sub(r).wrapping_sub(carry);
                let overflow = if ((l ^ r) & (l ^ diff) & 0x80) != 0 { Flags::V } else { Flags::EMPTY };
                let carry_out = if l < r + carry { Flags::C } else { Flags::EMPTY };
                (Some(carry_out), Some(overflow))
            },
            MainBusValue::Shr => {
                let carry_out = if (l & 0x01) != 0 { Flags::C } else { Flags::EMPTY };
                (Some(carry_out), None)
            },
            _ => (None, None),
        }
    }
}

pub trait OutReceiver {
    fn on_out_change(&self, _buses: &mut Buses, new_state: bool) {}
}
pub trait LoadReceiver {
    fn on_load_change(&self, _buses: &mut Buses, _new_state: bool) {}
}
pub trait IncReceiver {
    fn on_inc_change(&self, _buses: &mut Buses, _new_state: bool) {}
}
pub trait DecReceiver {
    fn on_dec_change(&self, _buses: &mut Buses, _new_state: bool) {}
}
pub trait ClockReceiver {
    fn on_clock_tick_primary(&mut self, _buses: &mut Buses) {}
    fn on_clock_tick_secondary(&mut self, _buses: &mut Buses) {}
}
pub trait Peek<T> {
    fn peek(&self) -> T;
}

pub struct RAM {
    pub name: &'static str,
}
impl OutReceiver for RAM {}
impl RAM {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_write_change(&self, _buses: &mut Buses, _new_state: bool) {}
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

pub struct WORegister {
    pub name: &'static str,
}
impl WORegister {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
}
impl LoadReceiver for WORegister {}
impl ClockReceiver for WORegister {}

pub struct Clock {
    pub name: &'static str,
}
impl Clock {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_halt_change(&self, _buses: &mut Buses, _new_state: bool) {}
    pub fn on_brk_change(&self, _buses: &mut Buses, _new_state: bool) {}
}
impl ClockReceiver for Clock {}

pub struct StepCounter {
    pub name: &'static str,
}

impl StepCounter {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_reset_change(&self, _buses: &mut Buses, _new_state: bool) {}
    pub fn on_extended_change(&self, _buses: &mut Buses, _new_state: bool) {}
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
    pub fn on_signed_change(&self, _buses: &mut Buses, _new_state: bool) {}
}
impl ClockReceiver for AddressCalculator {}

pub struct IOController {
    pub name: &'static str,
}
impl IOController {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_laddr_change(&self, _buses: &mut Buses, _new_state: bool) {}
    pub fn on_to_dev_change(&self, _buses: &mut Buses, _new_state: bool) {}
    pub fn on_from_dev_change(&self, _buses: &mut Buses, _new_state: bool) {}
}
impl ClockReceiver for IOController {}

#[cfg(test)]
mod tests {
    use rstest::rstest;
    use super::*;
    use crate::router::DeviceMap;
}

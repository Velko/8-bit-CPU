pub use crate::gp_register::GPRegister;
pub use crate::alu::ALU;

use std::cell::Cell;
use std::ops::{BitOr, BitAnd, BitOrAssign};
use std::fmt::Debug;

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
                let overflow = if ((l ^ sum) & (r ^ sum) & 0x80) != 0  { Flags::V } else { Flags::Empty };
                let carry_out = if (l + r + carry) > 0xFF { Flags::C } else { Flags::Empty };
                (Some(carry_out), Some(overflow))
            }
            MainBusValue::Subtract => {
                let diff = l.wrapping_sub(r).wrapping_sub(carry);
                let overflow = if ((l ^ r) & (l ^ diff) & 0x80) != 0 { Flags::V } else { Flags::Empty };
                let carry_out = if l < r + carry { Flags::C } else { Flags::Empty };
                (Some(carry_out), Some(overflow))
            },
            MainBusValue::Shr => {
                let carry_out = if (l & 0x01) != 0 { Flags::C } else { Flags::Empty };
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

#[derive(Clone, Copy, PartialEq, Default)]
pub struct Flags {
    value: u8,
}

impl Flags {
    pub const Empty: Flags = Flags { value: 0b0000 };
    pub const V: Flags = Flags { value: 0b1000 };
    pub const C: Flags = Flags { value: 0b0100 };
    pub const Z: Flags = Flags { value: 0b0010 };
    pub const N: Flags = Flags { value: 0b0001 };
}

impl Debug for Flags {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut flags = String::with_capacity(4);
        flags.push(if *self & Self::V != Self::Empty { 'V' } else { '-' });
        flags.push(if *self & Self::C != Self::Empty { 'C' } else { '-' });
        flags.push(if *self & Self::Z != Self::Empty { 'Z' } else { '-' });
        flags.push(if *self & Self::N != Self::Empty { 'N' } else { '-' });
        write!(f, "Flags({})", flags)
    }
}

impl BitOr for Flags {
    type Output = Self;

    fn bitor(self, rhs: Self) -> Self::Output {
        Flags { value: self.value | rhs.value }
    }
}

impl BitAnd for Flags {
    type Output = Self;

    fn bitand(self, rhs: Self) -> Self::Output {
        Flags { value: self.value & rhs.value }
    }
}

impl BitOrAssign for Flags {
    fn bitor_assign(&mut self, rhs: Self) {
        self.value |= rhs.value;
    }
}


pub struct FlagsRegister {
    pub name: &'static str,
    value_primary: Flags,
    value_secondary: Flags,
    calc_enabled: Cell<bool>,
}
impl OutReceiver for FlagsRegister {}
impl LoadReceiver for FlagsRegister {}
impl FlagsRegister {
    pub fn new(name: &'static str) -> Self {
        Self {
            name,
            value_primary: Flags::Empty,
            value_secondary: Flags::Empty,
            calc_enabled: Cell::new(false)
        }
    }
    pub fn on_calc_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("FlagsRegister {} Calc changed to: {}", self.name, new_state);
        self.calc_enabled.set(new_state);
    }
    pub fn on_carry_change(&self, buses: &mut Buses, new_state: bool) {
        println!("FlagsRegister {} Carry changed to: {}", self.name, new_state);
        buses.carry_in = new_state;
    }
}
impl ClockReceiver for FlagsRegister {
    fn on_clock_tick_primary(&mut self, buses: &mut Buses) {
        if self.calc_enabled.get() {
            // Perform Z and N calculations based on the main bus value
            let result = buses.resolve_main_bus();
            let mut new_value = Flags::Empty;
            if result == 0 {
                new_value |= Flags::Z;
            }
            if (result & 0x80) != 0 {
                new_value |= Flags::N;
            }

            let (carry, overflow) = buses.resolve_alu_flags();
            new_value |= carry.unwrap_or(self.value_primary & Flags::C); // Apply new or preserve previous carry if not calculated
            new_value |= overflow.unwrap_or(self.value_primary & Flags::V); // Apply new or preserve previous overflow if not calculated
            self.value_primary = new_value;
        }
    }
    fn on_clock_tick_secondary(&mut self, _buses: &mut Buses) {
        self.value_secondary = self.value_primary;
    }
}

impl Peek<Flags> for FlagsRegister {
    fn peek(&self) -> Flags {
        self.value_secondary
    }
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

pub struct TempRegister {
    pub name: &'static str,
}
impl LoadReceiver for TempRegister {}
impl TempRegister {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_alu_r_change(&self, _buses: &mut Buses, _new_state: bool) {}
}
impl ClockReceiver for TempRegister {}

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

pub struct ProgramCounter {
    pub name: &'static str,
}
impl ProgramCounter {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
}

impl OutReceiver for ProgramCounter {}
impl LoadReceiver for ProgramCounter {}
impl IncReceiver for ProgramCounter {}
impl ClockReceiver for ProgramCounter {}

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

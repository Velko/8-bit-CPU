use std::cell::Cell;
use std::ops::{BitOr, BitAnd, BitOrAssign};
use std::fmt::Debug;
    use crate::devices::MainBusValue;
use crate::devices::OutReceiver;
use crate::devices::LoadReceiver;
use crate::devices::ClockReceiver;
use crate::devices::ValueSource;
use crate::router::DeviceMap;
use crate::runtime_state::{ArgValues, ArgSources};

#[derive(Clone, Copy, PartialEq, Default)]
pub struct Flags {
    value: u8,
}

impl Flags {
    pub const EMPTY: Flags = Flags { value: 0b0000 };
    pub const V: Flags = Flags { value: 0b1000 };
    pub const C: Flags = Flags { value: 0b0100 };
    pub const Z: Flags = Flags { value: 0b0010 };
    pub const N: Flags = Flags { value: 0b0001 };
}

impl Debug for Flags {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut flags = String::with_capacity(4);
        flags.push(if *self & Self::V != Self::EMPTY { 'V' } else { '-' });
        flags.push(if *self & Self::C != Self::EMPTY { 'C' } else { '-' });
        flags.push(if *self & Self::Z != Self::EMPTY { 'Z' } else { '-' });
        flags.push(if *self & Self::N != Self::EMPTY { 'N' } else { '-' });
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
            value_primary: Flags::EMPTY,
            value_secondary: Flags::EMPTY,
            calc_enabled: Cell::new(false)
        }
    }
    pub fn on_calc_change(&self, _args: &mut ArgSources, enable: bool) {
        println!("FlagsRegister {} Calc changed to: {}", self.name, enable);
        self.calc_enabled.set(enable);
    }
    pub fn on_carry_change(&self, _args: &mut ArgSources, enable: bool) {
        println!("FlagsRegister {} Carry changed to: {}", self.name, enable);
        //state.carry_in = enable;
    }
}
impl ClockReceiver for FlagsRegister {
    fn on_clock_tick_primary(&mut self, args: &ArgValues) {
        // if self.calc_enabled.get() {
        //     // Perform Z and N calculations based on the main bus value
        //     let result = state.resolve_main_bus(devices);
        //     let mut new_value = Flags::EMPTY;
        //     if result == 0 {
        //         new_value |= Flags::Z;
        //     }
        //     if (result & 0x80) != 0 {
        //         new_value |= Flags::N;
        //     }

        //     let (carry, overflow) = state.resolve_alu_flags(devices);
        //     new_value |= carry.unwrap_or(self.value_primary & Flags::C); // Apply new or preserve previous carry if not calculated
        //     new_value |= overflow.unwrap_or(self.value_primary & Flags::V); // Apply new or preserve previous overflow if not calculated
        //     self.value_primary = new_value;
        // }
    }
    fn on_clock_tick_secondary(&mut self) {
        self.value_secondary = self.value_primary;
    }
}

impl ValueSource<Flags> for FlagsRegister {
    fn get_value(&self, _devices: &DeviceMap) -> Flags {
        self.value_secondary
    }
}

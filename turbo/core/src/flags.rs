use std::cell::Cell;
use std::ops::{BitOr, BitAnd, BitOrAssign};
use std::fmt::Debug;
use crate::devices::{DelayedPin, OutReceiver, ResetReceiver};
use crate::devices::LoadReceiver;
use crate::devices::ClockReceiver;
use crate::devices::ValueSource;
use crate::router::MainBusSource;
use crate::runtime_state::BusValues;

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
    main_id: MainBusSource,
    value_primary: Flags,
    value_secondary: Flags,
    load_enabled: Cell<bool>,
    pub calc: DelayedPin,
}
impl OutReceiver for FlagsRegister {
    fn on_out_change(&self, bus_values: &mut BusValues, enable: bool) {
        println!("FlagsRegister {} Out changed to: {}", self.name, enable);
        bus_values.main_bus.source = if enable {
            Some(self.main_id)
        } else {
            None
        };
    }
}

impl LoadReceiver for FlagsRegister {
    fn on_load_change(&self, _bus_values: &mut BusValues, enable: bool) {
        println!("FlagsRegister Load changed to: {}", enable);
        self.load_enabled.set(enable);
    }
}

impl FlagsRegister {
    pub fn new(name: &'static str, main_id: MainBusSource) -> Self {
        Self {
            name,
            main_id,
            value_primary: Flags::EMPTY,
            value_secondary: Flags::EMPTY,
            load_enabled: Cell::new(false),
            calc: DelayedPin::new()
        }
    }
}

impl ClockReceiver for FlagsRegister {
    fn on_clock_tick_primary(&mut self, bus_values: &BusValues) {
        if self.calc.is_enabled() {
            // Perform Z and N calculations based on the main bus value
            let result = bus_values.main_bus.value.unwrap();
            let mut new_value = Flags::EMPTY;
            if result == 0 {
                new_value |= Flags::Z;
            }
            if (result & 0x80) != 0 {
                new_value |= Flags::N;
            }

            new_value |= bus_values.flags.value.carry.unwrap_or(self.value_primary & Flags::C); // Apply new or preserve previous carry if not calculated
            new_value |= bus_values.flags.value.overflow.unwrap_or(self.value_primary & Flags::V); // Apply new or preserve previous overflow if not calculated
            self.value_primary = new_value;
        } else if self.load_enabled.get() {
            // Load flags from the main bus value
            let result = bus_values.main_bus.value.unwrap();
            self.value_primary = Flags { value: result };
        }
    }
    fn on_clock_tick_secondary(&mut self) {
        self.value_secondary = self.value_primary;
    }
}

impl ResetReceiver for FlagsRegister {
    fn on_reset(&mut self) {
        self.value_primary = Flags::EMPTY;
        self.value_secondary = Flags::EMPTY;
    }
}

impl ValueSource<Flags> for FlagsRegister {
    fn get_value(&self, _bus_values: &BusValues) -> Flags {
        self.value_secondary
    }
}

impl ValueSource<u8> for FlagsRegister {
    fn get_value(&self, _bus_values: &BusValues) -> u8 {
        self.value_secondary.value
    }
}
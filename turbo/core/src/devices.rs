use std::cell::Cell;

pub enum MainBusValue {
    None,
    Const(u8),
    Add,
}

pub struct Buses {
    pub main_bus: MainBusValue,
    pub address_bus: Option<u16>,
    pub alu_l_bus: Option<u8>,
    pub alu_r_bus: Option<u8>,
}

impl Buses {
    pub fn new() -> Self {
        Buses {
            main_bus: MainBusValue::None,
            address_bus: None,
            alu_l_bus: None,
            alu_r_bus: None,
        }
    }

    pub fn resolve_main_bus(&self) -> u8 {

        match self.main_bus {
            MainBusValue::None => panic!("Bus value is None"),
            MainBusValue::Const(value) => value,
            MainBusValue::Add => {
                let l = self.alu_l_bus.unwrap_or(0);
                let r = self.alu_r_bus.unwrap_or(0);
                l.wrapping_add(r)
            }
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


pub struct GPRegister {
    pub name: &'static str,
    value_primary: u8,
    value_secondary: u8,
    load_enabled: Cell<bool>,
    arg_l_enabled: Cell<bool>,
    arg_r_enabled: Cell<bool>,
}

impl OutReceiver for GPRegister {
    fn on_out_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("GPRegister {} Out changed to: {}", self.name, new_state);
    }
}

impl LoadReceiver for GPRegister {
    fn on_load_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("GPRegister {} Load changed to: {}", self.name, new_state);
        self.load_enabled.set(new_state);
    }
}

impl ClockReceiver for GPRegister {
    fn on_clock_tick_primary(&mut self, buses: &mut Buses) {
        if self.load_enabled.get() {
            self.value_primary = buses.resolve_main_bus();
        }
    }
    fn on_clock_tick_secondary(&mut self, buses: &mut Buses) {
        if self.value_primary != self.value_secondary {
            if self.arg_l_enabled.get() {
                buses.alu_l_bus = Some(self.value_primary);
            }
            if self.arg_r_enabled.get() {
                buses.alu_r_bus = Some(self.value_primary);
            }
            self.value_secondary = self.value_primary;
        }
    }
}

impl GPRegister {
    pub fn new(name: &'static str) -> Self {
        Self {
            name,
            value_primary: 0,
            value_secondary: 0,
            load_enabled: Cell::new(false),
            arg_l_enabled: Cell::new(false),
            arg_r_enabled: Cell::new(false),
        }
    }

    pub fn on_alu_l_change(&self, buses: &mut Buses, new_state: bool) {
        println!("GPRegister {} ALU L changed to: {}", self.name, new_state);
        self.arg_l_enabled.set(new_state);
        buses.alu_l_bus = if new_state {
            Some(self.value_secondary)
        } else {
            None
        };
    }
    pub fn on_alu_r_change(&self, buses: &mut Buses, new_state: bool) {
        println!("GPRegister {} ALU R changed to: {}", self.name, new_state);
        self.arg_r_enabled.set(new_state);
        buses.alu_r_bus = if new_state {
            Some(self.value_secondary)
        } else {
            None
        };
    }

    pub fn set_value(&mut self, buses: &mut Buses, value: u8) {
        self.value_primary = value;
        self.value_secondary = !value;
        self.on_clock_tick_primary(buses);
        self.on_clock_tick_secondary(buses);
    }
}


pub struct ALU {
    pub name: &'static str,
}
impl OutReceiver for ALU {
    fn on_out_change(&self, buses: &mut Buses, new_state: bool) {
        println!("ALU {} Out changed to: {}", self.name, new_state);
        buses.main_bus = if new_state {
            match self.name {
                "AddSub" => MainBusValue::Add,
                _ => panic!("Unknown ALU module name: {}", self.name),
            }
        } else {
            MainBusValue::None
        };
    }
}
impl ALU {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_alt_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("ALU {} Alt changed to: {}", self.name, new_state);
    }
}
impl ClockReceiver for ALU {}

pub struct FlagsRegister {
    pub name: &'static str,
}
impl OutReceiver for FlagsRegister {}
impl LoadReceiver for FlagsRegister {}
impl FlagsRegister {
    pub fn new(name: &'static str) -> Self {
        Self { name }
    }
    pub fn on_calc_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("FlagsRegister {} Calc changed to: {}", self.name, new_state);
    }
    pub fn on_carry_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("FlagsRegister {} Carry changed to: {}", self.name, new_state);
    }
}
impl ClockReceiver for FlagsRegister {}

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
    use super::*;
    use crate::router::DeviceMap;

    #[test]
    fn test_gp_register() {
        let mut buses = Buses::new();
        let mut gp_reg = GPRegister::new("GP1");

        // Simulate loading a value into the register
        gp_reg.load_enabled.set(true);
        buses.main_bus = MainBusValue::Const(42);
        gp_reg.on_clock_tick_primary(&mut buses);
        assert_eq!(gp_reg.value_primary, 42);

        // Simulate clock tick secondary
        gp_reg.on_clock_tick_secondary(&mut buses);
        assert_eq!(gp_reg.value_secondary, 42);
    }

    #[test]
    fn test_load_A() {
        let mut device_map = DeviceMap::new();
        let default_cw = 0x07ff58ff; // default
        let load_a_cw = 0x07ff580f; // load_A

        let mut buses = Buses::new();
        device_map.route_word(&mut buses, default_cw, load_a_cw);
        buses.main_bus = MainBusValue::Const(42); // Simulate loading 42 into A

        device_map.broadcast_clock_tick_primary(&mut buses);

        assert_eq!(42, device_map.A.value_primary); // Check if A has the value 42 after clock tick
    }

    #[test]
    fn test_alu_add() {
        let mut device_map = DeviceMap::new();
        let mut buses = Buses::new();
        let default_cw = 0x07ff58ff; // default
        device_map.route_word(&mut buses, !default_cw, default_cw); // Ensure we start from the default state


        device_map.A.set_value(&mut buses, 24);
        device_map.B.set_value(&mut buses, 18);

        let add_ab_cw = 0x07ff0405; // add_A_B
        device_map.route_word(&mut buses, default_cw, add_ab_cw);

        assert_eq!(42, buses.resolve_main_bus()); // Check if the main bus calculates the sum of A and B correctly
    }
}

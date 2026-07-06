use std::cell::RefCell;

pub struct Buses {
    pub main_bus: Option<u8>,
    pub address_bus: Option<u16>,
    pub alu_l_bus: Option<u8>,
    pub alu_r_bus: Option<u8>,
}

impl Buses {
    pub fn new() -> Self {
        Buses {
            main_bus: None,
            address_bus: None,
            alu_l_bus: None,
            alu_r_bus: None,
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
    fn on_clock_tick_primary(&mut self, _buses: &Buses) {}
    fn on_clock_tick_secondary(&mut self, _buses: &Buses) {}
}


pub struct GPRegister {
    pub name: &'static str,
    value_primary: u8,
    value_secondary: u8,
    load_enabled: RefCell<bool>,
}

impl OutReceiver for GPRegister {
    fn on_out_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("GPRegister {} Out changed to: {}", self.name, new_state);
    }
}

impl LoadReceiver for GPRegister {
    fn on_load_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("GPRegister {} Load changed to: {}", self.name, new_state);
        self.load_enabled.replace(new_state);
    }
}

impl ClockReceiver for GPRegister {
    fn on_clock_tick_primary(&mut self, buses: &Buses) {
        if *self.load_enabled.borrow() {
            self.value_primary = buses.main_bus.unwrap();
        }
    }
    fn on_clock_tick_secondary(&mut self, _buses: &Buses) {
        self.value_secondary = self.value_primary;
    }
}

impl GPRegister {
    pub fn new(name: &'static str) -> Self {
        Self {
            name,
            value_primary: 0,
            value_secondary: 0,
            load_enabled: RefCell::new(false)
        }
    }

    pub fn on_alu_l_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("GPRegister {} ALU L changed to: {}", self.name, new_state);
    }
    pub fn on_alu_r_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("GPRegister {} ALU R changed to: {}", self.name, new_state);
    }
}


pub struct ALU {
    pub name: &'static str,
}
impl OutReceiver for ALU {
    fn on_out_change(&self, _buses: &mut Buses, new_state: bool) {
        println!("ALU {} Out changed to: {}", self.name, new_state);
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
        *gp_reg.load_enabled.borrow_mut() = true;
        buses.main_bus = Some(42);
        gp_reg.on_clock_tick_primary(&buses);
        assert_eq!(gp_reg.value_primary, 42);

        // Simulate clock tick secondary
        gp_reg.on_clock_tick_secondary(&buses);
        assert_eq!(gp_reg.value_secondary, 42);
    }

    #[test]
    fn test_load_A() {
        let mut device_map = DeviceMap::new();
        let default_cw = 0x07ff58ff; // default
        let load_a_cw = 0x07ff580f; // load_A

        let mut buses = Buses::new();
        device_map.route_word(&mut buses, default_cw, load_a_cw);
        buses.main_bus = Some(42); // Simulate loading 42 into A

        device_map.broadcast_clock_tick_primary(&mut buses);

        assert_eq!(42, device_map.A.value_primary); // Check if A has the value 42 after clock tick
    }
}

use std::cell::Cell;

pub enum MainBusValue {
    None,
    Const(u8),
    Add,
    Subtract,
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
            }
        }
    }

    pub fn resolve_alu_flags(&self) -> (Option<bool>, Option<bool>) {
        let l = self.alu_l_bus.unwrap_or(0) as u16;
        let r = self.alu_r_bus.unwrap_or(0) as u16;
        let carry = if self.carry_in { 1 } else { 0 };
        match self.main_bus {
            MainBusValue::Add => {
                let sum = l.wrapping_add(r).wrapping_add(carry);
                let overflow = ((l ^ sum) & (r ^ sum) & 0x80) != 0;
                let carry_out = (l + r + carry) > 0xFF;
                (Some(carry_out), Some(overflow))
            }
            MainBusValue::Subtract => {
                //TODO: not sure if this is correct
                let sum = l.wrapping_add(!r).wrapping_add(1 - carry);
                let overflow = ((l ^ sum) & (r ^ sum) & 0x80) != 0;
                let carry_out = (l + r + carry) > 0xFF;
                (Some(carry_out), Some(overflow))
            }
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


pub struct GPRegister {
    pub name: &'static str,
    value_primary: u8,
    value_secondary: u8,
    out_enabled: Cell<bool>,
    load_enabled: Cell<bool>,
    arg_l_enabled: Cell<bool>,
    arg_r_enabled: Cell<bool>,
}

impl OutReceiver for GPRegister {
    fn on_out_change(&self, buses: &mut Buses, new_state: bool) {
        println!("GPRegister {} Out changed to: {}", self.name, new_state);
        buses.main_bus = if new_state {
            MainBusValue::Const(self.value_secondary)
        } else {
            MainBusValue::None
        };
        self.out_enabled.set(new_state);
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
            if self.out_enabled.get() {
                buses.main_bus = MainBusValue::Const(self.value_primary);
            }
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
            out_enabled: Cell::new(false),
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
    out_enabled: Cell<bool>,
    alt_enabled: Cell<bool>,
}
impl OutReceiver for ALU {
    fn on_out_change(&self, buses: &mut Buses, new_state: bool) {
        println!("ALU {} Out changed to: {}", self.name, new_state);
        self.out_enabled.set(new_state);
        self.publish_output(buses);
    }
}
impl ALU {
    pub fn new(name: &'static str) -> Self {
        Self {
            name,
            out_enabled: Cell::new(false),
            alt_enabled: Cell::new(false)
        }
    }
    pub fn on_alt_change(&self, buses: &mut Buses, new_state: bool) {
        println!("ALU {} Alt changed to: {}", self.name, new_state);
        self.alt_enabled.set(new_state);
        if self.out_enabled.get() {
            self.publish_output(buses);
        }
    }
    fn publish_output(&self, buses: &mut Buses) {
        buses.main_bus = if self.out_enabled.get() {
            match (self.name, self.alt_enabled.get()) {
                ("AddSub", false) => MainBusValue::Add,
                ("AddSub", true) => MainBusValue::Subtract,
                (_, _) => panic!("Unknown ALU module name: {}", self.name),
            }
        } else {
            MainBusValue::None
        };
    }
}
impl ClockReceiver for ALU {}

pub struct FlagsRegister {
    pub name: &'static str,
    value_primary: u8,
    value_secondary: u8,
    calc_enabled: Cell<bool>,
}
impl OutReceiver for FlagsRegister {}
impl LoadReceiver for FlagsRegister {}
impl FlagsRegister {

    const Empty: u8 = 0b0000;
    const V: u8 = 0b1000;
    const C: u8 = 0b0100;
    const Z: u8 = 0b0010;
    const N: u8 = 0b0001;

    pub fn new(name: &'static str) -> Self {
        Self {
            name,
            value_primary: Self::Empty,
            value_secondary: Self::Empty,
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
            let mut new_value = Self::Empty;
            if result == 0 {
                new_value |= Self::Z;
            }
            if (result & 0x80) != 0 {
                new_value |= Self::N;
            }

            let (carry, overflow) = buses.resolve_alu_flags();
            if let Some(carry) = carry {
                if carry {
                    new_value |= Self::C;
                }
            } else {
                new_value |= self.value_primary & Self::C; // Preserve previous carry if not calculated
            }
            if let Some(overflow) = overflow {
                if overflow {
                    new_value |= Self::V;
                }
            } else {
                new_value |= self.value_primary & Self::V; // Preserve previous overflow if not calculated
            }
            self.value_primary = new_value;
        }
    }
    fn on_clock_tick_secondary(&mut self, _buses: &mut Buses) {
        self.value_secondary = self.value_primary;
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

    fn i16tou8(value: i16) -> u8 {
        if value < 0 {
            (256 + value) as u8
        } else {
            value as u8
        }
    }

    #[rstest]
    #[case(24, 18, 42, FlagsRegister::Empty)] // 24 + 18 = 42, no flags set
    #[case(0, 0, 0, FlagsRegister::Z)] // 0 + 0 = 0, Z flag set
    #[case(0, -128, -128, FlagsRegister::N)]
    #[case(245, 18, 7, FlagsRegister::C)]
    #[case(126, 4, -126, FlagsRegister::N | FlagsRegister::V)] // 126 + 4 = -126 (overflow), N flag set
    #[case(246, 10, 0, FlagsRegister::C | FlagsRegister::Z)] // 246 + 10 = 0 (carry and zero), C and Z flags set
    #[case(200, 200, -112, FlagsRegister::C | FlagsRegister::N)]
    #[case(-30, -111, 115, FlagsRegister::V | FlagsRegister::C)]
    #[case(-128, -128, 0, FlagsRegister::C | FlagsRegister::Z | FlagsRegister::V)]
    fn test_alu_add(#[case] a: i16, #[case] b: i16, #[case] expected_sum: i16, #[case] expected_flags: u8) {
        let mut device_map = DeviceMap::new();
        let mut buses = Buses::new();
        let default_cw = 0x07ff58ff; // default
        device_map.route_word(&mut buses, !default_cw, default_cw); // Ensure we start from the default state

        let a = i16tou8(a);
        let b = i16tou8(b);
        let expected_sum = i16tou8(expected_sum);

        device_map.A.set_value(&mut buses, a);
        device_map.B.set_value(&mut buses, b);

        let add_ab_cw = 0x07ff0405; // add_A_B
        device_map.route_word(&mut buses, default_cw, add_ab_cw);

        assert_eq!(expected_sum, buses.resolve_main_bus()); // Check if the main bus calculates the sum of A and B correctly

        device_map.broadcast_clock_tick_primary(&mut buses);
        device_map.broadcast_clock_tick_secondary(&mut buses);

        assert_eq!(expected_sum, device_map.A.value_primary); // Check if A has the value expected_sum after clock tick
        assert_eq!(expected_sum, device_map.A.value_secondary); // Check if A has the value
        assert_eq!(b, device_map.B.value_primary); // Check if B remains unchanged
        assert_eq!(b, device_map.B.value_secondary); // Check if B remains unchanged
        assert_eq!(expected_flags, device_map.F.value_secondary); // Check if the flags register has the expected flags set after the operation

        assert_eq!(expected_sum, buses.alu_l_bus.unwrap()); // Check if ALU L bus has the updated value expected_sum
        assert_eq!(b, buses.alu_r_bus.unwrap()); // Check if ALU R bus has the original value b

    }

    #[test]
    fn test_output_reg_value() {
        let mut device_map = DeviceMap::new();
        let mut buses = Buses::new();
        let default_cw = 0x07ff58ff; // default
        device_map.route_word(&mut buses, !default_cw, default_cw); // Ensure we start from the default state

        device_map.A.set_value(&mut buses, 42);

        let out_a_cw = 0x07ff58f0; // out_A
        device_map.route_word(&mut buses, default_cw, out_a_cw);

        assert_eq!(42, buses.resolve_main_bus()); // Check if the main bus has the value 42 after out_A

        device_map.A.set_value(&mut buses, 100); // Change A's value to 100
        assert_eq!(100, buses.resolve_main_bus()); // Check if the main bus reflects the new value of A, since out_A is still active
    }

    #[test]
    fn test_alu_sub() {
        let mut device_map = DeviceMap::new();
        let mut buses = Buses::new();
        let default_cw = 0x07ff58ff; // default
        device_map.route_word(&mut buses, !default_cw, default_cw); // Ensure we start from the default state


        device_map.B.set_value(&mut buses, 24);
        device_map.C.set_value(&mut buses, 18);

        let sub_bc_cw = 0x07ff2915; // sub_B_C
        device_map.route_word(&mut buses, default_cw, sub_bc_cw);

        assert_eq!(6, buses.resolve_main_bus()); // Check if the main bus calculates the difference of B and C correctly

        device_map.broadcast_clock_tick_primary(&mut buses);
        device_map.broadcast_clock_tick_secondary(&mut buses);

        assert_eq!(6, device_map.B.value_primary); // Check if B has the value 6 after clock tick
        assert_eq!(6, device_map.B.value_secondary); // Check if B has the value
        assert_eq!(18, device_map.C.value_primary); // Check if C remains unchanged
        assert_eq!(18, device_map.C.value_secondary); // Check if C remains unchanged

        assert_eq!(6, buses.alu_l_bus.unwrap()); // Check if ALU L bus has the updated value 6
        assert_eq!(18, buses.alu_r_bus.unwrap()); // Check if ALU R bus has the original value 18
    }

    #[test]
    fn test_alu_adc() {
        let mut device_map = DeviceMap::new();
        let mut buses = Buses::new();
        let default_cw = 0x07ff58ff; // default
        device_map.route_word(&mut buses, !default_cw, default_cw); // Ensure we start from the default state


        device_map.A.set_value(&mut buses, 24);
        device_map.B.set_value(&mut buses, 18);

        let adc_ab_cw = 0x07ff8405; // adc_A_B
        device_map.route_word(&mut buses, default_cw, adc_ab_cw);

        assert_eq!(43, buses.resolve_main_bus()); // Check if the main bus calculates the sum of A and B + carry correctly
    }

    #[test]
    fn test_alu_sbb() {
        let mut device_map = DeviceMap::new();
        let mut buses = Buses::new();
        let default_cw = 0x07ff58ff; // default
        device_map.route_word(&mut buses, !default_cw, default_cw); // Ensure we start from the default state


        device_map.B.set_value(&mut buses, 24);
        device_map.C.set_value(&mut buses, 18);

        let sbb_bc_cw = 0x07ffa915; // sbb_B_C
        device_map.route_word(&mut buses, default_cw, sbb_bc_cw);

        assert_eq!(5, buses.resolve_main_bus()); // Check if the main bus calculates the difference of B and C correctly
    }
}

#![allow(non_snake_case)]
#![allow(dead_code)]

use crate::ControlWord;

include!(concat!(env!("OUT_DIR"), "/router_generated.rs"));

trait MuxDispatcher {
    const MASK: ControlWord;
    const DEFAULT: ControlWord;
    fn dispatch(dev: &DeviceMap, word: ControlWord, new_state: bool);
}

trait OutReceiver {
    fn on_out_change(&self, _new_state: bool) {}
}
trait LoadReceiver {
    fn on_load_change(&self, _new_state: bool) {}
}



struct GPRegister {
    name: &'static str,
}
impl OutReceiver for GPRegister {
    fn on_out_change(&self, new_state: bool) {
        println!("GPRegister {} Out changed to: {}", self.name, new_state);
    }
}

impl LoadReceiver for GPRegister {
    fn on_load_change(&self, new_state: bool) {
        println!("GPRegister {} Load changed to: {}", self.name, new_state);
    }
}

impl GPRegister {
    fn on_alu_l_change(&self, new_state: bool) {
        println!("GPRegister {} ALU L changed to: {}", self.name, new_state);
    }
    fn on_alu_r_change(&self, new_state: bool) {
        println!("GPRegister {} ALU R changed to: {}", self.name, new_state);
    }
}


struct ALU {
    name: &'static str,
}
impl OutReceiver for ALU {
    fn on_out_change(&self, new_state: bool) {
        println!("ALU {} Out changed to: {}", self.name, new_state);
    }
}

struct FlagsRegister {
    name: &'static str,
}
impl OutReceiver for FlagsRegister {}
impl LoadReceiver for FlagsRegister {}

struct RAM {
    name: &'static str,
}
impl OutReceiver for RAM {}
impl RAM {
    fn on_write_change(&self, _new_state: bool) {}
}

struct ROM {
    name: &'static str,
}
impl OutReceiver for ROM {}

struct TempRegister {
    name: &'static str,
}
impl LoadReceiver for TempRegister {}
impl TempRegister {
    fn on_alu_r_change(&self, _new_state: bool) {}
}


struct WORegister {
    name: &'static str,
}
impl LoadReceiver for WORegister {}

struct Clock {
    name: &'static str,
}

struct StepCounter {
    name: &'static str,
}

struct ProgramCounter {
    name: &'static str,
}
impl OutReceiver for ProgramCounter {}
impl LoadReceiver for ProgramCounter {}

struct TransferRegister {
    name: &'static str,
}
impl OutReceiver for TransferRegister {}
impl LoadReceiver for TransferRegister {}

struct StackPointer {
    name: &'static str,
}
impl OutReceiver for StackPointer {}
impl LoadReceiver for StackPointer {}

struct AddressRegister {
    name: &'static str,
}
impl OutReceiver for AddressRegister {}
impl LoadReceiver for AddressRegister {}

struct AddressCalculator {
    name: &'static str,
}
impl OutReceiver for AddressCalculator {}
impl LoadReceiver for AddressCalculator {}

struct IOController {
    name: &'static str,
}
impl IOController {
    fn on_laddr_change(&self, _new_state: bool) {}
    fn on_to_dev_change(&self, _new_state: bool) {}
    fn on_from_dev_change(&self, _new_state: bool) {}
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_static_dispatch() {
        let device_map = DeviceMap::new();
        let old_cw = 0x07ff58ff; // default
        let new_cw = 0x07ff0915; // add_B_C
        println!("add_B_C");
        device_map.route_word(old_cw, new_cw);

        let newer_cw = 0x07ff9805; // inc A
        println!("inc_A");
        device_map.route_word(new_cw, newer_cw);


        assert_eq!(old_cw, new_cw); // always fails, just to demonstrate the test
    }
}

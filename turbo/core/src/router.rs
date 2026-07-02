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



struct GPRegister;
impl OutReceiver for GPRegister {}
impl LoadReceiver for GPRegister {}

impl GPRegister {
    fn on_alu_l_change(&self, _new_state: bool) {}
    fn on_alu_r_change(&self, _new_state: bool) {}
}


struct ALU;
impl OutReceiver for ALU {}

struct FlagsRegister;
impl OutReceiver for FlagsRegister {}
impl LoadReceiver for FlagsRegister {}

struct RAM;
impl OutReceiver for RAM {}
impl RAM {
    fn on_write_change(&self, _new_state: bool) {}
}

struct ROM;
impl OutReceiver for ROM {}

struct TempRegister;
impl LoadReceiver for TempRegister {}
impl TempRegister {
    fn on_alu_r_change(&self, _new_state: bool) {}
}


struct WORegister;
impl LoadReceiver for WORegister {}

struct Clock;
struct StepCounter;

struct ProgramCounter;
impl OutReceiver for ProgramCounter {}
impl LoadReceiver for ProgramCounter {}

struct TransferRegister;
impl OutReceiver for TransferRegister {}
impl LoadReceiver for TransferRegister {}

struct StackPointer;
impl OutReceiver for StackPointer {}
impl LoadReceiver for StackPointer {}

struct AddressRegister;
impl OutReceiver for AddressRegister {}
impl LoadReceiver for AddressRegister {}

struct AddressCalculator;
impl OutReceiver for AddressCalculator {}
impl LoadReceiver for AddressCalculator {}

struct IOController;
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

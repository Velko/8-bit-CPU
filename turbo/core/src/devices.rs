pub trait OutReceiver {
    fn on_out_change(&self, _new_state: bool) {}
}
pub trait LoadReceiver {
    fn on_load_change(&self, _new_state: bool) {}
}
pub trait IncReceiver {
    fn on_inc_change(&self, _new_state: bool) {}
}
pub trait DecReceiver {
    fn on_dec_change(&self, _new_state: bool) {}
}


pub struct GPRegister {
    pub name: &'static str,
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

    pub fn on_alu_l_change(&self, new_state: bool) {
        println!("GPRegister {} ALU L changed to: {}", self.name, new_state);
    }
    pub fn on_alu_r_change(&self, new_state: bool) {
        println!("GPRegister {} ALU R changed to: {}", self.name, new_state);
    }
}


pub struct ALU {
    pub name: &'static str,
}
impl OutReceiver for ALU {
    fn on_out_change(&self, new_state: bool) {
        println!("ALU {} Out changed to: {}", self.name, new_state);
    }
}
impl ALU {
    pub fn on_alt_change(&self, new_state: bool) {
        println!("ALU {} Alt changed to: {}", self.name, new_state);
    }
}

pub struct FlagsRegister {
    pub name: &'static str,
}
impl OutReceiver for FlagsRegister {}
impl LoadReceiver for FlagsRegister {}
impl FlagsRegister {
    pub fn on_calc_change(&self, new_state: bool) {
        println!("FlagsRegister {} Calc changed to: {}", self.name, new_state);
    }
    pub fn on_carry_change(&self, new_state: bool) {
        println!("FlagsRegister {} Carry changed to: {}", self.name, new_state);
    }
}

pub struct RAM {
    pub name: &'static str,
}
impl OutReceiver for RAM {}
impl RAM {
    pub fn on_write_change(&self, _new_state: bool) {}
}

pub struct ROM {
    pub name: &'static str,
}
impl OutReceiver for ROM {}

pub struct TempRegister {
    pub name: &'static str,
}
impl LoadReceiver for TempRegister {}
impl TempRegister {
    pub fn on_alu_r_change(&self, _new_state: bool) {}
}


pub struct WORegister {
    pub name: &'static str,
}
impl LoadReceiver for WORegister {}

pub struct Clock {
    pub name: &'static str,
}
impl Clock {
    pub fn on_halt_change(&self, _new_state: bool) {}
    pub fn on_brk_change(&self, _new_state: bool) {}
}

pub struct StepCounter {
    pub name: &'static str,
}

impl StepCounter {
    pub fn on_reset_change(&self, _new_state: bool) {}
    pub fn on_extended_change(&self, _new_state: bool) {}
}

pub struct ProgramCounter {
    pub name: &'static str,
}
impl OutReceiver for ProgramCounter {}
impl LoadReceiver for ProgramCounter {}
impl IncReceiver for ProgramCounter {}

pub struct TransferRegister {
    pub name: &'static str,
}
impl OutReceiver for TransferRegister {}
impl LoadReceiver for TransferRegister {}

pub struct StackPointer {
    pub name: &'static str,
}
impl OutReceiver for StackPointer {}
impl LoadReceiver for StackPointer {}
impl IncReceiver for StackPointer {}
impl DecReceiver for StackPointer {}

pub struct AddressRegister {
    pub name: &'static str,
}
impl OutReceiver for AddressRegister {}
impl LoadReceiver for AddressRegister {}

pub struct AddressCalculator {
    pub name: &'static str,
}
impl OutReceiver for AddressCalculator {}
impl LoadReceiver for AddressCalculator {}
impl AddressCalculator {
    pub fn on_signed_change(&self, _new_state: bool) {}
}

pub struct IOController {
    pub name: &'static str,
}
impl IOController {
    pub fn on_laddr_change(&self, _new_state: bool) {}
    pub fn on_to_dev_change(&self, _new_state: bool) {}
    pub fn on_from_dev_change(&self, _new_state: bool) {}
}

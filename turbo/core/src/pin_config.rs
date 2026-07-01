#![allow(dead_code)]
use std::fs::File;
use serde::Deserialize;
use std::collections::HashMap;

#[derive(Debug, Deserialize)]
pub struct PinConfig {
    pub muxes: Vec<MuxConfig>,
    pub shared_pins: Vec<SharedPinConfig>,
    pub devices: Vec<DeviceConfig>,
}

#[derive(Debug, Deserialize)]
pub struct MuxConfig {
    pub name: String,
    pub pins: Vec<usize>,
    pub default: u8,
}

#[derive(Debug, Deserialize)]
#[serde(untagged)]
pub enum SharedPinConfig {
    MuxPin { name: String, mux: String, pin: u8 },
    DirectPin { name: String, pin: u8, level: Level },
}

#[derive(Debug, Deserialize)]
#[serde(tag = "type")]
pub enum DeviceConfig {
    GPRegister {
        name: String,
        pins: HashMap<GPRegisterPin, PinConfigEntry>,
    },
    ALU {
        name: String,
        pins: HashMap<ALUPin, PinConfigEntry>,
    },
    FlagsRegister {
        name: String,
        pins: FlagsRegisterPins,
    },
    RAM {
        name: String,
        pins: RAMPins,
    },
    ROM {
        name: String,
        pins: ROMPins,
    },
    TempRegister {
        name: String,
        pins: TempRegisterPins,
    },
    WORegister {
        name: String,
        pins: WORegisterPins,
    },
    Clock {
        name: String,
        pins: ClockPins,
    },
    StepCounter {
        name: String,
        pins: StepCounterPins,
    },
    ProgramCounter {
        name: String,
        pins: ProgramCounterPins,
    },
    TransferRegister {
        name: String,
        pins: TransferRegisterPins,
    },
    StackPointer {
        name: String,
        pins: StackPointerPins,
    },
    AddressRegister {
        name: String,
        pins: AddressRegisterPins,
    },
    AddressCalculator {
        name: String,
        pins: AddressCalculatorPins,
    },
    IOController {
        name: String,
        pins: IOControllerPins,
    },
}

#[derive(Debug, Deserialize, Hash, Eq, PartialEq)]
#[serde(rename_all = "snake_case")]
pub enum GPRegisterPin {
    Out,
    Load,
    AluL,
    AluR,
}

#[derive(Debug, Deserialize, Hash, Eq, PartialEq)]
#[serde(rename_all = "snake_case")]
pub enum ALUPin {
    Out,
    Alt,
}

#[derive(Debug, Deserialize)]
pub struct FlagsRegisterPins {
    out: PinConfigEntry,
    load: PinConfigEntry,
    calc: PinConfigEntry,
    carry: PinConfigEntry,
}

#[derive(Debug, Deserialize)]
pub struct RAMPins {
    out: PinConfigEntry,
    write: PinConfigEntry,
}

#[derive(Debug, Deserialize)]
pub struct ROMPins {
    out: PinConfigEntry,
}

#[derive(Debug, Deserialize)]
pub struct TempRegisterPins {
    load: PinConfigEntry,
    alu_r: PinConfigEntry,
}

#[derive(Debug, Deserialize)]
pub struct WORegisterPins {
    load: PinConfigEntry,
}

#[derive(Debug, Deserialize)]
pub struct ClockPins {
    halt: PinConfigEntry,
    brk: PinConfigEntry,
}

#[derive(Debug, Deserialize)]
pub struct StepCounterPins {
    reset: PinConfigEntry,
    extended: PinConfigEntry,
}

#[derive(Debug, Deserialize)]
pub struct ProgramCounterPins {
    out: PinConfigEntry,
    load: PinConfigEntry,
    inc: PinConfigEntry,
}

#[derive(Debug, Deserialize)]
pub struct TransferRegisterPins {
    out: PinConfigEntry,
    load: PinConfigEntry,
}

#[derive(Debug, Deserialize)]
pub struct StackPointerPins {
    out: PinConfigEntry,
    load: PinConfigEntry,
    inc: PinConfigEntry,
    dec: PinConfigEntry,
}

#[derive(Debug, Deserialize)]
pub struct AddressRegisterPins {
    out: PinConfigEntry,
    load: PinConfigEntry,
}

#[derive(Debug, Deserialize)]
pub struct AddressCalculatorPins {
    out: PinConfigEntry,
    load: PinConfigEntry,
    signed: PinConfigEntry,
}

#[derive(Debug, Deserialize)]
pub struct IOControllerPins {
    laddr: PinConfigEntry,
    to_dev: PinConfigEntry,
    from_dev: PinConfigEntry,
}

#[derive(Debug, Deserialize)]
pub enum Level {
    LOW,
    HIGH,
}

#[derive(Debug, Deserialize)]
#[serde(untagged)]
pub enum PinConfigEntry {
    MuxPin { mux: String, pin: u8 },
    Alias { pin: String },
    DirectPin { pin: u8, level: Level },
}

impl PinConfig {
    pub fn from_file(file_path: &str) -> Self {
        let f = File::open(file_path).expect("Failed to open pins file");
        serde_yaml::from_reader(f).expect("Failed to parse pins file")
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        hello();
    }
}

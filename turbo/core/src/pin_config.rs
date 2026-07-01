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
        pins: HashMap<String, PinConfigEntry>,
    },
    ALU {
        name: String,
        pins: HashMap<String, PinConfigEntry>,
    },
    FlagsRegister {
        name: String,
        pins: HashMap<String, PinConfigEntry>,
    },
    RAM {
        name: String,
        pins: HashMap<String, PinConfigEntry>,
    },
    ROM {
        name: String,
        pins: HashMap<String, PinConfigEntry>,
    },
    TempRegister {
        name: String,
        pins: HashMap<String, PinConfigEntry>,
    },
    WORegister {
        name: String,
        pins: HashMap<String, PinConfigEntry>,
    },
    Clock {
        name: String,
        pins: HashMap<String, PinConfigEntry>,
    },
    StepCounter {
        name: String,
        pins: HashMap<String, PinConfigEntry>,
    },
    ProgramCounter {
        name: String,
        pins: HashMap<String, PinConfigEntry>,
    },
    TransferRegister {
        name: String,
        pins: HashMap<String, PinConfigEntry>,
    },
    StackPointer {
        name: String,
        pins: HashMap<String, PinConfigEntry>,
    },
    AddressRegister {
        name: String,
        pins: HashMap<String, PinConfigEntry>,
    },
    AddressCalculator {
        name: String,
        pins: HashMap<String, PinConfigEntry>,
    },
    IOController {
        name: String,
        pins: HashMap<String, PinConfigEntry>,
    },
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

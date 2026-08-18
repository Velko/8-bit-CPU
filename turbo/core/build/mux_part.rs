use std::collections::HashMap;

use crate::{pin_config, util::format_const_name};

pub struct MuxPart {
    name: String,
    mask: u32,
    default: u32,
    pins: Vec<usize>,
    device_bits: HashMap<u32, (String, Vec<MuxPinRef>)>,
}

pub struct MuxPinRef {
    device: String,
    pin: String,
}

impl MuxPart {
    fn val_to_mask(pins: &[usize], val: u8) -> u32 {
        let mut mask: u32 = 0;
        for (i, pin) in pins.iter().enumerate() {
            if (val & (1 << i)) != 0 {
                mask |= 1 << pin;
            }
        }
        mask
    }

    pub fn emit(&self, writer: &mut dyn std::io::Write) -> std::io::Result<()> {
        writeln!(writer, "pub struct {};", self.name)?;
        writeln!(writer)?;
        writeln!(writer, "impl MuxDispatcher for {} {{", self.name)?;
        writeln!(writer, "    const MASK: ControlWord = 0b{:032b};", self.mask)?;
        writeln!(writer, "    const VALUE_DEFAULT: ControlWord = 0b{:032b};", self.default)?;
        writeln!(writer, "    fn dispatch<P: IOPorts>(dev: &DeviceMap<P>, bus_values: &mut BusValues, word: ControlWord, enable: bool) {{")?;
        writeln!(writer, "        match word & Self::MASK {{")?;
        for (_value, (alias, dev_refs)) in self.device_bits.iter() {
            if dev_refs.len() == 1 {
                let dev_ref = &dev_refs[0];
                writeln!(writer, "            Self::VALUE_{}_{} => dev.{}.{}.change(bus_values, enable),", dev_ref.device.to_uppercase(), dev_ref.pin.to_uppercase(), dev_ref.device, dev_ref.pin)?;
            } else {
                writeln!(writer, "            Self::VALUE_{} => {{", format_const_name(alias))?;
                for dev_ref in dev_refs {
                    match dev_ref.pin.as_str() {
                        "load" |
                        "laddr" |
                        "write" |
                        "to_dev" => writeln!(writer, "                dev.{}.{}.change(&dev.{}, bus_values, enable);", dev_ref.device, dev_ref.pin, dev_ref.device)?,
                        "out" =>    writeln!(writer, "                dev.{}.{}.change(bus_values, enable);", dev_ref.device, dev_ref.pin)?,
                        _ =>        writeln!(writer, "                dev.{}.on_{}_change(bus_values, enable);", dev_ref.device, dev_ref.pin)?,
                    }
                }
                writeln!(writer, "            }},")?;
            }
        }
        writeln!(writer, "            _ => {{}},")?;
        writeln!(writer, "        }}")?;
        writeln!(writer, "    }}")?;
        writeln!(writer, "}}")?;
        writeln!(writer)?;
        writeln!(writer, "impl {} {{", self.name)?;
        for (value, (alias, dev_refs)) in self.device_bits.iter() {
            if dev_refs.len() == 1 {
                let dev_ref = &dev_refs[0];
                writeln!(writer, "    pub const VALUE_{}_{}: ControlWord = 0b{:032b};", dev_ref.device.to_uppercase(), dev_ref.pin.to_uppercase(), value)?;
            } else {
                writeln!(writer, "    pub const VALUE_{}: ControlWord = 0b{:032b};", format_const_name(alias), value)?;
            }
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;
        Ok(())
    }

    pub fn add_device_bit(&mut self, device: &str, pin: &str, alias: &str, value: u8) {
        let mask = MuxPart::val_to_mask(&self.pins, value);
        self.device_bits.entry(mask).or_insert_with(|| (alias.to_string(), Vec::new())).1.push(MuxPinRef {
            device: device.to_string(),
            pin: pin.to_string(),
        });
    }
}

impl From<&pin_config::MuxConfig> for MuxPart {
    fn from(mux: &pin_config::MuxConfig) -> Self {
        let mut mask: u32 = 0;

        for pin in mux.pins.iter() {
            mask |= 1 << pin;
        }

        MuxPart {
            name: mux.name.clone(),
            pins: mux.pins.clone(),
            mask,
            default: MuxPart::val_to_mask(&mux.pins, mux.default),
            device_bits: HashMap::new(),
        }
    }
}

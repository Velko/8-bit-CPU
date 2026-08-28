use std::collections::HashMap;

use crate::util::format_type_name;

#[derive(Debug, Clone)]
pub struct DirectPinRef {
    pub device: String,
    pub pin: String,
    pub mask: u32,
    pub value: u32,
}

pub struct DirectPinsPart {
    pub direct_pins: HashMap<u32, (String, Vec<DirectPinRef>)>,
}

impl DirectPinsPart {
    pub fn new() -> Self {
        Self {
            direct_pins: HashMap::new(),
        }
    }

    pub fn emit(&self, writer: &mut dyn std::io::Write) -> std::io::Result<()> {
        for (mask, (device_name, direct_pins)) in &self.direct_pins {
            if direct_pins.len() == 1 {
                let direct_pin = &direct_pins[0];
                let struct_name = format_type_name(&format!("{}.{}", direct_pin.device, direct_pin.pin));
                writeln!(writer, "pub struct {};",  struct_name)?;
                writeln!(writer)?;
                writeln!(writer, "impl BitDispatcher for {} {{", struct_name)?;
                writeln!(writer, "    const MASK: ControlWord = 0b{:032b};", direct_pin.mask)?;
                writeln!(writer, "    const VALUE: ControlWord = 0b{:032b};", direct_pin.value)?;
                writeln!(writer, "}}")?;
            } else {
                let direct_pin = &direct_pins[0];
                writeln!(writer, "pub struct {};", format_type_name(&device_name))?;
                writeln!(writer)?;
                writeln!(writer, "impl BitDispatcher for {} {{", format_type_name(&device_name))?;
                writeln!(writer, "    const MASK: ControlWord = 0b{:032b};", mask)?;
                writeln!(writer, "    const VALUE: ControlWord = 0b{:032b};", direct_pin.value)?;
                writeln!(writer, "}}")?;
            }
            writeln!(writer)?;
        }
        Ok(())
    }
}

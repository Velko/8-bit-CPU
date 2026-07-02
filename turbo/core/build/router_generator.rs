use std::collections::HashMap;
use std::fs::File;
use crate::pin_config;

struct MuxPart {
    name: String,
    mask: u32,
    default: u32,
    pins: Vec<usize>,
    device_bits: Vec<MuxPinRef>,
}

pub struct MuxPinRef {
    device: String,
    pin: String,
    value: u32,
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
        writeln!(writer, "struct {};", self.name)?;
        writeln!(writer, "impl MuxDispatcher for {} {{", self.name)?;
        writeln!(writer, "    const MASK:    ControlWord = 0b{:032b};", self.mask)?;
        writeln!(writer, "    const DEFAULT: ControlWord = 0b{:032b};", self.default)?;
        writeln!(writer, "    fn dispatch(dev: &DeviceMap, word: ControlWord, new_state: bool) {{")?;
        writeln!(writer, "        match word & Self::MASK {{")?;
        for dev_ref in self.device_bits.iter() {
            writeln!(writer, "            0b{:032b} => dev.{}.on_{}_change(new_state),", dev_ref.value, dev_ref.device, dev_ref.pin)?;
        }
        writeln!(writer, "            _ => {{}},")?;
        writeln!(writer, "        }}")?;
        writeln!(writer, "    }}")?;
        writeln!(writer, "}}")?;
        writeln!(writer)?;
        Ok(())
    }

    fn add_device_bit(&mut self, device: &str, pin: &str, value: u8) {
        let mask = MuxPart::val_to_mask(&self.pins, value);
        self.device_bits.push(MuxPinRef {
            device: device.to_string(),
            pin: pin.to_string(),
            value: mask,
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
            device_bits: Vec::new(),
        }
    }
}


pub struct DevicePart {
    name: String,
    dev_type: String,
}

pub struct DeviceMapPart {
    devices: Vec<DevicePart>,
}

impl DeviceMapPart {
    fn emit(&self, writer: &mut dyn std::io::Write) -> std::io::Result<()> {
        writeln!(writer, "struct DeviceMap {{")?;
        for device in self.devices.iter() {
            writeln!(writer, "    {}: {},", device.name, device.dev_type)?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;


        writeln!(writer, "impl DeviceMap {{")?;
        writeln!(writer, "    pub fn new() -> Self {{")?;
        writeln!(writer, "        DeviceMap {{")?;
        for device in self.devices.iter() {
            writeln!(writer, "            {}: {} {{ }},", device.name, device.dev_type)?;
        }
        writeln!(writer, "        }}")?;
        writeln!(writer, "    }}")?;
        writeln!(writer, "}}")?;

        Ok(())
    }
}


pub fn generate_router(out_dir: &str, manifest_dir: &str) {
    let pins = pin_config::PinConfig::from_file(&format!("{}/pins.yaml", manifest_dir));
    //println!("Loaded pins: {:?}", pins);

    let mut muxes: HashMap<String, MuxPart> = HashMap::new();

    for mux in pins.muxes.iter() {
        muxes.insert(mux.name.clone(), MuxPart::from(mux));
    }

    let mut device_map = DeviceMapPart { devices: Vec::new() };


    for device in pins.devices.iter() {
        device_map.devices.push(DevicePart {
            name: device.name.clone(),
            dev_type: device.dev_type.clone(),
        });
        for (pin_name, pin_entry) in device.pins.iter() {
            match pin_entry {
                pin_config::PinConfigEntry::MuxPin { mux, pin } => {
                    if let Some(mux_part) = muxes.get_mut(mux) {
                        mux_part.add_device_bit(&device.name, pin_name, *pin);
                    } else {
                        eprintln!("Warning: Mux {} not found for device {} pin {}", mux, device.name, pin_name);
                    }
                },
                _ => {}
            }
        }
    }

    let mut f = File::create(&format!("{}/router_generated.rs", out_dir)).expect("Failed to create out file");

    device_map.emit(&mut f).expect("Failed to emit device map");

    for m in muxes.values() {
         m.emit(&mut f).expect("Failed to emit mux");
    }

    emit_router_fn(&mut f, &muxes).expect("Failed to emit router");
}


fn emit_router_fn(writer: &mut dyn std::io::Write, muxes: &HashMap<String, MuxPart>) -> std::io::Result<()> {
    writeln!(writer, "impl DeviceMap {{")?;
    writeln!(writer, "    pub fn route_word(&self, old_cw: ControlWord, new_cw: ControlWord) {{")?;


    for (name, mux) in muxes.iter() {
        writeln!(writer, "        if old_cw & {}::MASK != new_cw & {}::MASK {{", name, name)?;
        writeln!(writer, "            {}::dispatch(self, old_cw, false);", name)?;
        writeln!(writer, "            {}::dispatch(self, new_cw, true);", name)?;
        writeln!(writer, "        }}")?;
    }
    writeln!(writer, "    }}")?;
    writeln!(writer, "}}")?;

    Ok(())
}

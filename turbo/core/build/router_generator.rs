use std::collections::HashMap;
use std::fs::File;
use crate::pin_config;

struct MuxPart {
    name: String,
    mask: u32,
    default: u32,
    pins: Vec<usize>,
    device_bits: HashMap<u32, (String, Vec<MuxPinRef>)>,
}

pub struct MuxPinRef {
    device: String,
    pin: String,
    value: u32,
}

pub struct DirectPinRef {
    device: String,
    pin: String,
    mask: u32,
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
        writeln!(writer, "pub struct {};", self.name)?;
        writeln!(writer, "impl MuxDispatcher for {} {{", self.name)?;
        writeln!(writer, "    const MASK: ControlWord = 0b{:032b};", self.mask)?;
        writeln!(writer, "    const VALUE_DEFAULT: ControlWord = 0b{:032b};", self.default)?;
        writeln!(writer, "    fn dispatch(dev: &DeviceMap, buses: &mut Buses, word: ControlWord, new_state: bool) {{")?;
        writeln!(writer, "        match word & Self::MASK {{")?;
        for (value, (alias, dev_refs)) in self.device_bits.iter() {
            if dev_refs.len() == 1 {
                let dev_ref = &dev_refs[0];
                writeln!(writer, "            Self::VALUE_{}_{} => dev.{}.on_{}_change(buses, new_state),", dev_ref.device.to_uppercase(), dev_ref.pin.to_uppercase(), dev_ref.device, dev_ref.pin)?;
            } else {
                writeln!(writer, "            Self::VALUE_{} => {{", sanitize_name(&alias.to_uppercase()))?;
                for dev_ref in dev_refs {
                    writeln!(writer, "                dev.{}.on_{}_change(buses, new_state);", dev_ref.device, dev_ref.pin)?;
                }
                writeln!(writer, "            }},")?;
            }
        }
        writeln!(writer, "            _ => {{}},")?;
        writeln!(writer, "        }}")?;
        writeln!(writer, "    }}")?;
        writeln!(writer, "}}")?;
        writeln!(writer, "impl {} {{", self.name)?;
        for (value, (alias, dev_refs)) in self.device_bits.iter() {
            if dev_refs.len() == 1 {
                let dev_ref = &dev_refs[0];
                writeln!(writer, "    pub const VALUE_{}_{}: ControlWord = 0b{:032b};", dev_ref.device.to_uppercase(), dev_ref.pin.to_uppercase(), value)?;
            } else {
                writeln!(writer, "    pub const VALUE_{}: ControlWord = 0b{:032b};", sanitize_name(&alias.to_uppercase()), value)?;
            }
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;
        Ok(())
    }

    fn add_device_bit(&mut self, device: &str, pin: &str, alias: &str, value: u8) {
        let mask = MuxPart::val_to_mask(&self.pins, value);
        self.device_bits.entry(mask).or_insert_with(|| (alias.to_string(), Vec::new())).1.push(MuxPinRef {
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
            device_bits: HashMap::new(),
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
        writeln!(writer, "pub struct DeviceMap {{")?;
        for device in self.devices.iter() {
            writeln!(writer, "    pub {}: {},", device.name, device.dev_type)?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;


        writeln!(writer, "impl DeviceMap {{")?;
        writeln!(writer, "    pub fn new() -> Self {{")?;
        writeln!(writer, "        DeviceMap {{")?;
        for device in self.devices.iter() {
            writeln!(writer, "            {}: {}::new(\"{}\"),", device.name, device.dev_type, device.name)?;
        }
        writeln!(writer, "        }}")?;
        writeln!(writer, "    }}")?;

        writeln!(writer, "    pub fn broadcast_clock_tick_primary(&mut self, buses: &mut Buses) {{")?;
        for device in self.devices.iter() {
            writeln!(writer, "        self.{}.on_clock_tick_primary(buses);", device.name)?;
        }
        writeln!(writer, "    }}")?;

        writeln!(writer, "    pub fn broadcast_clock_tick_secondary(&mut self, buses: &mut Buses) {{")?;
        for device in self.devices.iter() {
            writeln!(writer, "        self.{}.on_clock_tick_secondary(buses);", device.name)?;
        }
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

    let shared: HashMap<String, &pin_config::SharedPinConfig> = pins.shared_pins.iter()
        .map(|sp| (match sp {
            pin_config::SharedPinConfig::DirectPin { name, .. } => name.clone(),
            pin_config::SharedPinConfig::MuxPin { name, .. } => name.clone(),
        }, sp))
        .collect();

    let mut device_map = DeviceMapPart { devices: Vec::new() };

    let mut direct_pins: HashMap<u32, (String, Vec<DirectPinRef>)> = HashMap::new();

    for device in pins.devices.iter() {
        device_map.devices.push(DevicePart {
            name: device.name.clone(),
            dev_type: device.dev_type.clone(),
        });
        for (pin_name, pin_entry) in device.pins.iter() {
            match pin_entry {
                pin_config::PinConfigEntry::MuxPin { mux, pin } => {
                    // Add the device pin to the corresponding mux
                    let mux_part = muxes.get_mut(mux).unwrap();
                    mux_part.add_device_bit(&device.name, pin_name, &format!("{}_{}", device.name, pin_name), *pin);
                },
                pin_config::PinConfigEntry::DirectPin { pin, level } => {
                    // Direct pins are not part of a mux, we will handle them separately
                    let mask = 1 << pin;
                    let value = if *level == pin_config::Level::HIGH { mask } else { 0 };
                    direct_pins.entry(mask).or_insert_with(|| (format!("{}{}", device.name, pin_name), Vec::new())).1.push(DirectPinRef { device: device.name.clone(), pin: pin_name.clone(), mask, value });
                },
                pin_config::PinConfigEntry::Alias { pin: apin }  => {
                    match shared.get(apin).unwrap() {
                        pin_config::SharedPinConfig::MuxPin { mux, pin: mux_pin, .. } => {
                            let mux_part = muxes.get_mut(mux).unwrap();
                            mux_part.add_device_bit(&device.name, pin_name, apin, *mux_pin);
                        },
                        pin_config::SharedPinConfig::DirectPin { pin: direct_pin, level, .. } => {
                            let mask = 1 << direct_pin;
                            let value = if *level == pin_config::Level::HIGH { mask } else { 0 };
                            direct_pins.entry(mask).or_insert_with(|| (sanitize_name(apin), Vec::new())).1.push(DirectPinRef { device: device.name.clone(), pin: pin_name.clone(), mask, value });
                        },
                    }
                },
            }
        }
    }

    let mut f = File::create(&format!("{}/router_generated.rs", out_dir)).expect("Failed to create out file");

    device_map.emit(&mut f).expect("Failed to emit device map");

    for m in muxes.values() {
         m.emit(&mut f).expect("Failed to emit mux");
    }

    emit_direct_pins(&mut f, &direct_pins).expect("Failed to emit direct pins");
    emit_router_fn(&mut f, &muxes, &direct_pins).expect("Failed to emit router");
}


fn emit_router_fn(writer: &mut dyn std::io::Write, muxes: &HashMap<String, MuxPart>, direct_pins: &HashMap<u32, (String, Vec<DirectPinRef>)>) -> std::io::Result<()> {
    writeln!(writer, "impl DeviceMap {{")?;
    writeln!(writer, "    pub fn route_word(&self, buses: &mut Buses, old_cw: ControlWord, new_cw: ControlWord) {{")?;


    for (name, _) in muxes.iter() {
        writeln!(writer, "        if old_cw & {}::MASK != new_cw & {}::MASK {{", name, name)?;
        writeln!(writer, "            {}::dispatch(self, buses, old_cw, false);", name)?;
        writeln!(writer, "            {}::dispatch(self, buses, new_cw, true);", name)?;
        writeln!(writer, "        }}")?;
    }

    for (mask, (alias, direct_pins)) in direct_pins {
        writeln!(writer, "        if old_cw & {}::MASK != new_cw & {}::MASK {{", alias, alias)?;
        for direct_pin in direct_pins {
            writeln!(writer, "            self.{}.on_{}_change(buses, new_cw & {}::MASK == {}::VALUE);", direct_pin.device, direct_pin.pin, alias, alias)?;
        }
        writeln!(writer, "        }}")?;
    }
    writeln!(writer, "    }}")?;
    writeln!(writer, "}}")?;
    Ok(())
}

fn emit_direct_pins(writer: &mut dyn std::io::Write, direct_pins: &HashMap<u32, (String, Vec<DirectPinRef>)>) -> std::io::Result<()> {
    for (mask, (device_name, direct_pins)) in direct_pins {
        if direct_pins.len() == 1 {
            let direct_pin = &direct_pins[0];
            writeln!(writer, "pub struct {}{};", direct_pin.device, direct_pin.pin)?;
            writeln!(writer, "impl BitDispatcher for {}{} {{", direct_pin.device, direct_pin.pin)?;
            writeln!(writer, "    const MASK: ControlWord = 0b{:032b};", direct_pin.mask)?;
            writeln!(writer, "    const VALUE: ControlWord = 0b{:032b};", direct_pin.value)?;
            writeln!(writer, "}}")?;
        } else {
            let direct_pin = &direct_pins[0];
            writeln!(writer, "pub struct {};", sanitize_name(&device_name))?;
            writeln!(writer, "impl BitDispatcher for {} {{", sanitize_name(&device_name))?;
            writeln!(writer, "    const MASK: ControlWord = 0b{:032b};", mask)?;
            writeln!(writer, "    const VALUE: ControlWord = 0b{:032b};", direct_pin.value)?;
            writeln!(writer, "}}")?;
        }
        writeln!(writer)?;
    }
    Ok(())
}

fn sanitize_name(name: &str) -> String {
    name.chars().map(|c| if c.is_alphanumeric() { c } else { '_' }).collect()
}

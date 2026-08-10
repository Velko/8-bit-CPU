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
        writeln!(writer)?;
        writeln!(writer, "impl MuxDispatcher for {} {{", self.name)?;
        writeln!(writer, "    const MASK: ControlWord = 0b{:032b};", self.mask)?;
        writeln!(writer, "    const VALUE_DEFAULT: ControlWord = 0b{:032b};", self.default)?;
        writeln!(writer, "    fn dispatch<P: IOPorts>(dev: &DeviceMap<P>, bus_values: &mut BusValues, word: ControlWord, enable: bool) {{")?;
        writeln!(writer, "        match word & Self::MASK {{")?;
        for (_value, (alias, dev_refs)) in self.device_bits.iter() {
            if dev_refs.len() == 1 {
                let dev_ref = &dev_refs[0];
                match dev_ref.pin.as_str() {
                    "load" |
                    "laddr" |
                    "write" |
                    "to_dev" => writeln!(writer, "            Self::VALUE_{}_{} => dev.{}.{}.change(&dev.{}, bus_values, enable),", dev_ref.device.to_uppercase(), dev_ref.pin.to_uppercase(), dev_ref.device, dev_ref.pin, dev_ref.device)?,
                    "alu_l" |
                    "alu_r" |
                    "out" |
                    "from_dev" =>  writeln!(writer, "            Self::VALUE_{}_{} => dev.{}.{}.change(bus_values, enable),", dev_ref.device.to_uppercase(), dev_ref.pin.to_uppercase(), dev_ref.device, dev_ref.pin)?,
                    _ => writeln!(writer, "            Self::VALUE_{}_{} => dev.{}.on_{}_change(bus_values, enable),", dev_ref.device.to_uppercase(), dev_ref.pin.to_uppercase(), dev_ref.device, dev_ref.pin)?,
                }

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

    fn add_device_bit(&mut self, device: &str, pin: &str, alias: &str, value: u8) {
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

pub struct BusSourcesPart {
    main_bus_sources: Vec<String>,
    address_bus_sources: Vec<String>,
    alu_l_sources: Vec<String>,
    alu_r_sources: Vec<String>,
    flags_sources: Vec<String>,
}

impl BusSourcesPart {
    pub fn new() -> Self {
        BusSourcesPart {
            main_bus_sources: Vec::new(),
            address_bus_sources: Vec::new(),
            alu_l_sources: Vec::new(),
            alu_r_sources: Vec::new(),
            flags_sources: Vec::new(),
        }
    }

    pub fn is_main_bus_source(dev_type: &str, name: &str) -> bool {
        match dev_type {
            "GPRegister" |
            "ALU" |
            "FlagsRegister" |
            "RAM" |
            "ROM" |
            "IOController"=> true,
            "TransferRegister" if name != "TX" => true,
            _ => false,
        }
    }

    pub fn is_alu_l_source(dev_type: &str) -> bool {
        match dev_type {
            "GPRegister" => true,
            _ => false,
        }
    }

    pub fn is_alu_r_source(dev_type: &str) -> bool {
        match dev_type {
            "GPRegister" |
            "TempRegister" => true,
            _ => false,
        }
    }

    pub fn is_address_bus_source(dev_type: &str, name: &str) -> bool {
        match dev_type {
            "ProgramCounter" |
            "AddressRegister" |
            "StackPointer" |
            "AddressCalculator" => true,
            "TransferRegister" if name == "TX" => true,
            _ => false,
        }
    }

    pub fn is_flags_source(dev_type: &str) -> bool {
        match dev_type {
            "ALU" => true,
            _ => false,
        }
    }

    pub fn emit(&self, writer: &mut dyn std::io::Write) -> std::io::Result<()> {
        writeln!(writer, "#[derive(Debug, Clone, Copy, PartialEq)]")?;
        writeln!(writer, "pub enum MainBusSource {{")?;
        for source in self.main_bus_sources.iter() {
            writeln!(writer, "    {},", source)?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;

        writeln!(writer, "#[derive(Debug, Clone, Copy, PartialEq)]")?;
        writeln!(writer, "pub enum ALULSource {{")?;
        for source in self.alu_l_sources.iter() {
            writeln!(writer, "    {},", source)?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;

        writeln!(writer, "#[derive(Debug, Clone, Copy, PartialEq)]")?;
        writeln!(writer, "pub enum ALURSource {{")?;
        for source in self.alu_r_sources.iter() {
            writeln!(writer, "    {},", source)?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;

        writeln!(writer, "#[derive(Debug, Clone, Copy, PartialEq)]")?;
        writeln!(writer, "pub enum AddressBusSource {{")?;
        for source in self.address_bus_sources.iter() {
            writeln!(writer, "    {},", source)?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;

        writeln!(writer, "#[derive(Debug, Clone, Copy, PartialEq)]")?;
        writeln!(writer, "pub enum FlagsSource {{")?;
        for source in self.flags_sources.iter() {
            writeln!(writer, "    {},", source)?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;

        Ok(())
    }
}


pub struct DevicePart {
    name: String,
    dev_type: String,
}

pub struct DeviceMapPart {
    devices: Vec<DevicePart>,
    bus_sources: BusSourcesPart,
}

impl DeviceMapPart {
    fn emit(&mut self, writer: &mut dyn std::io::Write) -> std::io::Result<()> {
        writeln!(writer, "pub struct DeviceMap<P: IOPorts> {{")?;
        for device in self.devices.iter() {
            writeln!(writer, "    pub {}: {},", device.name, map_device_type(&device.dev_type, &device.name))?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)?;


        writeln!(writer, "impl<P: IOPorts> DeviceMap<P> {{")?;
        writeln!(writer, "    pub fn new(ioports: P) -> Self {{")?;
        writeln!(writer, "        DeviceMap {{")?;
        for device in self.devices.iter() {
            let mut ids: Vec<String> = vec![format!("\"{}\"", device.name)];
            if BusSourcesPart::is_main_bus_source(&device.dev_type, &device.name) {
                ids.push(format!("MainBusSource::{}", device.name));
                self.bus_sources.main_bus_sources.push(device.name.clone());
            }
            if BusSourcesPart::is_alu_l_source(&device.dev_type) {
                ids.push(format!("ALULSource::{}", device.name));
                self.bus_sources.alu_l_sources.push(device.name.clone());
            }
            if BusSourcesPart::is_alu_r_source(&device.dev_type) {
                ids.push(format!("ALURSource::{}", device.name));
                self.bus_sources.alu_r_sources.push(device.name.clone());
            }
            if BusSourcesPart::is_address_bus_source(&device.dev_type, &device.name) {
                ids.push(format!("AddressBusSource::{}", device.name));
                self.bus_sources.address_bus_sources.push(device.name.clone());
            }
            if BusSourcesPart::is_flags_source(&device.dev_type) {
                ids.push(format!("FlagsSource::{}", device.name));
                self.bus_sources.flags_sources.push(device.name.clone());
            }
            if device.dev_type == "IOController" {
                ids.push("ioports".to_string());
            }
            writeln!(writer, "            {}: {}::new({}),", device.name, map_device_type(&device.dev_type, &device.name), ids.join(", "))?;
        }
        writeln!(writer, "        }}")?;
        writeln!(writer, "    }}")?;
        writeln!(writer)?;

        writeln!(writer, "    pub fn broadcast_clock_tick_primary(&mut self, bus_values: &mut BusValues) {{")?;
        for device in self.devices.iter() {
            writeln!(writer, "        self.{}.on_clock_tick_primary(bus_values);", device.name)?;
        }
        writeln!(writer, "    }}")?;
        writeln!(writer)?;

        writeln!(writer, "    pub fn broadcast_clock_tick_secondary(&mut self) {{")?;
        for device in self.devices.iter() {
            writeln!(writer, "        self.{}.on_clock_tick_secondary();", device.name)?;
        }
        writeln!(writer, "    }}")?;
        writeln!(writer)?;

        writeln!(writer, "    pub fn get_main_bus_value(&self, source: MainBusSource, bus_values: &BusValues) -> u8 {{")?;
        writeln!(writer, "        match source {{")?;
        for device in self.bus_sources.main_bus_sources.iter() {
            writeln!(writer, "            MainBusSource::{} => self.{}.get_value(bus_values),", device, device)?;
        }
        writeln!(writer, "        }}")?;
        writeln!(writer, "    }}")?;
        writeln!(writer)?;

        writeln!(writer, "    pub fn get_alu_l_value(&self, source: ALULSource, bus_values: &BusValues) -> u8 {{")?;
        writeln!(writer, "        match source {{")?;
        for device in self.bus_sources.alu_l_sources.iter() {
            writeln!(writer, "            ALULSource::{} => self.{}.get_value(bus_values),", device, device)?;
        }
        writeln!(writer, "        }}")?;
        writeln!(writer, "    }}")?;
        writeln!(writer)?;

        writeln!(writer, "    pub fn get_alu_r_value(&self, source: ALURSource, bus_values: &BusValues) -> u8 {{")?;
        writeln!(writer, "        match source {{")?;
        for device in self.bus_sources.alu_r_sources.iter() {
            writeln!(writer, "            ALURSource::{} => self.{}.get_value(bus_values),", device, device)?;
        }
        writeln!(writer, "        }}")?;
        writeln!(writer, "    }}")?;
        writeln!(writer)?;

        writeln!(writer, "    pub fn get_address_bus_value(&self, source: AddressBusSource, bus_values: &BusValues) -> u16 {{")?;
        writeln!(writer, "        match source {{")?;
        for device in self.bus_sources.address_bus_sources.iter() {
            writeln!(writer, "            AddressBusSource::{} => self.{}.get_value(bus_values),", device, device)?;
        }
        writeln!(writer, "        }}")?;
        writeln!(writer, "    }}")?;
        writeln!(writer)?;

        writeln!(writer, "    pub fn get_flags_value(&self, source: FlagsSource, bus_values: &BusValues) -> ALUFlags {{")?;
        writeln!(writer, "        match source {{")?;
        for device in self.bus_sources.flags_sources.iter() {
            writeln!(writer, "            FlagsSource::{} => self.{}.get_value(bus_values),", device, device)?;
        }
        writeln!(writer, "        }}")?;
        writeln!(writer, "    }}")?;
        writeln!(writer)?;

        writeln!(writer, "    pub fn broadcast_reset(&mut self) {{")?;
        for device in self.devices.iter() {
            writeln!(writer, "        self.{}.on_reset();", device.name)?;
        }
        writeln!(writer, "    }}")?;

        writeln!(writer, "}}")?;
        writeln!(writer)?;

        self.bus_sources.emit(writer).expect("Failed to emit bus sources");

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

    let mut device_map = DeviceMapPart { devices: Vec::new(), bus_sources: BusSourcesPart::new() };

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
                    direct_pins.entry(mask).or_insert_with(|| (format_type_name(&format!("{}.{}", device.name, pin_name)), Vec::new())).1.push(DirectPinRef { device: device.name.clone(), pin: pin_name.clone(), mask, value });
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
                            direct_pins.entry(mask).or_insert_with(|| (format_type_name(apin), Vec::new())).1.push(DirectPinRef { device: device.name.clone(), pin: pin_name.clone(), mask, value });
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


    emit_default_control_word(&mut f, &muxes, &direct_pins).expect("Failed to emit default control word");
}


fn emit_router_fn(writer: &mut dyn std::io::Write, muxes: &HashMap<String, MuxPart>, direct_pins: &HashMap<u32, (String, Vec<DirectPinRef>)>) -> std::io::Result<()> {
    writeln!(writer, "impl< P: IOPorts> DeviceMap<P> {{")?;
    writeln!(writer, "    pub fn route_word(&self, bus_values: &mut BusValues, old_cw: ControlWord, new_cw: ControlWord) {{")?;

    for (name, _) in muxes.iter() {
        writeln!(writer, "        if old_cw & {}::MASK != new_cw & {}::MASK {{", name, name)?;
        writeln!(writer, "            {}::dispatch(self, bus_values, old_cw, false);", name)?;
        writeln!(writer, "            {}::dispatch(self, bus_values, new_cw, true);", name)?;
        writeln!(writer, "        }}")?;
    }

    for (_, (alias, direct_pins)) in direct_pins {
        writeln!(writer, "        if old_cw & {}::MASK != new_cw & {}::MASK {{", alias, alias)?;
        for direct_pin in direct_pins {
            match direct_pin.pin.as_str() {
                "inc" |
                "dec" |
                "calc"|
                "alt" |
                "carry_in" |
                "load" |
                "signed" |
                "reset" |
                "extended" => writeln!(writer, "            self.{}.{}.change(&self.{}, bus_values, new_cw & {}::MASK == {}::VALUE);", direct_pin.device, direct_pin.pin, direct_pin.device, alias, alias)?,
                "halt" |
                "brk" =>   writeln!(writer, "            self.{}.{}.change(bus_values, new_cw & {}::MASK == {}::VALUE);", direct_pin.device, direct_pin.pin, alias, alias)?,
                _ => writeln!(writer, "            self.{}.on_{}_change(bus_values, new_cw & {}::MASK == {}::VALUE);", direct_pin.device, direct_pin.pin, alias, alias)?,
            }
        }
        writeln!(writer, "        }}")?;
    }
    writeln!(writer, "    }}")?;
    writeln!(writer, "}}")?;
    writeln!(writer)?;
    Ok(())
}

fn emit_direct_pins(writer: &mut dyn std::io::Write, direct_pins: &HashMap<u32, (String, Vec<DirectPinRef>)>) -> std::io::Result<()> {
    for (mask, (device_name, direct_pins)) in direct_pins {
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

fn format_const_name(name: &str) -> String {
    name.chars().map(|c| if c.is_alphanumeric() { c.to_ascii_uppercase() } else { '_' }).collect()
}

fn format_type_name(name: &str) -> String {
    // Split the name into words based on non-alphanumeric characters and capitalize each word
    name.split(|c: char| !c.is_alphanumeric())
        .filter(|s| !s.is_empty())
        .map(|s| {
            let mut chars = s.chars();
            match chars.next() {
                Some(first) => first.to_ascii_uppercase().to_string() + chars.as_str(),
                None => String::new(),
            }
        })
        .collect::<Vec<String>>()
        .join("")
}

fn emit_default_control_word(writer: &mut dyn std::io::Write, muxes: &HashMap<String, MuxPart>, direct_pins: &HashMap<u32, (String, Vec<DirectPinRef>)>) -> std::io::Result<()> {
    writeln!(writer, "pub const DEFAULT_CW: ControlWord = ControlWordBuilder::bootstrap()")?;
    for (name, _) in muxes.iter() {
        writeln!(writer, "        .apply_mux::<{}>({}::VALUE_DEFAULT)", name, name)?;
    }
    for (_, (device_name, direct_pins)) in direct_pins {
        if direct_pins.len() == 1 {
            let direct_pin = &direct_pins[0];
            writeln!(writer, "        .remove_bit::<{}>()", format_type_name(&format!("{}.{}", direct_pin.device, direct_pin.pin)))?;
        } else {
            writeln!(writer, "        .remove_bit::<{}>()", format_type_name(&device_name))?;
        }
    }
    writeln!(writer, "        .build();")?;
    writeln!(writer)?;
    Ok(())
}

fn map_device_type<'a>(dev_type: &'a str, name: &str) -> &'a str {
    eprintln!("Mapping device type: {} with name: {}", dev_type, name);
    match dev_type {
        "TransferRegister" if name == "TX" => "TransferRegister::<AddressBusBehavior>",
        "TransferRegister" => "TransferRegister::<MainBusBehavior>",
        "ALU" => Box::leak(format!("ALU::<{}>", name).into_boxed_str()),
        "RAM" => "Memory",
        "ROM" => "NullSource",
        "IOController" => "IOController::<P>",
        _ => dev_type,
    }
}

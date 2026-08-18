use std::collections::HashMap;
use std::fs::File;
use crate::bus_sources::BusSourcesPart;
use crate::mux_part::MuxPart;
use crate::pin_config;
use crate::util::{format_type_name, map_device_type};


pub struct DirectPinRef {
    device: String,
    pin: String,
    mask: u32,
    value: u32,
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
                self.bus_sources.main_bus_sources.push(&device.name);
            }
            if BusSourcesPart::is_alu_l_source(&device.dev_type) {
                ids.push(format!("ALULSource::{}", device.name));
                self.bus_sources.alu_l_sources.push(&device.name);
            }
            if BusSourcesPart::is_alu_r_source(&device.dev_type) {
                ids.push(format!("ALURSource::{}", device.name));
                self.bus_sources.alu_r_sources.push(&device.name);
            }
            if BusSourcesPart::is_address_bus_source(&device.dev_type, &device.name) {
                ids.push(format!("AddressBusSource::{}", device.name));
                self.bus_sources.address_bus_sources.push(&device.name);
            }
            if BusSourcesPart::is_flags_source(&device.dev_type) {
                ids.push(format!("FlagsSource::{}", device.name));
                self.bus_sources.flags_sources.push(&device.name);
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

        self.bus_sources.main_bus_sources.emit_get_value(writer)?;
        self.bus_sources.alu_l_sources.emit_get_value(writer)?;
        self.bus_sources.alu_r_sources.emit_get_value(writer)?;
        self.bus_sources.address_bus_sources.emit_get_value(writer)?;
        self.bus_sources.flags_sources.emit_get_value(writer)?;


        writeln!(writer, "    pub fn broadcast_reset(&mut self) {{")?;
        for device in self.devices.iter() {
            writeln!(writer, "        self.{}.on_reset();", device.name)?;
        }
        writeln!(writer, "    }}")?;

        writeln!(writer, "}}")?;
        writeln!(writer)?;

        self.bus_sources.emit(writer)
    }
}


pub fn generate_router(out_dir: &str, manifest_dir: &str) -> std::io::Result<()> {
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

    let mut f = File::create(&format!("{}/router_generated.rs", out_dir))?;

    device_map.emit(&mut f)?;

    for m in muxes.values() {
         m.emit(&mut f)?;
    }

    emit_direct_pins(&mut f, &direct_pins)?;
    emit_router_fn(&mut f, &muxes, &direct_pins)?;


    emit_default_control_word(&mut f, &muxes, &direct_pins)?;

    Ok(())
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
            writeln!(writer, "            self.{}.{}.change(bus_values, new_cw & {}::MASK == {}::VALUE);", direct_pin.device, direct_pin.pin, alias, alias)?;
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


use std::collections::HashMap;
use std::fs;
use std::io::Write;
use crate::mux_part::MuxPart;
use crate::pin_config;
use crate::device_map::DeviceMapPart;
use crate::direct_pins::{DirectPinRef, DirectPinsPart};
use crate::util::{format_type_name};
use quote::quote;

    pub fn generate_router(out_dir: &str, manifest_dir: &str) -> anyhow::Result<()> {
    let pins = pin_config::PinConfig::from_file(&format!("{}/pins.yaml", manifest_dir))?;
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

    let mut device_map = DeviceMapPart::new(&pins.devices);

    let mut direct_pins = DirectPinsPart::new();

    for device in pins.devices.iter() {
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
                    direct_pins.direct_pins.entry(mask).or_insert_with(|| (format_type_name(&format!("{}.{}", device.name, pin_name)), Vec::new())).1.push(DirectPinRef { device: device.name.clone(), pin: pin_name.clone(), mask, value });
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
                            direct_pins.direct_pins.entry(mask).or_insert_with(|| (format_type_name(apin), Vec::new())).1.push(DirectPinRef { device: device.name.clone(), pin: pin_name.clone(), mask, value });
                        },
                    }
                },
            }
        }
    }

    let mut f = fs::File::create(&format!("{}/router_generated.rs", out_dir))?;

    let devmap = device_map.emit();
    let bus_sources = device_map.emit_bus_sources();

    let muxes_emitted = muxes.values().map(|m| m.emit());
    let direct_pins_emitted = direct_pins.emit();

    let whole_file = quote! {
        #devmap
        #bus_sources
        #( #muxes_emitted )*
        #( #direct_pins_emitted )*
    };

    let tree = syn::parse2(whole_file).unwrap();
    let formatted = prettyplease::unparse(&tree);

    write!(f, "{}", formatted)?;

        emit_router_fn(&mut f, &muxes, &direct_pins)?;


    emit_default_control_word(&mut f, &muxes, &direct_pins)?;

    Ok(())
}


fn emit_router_fn(writer: &mut dyn std::io::Write, muxes: &HashMap<String, MuxPart>, direct_pins: &DirectPinsPart) -> std::io::Result<()> {
    writeln!(writer, "impl< P: IOPorts> DeviceMap<P> {{")?;
    writeln!(writer, "    pub fn route_word(&self, bus_values: &mut BusValues, old_cw: ControlWord, new_cw: ControlWord) {{")?;

    for (name, _) in muxes.iter() {
        writeln!(writer, "        if old_cw & {}::MASK != new_cw & {}::MASK {{", name, name)?;
        writeln!(writer, "            {}::dispatch(self, bus_values, old_cw, false);", name)?;
        writeln!(writer, "            {}::dispatch(self, bus_values, new_cw, true);", name)?;
        writeln!(writer, "        }}")?;
    }

    for (_, (alias, direct_pins)) in &direct_pins.direct_pins {
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

fn emit_default_control_word(writer: &mut dyn std::io::Write, muxes: &HashMap<String, MuxPart>, direct_pins: &DirectPinsPart) -> std::io::Result<()> {
    writeln!(writer, "pub const DEFAULT_CW: ControlWord = ControlWordBuilder::bootstrap()")?;
    for (name, _) in muxes.iter() {
        writeln!(writer, "        .apply_mux::<{}>({}::VALUE_DEFAULT)", name, name)?;
    }
    for (_, (device_name, direct_pins)) in &direct_pins.direct_pins {
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


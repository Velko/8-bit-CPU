use std::collections::HashMap;
use std::fs;
use std::io::Write;
use crate::bus_sources::BusSourcesPart;
use crate::mux_part::MuxPart;
use crate::pin_config;
use crate::device_map::DeviceMapPart;
use crate::direct_pins::{DirectPinRef, DirectPinsPart};
use crate::util::{format_type_name};
use proc_macro2::{Span, TokenStream};
use quote::{format_ident, quote};
use syn::Ident;

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
    let bus_sources = BusSourcesPart::new(&pins.devices);

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

    let devmap = device_map.emit(&bus_sources);
    let bus_source_enums = bus_sources.emit_enums();

    let muxes_emitted = muxes.values().map(|m| m.emit());
    let direct_pins_emitted = direct_pins.emit();
    let router_fn = emit_router_fn(&muxes, &direct_pins);
    let default_cw = emit_default_control_word(&muxes, &direct_pins);

    let whole_file = quote! {
        #devmap
        #bus_source_enums
        #( #muxes_emitted )*
        #( #direct_pins_emitted )*
        #router_fn
        #default_cw
    };

    let tree = syn::parse2(whole_file).unwrap();
    let formatted = prettyplease::unparse(&tree);

    write!(f, "{}", formatted)?;

    Ok(())
}


fn emit_router_fn(muxes: &HashMap<String, MuxPart>, direct_pins: &DirectPinsPart) -> TokenStream {

    let muxes_ts = muxes.iter().map(|(name, _)| {
        let name_ident = format_ident!("{}", name);
        quote! {
            if old_cw & #name_ident::MASK != new_cw & #name_ident::MASK {
                #name_ident::dispatch(self, bus_values, old_cw, false);
                #name_ident::dispatch(self, bus_values, new_cw, true);
            }
        }
    });

    let direct_pins_ts = direct_pins.direct_pins.iter().map(|(_, (alias, direct_pins))| {
        let alias_ident = format_ident!("{}", alias);
        let direct_pin_changes = direct_pins.iter().map(|direct_pin| {
            let device_ident = format_ident!("{}", direct_pin.device);
            let pin_ident = format_ident!("{}", direct_pin.pin);
            quote! {
                self.#device_ident.#pin_ident.change(bus_values, new_cw & #alias_ident::MASK == #alias_ident::VALUE);
            }
        });
        quote! {
            if old_cw & #alias_ident::MASK != new_cw & #alias_ident::MASK {
                #( #direct_pin_changes )*
            }
        }
    });

    quote! {
        impl <P: IOPorts> DeviceMap<P> {
            pub fn route_word(&self, bus_values: &mut BusValues, old_cw: ControlWord, new_cw: ControlWord) {
                #( #muxes_ts )*
                #( #direct_pins_ts )*
            }
        }
    }
}

fn emit_default_control_word(muxes: &HashMap<String, MuxPart>, direct_pins: &DirectPinsPart) -> TokenStream {
    let mut tokens = quote! {
        pub const DEFAULT_CW: ControlWord = ControlWordBuilder::bootstrap()
    };
    for (name, _) in muxes.iter() {
        let name_ident = Ident::new(&name, Span::call_site());
        tokens = quote! {
            #tokens
            .apply_mux::<#name_ident>(#name_ident::VALUE_DEFAULT)
        };
    }
    for (_, (device_name, direct_pins)) in &direct_pins.direct_pins {
        if direct_pins.len() == 1 {
            let direct_pin = &direct_pins[0];
            let type_name = Ident::new(&format_type_name(&format!("{}.{}", direct_pin.device, direct_pin.pin)), Span::call_site());
            tokens = quote! {
                #tokens
                .remove_bit::<#type_name>()
            };
        } else {
            let type_name = Ident::new(&device_name, Span::call_site());
            tokens = quote! {
                #tokens
                .remove_bit::<#type_name>()
            };
        }
    }
    tokens = quote! {
        #tokens
        .build();
    };
    tokens
}


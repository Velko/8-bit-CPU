use std::collections::HashMap;
use proc_macro2::{Literal, Span, TokenStream};
use quote::{format_ident, quote};
use syn::Ident;

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

    pub fn emit_ts(&self) -> TokenStream {
        let name = Ident::new(&self.name, Span::call_site());
        let mask = Literal::u32_unsuffixed(self.mask);
        let default = Literal::u32_unsuffixed(self.default);
        let match_arms: Vec<TokenStream> = self.device_bits.iter().map(|(_, (alias, dev_refs))| {
            if dev_refs.len() == 1 {
                let dev_ref = &dev_refs[0];
                let device_ident = Ident::new(&dev_ref.device, Span::call_site());
                let pin_ident = Ident::new(&dev_ref.pin, Span::call_site());
                let value_ident = Ident::new(&format!("VALUE_{}_{}", dev_ref.device.to_uppercase(), dev_ref.pin.to_uppercase()), Span::call_site());
                quote! {
                    Self::#value_ident => dev.#device_ident.#pin_ident.change(bus_values, enable),
                }
            } else {
                let alias_ident = format_ident!("VALUE_{}", format_const_name(alias));
                let dev_changes: Vec<TokenStream> = dev_refs.iter().map(|dev_ref| {
                    let device_ident = Ident::new(&dev_ref.device, Span::call_site());
                    let pin_ident = Ident::new(&dev_ref.pin, Span::call_site());
                    quote! {
                        dev.#device_ident.#pin_ident.change(bus_values, enable);
                    }
                }).collect();
                quote! {
                    Self::#alias_ident => {
                        #( #dev_changes )*
                    },
                }
            }
        }).collect();

        let part = quote! {
            pub struct #name;

            impl MuxDispatcher for #name {
                const MASK: ControlWord = #mask;
                const VALUE_DEFAULT: ControlWord = #default;
                fn dispatch<P: IOPorts>(dev: &DeviceMap<P>, bus_values: &mut BusValues, word: ControlWord, enable: bool) {
                    match word & Self::MASK {
                        #( #match_arms )*
                        _ => {},
                    }
                }
            }
        };

        part
    }

     pub fn emit(&self, writer: &mut dyn std::io::Write) -> std::io::Result<()> {
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

use std::collections::HashMap;

use proc_macro2::{Literal, Span, TokenStream};
use quote::quote;
use syn::Ident;

use crate::util::format_type_name;

#[derive(Debug, Clone)]
pub struct DirectPinRef {
    pub device: String,
    pub pin: String,
    pub mask: u32,
    pub value: u32,
}

impl DirectPinRef {
    fn emit(&self, struct_name: &str) -> TokenStream {
        let name = Ident::new(struct_name, Span::call_site());
        let mask = Literal::u32_unsuffixed(self.mask);
        let value = Literal::u32_unsuffixed(self.value);
        quote! {
            pub struct #name;
            impl BitDispatcher for #name {
                const MASK: ControlWord = #mask;
                const VALUE: ControlWord = #value;
            }
        }
    }
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

    pub fn emit(&self) -> Vec<TokenStream> {
        let mut pins_emitted: Vec<TokenStream> = Vec::new();
        for (_, (device_name, direct_pins)) in &self.direct_pins {
            let direct_pin = &direct_pins[0];
            if direct_pins.len() == 1 {
                let struct_name = format_type_name(&format!("{}.{}", direct_pin.device, direct_pin.pin));
                pins_emitted.push(direct_pin.emit(&struct_name));
            } else {
                let struct_name = format_type_name(&device_name);
                pins_emitted.push(direct_pin.emit(&struct_name));
            }
        }
        pins_emitted
    }
}

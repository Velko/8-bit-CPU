use proc_macro2::{Span, TokenStream};
use syn::Ident;
use quote::quote;

use crate::router_generator::DevicePart;

pub struct BusSourcesPart {
    pub main_bus_sources: BusSource,
    pub address_bus_sources: BusSource,
    pub alu_l_sources: BusSource,
    pub alu_r_sources: BusSource,
    pub flags_sources: BusSource,
}

pub struct BusSource {
    type_name: &'static str,
    getter_name: &'static str,
    value_type:  &'static str,
    member_names: Vec<String>,
}

impl BusSource {
    pub fn new(type_name: &'static str, getter_name: &'static str, value_type: &'static str) -> Self {
        Self {
            type_name,
            getter_name,
            value_type,
            member_names: Vec::new(),
        }
    }

    pub fn push(&mut self, member_name: &str) {
        self.member_names.push(member_name.to_owned());
    }

    pub fn emit_struct(&self, writer: &mut dyn std::io::Write) -> std::io::Result<()> {
        writeln!(writer, "#[derive(Debug, Clone, Copy, PartialEq)]")?;
        writeln!(writer, "pub enum {} {{", self.type_name)?;
        for source in self.member_names.iter() {
            writeln!(writer, "    {},", source)?;
        }
        writeln!(writer, "}}")?;
        writeln!(writer)
    }

    pub fn emit_get_value(&self) -> TokenStream {
        let getter_name = Ident::new(&format!("get_{}_value", self.getter_name), Span::call_site());
        let value_type = Ident::new(self.value_type, Span::call_site());
        let type_name = Ident::new(self.type_name, Span::call_site());
        let member_names = &self.member_names;

        let match_arms: Vec<TokenStream> = member_names.iter().map(|device| {
            let device_ident = Ident::new(device, Span::call_site());
            quote! {
                #type_name::#device_ident => self.#device_ident.get_value(bus_values),
            }
        }).collect();

        quote! {
            pub fn #getter_name(&self, source: #type_name, bus_values: &BusValues) -> #value_type {
                match source {
                    #( #match_arms )*
                }
            }
        }
    }
}

impl BusSourcesPart {
    pub fn new(devices: &[DevicePart]) -> Self {
        let mut bus_sources = BusSourcesPart {
            main_bus_sources: BusSource::new("MainBusSource", "main_bus", "u8"),
            address_bus_sources: BusSource::new("AddressBusSource", "address_bus", "u16"),
            alu_l_sources: BusSource::new("ALULSource", "alu_l", "u8"),
            alu_r_sources: BusSource::new("ALURSource", "alu_r", "u8"),
            flags_sources: BusSource::new("FlagsSource", "flags","ALUFlags"),
        };

        for device in devices {
            bus_sources.add_device(device);
        }

        bus_sources
    }

    fn add_device(&mut self, device: &DevicePart) {
        if BusSourcesPart::is_main_bus_source(&device.dev_type, &device.name) {
            self.main_bus_sources.push(&device.name);
        }
        if BusSourcesPart::is_alu_l_source(&device.dev_type) {
            self.alu_l_sources.push(&device.name);
        }
        if BusSourcesPart::is_alu_r_source(&device.dev_type) {
            self.alu_r_sources.push(&device.name);
        }
        if BusSourcesPart::is_address_bus_source(&device.dev_type, &device.name) {
            self.address_bus_sources.push(&device.name);
        }
        if BusSourcesPart::is_flags_source(&device.dev_type) {
            self.flags_sources.push(&device.name);
        }
    }

        pub fn make_bus_source_init_params(device: &DevicePart) -> TokenStream {
        let name_str = &device.name;
        let name = Ident::new(&device.name, Span::call_site());
        let mut params: Vec<TokenStream> = Vec::new();

        if BusSourcesPart::is_main_bus_source(&device.dev_type, &device.name) {
            params.push(quote! { MainBusSource::#name });
        }
        if BusSourcesPart::is_alu_l_source(&device.dev_type) {
            params.push(quote! { ALULSource::#name });
        }
        if BusSourcesPart::is_alu_r_source(&device.dev_type) {
            params.push(quote! { ALURSource::#name });
        }
        if BusSourcesPart::is_address_bus_source(&device.dev_type, &device.name) {
            params.push(quote! { AddressBusSource::#name });
        }
        if BusSourcesPart::is_flags_source(&device.dev_type) {
            params.push(quote! { FlagsSource::#name });
        }
        if device.dev_type == "IOController" {
            params.push(quote! { ioports });
        }

        quote! { #name_str, #( #params ),* }
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
        self.main_bus_sources.emit_struct(writer)?;
        self.alu_l_sources.emit_struct(writer)?;
        self.alu_r_sources.emit_struct(writer)?;
        self.address_bus_sources.emit_struct(writer)?;
        self.flags_sources.emit_struct(writer)
    }
}

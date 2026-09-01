use proc_macro2::{Span, TokenStream};
use syn::Ident;
use quote::quote;
use crate::bus_sources::BusSourcesPart;
use crate::pin_config::DeviceConfig;
use crate::util::map_device_type;


pub struct DevicePart {
    pub name: String,
    pub dev_type: String,
}

    impl DevicePart {
        pub fn emit_constructor(&self) -> TokenStream {
        let name = Ident::new(&self.name, Span::call_site());
        let dev_type = map_device_type(&self.dev_type, &self.name);
        let params = BusSourcesPart::make_bus_source_init_params(self);

        quote! {
            #name: #dev_type::new(
                #params
            )
        }
    }
}


pub struct DeviceMapPart {
    devices: Vec<DevicePart>,
}

impl DeviceMapPart {
    pub fn new(dev_cfg: &[DeviceConfig]) -> Self {
        let devices: Vec<_> = dev_cfg.iter().map(|d| DevicePart {
            name: d.name.clone(),
            dev_type: d.dev_type.clone(),
        }).collect();

        DeviceMapPart {
            devices,
        }
    }

    fn emit_struct(&mut self) -> TokenStream {

        let names = self.devices.iter().map(|d|Ident::new(&d.name, Span::call_site()));
        let types = self.devices.iter().map(|d|map_device_type(&d.dev_type, &d.name));

        quote! {
            pub struct DeviceMap<P: IOPorts> {
                #( pub #names: #types ),*
            }
        }
    }

    pub fn emit(&mut self, bus_sources: &BusSourcesPart) -> TokenStream {

        let device_map_struct = self.emit_struct();
        let device_map_impl = self.emit_impl(bus_sources);

        quote! {
            #device_map_struct
            #device_map_impl
        }
    }

    fn emit_impl(&self, bus_sources: &BusSourcesPart) -> TokenStream {
        let names: Vec<_> = self.devices.iter().map(|d|Ident::new(&d.name, Span::call_site())).collect();
        let constructors: Vec<_> = self.devices.iter().map(|d|d.emit_constructor()).collect();

        let getters = bus_sources.emit_getters();

        quote! {
            impl<P: IOPorts> DeviceMap<P> {
                pub fn new(ioports: P) -> Self {
                    DeviceMap {
                        #( #constructors ),*
                    }
                }

                pub fn broadcast_clock_tick_primary(&mut self, bus_values: &mut BusValues) {
                    #( self.#names.on_clock_tick_primary(bus_values));*
                }

                pub fn broadcast_clock_tick_secondary(&mut self) {
                    #( self.#names.on_clock_tick_secondary());*
                }

                pub fn broadcast_reset(&mut self) {
                    #( self.#names.on_reset());*
                }

                #getters
            }
        }
    }
}

use proc_macro2::TokenStream;

pub fn format_const_name(name: &str) -> String {
    name.chars().map(|c| if c.is_alphanumeric() { c.to_ascii_uppercase() } else { '_' }).collect()
}

pub fn format_type_name(name: &str) -> String {
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

pub fn map_device_type<'a>(dev_type: &'a str, name: &str) -> TokenStream {
    eprintln!("Mapping device type: {} with name: {}", dev_type, name);
    match dev_type {
        "TransferRegister" if name == "TX" => quote::quote! { TransferRegister::<AddressBusBehavior> },
        "TransferRegister" => quote::quote! { TransferRegister::<MainBusBehavior> },
        "ALU" => {
            let name_ident = syn::Ident::new(name, proc_macro2::Span::call_site());
            quote::quote! { ALU::<#name_ident> }
        }
        "RAM" => quote::quote! { Memory },
        "ROM" => quote::quote! { NullSource },
        "IOController" => quote::quote! { IOController::<P> },
        "ConstArg" if name == "ZeroArg" => quote::quote! { ConstArg::<0> },
        _ => {
            let dev_type_ident = syn::Ident::new(dev_type, proc_macro2::Span::call_site());
            quote::quote! { #dev_type_ident }
        }
    }
}

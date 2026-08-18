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

pub fn map_device_type<'a>(dev_type: &'a str, name: &str) -> &'a str {
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

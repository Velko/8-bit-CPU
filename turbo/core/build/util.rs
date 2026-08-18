pub fn format_const_name(name: &str) -> String {
    name.chars().map(|c| if c.is_alphanumeric() { c.to_ascii_uppercase() } else { '_' }).collect()
}

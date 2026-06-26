mod pin_config;


pub fn load_pins(file_path: &str) -> pin_config::PinConfig {
    pin_config::PinConfig::from_file(file_path)
}

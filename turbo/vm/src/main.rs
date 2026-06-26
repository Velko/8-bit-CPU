use turbo_core::{load_pins};

fn main() {
    let pins = load_pins("pins.yaml");
    println!("Loaded pins: {:?}", pins);
}

mod router_generator;
mod pin_config;
mod mux_part;
mod util;
use crate::router_generator::generate_router;
use std::env;

fn main() {
    let out_dir = env::var("OUT_DIR").unwrap();
    let manifest_dir = env::var("CARGO_MANIFEST_DIR").unwrap();
    println!("cargo:rerun-if-changed={}/pins.yaml", manifest_dir);
    generate_router(&out_dir, &manifest_dir);
}

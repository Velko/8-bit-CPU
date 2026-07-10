#![allow(non_snake_case)]
#![allow(dead_code)]

use crate::ControlWord;
use crate::devices::*;
use crate::control_word::ControlWordBuilder;


include!(concat!(env!("OUT_DIR"), "/router_generated.rs"));

pub trait MuxDispatcher {
    const MASK: ControlWord;
    const VALUE_DEFAULT: ControlWord;
    fn dispatch(dev: &DeviceMap, state: &mut RuntimeState, word: ControlWord, enable: bool);
}

pub trait BitDispatcher {
    const MASK: ControlWord;
    const VALUE: ControlWord;
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_static_dispatch() {
        let device_map = DeviceMap::new();
        let default_cw = 0x07ff58ff; // default
        let add_bc_cw = 0x07ff0915; // add_B_C
        println!("add_B_C");
        let mut state = RuntimeState::new();
        device_map.route_word(&mut state, default_cw, add_bc_cw);

        let inc_a_cw = 0x07ff9805; // inc A
        println!("inc_A");
        device_map.route_word(&mut state, add_bc_cw, inc_a_cw);


        println!("Off");
        device_map.route_word(&mut state, inc_a_cw, default_cw);
    }

    #[test]
    fn test_default_cw() {
        println!("DEFAULT_CW: 0x{:08x}", DEFAULT_CW);
        assert_eq!(DEFAULT_CW, 0x07ff58ff);
    }
}

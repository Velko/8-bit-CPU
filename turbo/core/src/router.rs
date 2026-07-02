#![allow(non_snake_case)]
#![allow(dead_code)]

use crate::ControlWord;
use crate::devices::*;

include!(concat!(env!("OUT_DIR"), "/router_generated.rs"));

trait MuxDispatcher {
    const MASK: ControlWord;
    const DEFAULT: ControlWord;
    fn dispatch(dev: &DeviceMap, word: ControlWord, new_state: bool);
}



#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_static_dispatch() {
        let device_map = DeviceMap::new();
        let old_cw = 0x07ff58ff; // default
        let new_cw = 0x07ff0915; // add_B_C
        println!("add_B_C");
        device_map.route_word(old_cw, new_cw);

        let newer_cw = 0x07ff9805; // inc A
        println!("inc_A");
        device_map.route_word(new_cw, newer_cw);


        assert_eq!(old_cw, new_cw); // always fails, just to demonstrate the test
    }
}

#![allow(non_snake_case)]
#![allow(dead_code)]

use crate::ControlWord;
use crate::devices::*;

include!(concat!(env!("OUT_DIR"), "/router_generated.rs"));

trait MuxDispatcher {
    const MASK: ControlWord;
    const DEFAULT: ControlWord;
    fn dispatch(dev: &DeviceMap, buses: &mut Buses, word: ControlWord, new_state: bool);
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
        let mut buses = Buses::new();
        device_map.route_word(&mut buses, default_cw, add_bc_cw);

        let inc_a_cw = 0x07ff9805; // inc A
        println!("inc_A");
        device_map.route_word(&mut buses, add_bc_cw, inc_a_cw);


        println!("Off");
        device_map.route_word(&mut buses, inc_a_cw, default_cw);

        assert_eq!(default_cw, inc_a_cw); // always fails, just to demonstrate the test
    }
}

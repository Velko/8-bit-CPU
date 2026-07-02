mod router;

// pub fn load_pins(file_path: &str) -> pin_config::PinConfig {

//     let cfg = pin_config::PinConfig::from_file(file_path);

//     cfg
// }

// struct GPRegister {
//     name: String,
// }

// impl GPRegister {
//     fn on_out_change(&self, value: bool) {
//         println!("GPRegister {} Out changed to: {}", self.name, value);
//     }
//     fn on_load_change(&self, value: bool) {
//         println!("GPRegister {} Load changed to: {}", self.name, value);
//     }
//     fn on_alu_l_change(&self, value: bool) {
//         println!("GPRegister {} ALU L changed to: {}", self.name, value);
//     }
//     fn on_alu_r_change(&self, value: bool) {
//         println!("GPRegister {} ALU R changed to: {}", self.name, value);
//     }
// }

// struct ALU {}
// impl ALU {
//     fn on_out_change(&self, value: bool) {
//         println!("ALU Out changed to: {}", value);
//     }
// }

// struct DeviceMap {
//     a: GPRegister,
//     b: GPRegister,
//     c: GPRegister,
//     d: GPRegister,
//     alu: ALU,
// }

type ControlWord = u32;



// struct OutMux;
// impl MuxDispatcher for OutMux {
//     const MASK: ControlWord = 0b00000000000000000000000000001111;
//     fn dispatch(dev: &DeviceMap, word: ControlWord, new_state: bool) {
//         match word & Self::MASK {
//             0b00000000000000000000000000000000 => dev.a.on_out_change(new_state),
//             0b00000000000000000000000000000001 => dev.b.on_out_change(new_state),
//             0b00000000000000000000000000000010 => dev.c.on_out_change(new_state),
//             0b00000000000000000000000000000011 => dev.d.on_out_change(new_state),
//             0b00000000000000000000000000000101 => dev.alu.on_out_change(new_state),
//             _ => {},
//         }
//     }
// }

// struct LoadMux;
// impl MuxDispatcher for LoadMux {
//     const MASK: ControlWord = 0b00000000000000000000000011110000;
//     fn dispatch(dev: &DeviceMap, word: ControlWord, new_state: bool) {
//         match word & Self::MASK {
//             0b00000000000000000000000000000000 => dev.a.on_load_change(new_state),
//             0b00000000000000000000000000010000 => dev.b.on_load_change(new_state),
//             0b00000000000000000000000000100000 => dev.c.on_load_change(new_state),
//             0b00000000000000000000000000110000 => dev.d.on_load_change(new_state),
//             _ => {},
//         }
//     }
// }

// struct ALULeftMux;
// impl MuxDispatcher for ALULeftMux {
//     const MASK: ControlWord = 0b00000000000000000000001100000000;
//     fn dispatch(dev: &DeviceMap, word: ControlWord, new_state: bool) {
//         match word & Self::MASK {
//             0b00000000000000000000000000000000 => dev.a.on_alu_l_change(new_state),
//             0b00000000000000000000000100000000 => dev.b.on_alu_l_change(new_state),
//             0b00000000000000000000001000000000 => dev.c.on_alu_l_change(new_state),
//             0b00000000000000000000001100000000 => dev.d.on_alu_l_change(new_state),
//             _ => {},
//         }
//     }
// }

// struct ALURightMux;
// impl MuxDispatcher for ALURightMux {
//     const MASK: ControlWord = 0b00000000000000000001110000000000;
//     fn dispatch(dev: &DeviceMap, word: ControlWord, new_state: bool) {
//         match word & Self::MASK {
//             0b00000000000000000000000000000000 => dev.a.on_alu_r_change(new_state),
//             0b00000000000000000000010000000000 => dev.b.on_alu_r_change(new_state),
//             0b00000000000000000000100000000000 => dev.c.on_alu_r_change(new_state),
//             0b00000000000000000000110000000000 => dev.d.on_alu_r_change(new_state),
//             _ => {},
//         }
//     }
// }

// impl DeviceMap {
//     pub fn new() -> Self {
//         DeviceMap {
//             a: GPRegister { name: "A".to_string()    },
//             b: GPRegister { name: "B".to_string()    },
//             c: GPRegister { name: "C".to_string()    },
//             d: GPRegister { name: "D".to_string()    },
//             alu: ALU { },
//         }
//     }

//     pub fn static_dispatch(&self, old_cw: u32, new_cw: u32) {
//         const MUX_ADDROUT_MASK: u32 =  0b00000000000001110000000000000000;
//         const MUX_ADDRLOAD_MASK: u32 = 0b00000000001110000000000000000000;

//         if (old_cw & OutMux::MASK) != (new_cw & OutMux::MASK) {
//             OutMux::dispatch(self, old_cw, false);
//             OutMux::dispatch(self, new_cw, true);
//         }

//         if (old_cw & LoadMux::MASK) != (new_cw & LoadMux::MASK) {
//             LoadMux::dispatch(self, old_cw, false);
//             LoadMux::dispatch(self, new_cw, true);
//         }

//         if (old_cw & ALULeftMux::MASK) != (new_cw & ALULeftMux::MASK) {
//             ALULeftMux::dispatch(self, old_cw, false);
//             ALULeftMux::dispatch(self, new_cw, true);
//         }

//         if (old_cw & ALURightMux::MASK) != (new_cw & ALURightMux::MASK) {
//             ALURightMux::dispatch(self, old_cw, false);
//             ALURightMux::dispatch(self, new_cw, true);
//         }

//         if (old_cw & MUX_ADDROUT_MASK) != (new_cw & MUX_ADDROUT_MASK) {
//             println!("MUX_ADDROUT changed from {} to {}", old_cw & MUX_ADDROUT_MASK, new_cw & MUX_ADDROUT_MASK);
//         }

//         if (old_cw & MUX_ADDRLOAD_MASK) != (new_cw & MUX_ADDRLOAD_MASK) {
//             println!("MUX_ADDRLOAD changed from {} to {}", old_cw & MUX_ADDRLOAD_MASK, new_cw & MUX_ADDRLOAD_MASK);
//         }
//     }
// }


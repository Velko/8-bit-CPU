use crate::alu;
use crate::flags::Flags;
use crate::router::{MainBusSource, ALULSource, ALURSource, AddressBusSource, FlagsSource};
use crate::router::DeviceMap;

pub struct ArgSources {
    pub main_bus_source: Option<MainBusSource>,
    pub alu_l_source: Option<ALULSource>,
    pub alu_r_source: Option<ALURSource>,
    pub address_bus_source: Option<AddressBusSource>,
    pub flags_source: Option<FlagsSource>,
    pub carry_in: bool,
}

impl ArgSources {
    pub fn new() -> Self {
        Self {
            main_bus_source: None,
            alu_l_source: None,
            alu_r_source: None,
            address_bus_source: None,
            flags_source: None,
            carry_in: false,
        }
    }

    pub fn resolve(&self, devices: &DeviceMap) -> ArgValues {
        let main_bus_value = self.main_bus_source.map(|source| devices.get_main_bus_value(source, self));
        let alu_flags_value = self.flags_source.map(|source| devices.get_flags_value(source, self));
        ArgValues {
            main_bus_value,
            address_bus_value: Some(0),
            alu_flags_value,
        }
    }
}

pub struct ArgValues {
    pub main_bus_value: Option<u8>,
    pub alu_flags_value: Option<ALUFlags>,
    pub address_bus_value: Option<u16>,
}

pub struct ALUFlags {
    pub carry: Option<Flags>,
    pub overflow: Option<Flags>,
}


pub enum MainBusValue {
    None,
    Const(u8),
    Add,
    Subtract,
    And,
    Or,
    Xor,
    Not,
    Shr,
    Swap,
    MemRead,
}

pub struct RuntimeStateOld {
    pub main_bus: MainBusValue,
    pub address_bus: Option<u16>,
    pub alu_l_bus: Option<ALULSource>,
    pub alu_r_bus: Option<ALURSource>,
    pub carry_in: bool,
}

impl RuntimeStateOld {
    pub fn new() -> Self {
        Self {
            main_bus: MainBusValue::None,
            address_bus: None,
            alu_l_bus: None,
            alu_r_bus: None,
            carry_in: false,
        }
    }

    pub fn resolve_main_bus(&self, devices: &DeviceMap) -> u8 {

        // match self.main_bus {
        //     MainBusValue::None => panic!("Bus value is None"),
        //     MainBusValue::Const(value) => value,
        //     MainBusValue::Add => {
        //         let l = devices.get_alu_l_value(self.alu_l_bus.unwrap());
        //         let r = devices.get_alu_r_value(self.alu_r_bus.unwrap());
        //         let carry = if self.carry_in { 1 } else { 0 };
        //         l.wrapping_add(r).wrapping_add(carry)
        //     }
        //     MainBusValue::Subtract => {
        //         let l = devices.get_alu_l_value(self.alu_l_bus.unwrap());
        //         let r = devices.get_alu_r_value(self.alu_r_bus.unwrap());
        //         let carry = if self.carry_in { 1 } else { 0 };
        //         l.wrapping_sub(r).wrapping_sub(carry)
        //     },
        //     MainBusValue::And => {
        //         let l = devices.get_alu_l_value(self.alu_l_bus.unwrap());
        //         let r = devices.get_alu_r_value(self.alu_r_bus.unwrap());
        //         l & r
        //     },
        //     MainBusValue::Or => {
        //         let l = devices.get_alu_l_value(self.alu_l_bus.unwrap());
        //         let r = devices.get_alu_r_value(self.alu_r_bus.unwrap());
        //         l | r
        //     },
        //     MainBusValue::Xor => {
        //         let l = devices.get_alu_l_value(self.alu_l_bus.unwrap());
        //         let r = devices.get_alu_r_value(self.alu_r_bus.unwrap());
        //         l ^ r
        //     },
        //     MainBusValue::Not => {
        //         let l = devices.get_alu_l_value(self.alu_l_bus.unwrap());
        //         !l
        //     },
        //     MainBusValue::Shr => {
        //         let l = devices.get_alu_l_value(self.alu_l_bus.unwrap());
        //         l >> 1
        //     },
        //     MainBusValue::Swap => {
        //         let l = devices.get_alu_l_value(self.alu_l_bus.unwrap());
        //         (l << 4) | (l >> 4)
        //     },
        //     MainBusValue::MemRead => {
        //         todo!("Memory read not implemented in resolve_main_bus");
        //     },
        todo!()
    }

    pub fn resolve_alu_flags(&self, devices: &DeviceMap) -> (Option<Flags>, Option<Flags>) {
        /*let l = devices.get_alu_l_value.map(|source|  self.alu_l_bus.unwrap(), self) as u16;
        let r = devices.get_alu_r_value(self.alu_r_bus.unwrap(), self) as u16;
        let carry = if self.carry_in { 1 } else { 0 };
        match self.main_bus {
            MainBusValue::Add => {
                let sum = l.wrapping_add(r).wrapping_add(carry);
                let overflow = if ((l ^ sum) & (r ^ sum) & 0x80) != 0  { Flags::V } else { Flags::EMPTY };
                let carry_out = if (l + r + carry) > 0xFF { Flags::C } else { Flags::EMPTY };
                (Some(carry_out), Some(overflow))
            }
            MainBusValue::Subtract => {
                let diff = l.wrapping_sub(r).wrapping_sub(carry);
                let overflow = if ((l ^ r) & (l ^ diff) & 0x80) != 0 { Flags::V } else { Flags::EMPTY };
                let carry_out = if l < r + carry { Flags::C } else { Flags::EMPTY };
                (Some(carry_out), Some(overflow))
            },
            MainBusValue::Shr => {
                let carry_out = if (l & 0x01) != 0 { Flags::C } else { Flags::EMPTY };
                (Some(carry_out), None)
            },
            _ => (None, None),
        }*/
        (None, None)
    }
}

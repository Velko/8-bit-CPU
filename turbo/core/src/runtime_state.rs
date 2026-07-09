use crate::flags::Flags;

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

pub struct Buses {
    pub main_bus: MainBusValue,
    pub address_bus: Option<u16>,
    pub alu_l_bus: Option<u8>,
    pub alu_r_bus: Option<u8>,
    pub carry_in: bool,
}

impl Buses {
    pub fn new() -> Self {
        Buses {
            main_bus: MainBusValue::None,
            address_bus: None,
            alu_l_bus: None,
            alu_r_bus: None,
            carry_in: false,
        }
    }

    pub fn resolve_main_bus(&self) -> u8 {

        match self.main_bus {
            MainBusValue::None => panic!("Bus value is None"),
            MainBusValue::Const(value) => value,
            MainBusValue::Add => {
                let l = self.alu_l_bus.unwrap_or(0);
                let r = self.alu_r_bus.unwrap_or(0);
                let carry = if self.carry_in { 1 } else { 0 };
                l.wrapping_add(r).wrapping_add(carry)
            }
            MainBusValue::Subtract => {
                let l = self.alu_l_bus.unwrap_or(0);
                let r = self.alu_r_bus.unwrap_or(0);
                let carry = if self.carry_in { 1 } else { 0 };
                l.wrapping_sub(r).wrapping_sub(carry)
            },
            MainBusValue::And => {
                let l = self.alu_l_bus.unwrap_or(0);
                let r = self.alu_r_bus.unwrap_or(0);
                l & r
            },
            MainBusValue::Or => {
                let l = self.alu_l_bus.unwrap_or(0);
                let r = self.alu_r_bus.unwrap_or(0);
                l | r
            },
            MainBusValue::Xor => {
                let l = self.alu_l_bus.unwrap_or(0);
                let r = self.alu_r_bus.unwrap_or(0);
                l ^ r
            },
            MainBusValue::Not => {
                let l = self.alu_l_bus.unwrap_or(0);
                !l
            },
            MainBusValue::Shr => {
                let l = self.alu_l_bus.unwrap_or(0);
                l >> 1
            },
            MainBusValue::Swap => {
                let l = self.alu_l_bus.unwrap_or(0);
                (l << 4) | (l >> 4)
            },
            MainBusValue::MemRead => {
                todo!("Memory read not implemented in resolve_main_bus");
            },
        }
    }

    pub fn resolve_alu_flags(&self) -> (Option<Flags>, Option<Flags>) {
        let l = self.alu_l_bus.unwrap_or(0) as u16;
        let r = self.alu_r_bus.unwrap_or(0) as u16;
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
        }
    }
}

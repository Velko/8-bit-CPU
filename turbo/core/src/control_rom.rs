use crate::control_word::ControlWord;
pub struct ControlROM;

impl ControlROM {
    pub fn get_value(address: usize) -> ControlWord {
        ((CONTROL_ROM_0[address] as ControlWord) << 0)  |
        ((CONTROL_ROM_1[address] as ControlWord) << 8)  |
        ((CONTROL_ROM_2[address] as ControlWord) << 16) |
        ((CONTROL_ROM_3[address] as ControlWord) << 24)
    }
}

static CONTROL_ROM_0: &[u8] = include_bytes!("../../../include/control_rom0.bin");
static CONTROL_ROM_1: &[u8] = include_bytes!("../../../include/control_rom1.bin");
static CONTROL_ROM_2: &[u8] = include_bytes!("../../../include/control_rom2.bin");
static CONTROL_ROM_3: &[u8] = include_bytes!("../../../include/control_rom3.bin");

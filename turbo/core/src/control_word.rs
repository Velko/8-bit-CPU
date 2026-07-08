use crate::router::{MuxDispatcher, BitDispatcher};

pub type ControlWord = u32;


pub struct ControlWordBuilder {
    word: ControlWord,
}

impl ControlWordBuilder {
    pub fn new() -> Self {
        ControlWordBuilder { word: 0x07ff58ff } //TODO: calculate it from the disabled state of all devices, instead of hardcoding
    }

    pub fn apply_mux<D: MuxDispatcher>(self, new_state: ControlWord) -> Self {
        ControlWordBuilder {
            word: (self.word & !D::MASK) | (new_state & D::MASK),
        }
    }

    pub fn apply_bit<D: BitDispatcher>(self) -> Self {
        ControlWordBuilder {
            word: (self.word & !D::MASK) | D::VALUE,
        }
    }

    pub fn build(self) -> ControlWord {
        self.word
    }
}

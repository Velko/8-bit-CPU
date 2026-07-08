use crate::router::{MuxDispatcher, BitDispatcher};

pub type ControlWord = u32;


pub struct ControlWordBuilder {
    word: ControlWord,
}

impl ControlWordBuilder {
    pub const fn bootstrap() -> Self {
        ControlWordBuilder { word: 0 }
    }

    pub const fn new() -> Self {
        ControlWordBuilder { word: 0x07ff58ff } //TODO: calculate it from the disabled state of all devices, instead of hardcoding
    }

    pub const fn apply_mux<D: MuxDispatcher>(self, new_state: ControlWord) -> Self {
        ControlWordBuilder {
            word: (self.word & !D::MASK) | (new_state & D::MASK),
        }
    }

    pub const fn apply_bit<D: BitDispatcher>(self) -> Self {
        ControlWordBuilder {
            word: (self.word & !D::MASK) | D::VALUE,
        }
    }

    pub const fn remove_bit<D: BitDispatcher>(self) -> Self {
        ControlWordBuilder {
            word: (self.word & !D::MASK) | (!D::VALUE & D::MASK),
        }
    }

    pub const fn build(self) -> ControlWord {
        self.word
    }
}

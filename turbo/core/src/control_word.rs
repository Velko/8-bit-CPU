use crate::router::{MuxDispatcher, BitDispatcher, DEFAULT_CW};

pub type ControlWord = u32;


pub struct ControlWordBuilder {
    word: ControlWord,
}

impl ControlWordBuilder {
    pub const fn bootstrap() -> Self {
        ControlWordBuilder { word: 0 }
    }

    pub const fn apply_mux<D: MuxDispatcher>(self, enable: ControlWord) -> Self {
        ControlWordBuilder {
            word: (self.word & !D::MASK) | (enable & D::MASK),
        }
    }

    #[cfg(test)]
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

impl Default for ControlWordBuilder {
    fn default() -> Self {
        Self { word: DEFAULT_CW }
    }
}

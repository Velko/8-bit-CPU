pub struct DisplayNumeric {
    mode: u8,
}

impl DisplayNumeric {
    pub fn new() -> Self {
        Self { mode: 0 }
    }

    pub fn format(&self, value: u8) -> String {
        match self.mode {
            0 => format!("{:4}\\n", value),
            1 => format!("{:4}\\n", value as i8),
            2 => format!("h {:02x}\\n", value),
            3 => format!("o{:03o}\\n", value),
            _ => panic!("DisplayNumeric: unsupported mode {}", self.mode),
        }
    }

    pub fn set_mode(&mut self, mode: u8) {
        self.mode = mode;
    }
}

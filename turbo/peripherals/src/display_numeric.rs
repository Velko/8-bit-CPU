pub struct DisplayNumeric;

impl DisplayNumeric {
    pub fn new() -> Self {
        Self {}
    }

    pub fn format(&self, value: u8, mode: u8) -> String {
        match mode {
            0 => format!("{:4}\\n", value),
            1 => format!("{:4}\\n", value as i8),
            2 => format!("h {:02x}\\n", value),
            3 => format!("o{:03o}\\n", value),
            _ => panic!("DisplayNumeric: unsupported mode {}", mode),
        }
    }
}

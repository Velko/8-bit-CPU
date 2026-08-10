pub struct DisplayChar;

impl DisplayChar {
    pub fn new() -> Self {
        Self {}
    }

    pub fn format(&self, value: u8) -> String {
        format!("{}", value as char)
    }
}

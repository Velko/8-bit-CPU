#[derive(Debug, Clone, PartialEq, Eq)]
pub enum IOMessage {
    Out { payload: String, port: u8 },
    Halt,
    Brk,
}

impl IOMessage {
    pub fn to_string(&self) -> String {
        match self {
            IOMessage::Out { payload, port } => Self::escape_newline(&format!("#OUT#{:X}#{}", port, payload)),
            IOMessage::Halt => "#HLT\r\n".to_string(),
            IOMessage::Brk => "#BRK\r\n".to_string(),
        }
    }

    fn escape_newline(s: &str) -> String {
        s.replace("\n", "\\n").replace("\r", "\\r")
    }
}

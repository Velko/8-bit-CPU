pub enum IOMessage {
    Out { payload: String, port: u8 },
}

impl IOMessage {
    pub fn to_string(&self) -> String {
        match self {
            IOMessage::Out { payload, port } => Self::escape_newline(&format!("#OUT#{:02X}#{}", port, payload)),
        }
    }

    fn escape_newline(s: &str) -> String {
        s.replace("\n", "\\n").replace("\r", "\\r")
    }
}
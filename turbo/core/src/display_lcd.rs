use std::cell::Cell;

pub struct Lcd {
    busy: Cell<bool>,
}

impl Lcd {
    pub fn new() -> Self {
        Self {
            busy: Cell::new(false)
        }
    }

    pub fn send_data(&self, value: u8) -> Option<String> {
        if self.busy.get() {
            return None; // LCD is busy, cannot send data
        }
        self.busy.set(true);
        Some(format!("{}", value as char))
    }

    pub fn send_command(&self, _value: u8) {
        // ignore the actual command for now, just set the busy flag
        self.busy.set(true);
    }

    pub fn get_status(&self) -> u8 {
        // just clear the busy flag and return 0, indicating that the LCD is ready
        self.busy.set(false);
        0
    }
}

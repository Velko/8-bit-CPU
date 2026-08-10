use std::cell::Cell;

pub struct Lcd {
    status: Cell<u8>,
}

const LCD_BUSY_FLAG: u8 = 0x80;

impl Lcd {
    pub fn new() -> Self {
        Self {
            status: Cell::new(LCD_BUSY_FLAG), // Initially busy
        }
    }

    pub fn send_data(&self, value: u8) -> Option<String> {
        if self.status.get() & LCD_BUSY_FLAG != 0 {
            return None; // LCD is busy, cannot send data
        }
        self.status.set(LCD_BUSY_FLAG);
        Some(format!("{}", value as char))
    }

    pub fn send_command(&self, _value: u8) {
        // ignore the actual command for now, just set the busy flag
        self.status.set(LCD_BUSY_FLAG);
    }

    pub fn get_status(&self) -> u8 {
        // just clear the busy flag and return 0, indicating that the LCD is ready
        let status = self.status.get();
        self.status.set(0x00); // Clear the busy flag
        status
    }
}

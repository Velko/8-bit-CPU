use std::cell::Cell;
use std::rc::Rc;
use std::cell::RefCell;
use turbo_bridge::CommsChannel;
pub struct Lcd {
    status: Cell<u8>,
    comm_channel: Rc<RefCell<CommsChannel>>,
}

const LCD_BUSY_FLAG: u8 = 0x80;

impl Lcd {
    pub fn new(comm_channel: Rc<RefCell<CommsChannel>>) -> Self {
        Self {
            status: Cell::new(LCD_BUSY_FLAG), // Initially busy
            comm_channel,
        }
    }

    pub fn send_data(&self, value: u8) {
        if self.status.get() & LCD_BUSY_FLAG != 0 {
            return; // LCD is busy, cannot send data
        }
        self.status.set(LCD_BUSY_FLAG);
        let payload = format!("{}", value as char);
        self.comm_channel.borrow_mut().send_output_msg(&payload, 0x10);
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

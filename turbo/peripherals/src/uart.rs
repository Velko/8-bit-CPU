use std::rc::Rc;
use std::cell::RefCell;
use std::thread;
use std::time::Duration;
use turbo_bridge::CommsChannel;

pub struct Uart<CC: CommsChannel> {
    comm_channel: Rc<RefCell<CC>>,
}

impl<CC: CommsChannel> Uart<CC> {
    pub fn new(comm_channel: Rc<RefCell<CC>>) -> Self {
        Self {
            comm_channel,
        }
    }

    pub fn send_char(&self, value: u8) {
        self.comm_channel.borrow().send_response_byte(value);
        thread::sleep(Duration::from_micros(87));
    }

    pub fn get_status(&self) -> u8 {
        if self.comm_channel.borrow().is_input_available() {
            0x01
        } else {
            0x00
        }
    }

    pub fn get_char(&self) -> u8 {
        // avoid blocking if no input is available, return 0xFF instead
        if self.get_status() == 0 {
            0xFF
        } else {
            self.comm_channel.borrow().recv_byte()
        }
    }
}

//TODO: UART should get its own CommsChannel, and should not interfere with the main one.
// Current implementation, however, utilizes the main one for compatibility with another
// (VeriLog) implementation, and the Python client side. All parts should be ported to
// the dedicated UART channel eventually, but we can not do it all at once.

use std::rc::Rc;
use std::cell::RefCell;
use turbo_bridge::CommsChannel;

pub struct Uart {
    comm_channel: Rc<RefCell<CommsChannel>>,
}

impl Uart {
    pub fn new(comm_channel: Rc<RefCell<CommsChannel>>) -> Self {
        Self {
            comm_channel,
        }
    }

    pub fn send_char(&self, value: u8) {
        self.comm_channel.borrow().send_response_byte(value);
    }

    pub fn get_status(&self) -> u8 {
        if self.comm_channel.borrow().rx.peek().is_some() {
            0x01
        } else {
            0x00
        }
    }

    pub fn get_char(&self) -> u8 {
        let rx = &self.comm_channel.borrow().rx;
        // avoid blocking if no input is available, return 0xFF instead
        if self.get_status() == 0 {
            0xFF
        } else {
            rx.recv() as u8
        }
    }
}

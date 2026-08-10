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
        print!("{}", value as char);
    }

    pub fn get_status(&self) -> u8 {
        todo!()
    }

    pub fn get_char(&self) -> u8 {
        todo!()
    }
}

use std::rc::Rc;
use std::cell::RefCell;

use turbo_bridge::CommsChannel;

pub struct DisplayNumeric<CC: CommsChannel> {
    comm_channel: Rc<RefCell<CC>>,
}

impl<CC: CommsChannel> DisplayNumeric<CC> {
    pub fn new(comm_channel: Rc<RefCell<CC>>) -> Self {
        Self {
            comm_channel
        }
    }

    pub fn send(&self, value: u8, mode: u8) {

        let payload = match mode {
            0 => format!("{:4}\n", value),
            1 => format!("{:4}\n", value as i8),
            2 => format!("h {:02x}\n", value),
            3 => format!("o{:03o}\n", value),
            _ => panic!("DisplayNumeric: unsupported mode {}", mode),
        };

        self.comm_channel.borrow_mut().send_output_msg(&payload, 0);
    }
}

use std::rc::Rc;
use std::cell::RefCell;
use turbo_bridge::CommsChannel;

pub struct DisplayChar {
    comm_channel: Rc<RefCell<CommsChannel>>,
}

impl DisplayChar {
    pub fn new(comm_channel: Rc<RefCell<CommsChannel>>) -> Self {
        Self {
            comm_channel
        }
    }

    pub fn send(&self, value: u8) {
        let payload = format!("{}", value as char);
        self.comm_channel.borrow_mut().send_output_msg(&payload, 4);
    }
}

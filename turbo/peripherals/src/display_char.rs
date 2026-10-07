use std::rc::Rc;
use std::cell::RefCell;
use turbo_bridge::CommsChannel;

pub struct DisplayChar<CC: CommsChannel> {
    comm_channel: Rc<RefCell<CC>>,
}

impl<CC: CommsChannel> DisplayChar<CC> {
    pub fn new(comm_channel: Rc<RefCell<CC>>) -> Self {
        Self {
            comm_channel
        }
    }

    pub fn send(&self, value: u8) {
        let payload = format!("{}", value as char);
        self.comm_channel.borrow_mut().send_output_msg(&payload, 4);
    }
}

use std::rc::Rc;
use std::cell::RefCell;
use std::thread;
use std::time::Duration;
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
        thread::sleep(Duration::from_micros(87));
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

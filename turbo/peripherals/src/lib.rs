mod display_lcd;
mod display_numeric;
mod display_char;
mod uart;

use turbo_core::{IOMessage, IOPorts};
use std::cell::RefCell;
use std::rc::Rc;
use turbo_bridge::CommsChannel;
use crate::{display_lcd::Lcd, display_numeric::DisplayNumeric, display_char::DisplayChar, uart::Uart};

pub struct Peripherals {
    display_numeric: DisplayNumeric,
    display_char: DisplayChar,
    lcd: Lcd,
    uart: Uart,
}

impl Peripherals {
    pub fn new(comm_channel0: Rc<RefCell<CommsChannel>>) -> Self {
        Self {
            display_numeric: DisplayNumeric::new(),
            display_char: DisplayChar::new(),
            lcd: Lcd::new(),
            uart: Uart::new(comm_channel0),
        }
    }
}

impl IOPorts for Peripherals {
    fn read_port(&self, port: u8) -> u8 {
        match port {
            0x11 => self.lcd.get_status(),
            0x20 => self.uart.get_status(),
            0x21 => self.uart.get_char(),
            _ => todo!("Port: 0x{:02x} input not yet implemented", port),
        }
    }

    fn write_port(&mut self, port: u8, value: u8) -> Option<IOMessage> {
        match port {
            0 => {
                return Some(IOMessage::Out { payload: self.display_numeric.format(value), port: port });
            },
            1 => {
                self.display_numeric.set_mode(value);
            },
            4 => {
                return Some(IOMessage::Out { payload: self.display_char.format(value), port: port });
            },
            0x10 => {
                if let Some(msg) = self.lcd.send_data(value) {
                    return Some(IOMessage::Out { payload: msg, port: port });
                }
            },
            0x11 => {
                self.lcd.send_command(value);
            },
            0x21 => {
                self.uart.send_char(value);
            },
            _ => todo!("Port: 0x{:02x} not yet implemented", port),
        }
        None
    }
}

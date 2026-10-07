mod display_lcd;
mod display_numeric;
mod display_char;
mod uart;
mod timer;

use turbo_core::IOPorts;
use std::cell::RefCell;
use std::rc::Rc;
use turbo_bridge::CommsChannel;
use crate::{display_lcd::Lcd, display_numeric::DisplayNumeric, display_char::DisplayChar, uart::Uart, timer::Timer};

pub struct Peripherals<CC: CommsChannel> {
    display_numeric: DisplayNumeric<CC>,
    display_char: DisplayChar<CC>,
    lcd: Lcd<CC>,
    uart: Uart<CC>,
    timer: Timer,
}

impl<CC: CommsChannel> Peripherals<CC> {
    pub fn new(channels: &[Rc<RefCell<CC>>]) -> Self {
        Self {
            display_numeric: DisplayNumeric::new(channels[0].clone()),
            display_char: DisplayChar::new(channels[0].clone()),
            lcd: Lcd::new(channels[0].clone()), //TODO: should use channel 1 instead
            uart: Uart::new(channels[2].clone()),
            timer: Timer::new(),
        }
    }
}

impl<CC: CommsChannel> IOPorts for Peripherals<CC> {
    fn read_port(&self, port: u8) -> u8 {
        match port {
            0x11 => self.lcd.get_status(),
            0x20 => self.uart.get_status(),
            0x21 => self.uart.get_char(),
            0x30 => self.timer.get_counter(),
            _ => todo!("Port: 0x{:02x} input not yet implemented", port),
        }
    }

    fn write_port(&mut self, port: u8, value: u8) {
        match port {
            0..4 => {
                self.display_numeric.send(value, port);
            },
            4 => {
                self.display_char.send(value);
            },
            0x10 => {
                self.lcd.send_data(value);
            },
            0x11 => {
                self.lcd.send_command(value);
            },
            0x21 => {
                self.uart.send_char(value);
            },
            0x30 => {
                self.timer.set_counter(value);
            },
            _ => todo!("Port: 0x{:02x} not yet implemented", port),
        }
    }
}

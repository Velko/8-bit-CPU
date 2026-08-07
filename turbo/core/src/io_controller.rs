use crate::{BusValues, IOMessage, devices::{BusOutputPin, DelayedPin, GlobalSignalsReceiver, ValueSource}, router::MainBusSource};

pub struct IOController {
    pub name: &'static str,
    pub from_dev: BusOutputPin<MainBusSource>,
    pub to_dev: DelayedPin,
    pub laddr: DelayedPin,
    selected_port: u8,
    display_numeric: DisplayNumeric,
    display_char: DisplayChar,
    lcd: Lcd,
    uart: Uart,
}

impl IOController {
    pub fn new(name: &'static str, main_id: MainBusSource) -> Self {
        Self {
            name,
            from_dev: BusOutputPin::new(main_id),
            to_dev: DelayedPin::new(),
            laddr: DelayedPin::new(),
            selected_port: 0,
            display_numeric: DisplayNumeric::new(),
            display_char: DisplayChar::new(),
            lcd: Lcd::new(),
            uart: Uart::new(),
        }
    }

    fn wrap_message(&self, payload: String) -> Option<IOMessage> {
        Some(IOMessage::Out { payload, port: self.selected_port })
    }
}

impl ValueSource<u8> for IOController {
    fn get_value(&self, _bus_values: &BusValues) -> u8 {
        match self.selected_port {
            0x11 => self.lcd.get_status(),
            0x20 => self.uart.get_status(),
            0x21 => self.uart.get_char(),
            _ => todo!("Port: 0x{:02x} input not yet implemented", self.selected_port),
        }
    }
}

impl GlobalSignalsReceiver for IOController {
    fn on_clock_tick_primary(&mut self, bus_values: &mut BusValues) {
        if self.laddr.is_enabled() {
            self.selected_port = bus_values.main_bus.value.unwrap();
        } else if self.to_dev.is_enabled() {
            match self.selected_port {
                0 => {
                    bus_values.message = self.wrap_message(self.display_numeric.format(bus_values.main_bus.value.unwrap()));
                },
                1 => {
                    self.display_numeric.set_mode(bus_values.main_bus.value.unwrap());
                },
                4 => {
                    bus_values.message = self.wrap_message(self.display_char.format(bus_values.main_bus.value.unwrap()));
                },
                0x10 => {
                    self.lcd.send_data(bus_values.main_bus.value.unwrap());
                },
                0x11 => {
                    self.lcd.send_command(bus_values.main_bus.value.unwrap());
                },
                0x21 => {
                    self.uart.send_char(bus_values.main_bus.value.unwrap());
                },
                _ => todo!("Port: 0x{:02x} not yet implemented", self.selected_port),
            };
        }
    }
}

struct DisplayNumeric {
    mode: u8,
}

impl DisplayNumeric {
    pub fn new() -> Self {
        Self { mode: 0 }
    }

    pub fn format(&self, value: u8) -> String {
        match self.mode {
            0 => format!("{:4}\\n", value),
            1 => format!("{:4}\\n", value as i8),
            2 => format!("h {:02x}\\n", value),
            3 => format!("o{:03o}\\n", value),
            _ => panic!("DisplayNumeric: unsupported mode {}", self.mode),
        }
    }

    pub fn set_mode(&mut self, mode: u8) {
        self.mode = mode;
    }
}

struct DisplayChar {
}

impl DisplayChar {
    pub fn new() -> Self {
        Self {}
    }

    pub fn format(&self, value: u8) -> String {
        format!("{}", value as char)
    }
}

struct Lcd {
}

impl Lcd {
    pub fn new() -> Self {
        Self {}
    }

    pub fn send_data(&self, value: u8) {
        print!("{}", value as char);
    }

    pub fn send_command(&self, value: u8) {
        print!("LCD command: 0x{:02x}\\n", value);
    }

    pub fn get_status(&self) -> u8 {
        todo!()
    }
}

struct Uart {
}

impl Uart {
    pub fn new() -> Self {
        Self {}
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

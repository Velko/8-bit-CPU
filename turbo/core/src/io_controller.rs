use crate::{BusValues, devices::{BusOutputPin, DelayedPin, GlobalSignalsReceiver, ValueSource}, router::MainBusSource};

pub struct IOController {
    pub name: &'static str,
    pub from_dev: BusOutputPin<MainBusSource>,
    pub to_dev: DelayedPin,
    pub laddr: DelayedPin,
    selected_port: u8,
    display_numeric: DisplayNumeric,
    display_char: DisplayChar,
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
        }
    }
}

impl ValueSource<u8> for IOController {
    fn get_value(&self, _bus_values: &BusValues) -> u8 {
        todo!()
    }
}

impl GlobalSignalsReceiver for IOController {
    fn on_clock_tick_primary(&mut self, bus_values: &mut BusValues) {
        if self.laddr.is_enabled() {
            self.selected_port = bus_values.main_bus.value.unwrap();
        } else if self.to_dev.is_enabled() {
            bus_values.message = match self.selected_port {
                0 => self.display_numeric.format(bus_values.main_bus.value.unwrap()),
                1 => self.display_numeric.set_mode(bus_values.main_bus.value.unwrap()),
                4 => self.display_char.format(bus_values.main_bus.value.unwrap()),
                _ => todo!(),
            }.map(|payload| crate::IOMessage::Out { payload, port: self.selected_port });
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

    pub fn format(&mut self, value: u8) -> Option<String> {
        match self.mode {
            0 => Some(format!("{:4}\\n", value)),
            1 => Some(format!("{:4}\\n", value as i8)),
            2 => Some(format!("h {:02x}\\n", value)),
            3 => Some(format!("o{:03o}\\n", value)),
            _ => panic!("DisplayNumeric: unsupported mode {}", self.mode),
        }

    }

    pub fn set_mode(&mut self, mode: u8) -> Option<String> {
        self.mode = mode;
        None
    }
}

struct DisplayChar {
}

impl DisplayChar {
    pub fn new() -> Self {
        Self {}
    }

    pub fn format(&mut self, value: u8) -> Option<String> {
        Some(format!("{}", value as char))
    }
}

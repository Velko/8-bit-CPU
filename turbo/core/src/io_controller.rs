use crate::{BusValues, devices::{BusOutputPin, DelayedPin, GlobalSignalsReceiver, ValueSource}, peripherals::Peripherals, router::MainBusSource};

pub struct IOController {
    pub name: &'static str,
    pub from_dev: BusOutputPin<MainBusSource>,
    pub to_dev: DelayedPin,
    pub laddr: DelayedPin,
    selected_port: u8,
    peripherals: Peripherals,
}

pub trait IOPorts {
    fn read_port(&self, port: u8) -> u8;
    fn write_port(&mut self, port: u8, value: u8) -> Option<crate::IOMessage>;
}

impl IOController {
    pub fn new(name: &'static str, main_id: MainBusSource) -> Self {
        Self {
            name,
            from_dev: BusOutputPin::new(main_id),
            to_dev: DelayedPin::new(),
            laddr: DelayedPin::new(),
            selected_port: 0,
            peripherals: Peripherals::new(),
        }
    }
}

impl ValueSource<u8> for IOController {
    fn get_value(&self, _bus_values: &BusValues) -> u8 {
        self.peripherals.read_port(self.selected_port)
    }
}

impl GlobalSignalsReceiver for IOController {
    fn on_clock_tick_primary(&mut self, bus_values: &mut BusValues) {
        if self.laddr.is_enabled() {
            self.selected_port = bus_values.main_bus.value.unwrap();
        } else if self.to_dev.is_enabled() {
            bus_values.message = self.peripherals.write_port(self.selected_port, bus_values.main_bus.value.unwrap());
        }
    }
}


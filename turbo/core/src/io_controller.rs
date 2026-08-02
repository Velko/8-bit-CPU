use crate::{BusValues, devices::{BusOutputPin, DelayedPin, GlobalSignalsReceiver, ValueSource}, router::MainBusSource};

pub struct IOController {
    pub name: &'static str,
    pub from_dev: BusOutputPin<MainBusSource>,
    pub to_dev: DelayedPin,
    pub laddr: DelayedPin,
    selected_port: u8,
}
impl IOController {
    pub fn new(name: &'static str, main_id: MainBusSource) -> Self {
        Self {
            name,
            from_dev: BusOutputPin::new(main_id),
            to_dev: DelayedPin::new(),
            laddr: DelayedPin::new(),
            selected_port: 0,
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
            println!("IOController {}: to_dev enabled, selected_port = {}", self.name, self.selected_port);
            bus_values.messages.push(crate::IOMessage::Out { port: self.selected_port, value: bus_values.main_bus.value.unwrap() });
        }
    }
}

use crate::{BusValues, devices::{BusOutputPin, DelayedPin, GlobalSignalsReceiver, ValueSource}, router::MainBusSource};

pub struct IOController<P> where P: IOPorts {
    pub name: &'static str,
    pub from_dev: BusOutputPin<MainBusSource>,
    pub to_dev: DelayedPin,
    pub laddr: DelayedPin,
    selected_port: u8,
    ioports: P,
}

pub trait IOPorts {
    fn read_port(&self, port: u8) -> u8;
    fn write_port(&mut self, port: u8, value: u8) -> Option<crate::IOMessage>;
}

impl<P: IOPorts> IOController<P> {
        pub fn new(name: &'static str, main_id: MainBusSource, ioports: P) -> Self {
            Self {
            name,
            from_dev: BusOutputPin::new(main_id),
            to_dev: DelayedPin::new(),
            laddr: DelayedPin::new(),
            selected_port: 0,
            ioports,
        }
    }
}

impl<P: IOPorts> ValueSource<u8> for IOController<P> {
    fn get_value(&self, _bus_values: &BusValues) -> u8 {
        self.ioports.read_port(self.selected_port)
    }
}

impl<P: IOPorts> GlobalSignalsReceiver for IOController<P> {
    fn on_clock_tick_primary(&mut self, bus_values: &mut BusValues) {
        if self.laddr.is_enabled() {
            self.selected_port = bus_values.main_bus.value.unwrap();
        } else if self.to_dev.is_enabled() {
            bus_values.message = self.ioports.write_port(self.selected_port, bus_values.main_bus.value.unwrap());
        }
    }
}


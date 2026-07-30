use crate::{BusValues, devices::{BusOutputPin, DelayedPin, GlobalSignalsReceiver, ValueSource}, router::{AddressBusSource, MainBusSource}};


pub trait TransferRegisterBehavior {
    type BusSource;
    type ValueType;
    fn store_value(register: &mut TransferRegister<Self>, bus_values: &BusValues) where Self: Sized;
    fn get_value(register: &TransferRegister<Self>, bus_values: &BusValues) -> Self::ValueType where Self: Sized;
}

pub struct TransferRegister<Behavior: TransferRegisterBehavior> {
    pub name: &'static str,
    pub out: BusOutputPin<Behavior::BusSource>,
    pub load: DelayedPin,
}

impl<Behavior: TransferRegisterBehavior> TransferRegister<Behavior> {
    pub fn new(name: &'static str, bus_id: Behavior::BusSource) -> Self {
        Self {
            name,
            out: BusOutputPin::new(bus_id),
            load: DelayedPin::new(),
        }
    }
}

pub struct MainBusBehavior;
impl TransferRegisterBehavior for MainBusBehavior {
    type BusSource = MainBusSource;
    type ValueType = u8;

    fn store_value(register: &mut TransferRegister<Self>, bus_values: &BusValues) {
        let value = bus_values.main_bus.value.unwrap();
        match register.out.source {
            MainBusSource::TH => bus_values.th_reg_val.set(value),
            MainBusSource::TL => bus_values.tl_reg_val.set(value),
            _ => {},
        }
    }

    fn get_value(register: &TransferRegister<Self>, bus_values: &BusValues) -> Self::ValueType {
        match register.out.source {
            MainBusSource::TH => bus_values.th_reg_val.get(),
            MainBusSource::TL => bus_values.tl_reg_val.get(),
            _ => panic!("Invalid bus source for MainBusBehavior: {:?}", register.out.source),
        }
    }
}

pub struct AddressBusBehavior;
impl TransferRegisterBehavior for AddressBusBehavior {
    type BusSource = AddressBusSource;
    type ValueType = u16;

    fn store_value(_register: &mut TransferRegister<Self>, bus_values: &BusValues) {
        let value = bus_values.address_bus.value.unwrap();
        bus_values.th_reg_val.set((value >> 8) as u8);
        bus_values.tl_reg_val.set((value & 0xFF) as u8);
    }

    fn get_value(_register: &TransferRegister<Self>, bus_values: &BusValues) -> Self::ValueType {
        ((bus_values.th_reg_val.get() as u16) << 8) | bus_values.tl_reg_val.get() as u16
    }
}


impl<Behavior: TransferRegisterBehavior> GlobalSignalsReceiver for TransferRegister<Behavior> {
    fn on_clock_tick_primary(&mut self, bus_values: &BusValues) {
        if self.load.is_enabled() {
            Behavior::store_value(self, bus_values);
        }
    }
    fn on_clock_tick_secondary(&mut self) {

    }
}

impl<Behavior: TransferRegisterBehavior> ValueSource<Behavior::ValueType> for TransferRegister<Behavior> {
    fn get_value(&self, bus_values: &BusValues) -> Behavior::ValueType {
        Behavior::get_value(self, bus_values)
    }
}


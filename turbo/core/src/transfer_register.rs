use crate::{BusValues, devices::{BusOutputPin, DelayedPin, GlobalSignalsReceiver, ValueSource}, router::{AddressBusSource, MainBusSource}};


pub trait TransferRegisterBehavior {
    type BusSource;
    type ValueType;
    fn store_value(register: &mut TransferRegister<Self>, bus_values: &mut BusValues) where Self: Sized;
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

    fn store_value(register: &mut TransferRegister<Self>, bus_values: &mut BusValues) {
        let value = bus_values.main_bus.value.unwrap();
        match register.out.source {
            MainBusSource::TH => bus_values.th_reg_val = value,
            MainBusSource::TL => bus_values.tl_reg_val = value,
            _ => {},
        }
    }

    fn get_value(register: &TransferRegister<Self>, bus_values: &BusValues) -> Self::ValueType {
        match register.out.source {
            MainBusSource::TH => bus_values.th_reg_val,
            MainBusSource::TL => bus_values.tl_reg_val,
            _ => panic!("Invalid bus source for MainBusBehavior: {:?}", register.out.source),
        }
    }
}

pub struct AddressBusBehavior;
impl TransferRegisterBehavior for AddressBusBehavior {
    type BusSource = AddressBusSource;
    type ValueType = u16;

    fn store_value(_register: &mut TransferRegister<Self>, bus_values: &mut BusValues) {
        let value = bus_values.address_bus.value.unwrap();
        bus_values.th_reg_val = (value >> 8) as u8;
        bus_values.tl_reg_val = (value & 0xFF) as u8;
    }

    fn get_value(_register: &TransferRegister<Self>, bus_values: &BusValues) -> Self::ValueType {
        ((bus_values.th_reg_val as u16) << 8) | bus_values.tl_reg_val as u16
    }
}


impl<Behavior: TransferRegisterBehavior> GlobalSignalsReceiver for TransferRegister<Behavior> {
    fn on_clock_tick_primary(&mut self, bus_values: &mut BusValues) {
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

#[cfg(test)]
mod tests {
    use crate::{control_word::ControlWordBuilder, devices::ValueSource, router::{AddrLoadMux, LoadMux}, test_helpers::TestBench};

    #[test]
    fn test_load_tx_get_th_tl() {
        let mut bench = TestBench::new();
        bench.bus_values.address_bus.value = Some(0xABCD);

        let load_tx_cw = ControlWordBuilder::default()
            .apply_mux::<AddrLoadMux>(AddrLoadMux::VALUE_TX_LOAD)
            .build(); // Enable TX Load

        bench.devices.route_word(&mut bench.bus_values, crate::router::DEFAULT_CW, load_tx_cw);

        bench.devices.broadcast_clock_tick_primary(&mut bench.bus_values);

        assert_eq!(bench.bus_values.th_reg_val, 0xAB);
        assert_eq!(bench.bus_values.tl_reg_val, 0xCD);
    }

    #[test]
    fn test_load_th_tl_get_tx() {
        let mut bench = TestBench::new();

        let load_th_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_TH_LOAD)
            .build(); // Enable TH Load

        bench.devices.route_word(&mut bench.bus_values, crate::router::DEFAULT_CW, load_th_cw);
        bench.bus_values.main_bus.value = Some(0x12);

        bench.devices.broadcast_clock_tick_primary(&mut bench.bus_values);

        let load_tl_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_TL_LOAD)
            .build(); // Enable TL Load
        bench.devices.route_word(&mut bench.bus_values, load_th_cw, load_tl_cw);
        bench.bus_values.main_bus.value = Some(0x34);

        bench.devices.broadcast_clock_tick_primary(&mut bench.bus_values);

        assert_eq!(bench.devices.TX.get_value(&bench.bus_values), 0x1234);
    }
}

use crate::{BusValues, devices::{BusOutputPin, DelayedPin, GlobalSignalsReceiver, ValueSource}, router::AddressBusSource};

pub struct AddressCalculator {
    pub name: &'static str,
    pub out: BusOutputPin<AddressBusSource>,
    pub load: DelayedPin,
    pub signed: DelayedPin,
    value: u16,
}

impl AddressCalculator {
    pub fn new(name: &'static str, address_bus_id: AddressBusSource) -> Self {
        Self {
            name,
            out: BusOutputPin::new(address_bus_id),
            load: DelayedPin::new(),
            signed: DelayedPin::new(),
            value: 0,
        }
    }
}

impl GlobalSignalsReceiver for AddressCalculator {
    fn on_clock_tick_primary(&mut self, bus_values: &BusValues) {
        if self.load.is_enabled() {
            let base_address = bus_values.address_bus.value.unwrap();
            self.value = if self.signed.is_enabled() {
                let signed_offset = bus_values.main_bus.value.unwrap() as i8 as i16;
                base_address.wrapping_add_signed(signed_offset)
            } else {
                base_address.wrapping_add(bus_values.main_bus.value.unwrap() as u16)
            }
        }
    }

    fn on_reset(&mut self) {
        self.value = 0;
    }
}

impl ValueSource<u16> for AddressCalculator {
    fn get_value(&self, _bus_values: &BusValues) -> u16 {
        self.value
    }
}

#[cfg(test)]
mod tests {
    use crate::{DEFAULT_CW, control_word::ControlWordBuilder, router::AddrLoadMux, test_helpers::TestBench, router::ACalcSigned};

    #[test]
    fn test_load_unsigned() {
        let mut bench = TestBench::new();

        let load_calc_unsigned = ControlWordBuilder::default()
            .apply_mux::<AddrLoadMux>(AddrLoadMux::VALUE_ACALC_LOAD)
            .build();

        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, load_calc_unsigned);
        bench.bus_values.main_bus.value = Some(0x20);
        bench.bus_values.address_bus.value = Some(0x1000);

        bench.devices.broadcast_clock_tick_primary(&bench.bus_values);


        assert_eq!(bench.devices.ACalc.value, 0x1020);
    }

    #[test]
    fn test_load_signed() {
        let mut bench = TestBench::new();

        let load_calc_unsigned = ControlWordBuilder::default()
            .apply_mux::<AddrLoadMux>(AddrLoadMux::VALUE_ACALC_LOAD)
            .apply_bit::<ACalcSigned>()
            .build();

        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, load_calc_unsigned);
        bench.bus_values.main_bus.value = Some(0x80);
        bench.bus_values.address_bus.value = Some(0x1000);

        bench.devices.broadcast_clock_tick_primary(&bench.bus_values);


        assert_eq!(bench.devices.ACalc.value, 0x0F80);
    }
}

use crate::{BusValues, devices::{BusOutputPin, DelayedPin, GlobalSignalsReceiver, ValueSource}, router::AddressBusSource};

pub struct StackPointer {
    pub name: &'static str,
    pub out: BusOutputPin<AddressBusSource>,
    pub load: DelayedPin,
    pub inc: DelayedPin,
    pub dec: DelayedPin,
    value_primary: u16,
    value_secondary: u16,
}

impl StackPointer {
    pub fn new(name: &'static str, address_bus_id: AddressBusSource) -> Self {
        Self {
            name,
            out: BusOutputPin::new(address_bus_id),
            load: DelayedPin::new(),
            inc: DelayedPin::new(),
            dec: DelayedPin::new(),
            value_primary: 0,
            value_secondary: 0,
        }
    }

    pub fn set_value(&mut self, value: u16) {
        self.value_primary = value;
        self.value_secondary = value;
    }
}

impl GlobalSignalsReceiver for StackPointer {
    fn on_clock_tick_primary(&mut self, bus_values: &BusValues) {
        if self.load.is_enabled() {
            self.value_primary = bus_values.address_bus.value.unwrap();
        } else if self.inc.is_enabled() {
            self.value_primary = self.value_primary.wrapping_add(1);
        } else if self.dec.is_enabled() {
            self.value_primary = self.value_primary.wrapping_sub(1);
        }
    }

    fn on_clock_tick_secondary(&mut self) {
        if self.value_primary != self.value_secondary {
            self.value_secondary = self.value_primary;
        }
    }
    fn on_reset(&mut self) {
        self.value_primary = 0;
        self.value_secondary = 0;
    }
}

impl ValueSource<u16> for StackPointer {
    fn get_value(&self, _bus_values: &BusValues) -> u16 {
        self.value_secondary
    }
}

#[cfg(test)]
mod tests {
    use crate::router::AddrDec;
use crate::test_helpers::TestBench;
    use crate::router::AddrLoadMux;
    use crate::router::AddrInc;
    use crate::router::AddrOutMux;
    use crate::control_word::ControlWordBuilder;
    use crate::router::DEFAULT_CW;

    #[test]
    fn test_stack_pointer_out_inc() {
        let mut bench = TestBench::new();
        bench.devices.SP.set_value(0x1234);

        let sp_out_inc_cw = ControlWordBuilder::default()
            .apply_mux::<AddrOutMux>(AddrOutMux::VALUE_SP_OUT)
            .apply_bit::<AddrInc>()
            .build(); // Enable SP Out and Inc
        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, sp_out_inc_cw);

        // broadcasts the original value
        bench.bus_values.resolve(&bench.devices);
        assert_eq!(Some(0x1234), bench.bus_values.address_bus.value);

        // incrementing the value should only affect the internal storage
        bench.devices.broadcast_clock_tick_primary(&bench.bus_values);
        assert_eq!(0x1235, bench.devices.SP.value_primary);

        // check if still broadcasts the original value
        bench.bus_values.resolve(&bench.devices);
        assert_eq!(Some(0x1234), bench.bus_values.address_bus.value);
    }

    #[test]
    fn test_stack_pointer_out_dec() {
        let mut bench = TestBench::new();
        bench.devices.SP.set_value(0x1234);

        let sp_out_dec_cw = ControlWordBuilder::default()
            .apply_mux::<AddrOutMux>(AddrOutMux::VALUE_SP_OUT)
            .apply_bit::<AddrDec>()
            .build(); // Enable SP Out and Dec
        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, sp_out_dec_cw);

        // broadcasts the original value
        bench.bus_values.resolve(&bench.devices);
        assert_eq!(Some(0x1234), bench.bus_values.address_bus.value);

        // decrementing the value should only affect the internal storage
        bench.devices.broadcast_clock_tick_primary(&bench.bus_values);
        assert_eq!(0x1233, bench.devices.SP.value_primary);

        // check if still broadcasts the original value
        bench.bus_values.resolve(&bench.devices);
        assert_eq!(Some(0x1234), bench.bus_values.address_bus.value);
    }

    #[test]
    fn test_stack_pointer_load() {
        let mut bench = TestBench::new();
        bench.bus_values.address_bus.value = Some(0x5678); // Simulate loading 42 into A

        let sp_load_cw = ControlWordBuilder::default()
            .apply_mux::<AddrLoadMux>(AddrLoadMux::VALUE_SP_LOAD)
            .build(); // Enable SP Load
        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, sp_load_cw);

        bench.devices.broadcast_clock_tick_primary(&bench.bus_values);

        assert_eq!(0x5678, bench.devices.SP.value_primary);
        assert_eq!(0, bench.devices.SP.value_secondary);

        bench.devices.broadcast_clock_tick_secondary();
        assert_eq!(0x5678, bench.devices.SP.value_secondary);
    }
}

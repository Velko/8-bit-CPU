use crate::{BusValues, devices::{DelayedPin, GlobalSignalsReceiver, ValueSource}};

pub struct StepCounter {
    pub name: &'static str,
    pub reset: DelayedPin,
    pub extended: DelayedPin, //TODO: does this pin really belongs here?
    step: u8,
    extval: usize,
}

impl StepCounter {
    pub fn new(name: &'static str) -> Self {
        Self {
            name,
            reset: DelayedPin::new(),
            extended: DelayedPin::new(),
            step: 0,
            extval: 0,
        }
    }

    pub fn get_extended_value(&self) -> usize {
        self.extval
    }
}

impl GlobalSignalsReceiver for StepCounter {
    fn on_clock_tick_primary(&mut self, _bus_values: &mut BusValues) {
        if self.extended.is_enabled() {
            // while hardware only allows an extra bit, we can future-proof and support more
            self.extval += 0x1;
        }
    }

    fn on_clock_tick_secondary(&mut self) {
        if self.reset.is_enabled() {
            self.step = 0;
            self.extval = 0;
        } else {
            if !self.extended.is_enabled() {
                // do not care about overflow, it is reset to 0 before entering the Run mode
                // and not used otherwise
                self.step = self.step.wrapping_add(1);
            }
        }
    }

    fn on_reset(&mut self) {
        self.step = 0;
        self.extval = 0;
    }
}

impl ValueSource<u8> for StepCounter {
    fn get_value(&self, _bus_values: &BusValues) -> u8 {
        self.step
    }
}

#[cfg(test)]
mod tests {
    use crate::{devices::ValueSource, test_helpers::TestBench};


    #[test]
    fn test_step_counter_increment() {
        let mut bench = TestBench::new();

        bench.devices.broadcast_clock_tick_secondary();
        assert_eq!(bench.devices.StepCounter.get_value(&bench.bus_values), 1);


        bench.devices.broadcast_clock_tick_secondary();
        assert_eq!(bench.devices.StepCounter.get_value(&bench.bus_values), 2);
    }

    #[test]
    fn test_step_counter_reset() {
        let mut bench = TestBench::new();
        bench.devices.StepCounter.step = 5;

        bench.devices.StepCounter.reset.change(&mut bench.bus_values, true);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(bench.devices.StepCounter.get_value(&bench.bus_values), 0);
    }

    #[test]
    fn test_step_counter_extended() {
        let mut bench = TestBench::new();

        bench.devices.StepCounter.extended.change(&mut bench.bus_values, true);
        bench.devices.broadcast_clock_tick_primary(&mut bench.bus_values);

        assert_eq!(bench.devices.StepCounter.get_extended_value(), 0x1);
    }

    #[test]
    fn test_step_counter_extended_stretch() {
        let mut bench = TestBench::new();
        bench.devices.StepCounter.step = 1;

        bench.devices.StepCounter.extended.change(&mut bench.bus_values, true);
        bench.devices.broadcast_clock_tick_secondary();

        // Should keep the original step value, when extended is enabled
        assert_eq!(bench.devices.StepCounter.get_value(&bench.bus_values), 1);
    }
}

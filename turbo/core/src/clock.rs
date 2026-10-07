use crate::{BusValues, TrapReason, devices::{BusOutputPinChange, GlobalSignalsReceiver}};


pub struct SetTrapPin {
    trap: TrapReason,
}

impl BusOutputPinChange for SetTrapPin {
    fn change(&self, bus_values: &mut BusValues, enable: bool) {
        if enable {
            bus_values.trap_reason = Some(self.trap.clone());
        }
    }
}

pub struct Clock {
    pub name: &'static str,
    pub halt: SetTrapPin,
    pub brk: SetTrapPin,
}
impl Clock {
    pub fn new(name: &'static str) -> Self {
        Self {
            name,
            halt: SetTrapPin { trap: TrapReason::Halt },
            brk: SetTrapPin { trap: TrapReason::Brk },
        }
    }
}

impl GlobalSignalsReceiver for Clock {}

#[cfg(test)]
mod tests {
    use crate::{DEFAULT_CW, TrapReason, control_word::ControlWordBuilder, router::{ClockHalt, ClockBrk}, test_helpers::TestBench};

    #[test]
    fn test_clock_halt_trap() {
        let mut bench = TestBench::new();

        let halt_cw = ControlWordBuilder::default()
            .apply_bit::<ClockHalt>()
            .build();

        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, halt_cw);

        assert_eq!(bench.bus_values.trap_reason, Some(TrapReason::Halt));
    }

     #[test]
    fn test_clock_brk_trap() {
        let mut bench = TestBench::new();

        let brk_cw = ControlWordBuilder::default()
            .apply_bit::<ClockBrk>()
            .build();

        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, brk_cw);

        assert_eq!(bench.bus_values.trap_reason, Some(TrapReason::Brk));
    }
}

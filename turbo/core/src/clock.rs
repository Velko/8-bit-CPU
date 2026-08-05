use crate::{BusValues, IOMessage, devices::{BusOutputPinChange, GlobalSignalsReceiver}};


pub struct MessageOutPin {
    msg: IOMessage,
}

impl BusOutputPinChange for MessageOutPin {
    fn change(&self, bus_values: &mut BusValues, enable: bool) {
        if enable {
            bus_values.message = Some(self.msg.clone());
        }
    }
}

pub struct Clock {
    pub name: &'static str,
    pub halt: MessageOutPin,
    pub brk: MessageOutPin,
}
impl Clock {
    pub fn new(name: &'static str) -> Self {
        Self {
            name,
            halt: MessageOutPin { msg: IOMessage::Halt },
            brk: MessageOutPin { msg: IOMessage::Brk },
        }
    }
}

impl GlobalSignalsReceiver for Clock {}

#[cfg(test)]
mod tests {
    use crate::{DEFAULT_CW, IOMessage, control_word::ControlWordBuilder, router::{ClockHalt, ClockBrk}, test_helpers::TestBench};

    #[test]
    fn test_clock_halt_message() {
        let mut bench = TestBench::new();

        let halt_cw = ControlWordBuilder::default()
            .apply_bit::<ClockHalt>()
            .build();

        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, halt_cw);

        assert_eq!(bench.bus_values.message, Some(IOMessage::Halt));
    }

     #[test]
    fn test_clock_brk_message() {
        let mut bench = TestBench::new();

        let brk_cw = ControlWordBuilder::default()
            .apply_bit::<ClockBrk>()
            .build();

        bench.devices.route_word(&mut bench.bus_values, DEFAULT_CW, brk_cw);

        assert_eq!(bench.bus_values.message, Some(IOMessage::Brk));
    }
}

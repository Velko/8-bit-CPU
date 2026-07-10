use std::cell::Cell;
    use crate::devices::MainBusValue;
use crate::devices::ClockReceiver;
use crate::devices::OutReceiver;
use crate::router::DEFAULT_CW;
use crate::runtime_state::{ArgSources, ArgValues};

pub struct ALU {
    pub name: &'static str,
    out_enabled: Cell<bool>,
    alt_enabled: Cell<bool>,
}
impl OutReceiver for ALU {
    fn on_out_change(&self, args: &mut ArgSources, enable: bool) {
        println!("ALU {} Out changed to: {}", self.name, enable);
        self.out_enabled.set(enable);
        //self.publish_output(state);
    }
}
impl ALU {
    pub fn new(name: &'static str) -> Self {
        Self {
            name,
            out_enabled: Cell::new(false),
            alt_enabled: Cell::new(false)
        }
    }
    pub fn on_alt_change(&self, args: &mut ArgSources, enable: bool) {
        println!("ALU {} Alt changed to: {}", self.name, enable);
        self.alt_enabled.set(enable);
        if self.out_enabled.get() {
            self.publish_output(args);
        }
    }
    fn publish_output(&self, args: &mut ArgSources) {
        // state.main_bus = if self.out_enabled.get() {
        //     match (self.name, self.alt_enabled.get()) {
        //         ("AddSub", false) => MainBusValue::Add,
        //         ("AddSub", true) => MainBusValue::Subtract,
        //         ("AndOr", false) => MainBusValue::And,
        //         ("AndOr", true) => MainBusValue::Or,
        //         ("XorNot", false) => MainBusValue::Xor,
        //         ("XorNot", true) => MainBusValue::Not,
        //         ("ShiftSwap", false) => MainBusValue::Shr,
        //         ("ShiftSwap", true) => MainBusValue::Swap,
        //         (_, _) => panic!("Unknown ALU module name: {}", self.name),
        //     }
        // } else {
        //     MainBusValue::None
        // };
    }
}
impl ClockReceiver for ALU {}

#[cfg(false)]
mod tests {
    use rstest::rstest;
    use super::*;
    use crate::router::{OutMux, AluArgL, AluArgR, LoadMux, FCalc, AluAlt, FCarry};
    use crate::devices::ValueSource;
    use crate::devices::Flags;
    use crate::test_helpers::{TestBench, i16tou8};
    use crate::control_word::ControlWordBuilder;

    #[rstest]
    #[case(24, 18, 42, Flags::EMPTY)] // 24 + 18 = 42, no flags set
    #[case(0, 0, 0, Flags::Z)] // 0 + 0 = 0, Z flag set
    #[case(0, -128, -128, Flags::N)]
    #[case(245, 18, 7, Flags::C)]
    #[case(126, 4, -126, Flags::N | Flags::V)] // 126 + 4 = -126 (overflow), N flag set
    #[case(246, 10, 0, Flags::C | Flags::Z)] // 246 + 10 = 0 (carry and zero), C and Z flags set
    #[case(200, 200, -112, Flags::C | Flags::N)]
    #[case(-30, -111, 115, Flags::V | Flags::C)]
    #[case(-128, -128, 0, Flags::C | Flags::Z | Flags::V)]
    fn test_alu_add(#[case] a: i16, #[case] b: i16, #[case] expected_sum: i16, #[case] expected_flags: Flags) {
        let mut bench = TestBench::new();

        let a = i16tou8(a);
        let b = i16tou8(b);
        let expected_sum = i16tou8(expected_sum);

        bench.devices.A.set_value(&mut bench.state, a);
        bench.devices.B.set_value(&mut bench.state, b);

        // add_A_B
        let add_ab_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_ADDSUB_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_mux::<AluArgR>(AluArgR::VALUE_B_ALU_R)
            .apply_bit::<FCalc>()
            .build();
        bench.devices.route_word(&mut bench.state, DEFAULT_CW, add_ab_cw);

        assert_eq!(expected_sum, bench.state.resolve_main_bus(&bench.devices)); // Check if the main bus calculates the sum of A and B correctly

        bench.devices.broadcast_clock_tick_primary(&mut bench.state);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_sum, bench.devices.A.get_value(&bench.state)); // Check if A has the value
        assert_eq!(b, bench.devices.B.get_value(&bench.state)); // Check if B remains unchanged
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.state)); // Check if the flags register has the expected flags set after the operation

        assert_eq!(expected_sum, bench.devices.get_alu_l_value(bench.state.alu_l_bus.unwrap(), &bench.state)); // Check if ALU L bus has the updated value 6
        assert_eq!(b, bench.devices.get_alu_r_value(bench.state.alu_r_bus.unwrap(), &bench.state)); // Check if ALU R bus has the original value 18

    }

    #[rstest]
    #[case(4, 3, 1, Flags::EMPTY)]
    #[case(-128, 0, -128, Flags::N)]
    #[case(4, 4, 0, Flags::Z)]
    #[case(0, -127, 127, Flags::C)]
    #[case(3, 5, -2, Flags::C | Flags::N)]
    #[case(-128, 1, 127, Flags::V)]
    #[case(120, -126, -10, Flags::V | Flags::C | Flags::N)]
    fn test_alu_sub(#[case] a: i16, #[case] b: i16, #[case] expected_result: i16, #[case] expected_flags: Flags) {
        let mut bench = TestBench::new();

        let a = i16tou8(a);
        let b = i16tou8(b);
        let expected_result = i16tou8(expected_result);

        bench.devices.B.set_value(&mut bench.state, a);
        bench.devices.C.set_value(&mut bench.state, b);

        // sub_B_C
        let sub_bc_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_B_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_ADDSUB_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_B_ALU_L)
            .apply_mux::<AluArgR>(AluArgR::VALUE_C_ALU_R)
            .apply_bit::<AluAlt>()
            .apply_bit::<FCalc>()
            .build();
        bench.devices.route_word(&mut bench.state, DEFAULT_CW, sub_bc_cw);

        assert_eq!(expected_result, bench.state.resolve_main_bus(&bench.devices)); // Check if the main bus calculates the difference of B and C correctly

        bench.devices.broadcast_clock_tick_primary(&mut bench.state);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_result, bench.devices.B.get_value(&bench.state)); // Check if B has the value
        assert_eq!(b, bench.devices.C.get_value(&bench.state)); // Check if C remains unchanged
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.state)); // Check if the flags register has the expected flags set after the operation

        assert_eq!(expected_result, bench.devices.get_alu_l_value(bench.state.alu_l_bus.unwrap(), &bench.state)); // Check if ALU L bus has the updated value 6
        assert_eq!(b, bench.devices.get_alu_r_value(bench.state.alu_r_bus.unwrap(), &bench.state)); // Check if ALU R bus has the original value 18
    }

    #[test]
    fn test_alu_adc() {
        let mut bench = TestBench::new();

        bench.devices.A.set_value(&mut bench.state, 24);
        bench.devices.B.set_value(&mut bench.state, 18);

        // adc_A_B
        let adc_ab_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_ADDSUB_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_mux::<AluArgR>(AluArgR::VALUE_B_ALU_R)
            .apply_bit::<FCalc>()
            .apply_bit::<FCarry>()
            .build();
        bench.devices.route_word(&mut bench.state, DEFAULT_CW, adc_ab_cw);

        assert_eq!(43, bench.state.resolve_main_bus(&bench.devices)); // Check if the main bus calculates the sum of A and B + carry correctly
    }

    #[test]
    fn test_alu_sbb() {
        let mut bench = TestBench::new();

        bench.devices.B.set_value(&mut bench.state, 24);
        bench.devices.C.set_value(&mut bench.state, 18);

        // sbb_B_C
        let sbb_bc_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_B_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_ADDSUB_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_B_ALU_L)
            .apply_mux::<AluArgR>(AluArgR::VALUE_C_ALU_R)
            .apply_bit::<AluAlt>()
            .apply_bit::<FCalc>()
            .apply_bit::<FCarry>()
            .build();
        bench.devices.route_word(&mut bench.state, DEFAULT_CW, sbb_bc_cw);

        assert_eq!(5, bench.state.resolve_main_bus(&bench.devices)); // Check if the main bus calculates the difference of B and C correctly
    }


    #[rstest]
    #[case(1, 1, 1, Flags::EMPTY)]
    #[case(0xff, 0x01, 0x01, Flags::EMPTY)]
    #[case(128, 128, 128, Flags::N)]
    #[case(255, 255, 255, Flags::N)]
    #[case(0, 0, 0, Flags::Z)]
    #[case(128, 127, 0, Flags::Z)]
    fn test_alu_and(#[case] a: u8, #[case] b: u8, #[case] expected_result: u8, #[case] expected_flags: Flags) {
        let mut bench = TestBench::new();

        bench.devices.A.set_value(&mut bench.state, a);
        bench.devices.B.set_value(&mut bench.state, b);

         // and_A_B
        let and_ab = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_ANDOR_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_mux::<AluArgR>(AluArgR::VALUE_B_ALU_R)
            .apply_bit::<FCalc>()
            .build();

        bench.devices.route_word(&mut bench.state, DEFAULT_CW, and_ab);
        bench.devices.broadcast_clock_tick_primary(&mut bench.state);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_result, bench.devices.A.get_value(&bench.state)); // Check if A has the value
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.state)); // Check if the flags register has the expected flags set after the operation
    }

    #[rstest]
    #[case(0, 1, 1, Flags::EMPTY)]
    #[case(0x7f, 0x01, 0x7f, Flags::EMPTY)]
    #[case(0, 128, 128, Flags::N)]
    #[case(0x80, 0x7f, 0xff, Flags::N)]
    #[case(0, 0, 0, Flags::Z)]
    fn test_alu_or(#[case] a: u8, #[case] b: u8, #[case] expected_result: u8, #[case] expected_flags: Flags) {
        let mut bench = TestBench::new();

        bench.devices.A.set_value(&mut bench.state, a);
        bench.devices.B.set_value(&mut bench.state, b);

        // or_A_B
        let or_ab = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_ANDOR_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_mux::<AluArgR>(AluArgR::VALUE_B_ALU_R)
            .apply_bit::<FCalc>()
            .apply_bit::<AluAlt>()
            .build();

        bench.devices.route_word(&mut bench.state, DEFAULT_CW, or_ab);
        bench.devices.broadcast_clock_tick_primary(&mut bench.state);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_result, bench.devices.A.get_value(&bench.state)); // Check if A has the value
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.state)); // Check if the flags register has the expected flags set after the operation
    }

    #[rstest]
    #[case(0x55, 0x01, 0x54, Flags::EMPTY)]
    #[case(0x55, 0x0f, 0x5a, Flags::EMPTY)]
    #[case(230, 92, 186, Flags::N)]
    #[case(0xa5, 0x5a, 0xff, Flags::N)]
    #[case(0x42, 0x42, 0, Flags::Z)]
    #[case(0x00, 0x00, 0, Flags::Z)]
    fn test_alu_xor(#[case] a: u8, #[case] b: u8, #[case] expected_result: u8, #[case] expected_flags: Flags) {
        let mut bench = TestBench::new();

        bench.devices.A.set_value(&mut bench.state, a);
        bench.devices.B.set_value(&mut bench.state, b);

        // xor_A_B
        let xor_ab = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_XORNOT_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_mux::<AluArgR>(AluArgR::VALUE_B_ALU_R)
            .apply_bit::<FCalc>()
            .build();

        bench.devices.route_word(&mut bench.state, DEFAULT_CW, xor_ab);
        bench.devices.broadcast_clock_tick_primary(&mut bench.state);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_result, bench.devices.A.get_value(&bench.state)); // Check if A has the value
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.state)); // Check if the flags register has the expected flags set after the operation
    }

    #[rstest]
    #[case(0x80, 0x7f, Flags::EMPTY)]
    #[case(25, 230, Flags::N)]
    #[case(0x00, 0xff, Flags::N)]
    #[case(0xFF, 0, Flags::Z)]
    fn test_alu_not(#[case] a: u8, #[case] expected_result: u8, #[case] expected_flags: Flags) {
        let mut bench = TestBench::new();

        bench.devices.A.set_value(&mut bench.state, a);

        // not_A
        let not_a = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_XORNOT_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_bit::<FCalc>()
            .apply_bit::<AluAlt>()
            .build();
        bench.devices.route_word(&mut bench.state, DEFAULT_CW, not_a);
        bench.devices.broadcast_clock_tick_primary(&mut bench.state);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_result, bench.devices.A.get_value(&bench.state)); // Check if A has the value
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.state)); // Check if the flags register has the expected flags set after the operation
    }

    #[rstest]
    #[case(25, 12, Flags::C)]
    #[case(122, 61, Flags::EMPTY)]
    #[case(128, 64, Flags::EMPTY)]
    #[case(0, 0, Flags::Z)]
    #[case(1, 0, Flags::C | Flags::Z)]
    fn test_alu_shr(#[case] a: u8, #[case] expected_result: u8, #[case] expected_flags: Flags) {
        let mut bench = TestBench::new();

        bench.devices.A.set_value(&mut bench.state, a);

        // shr_A
        let shr_a = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_SHIFTSWAP_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_bit::<FCalc>()
            .build();

        bench.devices.route_word(&mut bench.state, DEFAULT_CW, shr_a);
        bench.devices.broadcast_clock_tick_primary(&mut bench.state);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_result, bench.devices.A.get_value(&bench.state)); // Check if A has the value
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.state)); // Check if the flags register has the expected flags set after the operation
    }

    #[rstest]
    #[case(0xa2, 0x2a, Flags::EMPTY)]
    #[case(0x58, 0x85, Flags::N)]
    #[case(0x00, 0x00, Flags::Z)]
    #[case(0xff, 0xff, Flags::N)]
    #[case(0x0f, 0xf0, Flags::N)]
    #[case(0xf0, 0x0f, Flags::EMPTY)]
    #[case(0x3c, 0xc3, Flags::N)]
    #[case(0xc3, 0x3c, Flags::EMPTY)]
    fn test_alu_swap(#[case] a: u8, #[case] expected_result: u8, #[case] expected_flags: Flags) {
        let mut bench = TestBench::new();

        bench.devices.A.set_value(&mut bench.state, a);

        // swap_A
        let swap_a = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_SHIFTSWAP_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_bit::<FCalc>()
            .apply_bit::<AluAlt>()
            .build();

        bench.devices.route_word(&mut bench.state, DEFAULT_CW, swap_a);
        bench.devices.broadcast_clock_tick_primary(&mut bench.state);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_result, bench.devices.A.get_value(&bench.state)); // Check if A has the value
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.state)); // Check if the flags register has the expected flags set after the operation
    }
}

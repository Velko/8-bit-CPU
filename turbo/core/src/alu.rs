use std::cell::Cell;
use std::mem::MaybeUninit;
use crate::devices::ClockReceiver;
use crate::devices::OutReceiver;
use crate::devices::ValueSource;
use crate::router::DEFAULT_CW;
use crate::router::DeviceMap;
use crate::router::{MainBusSource, FlagsSource};
use crate::runtime_state::{ArgSources, ArgValues, ALUFlags};
use crate::flags::Flags;

pub struct ALU {
    pub name: &'static str,
    main_id: MainBusSource,
    flags_id: FlagsSource,
    alt_enabled: Cell<bool>,
}
impl OutReceiver for ALU {
    fn on_out_change(&self, args: &mut ArgSources, enable: bool) {
        println!("ALU {} Out changed to: {}", self.name, enable);
        args.main_bus_source = if enable { Some(self.main_id) } else { None };
        args.flags_source = if enable { Some(self.flags_id) } else { None };
    }
}
impl ALU {
    pub fn new(name: &'static str, main_id: MainBusSource, flags_id: FlagsSource) -> Self {
        Self {
            name,
            main_id,
            flags_id,
            alt_enabled: Cell::new(false)
        }
    }

    pub fn on_alt_change(&self, args: &mut ArgSources, enable: bool) {
        println!("ALU {} Alt changed to: {}", self.name, enable);
        self.alt_enabled.set(enable);
    }

    fn solve_add_sub(&self, devices: &DeviceMap, args: &ArgSources) -> u8 {
        let alu_l_value = args.alu_l_source.map(|source| devices.get_alu_l_value(source, args)).unwrap_or(0);
        let alu_r_value = args.alu_r_source.map(|source| devices.get_alu_r_value(source, args)).unwrap_or(0);
        let carry_in = if args.carry_in { 1 } else { 0 };

        if self.alt_enabled.get() {
            // Subtract
            alu_l_value.wrapping_sub(alu_r_value).wrapping_sub(carry_in)
        } else {
            // Add
            alu_l_value.wrapping_add(alu_r_value).wrapping_add(carry_in)
        }
    }

    fn solve_add_sub_flags(&self, devices: &DeviceMap, args: &ArgSources) -> ALUFlags {
        let alu_l_value = args.alu_l_source.map(|source| devices.get_alu_l_value(source, args)).unwrap_or(0);
        let alu_r_value = args.alu_r_source.map(|source| devices.get_alu_r_value(source, args)).unwrap_or(0);
        let carry_in = if args.carry_in { 1 } else { 0 };

        if self.alt_enabled.get() {
            // Subtract
            let result = alu_l_value.wrapping_sub(alu_r_value).wrapping_sub(carry_in);
            let carry = (alu_l_value as i16 - alu_r_value as i16 - carry_in as i16) < 0;
            let overflow = ((alu_l_value ^ alu_r_value) & (alu_l_value ^ result)) & 0x80 != 0;
            ALUFlags {
                carry: if carry { Some(Flags::C) } else { Some(Flags::EMPTY) },
                overflow: if overflow { Some(Flags::V) } else { Some(Flags::EMPTY) },
            }
        } else {
            // Add
            let result = alu_l_value.wrapping_add(alu_r_value).wrapping_add(carry_in);
            let carry = (alu_l_value as u16 + alu_r_value as u16 + carry_in as u16) > 0xFF;
            let overflow = ((alu_l_value ^ result) & (alu_r_value ^ result)) & 0x80 != 0;
            ALUFlags {
                carry: if carry { Some(Flags::C) } else { Some(Flags::EMPTY) },
                overflow: if overflow { Some(Flags::V) } else { Some(Flags::EMPTY) },
            }
        }
    }

    fn solve_and_or(&self, devices: &DeviceMap, args: &ArgSources) -> u8 {
        let alu_l_value = args.alu_l_source.map(|source| devices.get_alu_l_value(source, args)).unwrap_or(0);
        let alu_r_value = args.alu_r_source.map(|source| devices.get_alu_r_value(source, args)).unwrap_or(0);

        if self.alt_enabled.get() {
            // Or
            alu_l_value | alu_r_value
        } else {
            // And
            alu_l_value & alu_r_value
        }
    }

    fn solve_xor_not(&self, devices: &DeviceMap, args: &ArgSources) -> u8 {
        let alu_l_value = args.alu_l_source.map(|source| devices.get_alu_l_value(source, args)).unwrap_or(0);
        if self.alt_enabled.get() {
            // Not
            !alu_l_value
        } else {
            // Xor
            let alu_r_value = args.alu_r_source.map(|source| devices.get_alu_r_value(source, args)).unwrap_or(0);
            alu_l_value ^ alu_r_value
        }
    }

    fn solve_shift_swap(&self, devices: &DeviceMap, args: &ArgSources) -> u8 {
        let alu_l_value = args.alu_l_source.map(|source| devices.get_alu_l_value(source, args)).unwrap_or(0);
        if self.alt_enabled.get() {
            // Swap
            (alu_l_value << 4) | (alu_l_value >> 4)
        } else {
            // Shift right
            let carry_in = if args.carry_in { 0x80 } else { 0 };
            alu_l_value >> 1 | carry_in
        }
    }

    fn solve_shift_swap_flags(&self, devices: &DeviceMap, args: &ArgSources) -> ALUFlags {
        let alu_l_value = args.alu_l_source.map(|source| devices.get_alu_l_value(source, args)).unwrap_or(0);
        if self.alt_enabled.get() {
            // Swap
            ALUFlags {
                carry: None,
                overflow: None,
            }
        } else {
            // Shift right
            let carry = (alu_l_value & 0x01) != 0;
            ALUFlags {
                carry: if carry { Some(Flags::C) } else { Some(Flags::EMPTY) },
                overflow: None,
            }
        }
    }

}

impl ClockReceiver for ALU {}

impl ValueSource<u8> for ALU {
    fn get_value(&self, devices: &DeviceMap, args: &ArgSources) -> u8 {
        match self.main_id {
            MainBusSource::AddSub => self.solve_add_sub(devices, args),
            MainBusSource::AndOr => self.solve_and_or(devices, args),
            MainBusSource::XorNot => self.solve_xor_not(devices, args),
            MainBusSource::ShiftSwap => self.solve_shift_swap(devices, args),
            _ => panic!("Unknown ALU main bus source: {:?}", self.main_id),
        }
    }
}


impl ValueSource<ALUFlags> for ALU {
    fn get_value(&self, devices: &DeviceMap, args: &ArgSources) -> ALUFlags {
        match self.flags_id {
            FlagsSource::AddSub => self.solve_add_sub_flags(devices, args),
            FlagsSource::ShiftSwap => self.solve_shift_swap_flags(devices, args),
            _ => ALUFlags {
                carry: None,
                overflow: None,
            },
        }
    }
}

#[cfg(test)]
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

        bench.devices.A.set_value(a);
        bench.devices.B.set_value(b);

        // add_A_B
        let add_ab_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_ADDSUB_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_mux::<AluArgR>(AluArgR::VALUE_B_ALU_R)
            .apply_bit::<FCalc>()
            .build();
        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, add_ab_cw);

        let values = bench.sources.resolve(&bench.devices);
        assert_eq!(Some(expected_sum), values.main_bus_value); // Check if the ALU calculates the sum of A and B correctly

        bench.devices.broadcast_clock_tick_primary(&values);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_sum, bench.devices.A.get_value(&bench.devices, &bench.sources)); // Check if A has the value
        assert_eq!(b, bench.devices.B.get_value(&bench.devices, &bench.sources)); // Check if B remains unchanged
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.devices, &bench.sources)); // Check if the flags register has the expected flags set after the operation
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

        bench.devices.B.set_value(a);
        bench.devices.C.set_value(b);

        // sub_B_C
        let sub_bc_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_B_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_ADDSUB_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_B_ALU_L)
            .apply_mux::<AluArgR>(AluArgR::VALUE_C_ALU_R)
            .apply_bit::<AluAlt>()
            .apply_bit::<FCalc>()
            .build();
        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, sub_bc_cw);

        let values = bench.sources.resolve(&bench.devices);

        assert_eq!(Some(expected_result), values.main_bus_value); // Check if the ALU calculates the difference of B and C correctly

        bench.devices.broadcast_clock_tick_primary(&values);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_result, bench.devices.B.get_value(&bench.devices, &bench.sources)); // Check if B has the value
        assert_eq!(b, bench.devices.C.get_value(&bench.devices, &bench.sources)); // Check if C remains unchanged
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.devices, &bench.sources)); // Check if the flags register has the expected flags set after the operation
    }

    #[test]
    fn test_alu_adc() {
        let mut bench = TestBench::new();

        bench.devices.A.set_value(24);
        bench.devices.B.set_value(18);

        // adc_A_B
        let adc_ab_cw = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_ADDSUB_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_mux::<AluArgR>(AluArgR::VALUE_B_ALU_R)
            .apply_bit::<FCalc>()
            .apply_bit::<FCarry>()
            .build();
        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, adc_ab_cw);
        let values = bench.sources.resolve(&bench.devices);

        assert_eq!(Some(43), values.main_bus_value); // Check if the ALU calculates the sum of A and B + carry correctly
    }

    #[test]
    fn test_alu_sbb() {
        let mut bench = TestBench::new();

        bench.devices.B.set_value(24);
        bench.devices.C.set_value(18);

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

        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, sbb_bc_cw);
        let values = bench.sources.resolve(&bench.devices);


        assert_eq!(Some(5), values.main_bus_value); // Check if the ALU calculates the difference of B and C correctly
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

        bench.devices.A.set_value(a);
        bench.devices.B.set_value(b);

         // and_A_B
        let and_ab = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_ANDOR_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_mux::<AluArgR>(AluArgR::VALUE_B_ALU_R)
            .apply_bit::<FCalc>()
            .build();

        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, and_ab);
        let values = bench.sources.resolve(&bench.devices);

        assert_eq!(Some(expected_result), values.main_bus_value); // Check if the ALU calculates the AND of A and B correctly

        bench.devices.broadcast_clock_tick_primary(&values);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_result, bench.devices.A.get_value(&bench.devices, &bench.sources)); // Check if A has the value
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.devices, &bench.sources)); // Check if the flags register has the expected flags set after the operation
    }

    #[rstest]
    #[case(0, 1, 1, Flags::EMPTY)]
    #[case(0x7f, 0x01, 0x7f, Flags::EMPTY)]
    #[case(0, 128, 128, Flags::N)]
    #[case(0x80, 0x7f, 0xff, Flags::N)]
    #[case(0, 0, 0, Flags::Z)]
    fn test_alu_or(#[case] a: u8, #[case] b: u8, #[case] expected_result: u8, #[case] expected_flags: Flags) {
        let mut bench = TestBench::new();

        bench.devices.A.set_value(a);
        bench.devices.B.set_value(b);

        // or_A_B
        let or_ab = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_ANDOR_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_mux::<AluArgR>(AluArgR::VALUE_B_ALU_R)
            .apply_bit::<FCalc>()
            .apply_bit::<AluAlt>()
            .build();

        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, or_ab);
        let values = bench.sources.resolve(&bench.devices);

        assert_eq!(Some(expected_result), values.main_bus_value); // Check if the ALU calculates the OR of A and B correctly

        bench.devices.broadcast_clock_tick_primary(&values);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_result, bench.devices.A.get_value(&bench.devices, &bench.sources)); // Check if A has the value
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.devices, &bench.sources)); // Check if the flags register has the expected flags set after the operation
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

        bench.devices.A.set_value(a);
        bench.devices.B.set_value(b);

        // xor_A_B
        let xor_ab = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_XORNOT_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_mux::<AluArgR>(AluArgR::VALUE_B_ALU_R)
            .apply_bit::<FCalc>()
            .build();

        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, xor_ab);
        let values = bench.sources.resolve(&bench.devices);

        assert_eq!(Some(expected_result), values.main_bus_value); // Check if the ALU calculates the XOR of A and B correctly

        bench.devices.broadcast_clock_tick_primary(&values);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_result, bench.devices.A.get_value(&bench.devices, &bench.sources)); // Check if A has the value
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.devices, &bench.sources)); // Check if the flags register has the expected flags set after the operation
    }

    #[rstest]
    #[case(0x80, 0x7f, Flags::EMPTY)]
    #[case(25, 230, Flags::N)]
    #[case(0x00, 0xff, Flags::N)]
    #[case(0xFF, 0, Flags::Z)]
    fn test_alu_not(#[case] a: u8, #[case] expected_result: u8, #[case] expected_flags: Flags) {
        let mut bench = TestBench::new();

        bench.devices.A.set_value(a);

        // not_A
        let not_a = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_XORNOT_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_bit::<FCalc>()
            .apply_bit::<AluAlt>()
            .build();
        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, not_a);
        let values = bench.sources.resolve(&bench.devices);

        assert_eq!(Some(expected_result), values.main_bus_value); // Check if the ALU calculates the NOT of A correctly

        bench.devices.broadcast_clock_tick_primary(&values);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_result, bench.devices.A.get_value(&bench.devices, &bench.sources)); // Check if A has the value
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.devices, &bench.sources)); // Check if the flags register has the expected flags set after the operation
    }

    #[rstest]
    #[case(25, 12, Flags::C)]
    #[case(122, 61, Flags::EMPTY)]
    #[case(128, 64, Flags::EMPTY)]
    #[case(0, 0, Flags::Z)]
    #[case(1, 0, Flags::C | Flags::Z)]
    fn test_alu_shr(#[case] a: u8, #[case] expected_result: u8, #[case] expected_flags: Flags) {
        let mut bench = TestBench::new();

        bench.devices.A.set_value(a);

        // shr_A
        let shr_a = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_SHIFTSWAP_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_bit::<FCalc>()
            .build();

        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, shr_a);
        let values = bench.sources.resolve(&bench.devices);

        assert_eq!(Some(expected_result), values.main_bus_value); // Check if the ALU calculates the SHR of A correctly

        bench.devices.broadcast_clock_tick_primary(&values);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_result, bench.devices.A.get_value(&bench.devices, &bench.sources)); // Check if A has the value
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.devices, &bench.sources)); // Check if the flags register has the expected flags set after the operation
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

        bench.devices.A.set_value(a);

        // swap_A
        let swap_a = ControlWordBuilder::default()
            .apply_mux::<LoadMux>(LoadMux::VALUE_A_LOAD)
            .apply_mux::<OutMux>(OutMux::VALUE_SHIFTSWAP_OUT)
            .apply_mux::<AluArgL>(AluArgL::VALUE_A_ALU_L)
            .apply_bit::<FCalc>()
            .apply_bit::<AluAlt>()
            .build();

        bench.devices.route_word(&mut bench.sources, DEFAULT_CW, swap_a);
        let values = bench.sources.resolve(&bench.devices);

        assert_eq!(Some(expected_result), values.main_bus_value); // Check if the ALU calculates the SWAP of A correctly

        bench.devices.broadcast_clock_tick_primary(&values);
        bench.devices.broadcast_clock_tick_secondary();

        assert_eq!(expected_result, bench.devices.A.get_value(&bench.devices, &bench.sources)); // Check if A has the value
        assert_eq!(expected_flags, bench.devices.F.get_value(&bench.devices, &bench.sources)); // Check if the flags register has the expected flags set after the operation
    }
}

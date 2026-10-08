use turbo_peripherals::Peripherals;
use turbo_bridge::{CommsChannel, UDPCommsChannel};
use std::rc::Rc;
use std::cell::RefCell;

fn main() -> std::io::Result<()> {

    let comms_channels: Vec<Rc<RefCell<UDPCommsChannel>>> = vec![
        Rc::new(RefCell::new(UDPCommsChannel::new(8888))),
        Rc::new(RefCell::new(UDPCommsChannel::new(8889))),
        Rc::new(RefCell::new(UDPCommsChannel::new(8890))),
    ];

    let main_channel = comms_channels[0].clone();

    let peripherals = Peripherals::new(&comms_channels);
    let mut cpu = turbo_core::Cpu::new(peripherals);

    loop {

        let c = main_channel.borrow_mut().recv_char();
        match c {
            'I' => {
                main_channel.borrow().send_response_str("Turbo VM");
            },
            'A' => {
                let addr = main_channel.borrow_mut().recv_int();
                cpu.inject_address_bus_value(addr as u16);
            },
            'a' => {
                let value = cpu.read_address_bus_value();
                main_channel.borrow().send_response_int(value as u32);
            },
            'B' => {
                let value = main_channel.borrow_mut().recv_int();
                cpu.inject_main_bus_value(value as u8);
            },
            'b' => {
                let value = cpu.read_main_bus_value();
                main_channel.borrow().send_response_int(value as u32);
            },
            's' => {
                let value = cpu.read_flags_value();
                main_channel.borrow().send_response_int(value as u32);
            },
            'f' => {
                // is this ever used?
                cpu.clear_injected_values();
            },
            'O' => {
                let _cw = main_channel.borrow_mut().recv_int();
                cpu.clear_injected_values();
                cpu.apply_control_word(turbo_core::DEFAULT_CW);
            },
            'M' => {
                let cw = main_channel.borrow_mut().recv_int();
                cpu.apply_control_word(cw);
            },
            'N' => {
                // NOP
            },
            'c' => {
                cpu.clock_pulse_primary();
            },
            'C' => {
                cpu.clock_pulse_secondary();
            },
            'T' => {
                if let Some(trap) = cpu.clock_tick() {
                    main_channel.borrow().send_response_trap(&trap);
                }
                main_channel.borrow().send_response_str("#T");
            },
            'r' => {
                _ = main_channel.borrow_mut().recv_int(); // client sends control word for IRFetch, discard it
                let value = cpu.read_instruction_register();
                main_channel.borrow().send_response_int(value as u32);
            },
            'R' => {
                let trap = cpu.run_until_trap();
                main_channel.borrow().send_response_trap(&trap);
            },
            'Z' => {
                cpu.reset();
            },
            'W' => {
                let mut channel = main_channel.borrow_mut();
                let cw = channel.recv_int();
                channel.discard_char(); // discard separator
                let mut addr = channel.recv_int();
                channel.discard_char();
                let mut data = channel.recv_int();
                while data < 0x100 {
                    channel.discard_char();
                    cpu.inject_main_bus_value(data as u8);
                    cpu.inject_address_bus_value(addr as u16);
                    cpu.apply_control_word(cw);
                    cpu.clock_tick();
                    addr += 1;
                    data = channel.recv_int();
                }
                channel.send_response_str("#W");
            },
            'Q' => {
                break;
            },
            'E' => {
                let mut channel = main_channel.borrow_mut();
                let chan = channel.recv_int();
                channel.discard_char(); // discard separator
                let port = channel.recv_int();
                drop(channel); // drop immutable borrow to enable set_response_destination to get mutable one
                comms_channels[chan as usize].borrow_mut().set_response_destination(port as u16);
            },
            _ => {
                println!("Received: unknown {}", c);
            }
        }
    }

    Ok(())
}

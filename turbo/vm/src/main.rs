use turbo_peripherals::Peripherals;
use turbo_core::IOMessage;
use turbo_bridge::CommsChannel;
use std::rc::Rc;
use std::cell::RefCell;

fn main() -> std::io::Result<()> {

    let comms_channels: Vec<Rc<RefCell<CommsChannel>>> = vec![
        Rc::new(RefCell::new(CommsChannel::new(8888))),
        Rc::new(RefCell::new(CommsChannel::new(8889))),
        Rc::new(RefCell::new(CommsChannel::new(8890))),
    ];

    let main_channel = comms_channels[0].clone();

    let peripherals = Peripherals::new(&comms_channels);
    let mut cpu = turbo_core::Cpu::new(peripherals);

    loop {

        let c = main_channel.borrow().rx.recv();
        match c {
            'I' => {
                main_channel.borrow().send_response_str("Turbo VM");
            },
            'A' => {
                let addr = main_channel.borrow().recv_int();
                cpu.inject_address_bus_value(addr as u16);
            },
            'a' => {
                let value = cpu.read_address_bus_value();
                main_channel.borrow().send_response_int(value as u32);
            },
            'B' => {
                let value = main_channel.borrow().recv_int();
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
                let _cw = main_channel.borrow().recv_int();
                cpu.clear_injected_values();
                cpu.apply_control_word(turbo_core::DEFAULT_CW);
            },
            'M' => {
                let cw = main_channel.borrow().recv_int();
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
                if let Some(message) = cpu.clock_tick() {
                    main_channel.borrow().send_response_message(&message);
                }
                main_channel.borrow().send_response_str("#T");
            },
            'r' => {
                _ = main_channel.borrow().recv_int(); // client sends control word for IRFetch, discard it
                let value = cpu.read_instruction_register();
                main_channel.borrow().send_response_int(value as u32);
            },
            'R' => {
                loop {
                    let message = cpu.run_until_message().expect("Error while running program");
                    main_channel.borrow().send_response_message(&message);
                    match message {
                        IOMessage::Halt | IOMessage::Brk => {
                            break;
                        },
                        _ => {},
                    }
                }
            },
            'Z' => {
                cpu.reset();
            },
            'W' => {
                let channel = main_channel.borrow();
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
                let channel = main_channel.borrow();
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

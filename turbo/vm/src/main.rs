use turbo_core::IOMessage;
mod comms_channel;
use comms_channel::CommsChannel;

fn main() -> std::io::Result<()> {

    let mut comms_channel = CommsChannel::new(8888);

    let mut cpu = turbo_core::Cpu::new();

    loop {

        let c = comms_channel.rx.recv();
        match c {
            'I' => {
                comms_channel.send_response_str("Turbo VM");
            },
            'A' => {
                let addr = comms_channel.recv_int();
                cpu.inject_address_bus_value(addr as u16);
            },
            'a' => {
                let value = cpu.read_address_bus_value();
                comms_channel.send_response_int(value as u32);
            },
            'B' => {
                let value = comms_channel.recv_int();
                cpu.inject_main_bus_value(value as u8);
            },
            'b' => {
                let value = cpu.read_main_bus_value();
                comms_channel.send_response_int(value as u32);
            },
            's' => {
                let value = cpu.read_flags_value();
                comms_channel.send_response_int(value as u32);
            },
            'f' => {
                // is this ever used?
                cpu.clear_injected_values();
            },
            'O' => {
                let _cw = comms_channel.recv_int();
                cpu.clear_injected_values();
                cpu.apply_control_word(turbo_core::DEFAULT_CW);
            },
            'M' => {
                let cw = comms_channel.recv_int();
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
                // send response immediately, as executing the tick may produce additional output
                comms_channel.send_response_str("#T");
                if let Some(message) = cpu.clock_tick() {
                    comms_channel.send_response_message(&message);
                }
            },
            'r' => {
                _ = comms_channel.recv_int(); // client sends control word for IRFetch, discard it
                let value = cpu.read_instruction_register();
                comms_channel.send_response_int(value as u32);
            },
            'R' => {
                loop {
                    let message = cpu.run_until_message().expect("Error while running program");
                    comms_channel.send_response_message(&message);
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
                let cw = comms_channel.recv_int();
                comms_channel.discard_char(); // discard separator
                let mut addr = comms_channel.recv_int();
                comms_channel.discard_char();
                let mut data = comms_channel.recv_int();
                while data < 0x100 {
                    comms_channel.discard_char();
                    cpu.inject_main_bus_value(data as u8);
                    cpu.inject_address_bus_value(addr as u16);
                    cpu.apply_control_word(cw);
                    cpu.clock_tick();
                    addr += 1;
                    data = comms_channel.recv_int();
                }
                comms_channel.send_response_str("#W");
            },
            'Q' => {
                break;
            },
            'E' => {
                let _chan = comms_channel.recv_int();
                comms_channel.discard_char(); // discard separator
                let port = comms_channel.recv_int();
                comms_channel.set_response_destination(port as u16);
            },
            _ => {
                println!("Received: unknown {}", c);
            }
        }
    }

    Ok(())
}

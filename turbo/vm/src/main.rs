use std::{net::{SocketAddr, UdpSocket}, sync::mpsc::{self, Receiver, Sender}, thread};

use turbo_core::IOMessage;

const BUFFER_SIZE: usize = 1024;

fn main() -> std::io::Result<()> {

    let socket = UdpSocket::bind("127.0.0.1:8888").expect("Couldn't bind to address");

    let (tx, rx): (Sender<char>, Receiver<char>) = mpsc::channel();

    let r_socket = socket.try_clone().expect("Couldn't clone socket");

    let _receiver = thread::spawn(move || {
        let mut buf = [0; BUFFER_SIZE];

        loop {
            let (amt, _src) = r_socket.recv_from(&mut buf).expect("Couldn't receive");
            for byte in &buf[..amt] {
                tx.send(*byte as char).expect("Couldn't send to main");
            }
        }
    });

    let mut cpu = turbo_core::Cpu::new();

    let mut ch0_dest: SocketAddr = "127.0.0.1:8888".parse().expect("Invalid address");

    loop {

        let c = rx.recv().expect("Couldn't receive from channel");
        match c {
            'I' => {
                println!("Received: I command");
                socket.send_to(b"Turbo VM", ch0_dest).expect("Couldn't send response");
            },
            'A' => {
                let addr = recv_int(&rx);
                cpu.inject_address_bus_value(addr as u16);
                println!("Received: A command with address 0x{:04X}", addr);
            },
            'a' => {
                let value = cpu.read_address_bus_value();
                let response = format!("{:04X}", value);
                socket.send_to(response.as_bytes(), ch0_dest).expect("Couldn't send response");
            },
            'B' => {
                let value = recv_int(&rx);
                println!("Received: B command with value 0x{:02X}", value);
                cpu.inject_main_bus_value(value as u8);
            },
            'b' => {
                let value = cpu.read_main_bus_value();
                let response = format!("{:02X}", value);
                socket.send_to(response.as_bytes(), ch0_dest).expect("Couldn't send response");
            },
            's' => {
                let value = cpu.read_flags_value();
                let response = format!("{:02X}", value);
                socket.send_to(response.as_bytes(), ch0_dest).expect("Couldn't send response");
            },
            'f' => {
                // is this ever used?
                cpu.clear_injected_values();
            },
            'O' => {
                let _cw = recv_int(&rx);
                println!("Received: O command with control word 0x{:08X}", _cw);
                cpu.clear_injected_values();
                cpu.apply_control_word(turbo_core::DEFAULT_CW);
            },
            'M' => {
                let cw = recv_int(&rx);
                println!("Received: M command with control word 0x{:08X}", cw);
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
                println!("Received: T command, executing clock tick\n");
                socket.send_to(b"#T", ch0_dest).expect("Couldn't send response");
                if let Some(message) = cpu.clock_tick() {
                    send_response_message(&socket, &ch0_dest, &message);
                }
            },
            'r' => {
                _ = recv_int(&rx); // client sends control word for IRFetch, discard it
                let value = cpu.read_instruction_register();
                let response = format!("{:02X}", value);
                socket.send_to(response.as_bytes(), ch0_dest).expect("Couldn't send response");
            },
            'R' => {
                println!("Received: R command, running a program until message is produced");
                loop {
                    let message = cpu.run_until_message().expect("Error while running program");
                    send_response_message(&socket, &ch0_dest, &message);
                    match message {
                        IOMessage::Halt | IOMessage::Brk => {
                            println!("Produced break message");
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
                let cw = recv_int(&rx);
                let mut addr = recv_int(&rx);
                println!("Received: W command with control word 0x{:08X} and address 0x{:04X}", cw, addr);
                let mut data = recv_int(&rx);
                while data < 0x100 {
                    cpu.inject_main_bus_value(data as u8);
                    cpu.inject_address_bus_value(addr as u16);
                    cpu.apply_control_word(cw);
                    cpu.clock_tick();
                    addr += 1;
                    data = recv_int(&rx);
                }
                socket.send_to(b"#W", ch0_dest).expect("Couldn't send response");
            },
            'Q' => {
                println!("Received 'Q', exiting.");
                break;
            },
            'E' => {
                let _chan = recv_int(&rx);
                let _port = recv_int(&rx);
                println!("Received: E command with channel {} and port {}", _chan, _port);
                ch0_dest = format!("127.0.0.1:{}", _port).parse().expect("Invalid address");
            },
            _ => {
                println!("Received: unknown {}", c);
            }
        }
    }

    Ok(())
}

fn recv_int(rx: &Receiver<char>) -> u32 {
    let mut digits: Vec<char> = Vec::new();

    loop {
        let c = rx.recv().expect("Couldn't receive from channel");
        if c.is_digit(16) {
            digits.push(c);
        } else {
            break;
        }
    }

    u32::from_str_radix(&digits.iter().collect::<String>(), 16).expect("Failed to parse hex string")
}

fn send_response_message(socket: &UdpSocket, dest: &SocketAddr, message: &IOMessage) {
    let response = message.to_string();
    socket.send_to(response.as_bytes(), dest).expect("Couldn't send response");
}

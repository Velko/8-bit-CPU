use std::{collections::HashMap, net::{SocketAddr, UdpSocket}, sync::mpsc::{self, Receiver, Sender}, thread};

use turbo_core::IOMessage;

const BUFFER_SIZE: usize = 1024;

struct CommsChannel {
    socket: UdpSocket,
    rx: Receiver<char>,
    response_destination: Option<SocketAddr>,
}

impl CommsChannel {
    pub fn new(port: u16) -> Self {
        let socket = UdpSocket::bind(format!("127.0.0.1:{}", port)).expect("Couldn't bind to address");
        let (tx, rx): (Sender<char>, Receiver<char>) = mpsc::channel();

        let r_socket = socket.try_clone().expect("Couldn't clone socket");
        thread::spawn(move || {
            let mut buf = [0; BUFFER_SIZE];

            loop {
                let (amt, _src) = r_socket.recv_from(&mut buf).expect("Couldn't receive");
                for byte in &buf[..amt] {
                    tx.send(*byte as char).expect("Couldn't send to main");
                }
            }
        });

        Self {
            socket,
            rx,
            response_destination: None,
        }
    }

    fn recv_int(&self) -> u32 {
        let mut digits: Vec<char> = Vec::new();

        loop {
            let c = self.rx.recv().expect("Couldn't receive from channel");
            if c.is_digit(16) {
                digits.push(c);
            } else {
                break;
            }
        }

        u32::from_str_radix(&digits.iter().collect::<String>(), 16).expect("Failed to parse hex string")
    }

    fn send_response_message(&self, message: &IOMessage) {
        let response = message.to_string();
        let dest = self.response_destination.as_ref().expect("Response destination not configured");
        self.socket.send_to(response.as_bytes(), dest).expect("Couldn't send response");
    }

    fn send_response_int(&self, value: u32) {
        let response = format!("{:X}", value);
        let dest = self.response_destination.as_ref().expect("Response destination not configured");
        self.socket.send_to(response.as_bytes(), dest).expect("Couldn't send response");
    }

    fn send_response_str(&self, value: &str) {
        let dest = self.response_destination.as_ref().expect("Response destination not configured");
        self.socket.send_to(value.as_bytes(), dest).expect("Couldn't send response");
    }

    fn set_response_destination(&mut self, port: u16) {
        let dest = format!("127.0.0.1:{}", port).parse().expect("Invalid address");
        self.response_destination = Some(dest);
    }

}

fn main() -> std::io::Result<()> {

    let mut comms_channel = CommsChannel::new(8888);

    let mut cpu = turbo_core::Cpu::new();

    loop {

        let c = comms_channel.rx.recv().expect("Couldn't receive from channel");
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
                let mut addr = comms_channel.recv_int();
                let mut data = comms_channel.recv_int();
                while data < 0x100 {
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

use std::{net::{SocketAddr, UdpSocket}, sync::mpsc::{self, Receiver, Sender}, thread};

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
                todo!("Set Address Bus");
            },
            'a' => {
                todo!("Read Address Bus");
            },
            'B' => {
                cpu.inject_main_bus_value(recv_int(&rx) as u8);
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
                //todo!("Release Buses");
            },
            'O' => {
                let _cw = recv_int(&rx);
                println!("Received: O command with control word 0x{:08X}", _cw);
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
                println!("Received: T command, executing clock tick");
                socket.send_to(b"#T", ch0_dest).expect("Couldn't send response");
                cpu.clock_tick();
            },
            'r' => {
                todo!("Read current Opcode from IR");
            },
            'R' => {
                todo!("Run program until event occurs");
            },
            'Z' => {
                cpu.reset();
            },
            'W' => {
                todo!("Write to memory");
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

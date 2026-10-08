use std::{net::{SocketAddr, UdpSocket}, str, sync::mpsc::{self, Receiver, Sender}, thread};
use turbo_core::TrapReason;

use crate::{PeekableReceiver, latest_slot::LatestSlot};

const BUFFER_SIZE: usize = 1024;

pub trait CommsChannel {
    fn send_response_str(&self, value: &str);
    fn send_response_byte(&self, value: u8);
    fn send_output_msg(&self, payload: &str, port: u8);
    fn recv_char(&mut self) -> char;
    fn is_input_available(&mut self) -> bool;
    fn recv_byte(&mut self) -> u8 {
        self.recv_char() as u8
    }
}

pub struct UDPCommsChannel {
    socket: UdpSocket,
    rx: PeekableReceiver<char>,
    response_destination: Option<SocketAddr>,
    latest_addr: LatestSlot<SocketAddr>,
}

impl UDPCommsChannel {
    pub fn new(port: u16) -> Self {
        let socket = UdpSocket::bind(format!("127.0.0.1:{}", port)).expect("Couldn't bind to address");
        let (tx, rx): (Sender<char>, Receiver<char>) = mpsc::channel();
        let latest_addr: LatestSlot<SocketAddr> = LatestSlot::new();

        let r_socket = socket.try_clone().expect("Couldn't clone socket");
        let r_addr = latest_addr.clone();
        thread::spawn(move || {
            let mut buf = [0; BUFFER_SIZE];

            loop {
                let (amt, src) = r_socket.recv_from(&mut buf).expect("Couldn't receive");
                r_addr.send(src);
                for byte in &buf[..amt] {
                    tx.send(*byte as char).expect("Couldn't send to main");
                }
            }
        });

        Self {
            socket,
            rx: PeekableReceiver::new(rx),
            response_destination: None,
            latest_addr,
        }
    }

    pub fn set_response_destination(&mut self, port: u16) {
        let dest = format!("127.0.0.1:{}", port).parse().expect("Invalid address");
        self.response_destination = Some(dest);
    }

    pub fn recv_int(&mut self) -> u32 {
        let mut digits: Vec<char> = Vec::new();

        loop {
            let c = self.rx.recv();
            if c.is_digit(16) {
                digits.push(c);
            } else {
                self.rx.unrecv(c);
                break;
            }
        }

        u32::from_str_radix(&digits.iter().collect::<String>(), 16).expect("Failed to parse hex string")
    }

    pub fn discard_char(&mut self) {
        let _ = self.rx.recv();
    }

    pub fn send_response_trap(&self, trap: &TrapReason) {
        let response = match trap {
            TrapReason::Halt => "#HLT\r\n",
            TrapReason::Brk => "#BRK\r\n",
        };
        self.send_to_dest(response.as_bytes());
    }

    pub fn send_response_int(&self, value: u32) {
        let response = format!("{:X}", value);
        self.send_to_dest(response.as_bytes());
    }


    fn send_to_dest(&self, data: &[u8]) {
        if let Some(dest) = self.response_destination.or_else(|| self.latest_addr.read()) {
            self.socket.send_to(data, dest).expect("Couldn't send response");
        }
    }

    fn escape_newline(s: &str) -> String {
        s.replace("\n", "\\n").replace("\r", "\\r")
    }
}

impl CommsChannel for UDPCommsChannel {
    fn send_response_str(&self, value: &str) {
        self.send_to_dest(value.as_bytes());
    }

    fn send_response_byte(&self, value: u8) {
        self.send_to_dest(&[value]);
    }

    fn send_output_msg(&self, payload: &str, port: u8) {
        let escaped_msg = Self::escape_newline(&format!("#OUT#{:X}#{}", port, payload));
        self.send_response_str(&escaped_msg);
    }

    fn recv_char(&mut self) -> char {
        self.rx.recv()
    }

    fn is_input_available(&mut self) -> bool {
        self.rx.peek().is_some()
    }
}

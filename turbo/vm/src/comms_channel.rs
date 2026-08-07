use std::{cell::Cell, net::{SocketAddr, UdpSocket}, str, sync::mpsc::{self, Receiver, Sender}, thread};
use turbo_core::IOMessage;

const BUFFER_SIZE: usize = 1024;

pub struct CommsChannel {
    socket: UdpSocket,
    pub rx: PeekableReceiver<char>,
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
            rx: PeekableReceiver::new(rx),
            response_destination: None,
        }
    }

    pub fn recv_int(&self) -> u32 {
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

    pub fn discard_char(&self) {
        let _ = self.rx.recv();
    }

    pub fn send_response_message(&self, message: &IOMessage) {
        let response = message.to_string();
        let dest = self.response_destination.as_ref().expect("Response destination not configured");
        self.socket.send_to(response.as_bytes(), dest).expect("Couldn't send response");
    }

    pub fn send_response_int(&self, value: u32) {
        let response = format!("{:X}", value);
        let dest = self.response_destination.as_ref().expect("Response destination not configured");
        self.socket.send_to(response.as_bytes(), dest).expect("Couldn't send response");
    }

    pub fn send_response_str(&self, value: &str) {
        let dest = self.response_destination.as_ref().expect("Response destination not configured");
        self.socket.send_to(value.as_bytes(), dest).expect("Couldn't send response");
    }

    pub fn set_response_destination(&mut self, port: u16) {
        let dest = format!("127.0.0.1:{}", port).parse().expect("Invalid address");
        self.response_destination = Some(dest);
    }

}

pub struct PeekableReceiver<T> {
    receiver: Receiver<T>,
    peeked: Cell<Option<T>>,
}

impl<T> PeekableReceiver<T> where T: Copy {
    pub fn new(receiver: Receiver<T>) -> Self {
        Self {
            receiver,
            peeked: Cell::new(None),
        }
    }

    pub fn peek(&self) -> Option<T> {
        if self.peeked.get().is_none() {
            match self.receiver.try_recv() {
                Ok(value) => self.peeked.set(Some(value)),
                Err(mpsc::TryRecvError::Empty) => return None,
                Err(mpsc::TryRecvError::Disconnected) => panic!("Couldn't receive from channel"),
            }
        }
        self.peeked.get()
    }

    pub fn recv(&self) -> T {
        if let Some(value) = self.peeked.get() {
            self.peeked.set(None);
            value
        } else {
            self.receiver.recv().expect("Couldn't receive from channel")
        }
    }

    pub fn unrecv(&self, value: T) {
        if self.peeked.get().is_some() {
            panic!("Peeked value already exists");
        }
        self.peeked.set(Some(value));
    }
}

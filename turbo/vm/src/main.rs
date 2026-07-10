use std::{io::{BufReader, ErrorKind::QuotaExceeded}, net::{SocketAddr, UdpSocket}, sync::mpsc::{self, Receiver, SendError, Sender}, thread};

const BUFFER_SIZE: usize = 1024;

fn main() -> std::io::Result<()> {

    let socket = UdpSocket::bind("127.0.0.1:8888").expect("Couldn't bind to address");

    let (tx, rx): (Sender<char>, Receiver<char>) = mpsc::channel();

    let r_socket = socket.try_clone().expect("Couldn't clone socket");

    let _receiver = thread::spawn(move || {
        let mut buf = [0; BUFFER_SIZE];

        loop {
            let (amt, src) = r_socket.recv_from(&mut buf).expect("Couldn't receive");
            for byte in &buf[..amt] {
                tx.send(*byte as char).expect("Couldn't send to main");
            }
        }
    });

    let mut ch0_dest: SocketAddr = "127.0.0.1:8888".parse().expect("Invalid address");

    loop {

        let c = rx.recv().expect("Couldn't receive from channel");
        match c {
            'Q' => {
                println!("Received 'Q', exiting.");
                break;
            },
            'I' => {
                socket.send_to(b"Turbo VM", ch0_dest).expect("Couldn't send response");
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

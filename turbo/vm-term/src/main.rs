use std::cell::RefCell;
use std::io::{Read, stdout, Write, stdin};
use termion::input::TermRead;
use termion::raw::IntoRawMode;
use std::rc::Rc;

use turbo_bridge::{CommsChannel, PeekableReceiver};
use turbo_peripherals::Peripherals;
use turbo_core::{Cpu, TrapReason};

#[derive(PartialEq)]
enum ChannelId {
    Debug,
    LCD,
    UART,
}

struct LocalCommsChannel {
    id: ChannelId,
    rx: PeekableReceiver<char>,
    tx: std::sync::mpsc::Sender<char>,
}

impl LocalCommsChannel {
    pub fn new(id: ChannelId) -> Self {
        let (tx, rx_c) = std::sync::mpsc::channel();
        let channel = Self {
            id,
            rx: PeekableReceiver::new(rx_c),
            tx,
        };

        if channel.id == ChannelId::UART {
            channel.start_terminal_reader();
        }

        channel
    }

    fn start_terminal_reader(&self) {
        let tx = self.tx.clone();
        std::thread::spawn(move || {
            let stdin = stdin();
            for key in stdin.keys() {
                if let Ok(k) = key {
                    let chars = match k {
                        termion::event::Key::Up => "\x1b[A",
                        termion::event::Key::Down => "\x1b[B",
                        termion::event::Key::Left => "\x1b[D",
                        termion::event::Key::Right => "\x1b[C",
                        _ => "",
                    };
                    for c in chars.chars() {
                        tx.send(c).expect("Failed to send char to channel");
                    }
                }
            }
        });
    }
}


impl CommsChannel for LocalCommsChannel {
    fn send_response_str(&self, value: &str) {
        stdout().write_all(value.as_bytes()).expect("Failed to write to stdout");
        stdout().flush().expect("Failed to flush stdout");
    }

    fn send_response_byte(&self, value: u8) {
        stdout().write_all(&[value]).expect("Failed to write to stdout");
        stdout().flush().expect("Failed to flush stdout");
    }

    fn send_output_msg(&self, payload: &str, _port: u8) {
        self.send_response_str(payload);
    }

    fn recv_char(&self) -> char {
        self.rx.recv()
    }

    fn is_input_available(&self) -> bool {
        self.rx.peek().is_some()
    }
}


fn main() -> std::io::Result<()> {
    // open file specified by command line arguments
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: {} <file>", args[0]);
        std::process::exit(1);
    }
    let filename = &args[1];

    let mut file = std::fs::File::open(filename)?;
    let mut buf = Vec::new();
    file.read_to_end(&mut buf)?;

    let _raw_stdio = stdout().into_raw_mode().unwrap();

    let comms_channels: Vec<Rc<RefCell<LocalCommsChannel>>> = vec![
        Rc::new(RefCell::new(LocalCommsChannel::new(ChannelId::Debug))),
        Rc::new(RefCell::new(LocalCommsChannel::new(ChannelId::LCD))),
        Rc::new(RefCell::new(LocalCommsChannel::new(ChannelId::UART))),
    ];

    let peripherals = Peripherals::new(&comms_channels);
    let mut cpu = Cpu::new(peripherals);

    cpu.write_memory(0, &buf);
    cpu.reset();

    let trap = cpu.run_until_trap();

    match trap {
        TrapReason::Halt => println!("# Halted"),
        TrapReason::Brk => println!("# Break"),
    }

    Ok(())
}

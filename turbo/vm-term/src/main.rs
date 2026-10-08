use std::cell::RefCell;
use std::io::{Read, stdout, Write, stdin};
use termion::input::TermRead;
use termion::raw::IntoRawMode;
use std::rc::Rc;

use turbo_bridge::{CommsChannel, PeekableReceiver};
use turbo_peripherals::Peripherals;
use turbo_core::{Cpu, TrapReason};

enum LocalCommsChannel {
    Debug,
    LCD,
    UART {
        rx: PeekableReceiver<char>,
    },
}

impl LocalCommsChannel {
    pub fn new_uart() -> Self {
        let (tx, rx_c) = std::sync::mpsc::channel();
        let channel = Self::UART {
            rx: PeekableReceiver::new(rx_c),
        };
        channel.start_terminal_reader(tx);
        channel
    }

    fn start_terminal_reader(&self, tx: std::sync::mpsc::Sender<char>) {
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

    fn recv_char(&mut self) -> char {
        if let Self::UART { rx, .. } = self {
            rx.recv()
        } else {
            0xFF as char
        }
    }

    fn is_input_available(&mut self) -> bool {
        if let Self::UART { rx, .. } = self {
            rx.peek().is_value()
        } else {
            false
        }
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

    let _raw_stdio = stdout().into_raw_mode().ok();

    let comms_channels: Vec<Rc<RefCell<LocalCommsChannel>>> = vec![
        Rc::new(RefCell::new(LocalCommsChannel::Debug)),
        Rc::new(RefCell::new(LocalCommsChannel::LCD)),
        Rc::new(RefCell::new(LocalCommsChannel::new_uart())),
    ];

    let peripherals = Peripherals::new(&comms_channels);
    let mut cpu = Cpu::new(peripherals);

    cpu.write_memory(0, &buf);
    cpu.reset();

    let trap = cpu.run_until_trap();

    match trap {
        TrapReason::Halt => eprintln!("# Halted"),
        TrapReason::Brk => eprintln!("# Break"),
    }

    Ok(())
}

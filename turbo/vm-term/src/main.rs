use std::cell::RefCell;
use std::io::{Read, stdout, Write};
use std::rc::Rc;

use turbo_bridge::CommsChannel;
use turbo_peripherals::Peripherals;
use turbo_core::{Cpu, TrapReason};

struct LocalCommsChannel;


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
        0xFF as char
    }

    fn is_input_available(&self) -> bool {
        false
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


    let comms_channels: Vec<Rc<RefCell<LocalCommsChannel>>> = vec![
        Rc::new(RefCell::new(LocalCommsChannel)),
        Rc::new(RefCell::new(LocalCommsChannel)),
        Rc::new(RefCell::new(LocalCommsChannel)),
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

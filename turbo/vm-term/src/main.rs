use std::cell::RefCell;
use std::io::Read;
use std::rc::Rc;

use turbo_bridge::UDPCommsChannel;
use turbo_peripherals::Peripherals;
use turbo_core::Cpu;

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


    let comms_channels: Vec<Rc<RefCell<UDPCommsChannel>>> = vec![
        Rc::new(RefCell::new(UDPCommsChannel::new(8888))),
        Rc::new(RefCell::new(UDPCommsChannel::new(8889))),
        Rc::new(RefCell::new(UDPCommsChannel::new(8890))),
    ];

    let peripherals = Peripherals::new(&comms_channels);
    let mut cpu = Cpu::new(peripherals);

    cpu.write_memory(0, &buf);

    let trap = cpu.run_until_trap();

    println!("Trap reason: {:?}", trap);

    Ok(())
}

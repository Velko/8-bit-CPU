mod pin_config;
use std::collections::HashMap;
use std::rc::Rc;
use std::cell::RefCell;

pub fn load_pins(file_path: &str) -> pin_config::PinConfig {

    let cfg = pin_config::PinConfig::from_file(file_path);

    let mut muxes: HashMap<String, Rc<Mux>> = HashMap::new();

    let mut dispatcher = ControlWordDispatcher::new(0x07ff58ff);


    for mux_cfg in &cfg.muxes {
        let mux = Mux {
            name: mux_cfg.name.clone(),
        };
        let mux_rc = Rc::new(mux);
        dispatcher.subscribe(&mux_cfg.pins, mux_rc.clone());
        muxes.insert(mux_cfg.name.clone(), mux_rc);
    }

    dispatcher.dispatch(0x07ff0915); // add_B_C

    cfg
}


pub trait BitChangeSubscriber {
    fn on_change(&self, value: usize);
}

pub struct ControlWordDispatcher {
    current: RefCell<u32>,
    subscribers: Vec<SubscriberEntry>,
}

struct SubscriberEntry {
    subscriber: Rc<dyn BitChangeSubscriber>,
    bits: Vec<usize>,
    mask: u32,
}

impl ControlWordDispatcher {
    pub fn new(default: u32) -> Self {
        ControlWordDispatcher {
            current: RefCell::new(default),
            subscribers: Vec::new(),
        }
    }

    pub fn dispatch(&self, control_word: u32) {

        for entry in &self.subscribers {
            // first quickly check if any of the bits in the mask have changed
            let old_value = *self.current.borrow() & entry.mask;
            let new_value = control_word & entry.mask;
            if old_value != new_value {
                // and only if it did, translate the bits into a value from subscriber's perspective
                let mut flat_value = 0;
                for (i, &bit) in entry.bits.iter().enumerate() {
                    if (new_value & (1 << bit)) != 0 {
                        flat_value |= 1 << i;
                    }
                }
                entry.subscriber.on_change(flat_value);
            }
        }

        *self.current.borrow_mut() = control_word;
    }

    pub fn subscribe(&mut self, bits: &[usize], subscriber: Rc<dyn BitChangeSubscriber>) {
        let mut mask = 0u32;
        for &bit in bits {
            assert!(bit < 32, "Bit index out of range (0-31)");
            mask |= 1 << bit;
        }
        self.subscribers.push(SubscriberEntry { subscriber, bits: bits.to_vec(), mask });
    }
}

struct Mux {
    name: String,
}

impl BitChangeSubscriber for Mux {
    fn on_change(&self, value: usize) {
        println!("Mux {} changed to value: {}", self.name, value);
    }
}

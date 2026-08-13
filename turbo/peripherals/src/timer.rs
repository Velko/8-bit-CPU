use std::sync::Arc;
use std::sync::atomic::AtomicU8;
use std::sync::atomic::Ordering;
use std::thread;
use std::time::Duration;
pub struct Timer {
    counter: Arc<AtomicU8>,
}

impl Timer {
    pub fn new() -> Self {
        let timer = Self {
            counter: Arc::new(AtomicU8::new(0)),
        };
        let counter = timer.counter.clone();
        thread::spawn({
            move || {
                loop {
                    thread::sleep(Duration::from_millis(10));
                    counter.fetch_update(Ordering::SeqCst, Ordering::SeqCst, |x| {
                        if x > 0 {
                            Some(x - 1)
                        } else {
                            None
                        }
                    }).ok();
                }
            }
        });

        timer
    }

    pub fn set_counter(&mut self, value: u8) {
        self.counter.store(value, Ordering::SeqCst);
    }

    pub fn get_counter(&self) -> u8 {
        self.counter.load(Ordering::SeqCst)
    }
}

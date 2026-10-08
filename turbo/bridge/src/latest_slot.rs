use std::sync::{Arc, Mutex};

pub struct LatestSlot<T> {
    inner: Arc<Mutex<Option<T>>>,
}

impl<T: Clone> LatestSlot<T> {
    pub fn new() -> Self {
        Self {
            inner: Arc::new(Mutex::new(None)),
        }
    }

    /// Overwrites the slot with a new item.
    pub fn send(&self, item: T) {
        let mut guard = self.inner.lock().unwrap();
        *guard = Some(item);
    }

    /// Instantly returns a clone of the latest item, or None if it's empty.
    /// Does not block and does not consume the item.
    pub fn read(&self) -> Option<T> {
        let guard = self.inner.lock().unwrap();
        guard.clone() // Clones the Option<T> inside the mutex
    }
}

// Implement Clone so handles can be passed to multiple threads
impl<T> Clone for LatestSlot<T> {
    fn clone(&self) -> Self {
        Self {
            inner: Arc::clone(&self.inner),
        }
    }
}

use std::{cell::Cell, sync::mpsc::{self, Receiver}};

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

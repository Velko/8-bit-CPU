use std::{sync::mpsc::{self, Receiver}};

pub struct PeekableReceiver<T> {
    receiver: Receiver<T>,
    peeked: Option<T>,
}

impl<T> PeekableReceiver<T> where T: Copy {
    pub fn new(receiver: Receiver<T>) -> Self {
        Self {
            receiver,
            peeked: None,
        }
    }

    pub fn peek(&mut self) -> Option<T> {
        if self.peeked.is_none() {
            match self.receiver.try_recv() {
                Ok(value) => self.peeked = Some(value),
                Err(mpsc::TryRecvError::Empty) => return None,
                Err(mpsc::TryRecvError::Disconnected) => panic!("Couldn't receive from channel"),
            }
        }
        self.peeked
    }

    pub fn recv(&mut self) -> T {
        if let Some(value) = self.peeked {
            self.peeked = None;
            value
        } else {
            self.receiver.recv().expect("Couldn't receive from channel")
        }
    }

    pub fn unrecv(&mut self, value: T) {
        if self.peeked.is_some() {
            panic!("Peeked value already exists");
        }
        self.peeked = Some(value);
    }
}

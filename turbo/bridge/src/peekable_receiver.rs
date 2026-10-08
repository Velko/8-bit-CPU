use std::sync::mpsc::{self, Receiver};

pub struct PeekableReceiver<T> {
    receiver: Receiver<T>,
    peeked: Option<T>,
}

#[derive(Debug, PartialEq)]
pub enum PeekResult<T> {
    Value(T),
    Empty,
    Disconnected,
}

impl<T> PeekResult<T> {
    pub fn is_value(&self) -> bool {
        matches!(self, PeekResult::Value(_))
    }
}

impl<T> PeekableReceiver<T> where T: Copy {
    pub fn new(receiver: Receiver<T>) -> Self {
        Self {
            receiver,
            peeked: None,
        }
    }

    pub fn peek(&mut self) -> PeekResult<T> {
        if let Some(value) = self.peeked {
            return PeekResult::Value(value);
        } else {
            match self.receiver.try_recv() {
                Ok(value) => {
                    self.peeked = Some(value);
                    return PeekResult::Value(value);
                }
                Err(mpsc::TryRecvError::Empty) => return PeekResult::Empty,
                Err(mpsc::TryRecvError::Disconnected) => return PeekResult::Disconnected,
            }
        }
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

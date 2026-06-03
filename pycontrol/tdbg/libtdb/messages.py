#!/usr/bin/env python3

from textual.message import Message
from textual.widget import Widget

class ToggleBreakpoint(Message):
    def __init__(self, filename: str, line: int):
        super().__init__()
        self.filename = filename
        self.line = line

#!/usr/bin/env python3

from typing import Any
from textual.app import ComposeResult
from textual.widgets import TabPane
from .debugview import DebugView


class DebugTab(TabPane):
    def __init__(self, filename: str, common_prefix: str = "", **kwargs: Any) -> None:
        super().__init__(filename[len(common_prefix):], **kwargs)
        self.filename = filename
        with open(filename, "r") as f:
            content = f.read()
        self.debug_view = DebugView(content)
        self.common_prefix = common_prefix

    def compose(self) -> ComposeResult:
        yield self.debug_view

    def on_mount(self) -> None:
        self.debug_view.current_line = 10  # Example: set the current line to 10
        self.debug_view.debug_gutter.filename = self.filename

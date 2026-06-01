#!/usr/bin/env python3

import logging
from typing import Any

from textual.containers import Horizontal
from textual.app import ComposeResult

from .gutter import Gutter
from .debugtextarea import DebugTextArea
from .messages import ToggleBreakpoint



class DebugView(Horizontal):
    code_editor: DebugTextArea
    debug_gutter: Gutter
    def __init__(self, content: str, **kwargs: Any) -> None:
        super().__init__(**kwargs)
        self.breakpoints: set[int] = set()
        self.current_line: int | None = 10

        self.debug_gutter = Gutter()
        self.code_editor = DebugTextArea(content)
        self._sync_views()

    def compose(self) -> ComposeResult:
        yield self.debug_gutter
        yield self.code_editor

    def on_mount(self) -> None:
        self.watch(self.code_editor, "scroll_y", self._sync_editor_scroll, init=True)
        self.debug_gutter.line_count = self.code_editor.document.line_count
        self.debug_gutter.refresh()

    def _sync_editor_scroll(self, _old_value: float, new_value: float) -> None:
        self.scroll_dy = int(new_value)
        self._sync_views()

    def on_toggle_breakpoint(self, message: ToggleBreakpoint) -> None:
        line = message.line
        if line in self.breakpoints:
            self.breakpoints.remove(line)
            logging.getLogger().info(f"Removed breakpoint at line {line+1}")
        else:
            self.breakpoints.add(line)
            logging.getLogger().info(f"Added breakpoint at line {line+1}")

        self._sync_views()

    def _sync_views(self) -> None:
        self.debug_gutter.breakpoints = self.breakpoints
        self.code_editor.breakpoints = self.breakpoints

        self.debug_gutter.current_line = self.current_line
        self.code_editor.current_line = self.current_line

        self.debug_gutter.line_count = self.code_editor.document.line_count
        self.debug_gutter.scroll_dy = int(self.code_editor.scroll_y)

        self.debug_gutter.refresh()
        self.code_editor.refresh()


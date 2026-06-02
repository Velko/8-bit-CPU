#!/usr/bin/env python3

from textual.widget import Widget
from textual.events import MouseDown
from rich.text import Text
from .messages import ToggleBreakpoint

class Gutter(Widget):
    breakpoints: set[int] = set()
    current_line: int | None = None
    line_count: int = 0
    scroll_dy: int = 0
    filename: str = ""

    def __init__(self) -> None:
        super().__init__()

    def render(self) -> Text:
        text = Text()

        for i in range(self.scroll_dy, self.scroll_dy + self.size.height):
            if i >= self.line_count:
                break

            if i == self.current_line:
                marker = ">"#"▶"
            elif i in self.breakpoints:
                marker = "●"
            else:
                marker = " "

            line_no = f"{i+1:>3}"
            text.append(f"{marker}{line_no}\n")

        return text

    def on_mouse_down(self, event: MouseDown) -> None:
        line = self.scroll_dy + event.y
        if 0 <= line < self.line_count:
            self.post_message(ToggleBreakpoint(self, self.filename, int(line)))

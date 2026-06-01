#!/usr/bin/env python3

from typing import Any
from textual.widgets import TextArea
from textual.strip import Strip
from rich.style import Style
from rich.segment import Segment

class DebugTextArea(TextArea):
    DEFAULT_CSS = """
    DebugTextArea {
        border: none;
        padding: 0;

        &:focus {
            border: none;
        }
    }
    """

    def __init__(self, text: str, *args: Any, **kwargs: Any) -> None:
        super().__init__(text, theme="css", show_line_numbers=False, read_only=True, *args, **kwargs)

    current_line: int | None = None
    breakpoints: set[int] = set()

    def render_line(self, y: int) -> Strip:
        strip = super().render_line(y)
        y_offset = y + self.scroll_offset.y
        try:
            line_index, _section_offset = self.wrapped_document._offset_to_line_info[y_offset]
        except IndexError:
            return strip

        style = None
        if line_index == self.current_line:
            style = Style(bgcolor="bright_blue")
        elif line_index in self.breakpoints:
            style = Style(bgcolor="dark_red", color="white")

        if style is None:
            return strip

        return Strip(
            Segment.apply_style(strip._segments, post_style=style),
            strip.cell_length,
        )

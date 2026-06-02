from rich.table import Table
from textual.app import App, ComposeResult
from textual.widgets import Static
from typing import Any

class RegistersView(Static):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)
        self.table = Table("Register", "Value")

    def on_mount(self) -> None:
        self.update(self.table)

    def update_table(self, registers: dict[str, str]) -> None:
        self.table = Table("Register", "Value")
        for reg, val in registers.items():
            self.table.add_row(reg, val)
        self.update(self.table)

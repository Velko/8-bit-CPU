from rich.table import Table
from textual.app import App, ComposeResult
from textual.widgets import Static
from typing import Any

class RegistersView(Static):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)
        self.table = Table("Register", "Value")
        self.old_values: dict[str, str] = {}

    def on_mount(self) -> None:
        self.update(self.table)

    def update_table(self, registers: dict[str, str]) -> None:
        if len(self.old_values) == 0:
            self.old_values = registers
        self.table = Table("Register", "Value")
        for reg, val in registers.items():
            old_val = self.old_values.get(reg)
            if old_val is not None and old_val != val:
                self.table.add_row(reg, f"[bold dark_red]{val}[/bold dark_red]")
            else:
                self.table.add_row(reg, val)
            self.old_values[reg] = val
        self.update(self.table)

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

    def reset_old_values(self) -> None:
        self.old_values = {}

    def update_table(self, registers: dict[str, str]) -> None:
        # only update if there are changes
        changed = False
        for reg, val in registers.items():
            old_val = self.old_values.get(reg)
            if old_val != val:
                changed = True

        if not changed:
            return

        # Rebuild the table with updated values, highlighting changes
        self.table = Table("Register", "Value")
        for reg, val in registers.items():
            old_val = self.old_values.get(reg)
            if old_val is not None and old_val != val:
                self.table.add_row(reg, f"[bold dark_red]{val}[/bold dark_red]")
            else:
                self.table.add_row(reg, val)
        self.update(self.table)

        self.old_values = registers

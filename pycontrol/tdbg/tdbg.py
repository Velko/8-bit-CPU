#!/usr/bin/env python3

import textual
import logging
from typing import Any
from datetime import datetime
from rich.logging import RichHandler
from rich.console import Console
from textual.app import App, ComposeResult
from textual.widgets import Footer, Header, RichLog, TabbedContent, TabPane


from libtdb.debugtab import DebugTab

import argparse, sys

from libtdb.addrmap import AddressMapping
from libtdb.messages import ToggleBreakpoint

class TextDebuggerApp(App[None]):

    BINDINGS = [("q", "quit", "Quit the IDE"),
                ("s", "step", "Step instruction"),
                ("c", "continue", "Continue execution"),
                ("b", "toggle_breakpoint", "Toggle breakpoint")]

    def __init__(self, address_mapping: AddressMapping, **kwargs: Any) -> None:
        super().__init__(**kwargs)
        self.address_mapping = address_mapping
        self.theme = "textual-light"  # Default theme
        self.tabs: dict[str, DebugTab] = {}

        self.pc_address: int | None = None

    def compose(self) -> ComposeResult:
        yield Header()
        yield Footer()
        with TabbedContent():
            for file in self.address_mapping.unique_files:
                tab = DebugTab(file, common_prefix=self.address_mapping.get_common_file_prefix)
                self.tabs[file] = tab
                yield tab
            with TabPane("Log"):
                yield RichLog()


    async def action_quit(self) -> None:
        """An action to quit the IDE."""
        self.exit()

    async def action_step(self) -> None:
        """An action to step through the code."""
        logging.getLogger().info("Step action triggered")

        code_location = None
        while code_location is None:

            if self.pc_address is None:
                self.pc_address = 0x0000  # Starting address, adjust as needed
            else:
                self.pc_address += 1  # Increment PC, adjust as needed for instruction size

            code_location = self.address_mapping.by_logical_address.get(self.pc_address)


        tab = self.tabs.get(code_location.file)
        if tab is None:
            logging.getLogger().error(f"No tab found for file: {code_location.file}")
            return

        tabbed = self.query_one(TabbedContent)

        tabbed.active = tab.id

        tab.debug_view.step_to_line(code_location.line_start)

    async def action_continue(self) -> None:
        """An action to continue execution."""
        logging.getLogger().info("Continue action triggered")

    async def action_toggle_breakpoint(self) -> None:
        """An action to toggle a breakpoint."""
        tabbed = self.query_one(TabbedContent)
        active_tab = tabbed.active
        if active_tab is None:
            logging.getLogger().error("No active tab found")
            return
        tab = tabbed.get_pane(active_tab)

        tab.debug_view.post_message(ToggleBreakpoint(self, filename=tab.filename, line=tab.debug_view.code_editor.cursor_location[0]))

    def on_mount(self) -> None:
        rich_log_widget = self.query_one(RichLog)

        # 3. Configure the RichHandler to use our redirector
        redirect_console = LogRedirector(rich_log_widget)
        handler = RichHandler(console=redirect_console, rich_tracebacks=True)
        handler.setLevel(logging.DEBUG)

        # 4. Attach the handler to the root logger
        logging.basicConfig(level=logging.DEBUG, handlers=[handler])

        # 5. Test logging
        logging.getLogger().info("Connected Textual logger to RichLog!")
        logging.getLogger().info(f"Running on Textual version: {textual.__version__}")
        logging.getLogger().debug("This is a debug message.")

    def on_toggle_breakpoint(self, message: ToggleBreakpoint) -> None:

        code_location = self.address_mapping.to_address_and_back(message.filename, message.line)
        if not code_location:
            return
        self.tabs[code_location.file].debug_view.toggle_breakpoint(code_location.line_start)



class LogRedirector(Console):
    def __init__(self, rich_log_widget: RichLog):
        self.rich_log = rich_log_widget
        # RichHandler expects a console-like object with a `.file` attribute.
        self.file = sys.stdout

    def get_datetime(self) -> datetime:
        return datetime.now()

    def print(self, *args: Any, **kwargs: Any) -> None:
        # RichHandler sends a renderable; RichLog can render rich objects directly.
        if not args:
            return
        self.rich_log.write(args[0])




if __name__ == "__main__":
    print(textual.__version__)
    parser = argparse.ArgumentParser(description="Custom IDE")
    parser.add_argument("--theme", help="Set the theme for the IDE")
    parser.add_argument("-i", "--addr-span", nargs='+', help="Address to source mapping file(s)")
    args = parser.parse_args()

    mappings = AddressMapping(args.addr_span)

    print(f"Unique source files found in mappings: {mappings.unique_files}")
    common_prefix = mappings.get_common_file_prefix
    print(f"Common prefix for source files: {common_prefix}")
    # Here you would add code to integrate the loaded mappings into your IDE as needed.

    app = TextDebuggerApp(mappings)
    if args.theme:
        app.theme = args.theme
    app.run()

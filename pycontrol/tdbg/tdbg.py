#!/usr/bin/env python3

import textual
import logging
from typing import Any
from datetime import datetime
from rich.logging import RichHandler
from rich.console import Console
from textual.app import App, ComposeResult
from textual.widgets import Footer, Header, RichLog, TabbedContent, TabPane, TextArea
from textual.containers import Horizontal


from libtdb.debugtab import DebugTab
from libtdb.tdbgwrapper import RegistersMessage, StopMessage, TDBGWrapper, OutputMessage

import argparse, sys

from libtdb.addrmap import AddressMapping
from libtdb.messages import ToggleBreakpoint
from libtdb.regs import RegistersView

class TextDebuggerApp(App[None]):

    BINDINGS = [("q", "quit", "Quit application"),
                ("s", "step", "Step instruction"),
                ("c", "continue", "Continue execution"),
                ("b", "toggle_breakpoint", "Toggle breakpoint"),
                ("r", "reset", "Reset the CPU")]

    CSS_PATH = "app.tcss"

    def __init__(self, address_mapping: AddressMapping, binary: str | None = None, **kwargs: Any) -> None:
        super().__init__(**kwargs)
        self.address_mapping = address_mapping
        self.theme = "textual-light"  # Default theme
        self.tabs: dict[str, DebugTab] = {}
        self.binary = binary

        self.breakpoints: set[int] = set()
        self.backend = TDBGWrapper(self)

    def compose(self) -> ComposeResult:
        yield Header()
        yield Footer()
        with Horizontal(id="main-horizontal"):
            with TabbedContent(id="main-tabs"):
                for file in self.address_mapping.unique_files:
                    tab = DebugTab(file, common_prefix=self.address_mapping.get_common_file_prefix)
                    self.tabs[file] = tab
                    yield tab
                with TabPane("Log"):
                    yield RichLog()
                with TabPane("Output"):
                    yield TextArea("", id="output-area")
            yield RegistersView(id="sidebar-registers")


    async def action_quit(self) -> None:
        """An action to quit the app."""
        self.exit()

    async def action_step(self) -> None:
        """An action to step through the code."""
        logging.getLogger().info("Step action triggered")
        self.backend.step()

    async def on_stop_message(self, message: StopMessage) -> None:
        logging.getLogger().info(f"Execution stopped: reason={message.reason}, addr={message.addr}")

        self.backend.get_registers()  # Update registers view on stop

        code_location = self.address_mapping.by_logical_address.get(message.addr)

        if code_location is None:
            logging.getLogger().warning(f"No code location found for address: {message.addr:04x}")
            return

        tab = self.tabs.get(code_location.file)
        if tab is None:
            logging.getLogger().error(f"No tab found for file: {code_location.file}")
            return

        tabbed = self.query_one(TabbedContent)

        tabbed.active = tab.id or ""

        tab.debug_view.step_to_line(code_location.line_start)


    async def on_output_message(self, message: OutputMessage) -> None:
        output_area = self.query_one("#output-area", TextArea)
        output_area.insert(message.data)


    async def action_continue(self) -> None:
        """An action to continue execution."""
        self.backend.cont()


    async def action_reset(self) -> None:
        """An action to reset the CPU."""
        logging.getLogger().info("Reset action triggered")
        output_area = self.query_one("#output-area", TextArea)
        output_area.clear()
        self.backend.reset()
        self.backend.get_pc()
        self.backend.get_registers()  # Update registers view after reset
        registers_view = self.query_one(RegistersView)
        registers_view.reset_old_values()

    async def on_registers_message(self, message: RegistersMessage) -> None:
        registers_view = self.query_one(RegistersView)
        registers_view.update_table(message.registers)

    async def action_toggle_breakpoint(self) -> None:
        """An action to toggle a breakpoint."""
        tabbed = self.query_one(TabbedContent)
        active_tab = tabbed.active
        if active_tab is None:
            logging.getLogger().error("No active tab found")
            return
        tab = tabbed.get_pane(active_tab)

        if not isinstance(tab, DebugTab):
            return
        self.post_message(ToggleBreakpoint(filename=tab.filename, line=tab.debug_view.code_editor.cursor_location[0]))

    def on_mount(self) -> None:
        self.title = "8-bit CPU TUI debugger"
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


        if self.binary:
            logging.getLogger().info(f"Uploading binary: {self.binary}")
            self.backend.upload_binary(self.binary)

        self.backend.get_pc()
        self.backend.get_registers()  # Initial fetch of registers to populate the view

    def on_toggle_breakpoint(self, message: ToggleBreakpoint) -> None:

        code_location = self.address_mapping.to_address_and_back(message.filename, message.line)
        if not code_location:
            return

        if code_location.logical_address in self.breakpoints:
            self.breakpoints.remove(code_location.logical_address)
            self.tabs[code_location.file].debug_view.clear_breakpoint(code_location.line_start)
            self.backend.clear_breakpoint(code_location.logical_address)
        else:
            self.breakpoints.add(code_location.logical_address)
            self.tabs[code_location.file].debug_view.set_breakpoint(code_location.line_start)
            self.backend.set_breakpoint(code_location.logical_address)


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
    parser = argparse.ArgumentParser(description="8-bit CPU TUI debugger")
    parser.add_argument("-b", "--binary", nargs="?", help="Binary file to upload on startup")
    parser.add_argument("--theme", help="Set the theme for the app")
    parser.add_argument("-i", "--addr-span", nargs='+', help="Address to source mapping file(s)")
    args = parser.parse_args()

    mappings = AddressMapping(args.addr_span)

    app = TextDebuggerApp(mappings, args.binary)
    if args.theme:
        app.theme = args.theme
    app.run()

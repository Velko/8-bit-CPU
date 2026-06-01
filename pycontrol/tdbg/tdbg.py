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
                ("c", "continue", "Continue execution")]

    def __init__(self, files: list[str] = [], common_prefix: str = "", **kwargs: Any) -> None:
        super().__init__(**kwargs)
        self.files = files or []
        self.common_prefix = common_prefix
        self.theme = "textual-light"  # Default theme
        self.tabs: dict[str, DebugTab] = {}


    def compose(self) -> ComposeResult:
        yield Header()
        yield Footer()
        with TabbedContent():
            for file in self.files:
                tab = DebugTab(file, common_prefix=self.common_prefix)
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

        filename = "/home/jurgis/work/8-bit-CPU/demo/snake.asm"
        tab = self.tabs.get(filename)
        if tab is None:
            logging.getLogger().error(f"No tab found for file: {filename}")
            return

        tabbed = self.query_one(TabbedContent)

        tabbed.active = tab.id

        current_line = tab.debug_view.current_line
        if current_line is None:
            tab.debug_view.step_to_line(26)
        else:
            tab.debug_view.step_to_line(current_line + 1)

    async def action_continue(self) -> None:
        """An action to continue execution."""
        logging.getLogger().info("Continue action triggered")

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
        logging.getLogger().info(f"Toggle breakpoint at line {message.line+1} in {message.filename}")



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

    app = TextDebuggerApp(mappings.unique_files, common_prefix)
    if args.theme:
        app.theme = args.theme
    app.run()

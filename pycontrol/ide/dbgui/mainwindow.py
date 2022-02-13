#!/usr/bin/python3

import os.path
from typing import List
import gi

from dbgui.addrmap import AddrMap
from dbgui.mainui import MainUI
from libcpu.debug import Debugger, StopReason

gi.require_version("Gtk", "3.0")
gi.require_version("GtkSource", "4")
from gi.repository import Gtk, GtkSource, Gdk, GdkPixbuf

# Helpful reference
# https://lazka.github.io/pgi-docs/Gtk-3.0/index.html

from .sourcetab import SourceTab
from .addrmap import AddrMap

from libcpu.debug import Debugger

class MainWindow(MainUI):
    def __init__(self) -> None:

        self.builder = Gtk.Builder.new_from_file("assets/mainwindow.ui")
        self.builder.connect_signals(self)

        self.window = self.builder.get_object("main_window")
        self.notebook = self.builder.get_object("notebook")

        self.tabs: List[SourceTab] = []

    on_window_destroy = Gtk.main_quit

    def on_upload_btn_clicked(self, widget: Gtk.Widget) -> None:
        nnoxt = os.path.splitext(self.main_file)[0]
        self.dbg.upload(f"{nnoxt}.bin")

    def on_reset_btn_clicked(self, widget: Gtk.Widget) -> None:
        self.dbg.reset()

    def on_run_btn_clicked(self, widget: Gtk.Widget) -> None:
        self.dbg.cont()

    def on_step_btn_clicked(self, widget: Gtk.Widget) -> None:
        self.dbg.step()

    def add_break(self, filename: str, lineno: int) -> bool:
        item = self.addr_map.lookup_by_line(filename, lineno)

        if item:
            self.dbg.set_breakpoint(item.addr)
            print (f"Brk at {item.addr:04x}")

        return item is not None

    def remove_break(self, filename: str, lineno: int) -> None:
        item = self.addr_map.lookup_by_line(filename, lineno)

        if item:
            self.dbg.clear_breakpoint(item.addr)
            print (f"Clr at {item.addr:04x}")


    def open_project(self, main_file: str) -> None:
        self.main_file = main_file

        self.addr_map = AddrMap(main_file)
        self.dbg = Debugger()

        self.dbg.on_stop = self.on_debugger_stop

        for f in self.addr_map.files():
            tab = SourceTab(self)
            tab.load_file(f)
            self.notebook.append_page(*tab.notepad_args())
            self.tabs.append(tab)

    def on_debugger_stop(self, reason: StopReason, addr: int) -> None:

        item = self.addr_map.lookup_by_addr(addr)

        for i, tab in enumerate(self.tabs):
            tab.clear_runcursor()
            if item is not None and item.filename == tab.filename:
                tab.set_runcursor(item.lineno)
                self.notebook.set_current_page(i)



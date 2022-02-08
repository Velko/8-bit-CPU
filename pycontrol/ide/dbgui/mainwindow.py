#!/usr/bin/python3

from typing import Sequence
import gi

from dbgui.addrmap import AddrMap
from dbgui.mainui import MainUI
from libcpu.debug import Debugger

gi.require_version("Gtk", "3.0")
gi.require_version("GtkSource", "4")
from gi.repository import Gtk, GtkSource, Gdk, GdkPixbuf


from .sourcetab import SourceTab
from .addrmap import AddrMap

from libcpu.debug import Debugger

class MainWindow(Gtk.Window, MainUI):
    def __init__(self):
        super().__init__(title="VelkoCPU IDE")

        self.set_default_size(800, 600)

        self.vpan = Gtk.VBox()

        self.add(self.vpan)

        self.toolbar = Gtk.Toolbar()
        self.vpan.pack_start(self.toolbar, False, False, 0)

        self.button = Gtk.ToolButton(label="Click Here")
        self.button.connect("clicked", self.on_button_clicked)
        self.toolbar.add(self.button)

        self.notebook = Gtk.Notebook()
        self.vpan.add(self.notebook)

    def on_button_clicked(self, widget):
        pass

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

        self.addr_map = AddrMap(main_file)
        self.dbg = Debugger()

        for f in self.addr_map.files():
            tab = SourceTab(self)
            tab.load_file(f)
            self.notebook.append_page(*tab.notepad_args())



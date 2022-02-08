#!/usr/bin/python3

from ast import Add
from typing import Sequence
import gi

gi.require_version("Gtk", "3.0")
gi.require_version("GtkSource", "4")
from gi.repository import Gtk, GtkSource, Gdk, GdkPixbuf


from .sourcetab import SourceTab
from .addrmap import AddrMap

from libcpu.debug import Debugger

class MainWindow(Gtk.Window):
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

    def open_files(self, addr_map: AddrMap, dbg: Debugger) -> None:
        for f in addr_map.files():
            tab = SourceTab(f, addr_map)
            self.notebook.append_page(*tab.notepad_args())



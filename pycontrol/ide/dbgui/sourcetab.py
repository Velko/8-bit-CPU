#!/usr/bin/python3

import gi
import os.path

from .addrmap import AddrMap
from .mainui import MainUI

gi.require_version("Gtk", "3.0")
gi.require_version("GtkSource", "4")
from gi.repository import Gtk, GtkSource, Gdk, GdkPixbuf

class SourceTab:
    def __init__(self, owner: MainUI):
        self.owner = owner
        self.filename = "Untitled"

        self.label = Gtk.Label(label=self.filename)
        self.scroll = Gtk.ScrolledWindow()

        self.src = GtkSource.View()
        self.src.set_show_line_numbers(True)
        self.src.set_show_line_marks(True)
        self.src.set_highlight_current_line(True)
        self.scroll.add(self.src)

        self.src.set_property("monospace", True)
        self.src.connect("line-mark-activated", self.on_line_mark)

        brk_attr = GtkSource.MarkAttributes()
        brk_icon = GdkPixbuf.Pixbuf.new_from_file("blemba.png")
        brk_attr.set_pixbuf(brk_icon)
        self.src.set_mark_attributes("breakpoint", brk_attr, 0)

        self.buffer = self.src.get_buffer()

        #att.set_background(Gdk.RGBA(1, 0, 0, 0.5))

    def load_file(self, filename: str) -> None:

        self.filename = os.path.basename(filename)
        self.label.set_label(self.filename)

        with open(filename) as f:
            self.buffer.set_text(f.read())


    def notepad_args(self):
        return self.scroll, self.label

    def on_line_mark(self, view, iter, event):

        marks = self.buffer.get_source_marks_at_iter(iter, "breakpoint")

        if marks:
            self.owner.remove_break(self.filename, iter.get_line() + 1)
            self.buffer.remove_source_marks(iter, iter, "breakpoint")
        else:
            added = self.owner.add_break(self.filename, iter.get_line() + 1)
            if added:
                self.buffer.create_source_mark(None, "breakpoint", iter)



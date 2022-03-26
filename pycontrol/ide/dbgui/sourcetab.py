#!/usr/bin/python3

from distutils.sysconfig import customize_compiler
from typing import Tuple
import gi
import os.path

from .addrmap import AddrMap
from . import asset_file
from .mainui import MainUI

gi.require_version("Gtk", "3.0")
gi.require_version("GtkSource", "4")
from gi.repository import Gtk, GtkSource, Gdk, GdkPixbuf

class SourceTab:
    def __init__(self, owner: MainUI):
        self.owner = owner
        self.filename = "Untitled"
        self.filepath = "temp"

        self.label = Gtk.Label(label=self.filename)
        self.label.show()

        self.scroll = Gtk.ScrolledWindow()
        self.scroll.show()

        self.src = GtkSource.View()
        self.src.show()
        self.src.set_show_line_numbers(True)
        self.src.set_show_line_marks(True)
        self.src.set_highlight_current_line(True)
        self.scroll.add(self.src)

        self.src.set_property("monospace", True)
        self.src.connect("line-mark-activated", self.on_line_mark)

        brk_attr = GtkSource.MarkAttributes()
        brk_icon = GdkPixbuf.Pixbuf.new_from_file(asset_file("breakpoint-icon.png"))
        brk_attr.set_pixbuf(brk_icon)
        self.src.set_mark_attributes("breakpoint", brk_attr, 0)

        self.buffer = self.src.get_buffer()
        self.buffer.connect("modified-changed", self.on_modified_changed)

        runc_attr = GtkSource.MarkAttributes()
        runc_attr.set_background(Gdk.RGBA(255/255.0, 241/255.0, 129/255.0, 1))
        self.src.set_mark_attributes("run-cursor", runc_attr, 1)

    def load_file(self, filepath: str) -> None:

        self.filepath = filepath
        self.filename = os.path.basename(filepath)

        with open(filepath) as f:
            self.buffer.set_text(f.read())

        self.buffer.set_modified(False)
        self.update_label()

    def update_label(self):
        if self.buffer.get_modified():
            self.label.set_markup(f"<b>{self.filename} *</b>")
        else:
            self.label.set_label(self.filename)

    def save_file(self) -> None:
        with open(self.filepath, "w") as f:
            text = self.buffer.get_text(self.buffer.get_start_iter(), self.buffer.get_end_iter(), True);
            f.write(text)
        self.buffer.set_modified(False)
        self.update_label()

    def notepad_args(self) -> Tuple[Gtk.Widget, Gtk.Widget]:
        return self.scroll, self.label

    def on_line_mark(self, view: GtkSource.View, iter: Gtk.TextIter, event: Gdk.Event) -> None:

        marks = self.buffer.get_source_marks_at_iter(iter, "breakpoint")

        if marks:
            self.owner.remove_break(self.filename, iter.get_line() + 1)
            self.buffer.remove_source_marks(iter, iter, "breakpoint")
        else:
            added = self.owner.add_break(self.filename, iter.get_line() + 1)
            if added:
                self.buffer.create_source_mark(None, "breakpoint", iter)

    def clear_runcursor(self) -> None:
        self.buffer.remove_source_marks(self.buffer.get_start_iter(), self.buffer.get_end_iter(), "run-cursor")

    def set_runcursor(self, line: int) -> None:
        iter = self.buffer.get_iter_at_line(line - 1)
        cursor = self.buffer.create_source_mark(None, "run-cursor", iter)

        self.src.scroll_to_mark(cursor, 0.25, False, 0, 0.5)

    def on_modified_changed(self, text_buffer: Gtk.TextBuffer) -> None:
        self.update_label()



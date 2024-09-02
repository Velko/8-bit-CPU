#!/usr/bin/python3

import os.path
from socket import timeout
from typing import cast
import gi

from dbgui.addrmap import AddrMap
from dbgui.mainui import MainUI
from dbgui.asproject import AsProject
from dbgui import asset_file
from dbgui.term import setup_cmd
from dbgui.cmd import CmdHandler
from libcpu.debug import Debugger, StopReason

gi.require_version("Gtk", "3.0")
gi.require_version("GtkSource", "4")
gi.require_version("Vte", "2.91")
from gi.repository import Gtk, Vte, GLib

# Helpful reference
# https://lazka.github.io/pgi-docs/Gtk-3.0/index.html

from .sourcetab import SourceTab
from .addrmap import AddrMap

from libcpu.debug import Debugger
from libcpu.util import unwrap

class MainWindow(MainUI):
    def __init__(self) -> None:

        self.builder = Gtk.Builder.new_from_file(asset_file("mainwindow.ui"))
        self.builder.connect_signals(self)

        self.window = cast(Gtk.ApplicationWindow, unwrap(self.builder.get_object("main_window")))
        self.notebook = cast(Gtk.Notebook, unwrap(self.builder.get_object("notebook")))

        self.out_text = cast(Gtk.TextView, unwrap(self.builder.get_object("output_text")))
        self.out_end_mark = self.out_text.get_buffer().create_mark("out_end", self.out_text.get_buffer().get_end_iter(), False)

        self.reg_a_val = cast(Gtk.Label, unwrap(self.builder.get_object("reg_a_val")))
        self.reg_b_val = cast(Gtk.Label, unwrap(self.builder.get_object("reg_b_val")))
        self.reg_c_val = cast(Gtk.Label, unwrap(self.builder.get_object("reg_c_val")))
        self.reg_d_val = cast(Gtk.Label, unwrap(self.builder.get_object("reg_d_val")))

        self.flags_val = cast(Gtk.Label, unwrap(self.builder.get_object("flags_val")))
        self.pc_val = cast(Gtk.Label, unwrap(self.builder.get_object("pc_val")))
        self.lr_val = cast(Gtk.Label, unwrap(self.builder.get_object("lr_val")))
        self.sp_val = cast(Gtk.Label, unwrap(self.builder.get_object("sp_val")))

        style_ctx = self.out_text.get_style_context()

        self.term_scroll = cast(Gtk.ScrolledWindow, unwrap(self.builder.get_object("term_scroll")))
        self.terminal = Vte.Terminal()
        self.term_scroll.add(self.terminal)
        self.terminal.set_color_foreground(style_ctx.get_color(Gtk.StateFlags.NORMAL))
        self.terminal.set_color_background(style_ctx.get_background_color(Gtk.StateFlags.NORMAL))
        self.terminal.set_font(style_ctx.get_font(Gtk.StateFlags.NORMAL))

        setup_cmd(self.terminal, CmdHandler())

        self.tabs: list[SourceTab] = []

        self.started = False

    on_window_destroy = Gtk.main_quit

    def on_upload_btn_clicked(self, widget: Gtk.Widget) -> None:
        self.dbg.upload(self.asproj.bin_file)

    def on_reset_btn_clicked(self, widget: Gtk.Widget) -> None:
        self.started = False
        self.dbg.reset()

    def on_dbg_run_cont_activated(self, widget: Gtk.Widget) -> None:
        if not self.started:
            self.started = True
            self.dbg.reset()

        self.dbg.cont()

    def on_dbg_step_into_activated(self, widget: Gtk.Widget) -> None:
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

        self.asproj = AsProject(main_file)
        self.addr_map = AddrMap(main_file)
        self.dbg = Debugger()

        self.dbg.on_stop = self.on_debugger_stop
        self.dbg.on_output = self.on_debugger_out

        self.load_file_tabs()

    def load_file_tabs(self) -> None:
        for f in self.addr_map.files():
            if any(filter(lambda t: t.filepath == f, self.tabs)): continue

            tab = SourceTab(self)
            tab.load_file(f)
            self.notebook.append_page(*tab.notepad_args())
            self.tabs.append(tab)

    def on_compile_activated(self, widget: Gtk.Widget) -> None:
        self.asproj.compile()
        self.addr_map.reload()
        self.load_file_tabs()

    def on_debugger_stop(self, reason: StopReason, addr: int) -> None:

        item = self.addr_map.lookup_by_addr(addr)

        for i, tab in enumerate(self.tabs):
            tab.clear_runcursor()
            if item is not None and item.filename == tab.filename:
                tab.set_runcursor(item.lineno)
                self.notebook.set_current_page(i)

        if reason == StopReason.HALT:
            self.started = False

        regs = self.dbg.get_registers()

        self.reg_a_val.set_text(f"{regs['A']:02x}")
        self.reg_b_val.set_text(f"{regs['B']:02x}")
        self.reg_c_val.set_text(f"{regs['C']:02x}")
        self.reg_d_val.set_text(f"{regs['D']:02x}")

        self.flags_val.set_text(f"{regs['Flags']}")
        self.pc_val.set_text(f"{regs['PC']:04x}")
        self.lr_val.set_text(f"{regs['LR']:04x}")
        self.sp_val.set_text(f"{regs['SP']:04x}")


    def on_debugger_out(self, msg: str) -> None:
        buffer = self.out_text.get_buffer()

        buffer.insert(buffer.get_end_iter(), msg)

        self.out_text.scroll_mark_onscreen(self.out_end_mark)

    def on_file_save_activated(self, widget: Gtk.Widget) -> None:
        for tab in self.tabs:
            tab.save_file()

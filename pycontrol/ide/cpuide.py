#!/usr/bin/python3

import localpath

import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

from dbgui.mainwindow import MainWindow
from dbgui.addrmap import AddrMap

from libcpu.debug import Debugger


am = AddrMap("add18.asm")

dbg = Debugger()

win = MainWindow()
win.connect("destroy", Gtk.main_quit)

win.open_files(am, dbg)

win.show_all()

Gtk.main()
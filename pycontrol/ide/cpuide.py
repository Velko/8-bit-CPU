#!/usr/bin/python3

import localpath

import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

from dbgui.mainwindow import MainWindow

win = MainWindow()

win.open_project("../../demo/add18.asm")

win.window.show_all()

Gtk.main()
#!/usr/bin/python3

import localpath

import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

from dbgui.mainwindow import MainWindow

win = MainWindow()
win.connect("destroy", Gtk.main_quit)

win.open_project("../../demo/add18.asm")

win.show_all()

Gtk.main()
#!/usr/bin/python3

import localpath
import sys

import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

from dbgui.mainwindow import MainWindow

win = MainWindow()

if len(sys.argv) > 1:
    win.open_project(sys.argv[1])

win.window.show_all()

Gtk.main()
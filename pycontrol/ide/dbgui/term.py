#!/usr/bin/python3

import cmd, sys
import multiprocessing

from . import script_file

import gi

gi.require_version("Vte", "2.91")
from gi.repository import GObject, Vte

class ProxiedCmd(cmd.Cmd):

    def get_line_buffer(self) -> str:
        return self.buffer

    def get_begidx(self) -> int:
        return self.begidx

    def get_endidx(self) -> int:
        return self.endidx

    def replace_readline(self) -> None:
        # Cmd uses readline module directly for completion information. As the interpreter receives
        # requests proxied from another procees, it does not share readline information. We
        # "hack in" what Cmd expects
        sys.modules['readline'] = self

    def io_watch_handler(self, channel, cond, *data):
        self.rpc_step()
        return True

    def rpc_step(self) -> bool:
        try:
            c = self.worker_pipe.recv()
        except EOFError:
            return False

        func = getattr(self, 'rpc_' + c[0])

        res = func(*c[1:])

        self.worker_pipe.send(res)

        return True


    def rpc_cmd(self, line: str) -> bool:
        return self.onecmd(line)

    def rpc_complete(self, buffer: str, begidx: int, endidx: int, text: str, state: int) -> list[str] | None:
        self.buffer = buffer
        self.begidx = begidx
        self.endidx = endidx

        return self.complete(text, state)

    def rpc_help(self, arg: str) -> bool | None:
        return self.do_help(arg)

class StdOutRedir:
    def __init__(self, term: Vte.Terminal):
        self.term = term

    def write(self, s: str) -> None:
        s = s.replace('\n', '\r\n')
        self.term.feed(bytes(s, 'utf-8'))


def setup_cmd(terminal: Vte.Terminal, handler: ProxiedCmd):

    handler.replace_readline()
    handler.stdout = StdOutRedir(terminal)

    worker_pipe, other_pipe = multiprocessing.Pipe()

    handler.worker_pipe = worker_pipe

    GObject.io_add_watch(worker_pipe, GObject.IO_IN, handler.io_watch_handler)

    other_fileno = other_pipe.fileno()
    other_pipe._handle = None # disown the fd

    terminal.spawn_with_fds_async(
            Vte.PtyFlags.DEFAULT, #pty_flags
            None, #working_directory
            [script_file("term_ui.py")], #argv
            [], #envv
            [other_fileno], #fds
            [3], #map_fds
            0, #spawn_flags
            None, #child_setup
            None, #cancellable
            -1, #timeout
            None, #callback
            None #user_data
            )

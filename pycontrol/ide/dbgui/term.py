#!/usr/bin/python3

import cmd, sys
from typing import Optional
import multiprocessing

from gi.repository import GObject

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

    def rpc_complete(self, buffer: str, begidx: int, endidx: int, text: str, state: int) -> Optional[list[str]]:
        self.buffer = buffer
        self.begidx = begidx
        self.endidx = endidx

        return self.complete(text, state)

    def rpc_help(self, arg: str) -> Optional[bool]:
        return self.do_help(arg)


def setup_cmd():

    c = CmdHandler()

    c.replace_readline()

    worker_pipe, other_pipe = multiprocessing.Pipe()

    c.worker_pipe = worker_pipe

    GObject.io_add_watch(worker_pipe, GObject.IO_IN, c.io_watch_handler)

    other_fileno = other_pipe.fileno()
    other_pipe._handle = None
    return other_fileno


class CmdHandler(ProxiedCmd):

    def do_example(self, args):
        "Some example command"
        print (f"example with '{args}'")

    #def help_example(self):
    #    print ("Another way describing an example command")

    def complete_example(self, text: str, line: str, begidx: int, endidx: int) -> list[str]:
        all_args = ['123', '456']
        return list(filter(lambda n: n.startswith(text), all_args))

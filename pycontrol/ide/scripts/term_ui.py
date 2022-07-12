#!/usr/bin/env python3

import cmd, readline
from typing import Optional
import multiprocessing.connection


class CmdUI(cmd.Cmd):

    def do_EOF(self, args):
        print()

    def default(self, line):
        self.ui_pipe.send(("cmd", line))
        return self.ui_pipe.recv()

    def complete(self, text: str, state: int) -> Optional[list[str]]:

        self.ui_pipe.send(("complete", readline.get_line_buffer(), readline.get_begidx(), readline.get_endidx(), text, state))
        return self.ui_pipe.recv()

    def do_help(self, arg):
        self.ui_pipe.send(("help", arg))
        return self.ui_pipe.recv()


if __name__ == "__main__":

    c = CmdUI()
    c.ui_pipe = multiprocessing.connection.Connection(3)
    c.cmdloop()

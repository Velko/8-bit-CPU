#!/usr/bin/env python3

from .term import ProxiedCmd


class CmdHandler(ProxiedCmd):

    def do_example(self, args):
        "Some example command"
        print (f"example with '{args}'")

    #def help_example(self):
    #    print ("Another way describing an example command")

    def complete_example(self, text: str, line: str, begidx: int, endidx: int) -> list[str]:
        all_args = ['123', '456']
        return list(filter(lambda n: n.startswith(text), all_args))

#!/usr/bin/python3

class MainUI:
    def add_break(self, filename: str, lineno: int) -> bool: ...
    def remove_break(self, filename: str, lineno: int) -> None: ...
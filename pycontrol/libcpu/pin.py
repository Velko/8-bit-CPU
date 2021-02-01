from enum import Enum

class Level(Enum):
    LOW = 0
    HIGH = 1

class Pin:
    def __init__(self, num, level):
        self.control_word = None
        self.num = num
        self.level = level

    def connect(self, control_word):
        self.control_word = control_word

    def enable(self):
        if self.level == Level.HIGH:
            self.control_word.set(self.num)
        else:
            self.control_word.clr(self.num)

    def disable(self):
        if self.level == Level.HIGH:
            self.control_word.clr(self.num)
        else:
            self.control_word.set(self.num)

class NullPin:
    def __init__(self, num, level):
        self.num = None
        pass

    def connect(self, control_word):
        pass

    def enable(self):
        pass

    def disable(self):
        pass

class Mux:
    def __init__(self, pins, default):
        self.control_word = None
        self.pins = pins
        self.default = default

    def connect(self, control_word):
        self.control_word = control_word

    def enable(self, num):
        for bit_idx, pin in enumerate(self.pins):
            if (num & (1 << bit_idx)) != 0:
                self.control_word.set(pin)
            else:
                self.control_word.clr(pin)

    def disable(self):
        self.enable(self.default)

class MuxPin:
    def __init__(self, mux, num):
        self.mux = mux
        self.num = num

    # There are some inefficiencies how MuxPin handles passing
    # the data back to Mux, but it does not matter much because
    # it occurs purely in Python
    # for example: Mux.connect() is called for by each MuxPin's
    # connect(), while calling it only once per Mux should be
    # enough. But it does not make any noticable impact on peformance
    def connect(self, control_word):
        self.mux.connect(control_word)

    def enable(self):
        self.mux.enable(self.num)

    def disable(self):
        self.mux.disable()

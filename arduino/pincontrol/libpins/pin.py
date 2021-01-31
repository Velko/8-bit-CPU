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

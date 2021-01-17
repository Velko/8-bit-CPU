from enum import Enum

class Level(Enum):
    LOW = 0
    HIGH = 1

class Pin:
    def __init__(self, num, level):
        self.client = None
        self.num = num
        self.level = level

    def connect(self, client):
        self.client = client

    def enable(self):
        if self.level == Level.HIGH:
            self.client.ctrl_set(self.num)
        else:
            self.client.ctrl_clr(self.num)

    def disable(self):
        if self.level == Level.HIGH:
            self.client.ctrl_clr(self.num)
        else:
            self.client.ctrl_set(self.num)

class NullPin:
    def __init__(self, num, level):
        pass

    def connect(self, client):
        pass

    def enable(self):
        pass

    def disable(self):
        pass
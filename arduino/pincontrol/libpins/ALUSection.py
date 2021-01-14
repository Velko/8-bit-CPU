from .devices import *

class ALUSection:
    def __init__(self):
        self.pin_client = None
        self.RegA = Register("A", 1, 0)
        self.RegB = Register("B", 6, 2)
        self.AddSub = ALU("Add/Sub", 3, 4)
        self.Flags = Flags(5)

    def connect(self, pin_client):
        self.pin_client = pin_client
        self.RegA.connect(pin_client)
        self.RegB.connect(pin_client)
        self.AddSub.connect(pin_client)
        self.Flags.connect(pin_client)

    def off(self):
        self.pin_client.off()

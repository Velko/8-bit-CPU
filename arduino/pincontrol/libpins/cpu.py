from . import DeviceSetup

class CPU:
    def __init__(self, pins):
        self.pins = pins

        self.reg_A = DeviceSetup.RegA
        self.reg_B = DeviceSetup.RegB
        self.reg_F = DeviceSetup.Flags
        self.alu = DeviceSetup.AddSub

        self.reg_A.connect(self.pins)
        self.reg_B.connect(self.pins)
        self.reg_F.connect(self.pins)
        self.alu.connect(self.pins)


    def op_ldi(self, target, value):
        target.load()
        self.pins.ctrl_commit()
        self.pins.bus_set(value)
        self.pins.clock_pulse()
        self.pins.clock_inverted()
        self.pins.ctrl_off()
        self.pins.bus_free()

    def op_add(self, target):
        target.load()
        self.alu.out()
        self.reg_F.load()
        self.pins.ctrl_commit()
        self.pins.clock_pulse()
        self.pins.clock_inverted()
        self.pins.ctrl_off()

    def op_out(self, source):
        source.out()
        self.pins.ctrl_commit()
        val = self.pins.bus_get()
        self.pins.ctrl_off()
        return int(val)




class PinClient:

    def __init__(self, serial):
        self.serial = serial

    def send_cmd(self, cmd):
        self.serial.write(cmd.encode("ascii"))
        self.serial.flush()

    def query(self, cmd):
        self.send_cmd(cmd)
        return self.serial.readline().decode('ascii').strip()

    def identify(self):
        return self.query('I')

    def start(self):
        self.ctrl_set(0)
        self.ctrl_set(1)
        self.ctrl_set(2)
        self.ctrl_set(3)
        self.ctrl_clr(4)
        self.ctrl_clr(5)
        self.ctrl_set(6)
        self.ctrl_set(7)
        self.ctrl_commit()


    def bus_set(self, arg):
        self.send_cmd("B{}".format(int(arg, 0)))

    def bus_get(self):
        return self.query("b")

    def bus_free(self):
        self.send_cmd("f")

    def ctrl_set(self, pin):
        self.send_cmd("P{}".format(pin))

    def ctrl_clr(self, pin):
        self.send_cmd("p{}".format(pin))

    def ctrl_commit(self):
        self.send_cmd("M")

    def clock_pulse(self):
        self.send_cmd('c')

    def clock_inverted(self):
        self.send_cmd('C')


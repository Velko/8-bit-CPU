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

    def ctrl_off(self):
        # All control lines inactive levels: 11001111
        self.send_cmd('O')

    def bus_set(self, arg):
        if isinstance(arg, str):
            arg = int(arg, 0)
        self.send_cmd("B{}".format(arg))

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


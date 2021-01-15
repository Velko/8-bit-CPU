DEFAULT=0b0111001111

class PinClient:

    def __init__(self, serial):
        self.serial = serial
        self.c_word = DEFAULT

    def send_cmd(self, cmd):
        self.serial.write(cmd.encode("ascii"))
        self.serial.flush()

    def query(self, cmd):
        self.send_cmd(cmd)
        return self.serial.readline().decode('ascii').strip()

    def identify(self):
        return self.query('I')

    def off(self):
        self.c_word = DEFAULT
        self.send_cmd('O')

    def bus_set(self, arg):
        if isinstance(arg, str):
            arg = int(arg, 0)
        self.send_cmd("B{}".format(arg))

    def bus_get(self):
        return self.query("b")

    def flags_get(self):
        return self.query("s")

    def bus_free(self):
        self.send_cmd("f")

    def ctrl_set(self, pin):
        self.c_word |= 1 << pin

    def ctrl_clr(self, pin):
        self.c_word &= ~(1 << pin)

    def ctrl_commit(self):
        self.send_cmd("M{}".format(self.c_word))

    def clock_pulse(self):
        self.send_cmd('c')

    def clock_inverted(self):
        self.send_cmd('C')


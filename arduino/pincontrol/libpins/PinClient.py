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

    def off(self, c_word):
        # Add NOP command at the end, so that
        # Serial.parseInt() in Arduino does not
        # have to wait for timeout
        self.send_cmd("O{}N".format(c_word))

    def bus_set(self, arg):
        if isinstance(arg, str):
            arg = int(arg, 0)
        self.send_cmd("B{}N".format(arg))

    def bus_get(self):
        return int(self.query("b"))

    def flags_get(self):
        return int(self.query("s"))

    def bus_free(self):
        self.send_cmd("f")

    def ctrl_commit(self, c_word):
        self.send_cmd("M{}N".format(c_word))

    def clock_pulse(self):
        self.send_cmd('c')

    def clock_inverted(self):
        self.send_cmd('C')

    def clock_tick(self):
        self.send_cmd('T')


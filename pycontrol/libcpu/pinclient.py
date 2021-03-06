import serial # type: ignore
import os
from typing import Union, Iterator

class PinClient:

    def __init__(self, serial: serial.Serial=None):

        if serial is not None:
            self.serial = serial
        else:
            self.serial = open_port()

        # Arduino is not ready directly after connecting
        # try a single operation before proceeding
        self.identify()

    def close(self) -> None:
        self.serial.close()

    def send_cmd(self, cmd: str) -> None:
        self.serial.write(cmd.encode("ascii"))
        self.serial.flush()

    def query(self, cmd: str) -> str:
        self.send_cmd(cmd)
        return self.serial.readline().decode('ascii').strip()

    def identify(self) -> str:
        return self.query('I')

    def off(self, c_word: int) -> None:
        # Add NOP command at the end, so that
        # Serial.parseInt() in Arduino does not
        # have to wait for timeout
        self.send_cmd("O{}N".format(c_word))

    def bus_set(self, arg: Union[int, str]) -> None:
        if isinstance(arg, str):
            arg = int(arg, 0)
        self.send_cmd("B{}N".format(arg))

    def bus_get(self) -> int:
        return int(self.query("b"))

    def flags_get(self) -> int:
        return int(self.query("s"))

    def bus_free(self) -> None:
        self.send_cmd("f")

    def ctrl_commit(self, c_word: int) -> None:
        self.send_cmd("M{}N".format(c_word))

    def clock_pulse(self) -> None:
        self.send_cmd('c')

    def clock_inverted(self) -> None:
        self.send_cmd('C')

    def clock_tick(self) -> None:
        self.send_cmd('T')

    def ir_get(self, c_word: int) -> int:
        return int(self.query("r{}N".format(c_word)))

    def run_program(self) -> Iterator[str]:
        self.send_cmd('R')
        while True:
            line = self.serial.readline().decode('ascii')
            yield line


def find_port() -> str:
    ports = list(filter(lambda fn: fn.startswith("ttyACM") or fn.startswith("ttyUSB"),  os.listdir("/dev")))

    if len(ports) > 1:
        raise Exception("Multiple USB serial devices found")

    if len(ports) == 0:
        raise Exception("No USB serial devices found")

    return os.path.join("/dev", ports[0])

def open_port() -> serial.Serial:
    return serial.Serial(find_port(), 115200, timeout=3)

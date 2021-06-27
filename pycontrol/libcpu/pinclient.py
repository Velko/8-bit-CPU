import serial
import os
from typing import Union, Iterator, Optional
from enum import Enum

class RunMessage:
    class Reason(Enum):
        OUT  = 0
        HALT = 1
        BRK  = 2

    def __init__(self, reason: Reason, payload: Optional[str]=None):
        self.reason = reason
        self.payload = payload


class PinClient:

    def __init__(self, serial: Optional[serial.Serial]=None) -> None:

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
        line: bytes = self.serial.readline()
        return line.decode('ascii').strip()

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

    def addr_set(self, arg: Union[int, str]) -> None:
        if isinstance(arg, str):
            arg = int(arg, 0)
        self.send_cmd("A{}N".format(arg))

    def addr_get(self) -> int:
        return int(self.query("a"))

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

    def run_program(self) -> Iterator[RunMessage]:
        self.send_cmd('R')
        while True:
            line = self.serial.readline().decode('ascii').strip()

            if line == "#HLT":
                yield RunMessage(RunMessage.Reason.HALT)
                break

            elif line == "#BRK":
                yield RunMessage(RunMessage.Reason.BRK)
                break

            elif line.startswith("#IOUT#"):
                yield RunMessage(RunMessage.Reason.OUT, f"{line[6:]}\n")

            elif line.startswith("#COUT#"):
                c = chr(int(line[6:]))
                yield RunMessage(RunMessage.Reason.OUT, c)

def find_port() -> str:
    if "SER_PORT" in os.environ:
        return os.environ.get("SER_PORT")

    ports = list(filter(lambda fn: fn.startswith("ttyACM") or fn.startswith("ttyUSB"),  os.listdir("/dev")))

    if len(ports) > 1:
        raise Exception("Multiple USB serial devices found")

    if len(ports) == 0:
        raise Exception("No USB serial devices found")

    return os.path.join("/dev", ports[0])

def open_port() -> serial.Serial:
    return serial.Serial(find_port(), 115200, timeout=3)

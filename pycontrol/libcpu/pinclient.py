import os
from typing import Union, Iterator, Optional
import serial
from .util import RunMessage, OutMessage, HaltMessage, BrkMessage

class ConnectionException(Exception):
    pass

class ProtocolException(Exception):
    pass

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
        self.send_cmd(f"O{c_word}N")

    def bus_set(self, arg: Union[int, str]) -> None:
        if isinstance(arg, str):
            arg = int(arg, 0)
        self.send_cmd(f"B{arg}N")

    def bus_get(self) -> int:
        return int(self.query("b"))

    def addr_set(self, arg: Union[int, str]) -> None:
        if isinstance(arg, str):
            arg = int(arg, 0)
        self.send_cmd(f"A{arg}N")

    def addr_get(self) -> int:
        return int(self.query("a"))

    def flags_get(self) -> int:
        return int(self.query("s"))

    def bus_free(self) -> None:
        self.send_cmd("f")

    def ctrl_commit(self, c_word: int) -> None:
        self.send_cmd(f"M{c_word}N")

    def clock_pulse(self) -> None:
        self.send_cmd('c')

    def clock_inverted(self) -> None:
        self.send_cmd('C')

    def clock_tick(self) -> None:
        self.send_cmd('T')

    def ir_get(self) -> int:
        return int(self.query("r0N"))

    def run_program(self) -> Iterator[RunMessage]:
        self.send_cmd('R')
        while True:
            yield self.receive_message()

    def receive_message(self) -> RunMessage:
        line = self.serial.readline().decode('ascii').strip('\r\n')

        match line:
            case "#HLT":
                return HaltMessage()
            case "#BRK":
                return BrkMessage()
            case _ if line.startswith("#FOUT#"):
                return OutMessage(line[6:].replace("\\n", "\n"))

        raise ProtocolException(f"RunMessage was expected, got: /{line}/")

    def reset(self) -> None:
        self.send_cmd('Z')

    def shutdown(self) -> None:
        self.send_cmd('Q')

def find_port() -> str:
    port = os.environ.get("SER_PORT")
    if port is not None:
        return port

    # if there's a virtual pty0 in current directory, it must be connected to emulator
    if os.path.exists("/tmp/cpu8pty0"):
        return "/tmp/cpu8pty0"

    # look for Arduino
    ports = list(filter(lambda fn: fn.startswith("ttyACM") or fn.startswith("ttyUSB"),  os.listdir("/dev")))

    if len(ports) > 1:
        raise ConnectionException("Multiple USB serial devices found")

    if len(ports) == 0:
        raise ConnectionException("No USB serial devices found")

    return os.path.join("/dev", ports[0])

def open_port() -> serial.Serial:
    return serial.Serial(find_port(), 115200, timeout=3)


single_inst: Optional[PinClient] = None

def get_client_instance() -> PinClient:
    global single_inst

    if single_inst is None:
        single_inst = PinClient()

    return single_inst

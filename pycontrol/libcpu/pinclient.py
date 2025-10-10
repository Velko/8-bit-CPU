import os
from collections.abc import Iterator
import socket
from .util import RunMessage, OutMessage, HaltMessage, BrkMessage

LOCAL_PORT = 9999
TARGET_IP = "127.0.0.1"
TARGET_PORT = 8888

class ConnectionException(Exception):
    pass

class ProtocolException(Exception):
    pass

class PinClient:

    def __init__(self) -> None:

        self.serial = open_port()

        # Arduino is not ready directly after connecting
        # try a single operation before proceeding
        self.identify()

    def close(self) -> None:
        self.serial.close()

    def send_cmd(self, cmd: str) -> None:
        self.serial.sendto(cmd.encode("ascii"), (TARGET_IP, TARGET_PORT))

    def query(self, cmd: str) -> str:
        self.send_cmd(cmd)
        packet, src = self.serial.recvfrom(1024)
        return packet.decode('ascii').strip()

    def identify(self) -> str:
        return self.query('I')

    def off(self, c_word: int) -> None:
        # Add NOP command at the end, so that
        # Serial.parseInt() in Arduino does not
        # have to wait for timeout
        self.send_cmd(f"O{c_word}N")

    def bus_set(self, arg: int | str) -> None:
        if isinstance(arg, str):
            arg = int(arg, 0)
        self.send_cmd(f"B{arg}N")

    def bus_get(self) -> int:
        return int(self.query("b"))

    def addr_set(self, arg: int | str) -> None:
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
        t = self.query('T')
        if t != "#T":
            raise ProtocolException(f"Expected #T from clock tick, got: /{t}/")

    def ir_get(self) -> int:
        return int(self.query("r0N"))

    def run_program(self) -> None:
        self.send_cmd('R')

    def receive_messages(self) -> Iterator[RunMessage]:
        while True:
            yield self.receive_message()

    def receive_raw(self) -> Iterator[str]:
        while True:
            packet, src = self.serial.recvfrom(1024)
            text = packet.decode('ascii')
            yield text

    def receive_message(self) -> RunMessage:
        packet, src = self.serial.recvfrom(1024)
        line = packet.decode('ascii').strip('\r\n')

        match line:
            case "#HLT":
                return HaltMessage()
            case "#BRK":
                return BrkMessage()
            case _ if line.startswith("#FOUT#"):
                return OutMessage(0, line[6:].replace("\\n", "\n"))

        raise ProtocolException(f"RunMessage was expected, got: /{line}/")

    def reset(self) -> None:
        self.send_cmd('Z')

    def shutdown(self) -> None:
        self.send_cmd('Q')

def open_port() -> socket.socket:
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((TARGET_IP, LOCAL_PORT))
    return sock


single_inst: PinClient | None = None

def get_client_instance() -> PinClient:
    global single_inst

    if single_inst is None:
        single_inst = PinClient()

    return single_inst

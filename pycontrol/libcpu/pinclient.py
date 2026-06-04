import os
from collections.abc import Iterator
import socket
import re
from .messages import RunMessage, OutMessage, HaltMessage, BrkMessage
from .ctrl_word import CtrlWord

TARGET_IP = "127.0.0.1"
TARGET_PORT = 8888

class ConnectionException(Exception):
    pass

class ProtocolException(Exception):
    pass

class PinClient:

    def __init__(self) -> None:
        self.transport = open_port()

    def close(self) -> None:
        self.transport.close()

    def send_cmd(self, cmd: str) -> None:
        self.transport.sendto(cmd.encode("ascii"), (TARGET_IP, TARGET_PORT))

    def query(self, cmd: str) -> str:
        self.send_cmd(cmd)
        packet, src = self.transport.recvfrom(1024)
        return packet.decode('ascii').strip()

    def identify(self) -> str:
        return self.query('I')

    def off(self) -> None:
        # Control word initializes to off-state
        cw = CtrlWord()
        # Add NOP command at the end, so that
        # Serial.parseInt() in Arduino does not
        # have to wait for timeout
        self.send_cmd(f"O{cw.c_word:x}N")

    def bus_set(self, arg: int | str) -> None:
        if isinstance(arg, str):
            arg = int(arg, 0)
        self.send_cmd(f"B{arg:x}N")

    def bus_get(self) -> int:
        return int(self.query("b"), 16)

    def addr_set(self, arg: int | str) -> None:
        if isinstance(arg, str):
            arg = int(arg, 0)
        self.send_cmd(f"A{arg:x}N")

    def addr_get(self) -> int:
        return int(self.query("a"), 16)

    def flags_get(self) -> int:
        return int(self.query("s"), 16)

    def bus_free(self) -> None:
        self.send_cmd("f")

    def ctrl_commit(self, cw: CtrlWord) -> None:
        self.send_cmd(f"M{cw.c_word:x}N")

    def clock_pulse(self) -> None:
        self.send_cmd('c')

    def clock_inverted(self) -> None:
        self.send_cmd('C')

    def clock_tick(self) -> None:
        t = self.query('T')
        if t != "#T":
            raise ProtocolException(f"Expected #T from clock tick, got: /{t}/")

    def write_mem(self, cw: CtrlWord, addr: int, data: bytes) -> None:
        # split data into chunks of 128 bytes, to avoid overrunning buffer in emulator
        for i in range(0, len(data), 128):
            chunk = data[i:i+128]
            w = ";".join(map(lambda b: f"{int(b):x}", chunk))
            resp = self.query(f"W{cw.c_word:x};{addr + i:x};{w};100N")
            if resp != "#W":
                raise ProtocolException(f"Expected #W from write memory, got: /{resp}/")

    def ir_get(self) -> int:
        return int(self.query("r0N"), 16)

    def run_program(self) -> None:
        self.send_cmd('R')

    def receive_messages(self) -> Iterator[RunMessage]:
        while True:
            yield self.receive_message()

    def receive_raw(self) -> str:
        packet, _ = self.transport.recvfrom(1024)
        return packet.decode('ascii')

    def send_raw(self, data: bytes) -> None:
        self.transport.sendto(data, (TARGET_IP, TARGET_PORT))

    OUT_RE = re.compile(r"#OUT#([0-9A-Fa-f]+)#(.*)")

    def receive_message(self) -> RunMessage:
        packet, src = self.transport.recvfrom(1024)
        line = packet.decode('ascii').strip('\r\n')

        match line:
            case "#HLT":
                return HaltMessage()
            case "#BRK":
                return BrkMessage()
            case _ if m := self.OUT_RE.match(line):
                target = int(m.group(1), 16)
                payload = m.group(2).replace("\\n", "\n")
                return OutMessage(target, payload)

        raise ProtocolException(f"RunMessage was expected, got: /{line}/")

    def reset(self) -> None:
        self.send_cmd('Z')

    def shutdown(self) -> None:
        self.send_cmd('Q')

def open_port() -> socket.socket:
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return sock


single_inst: PinClient | None = None

def get_client_instance() -> PinClient:
    global single_inst

    if single_inst is None:
        single_inst = PinClient()
        # Arduino is not ready directly after connecting
        # try a single operation before proceeding
        single_inst.identify()

    return single_inst

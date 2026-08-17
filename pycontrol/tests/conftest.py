import pytest
import random
import os, tempfile, shutil
from dataclasses import dataclass

from libcpu.cpu_helper import CPUHelper
from collections.abc import  Sequence, Iterator, Iterable

from libcpu.assisted_cpu import AssistedCPU
from libcpu.pinclient import PinClient, get_client_instance
from libcpu.devices import DeviceBase, Flags, GPRegister
from libcpu.DeviceSetup import hardware
from libcpu.uart_channel import UARTChannel

full_exec_supported = True
full_exec_reason = "code execution is not yet supported"

@pytest.fixture(scope="session")
def pins_client_real() -> Iterator[PinClient]:

    client = get_client_instance()

    yield client

    shd = os.environ.get("EMU_SHUTDOWN")
    if shd is not None:
        client.shutdown()


@pytest.fixture
def acpu(pins_client_real: PinClient) -> AssistedCPU:
    return AssistedCPU(pins_client_real)


@pytest.fixture
def cpu_helper(pins_client_real: PinClient) -> CPUHelper:
    pins_client_real.reset()
    return CPUHelper(pins_client_real)


@pytest.fixture(scope="session")
def uart_channel(pins_client_real: PinClient) -> UARTChannel:
    channel = UARTChannel()
    pins_client_real.register_endpoint(2, channel.get_port())
    return channel

class FillRam:
    def __init__(self, addresses: Sequence[int], values: Iterable[int] | None = None) -> None:

        if values is None:
            values = FillRam.random_bytes()

        self.contents = dict(zip(addresses, values))

    @staticmethod
    def random_bytes() -> Iterator[int]:
        while True:
            yield random.randrange(256)

    def write_ram(self, client: PinClient) -> None:
        cpu_helper = CPUHelper(client)

        for addr, value in self.contents.items():
            cpu_helper.ram[addr] = value

def devname(reg: DeviceBase) -> str:
    return f"{reg.name} "

@dataclass
class ALUTwoRegTestCase:
    name: str
    val_a: int
    val_b: int
    result: int
    xflags: Flags

    def __str__(self) -> str:
        return f"{self.name}: ({self.val_a}, {self.val_b}) -> ({self.result}, {self.xflags}) "

@dataclass
class ALUOneRegTestCase:
    name: str
    val: int
    result: int
    xflags: Flags

    def __str__(self) -> str:
        return f"{self.name}: ({self.val}) -> ({self.result}, {self.xflags}) "

class Compiler:
    def __init__(self, build_directory: str) -> None:
        self.build_directory = build_directory

    def compile(self, asm: str) -> bytes:
        sourcefd, sourcepath = tempfile.mkstemp(prefix="test_", suffix=".asm", dir=self.build_directory, text=True)

        with os.fdopen(sourcefd, "w") as f:
            f.write('#include "velkocpu.def"\n')
            f.write(asm)

        binarypath  = sourcepath[:-4] + ".bin"

        res = os.system(f"customasm -q -f binary {sourcepath} -o {binarypath}")
        if res != 0:
            raise RuntimeError("Failed to compile test program.")
        with open(binarypath, "rb") as f:
            return f.read()

@pytest.fixture(scope="session")
def asm_compiler() -> Iterator[Compiler]:
    dir = tempfile.mkdtemp(prefix="8bitcpu_test_build_")
    try:
        include_dir = os.path.join(os.path.dirname(__file__), "../../include")
        for f in os.listdir(include_dir):
            if f.endswith(".def"):
                os.symlink(os.path.join(include_dir, f), os.path.join(dir, f))
        yield Compiler(dir)
    finally:
        shutil.rmtree(dir, ignore_errors=True)
        pass

gp_regs: list[GPRegister] = [r for r in hardware.devices.values() if isinstance(r, GPRegister)]

def permute_gp_regs_nsame() -> Iterator[tuple[GPRegister, GPRegister]]:
    for l in gp_regs:
        for r in gp_regs:
            if l != r:
                yield l, r

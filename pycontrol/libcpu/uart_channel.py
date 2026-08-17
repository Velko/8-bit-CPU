import socket

TARGET_IP = "127.0.0.1"
TARGET_PORT = 8890

class UARTChannel:
    def __init__(self) -> None:
        self.transport = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.transport.bind(("", 0))

    def get_port(self) -> int:
        return int(self.transport.getsockname()[1])

    def receive(self) -> str:
        packet, _ = self.transport.recvfrom(1024)
        return packet.decode('ascii')

    def send(self, data: bytes) -> None:
        self.transport.sendto(data, (TARGET_IP, TARGET_PORT))

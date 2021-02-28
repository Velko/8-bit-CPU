from abc import abstractmethod

class UninitializedError(Exception):
    pass

class ControlSignal:
    @abstractmethod
    def enable(self) -> None: pass

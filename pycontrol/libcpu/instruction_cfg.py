#!/usr/bin/env python3

import yaml # type: ignore
from dataclasses import dataclass, field
from typing import Any
from enum import Enum, auto

class Repeat(Enum):
    once = auto()
    gp_regs = auto()
    gp_reg_pair_all = auto()
    gp_reg_pair_different = auto()

@dataclass
class Condition:
    match: dict[str, bool]
    steps: list[list[str]] = field(default_factory=list)

@dataclass
class Instruction:
    name: str
    repeat: Repeat
    args: list[str]
    format: str | None
    steps: list[list[str]]
    conditions: list[Condition]
    hidden: bool
    opcode: int | None

    def __init__(self, **kwargs: Any) -> None:
        self.name = kwargs['name']
        self.repeat = Repeat[kwargs.get('repeat', 'once')]
        self.args = kwargs.get('args', [])
        self.format = kwargs.get('format', None)
        self.steps = kwargs.get('steps', [])
        self.conditions = [Condition(**c) for c in kwargs.get('conditions', [])]
        self.hidden = kwargs.get('hidden', False)
        self.opcode = kwargs.get('opcode', None)

@dataclass
class InstructionConfig:
    fetch: list[list[str]]
    instructions: list[Instruction]

    def __init__(self, fetch: Any, instructions: list[Any]) -> None:
        self.fetch = fetch
        self.instructions = [Instruction(**i) for i in instructions]

    @staticmethod
    def load_from_yaml(filename: str) -> 'InstructionConfig':
        with open(filename) as stream:
            yconf = yaml.safe_load(stream)
            return InstructionConfig(**yconf)


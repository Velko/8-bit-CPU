#!/usr/bin/env pyhhon3


# Some trickery to make valid Python code feel closer
# to assembly. It exports all members of class instance
# that starts with 'reg_' and 'op_' to global scope

def export_isa(cpu, scope):
    export = dict()

    for member in dir(cpu):
        if member.startswith("reg_"):
            ex_name = member[len("reg_"):]
            export[ex_name] = getattr(cpu, member)
        elif member.startswith("op_"):
            ex_name = member[len("op_"):]
            export[ex_name] = getattr(cpu, member)

    scope.update(export)

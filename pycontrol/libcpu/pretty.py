
def ansi_red(text: str) -> str:
    return f"\x1b[1;31m{text}\x1b[0m"

def ansi_green(text: str) -> str:
    return f"\x1b[1;32m{text}\x1b[0m"

def format_message(target: int, msg: str) -> str:
    match target:
        case 0:
            return ansi_red(msg)
        case 0x10:
            return ansi_green(msg)
        case _:
            return msg

#include "instructions.def"
#include "aliases.def"
#include "ports.def"

#const(noemit) RAM_START = 0x2000
#const(noemit) STACK_END = 0xC010

#bankdef bios
{
    #bits 8
    #addr 0xE000
    #outp 0 * 8
    #addr_end 0x10000
    #fill
}

; Startup code, is executed after reset
; * initialize GP registers to zero (nice default)
; * load SP to dedicated stack area
; * jump to RAM location where the program should be loaded
__start:
    ldi A, 0x55 ; load something, because VerilogVM has X there by default and freaks out
    clr A       ; when clr (essentially xor A, A) is tried. Should work fine on hardware.
    mov B, A    ; Can not also ldi A, 0 directly, because we require bytes 0, 1, 2, 4 to
    mov C, A    ; be non-zero for memory tests
    mov D, A
    lea SP, STACK_END
    jmp RAM_START


#include "uart.asm"
#include "convert.asm"

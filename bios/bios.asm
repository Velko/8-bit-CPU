#include "instructions.def"
#include "aliases.def"
#include "ports.def"

#const(noemit) RAM_START = 0x2000
#const(noemit) STACK_END = 0xC010

#bankdef bios
{
    #bits 8
    #addr 0
    #outp 0 * 8
    #addr_end 32
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

; BIOS code is treated as "known data" for memory system tests. Test reads from "single-bit"
; addresses (0, 1, 2, 4, 8, 16, ...).
; The following is a complete nonsense, just a random instructions aligned up to a power-of-2
; addresses. Feel free to replace it with something more useful. Only try to keep the bytes at
; these addresses non-zero (nop-pad if required) and somewhat unique.

; #bankdef fill16
; {
;     #bits 8
;     #addr 16
;     #outp 16 * 8
;     #addr_end 32
;     #fill
; }
;     hlt

#bankdef fill32
{
    #bits 8
    #addr 32
    #outp 32 * 8
    #addr_end 64
    #fill
}
   inc B

#bankdef fill64
{
    #bits 8
    #addr 64
    #outp 64 * 8
    #addr_end 128
    #fill
}
   shr C


#bankdef fill128
{
    #bits 8
    #addr 128
    #outp 128 * 8
    #addr_end 256
    #fill
}
   mov B, C

#bankdef fill256
{
    #bits 8
    #addr 256
    #outp 256 * 8
    #addr_end 512
    #fill
}
   cmp D, C

#bankdef fill512
{
    #bits 8
    #addr 512
    #outp 512 * 8
    #addr_end 1024
    #fill
}
   clr A

#bankdef fill1024
{
    #bits 8
    #addr 1024
    #outp 1024 * 8
    #addr_end 2048
    #fill
}
   swap D

#bankdef fill2048
{
    #bits 8
    #addr 2048
    #outp 2048 * 8
    #addr_end 4096
    #fill
}
   xor C, B

#bankdef fill4096
{
    #bits 8
    #addr 4096
    #outp 4096 * 8
    #addr_end 8192
    #fill
}
   sbb B, C
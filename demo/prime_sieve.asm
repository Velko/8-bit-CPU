; The .def file can be generated using casmdefs.py tool
#include "velkocpu.def"

#bank program

sieve_start:

    ; value of 16 is commonly used for comparisons, keep it
    ; in register for quick access
    ldi D, 16
    ; also, value of 0 is used frequently
    ldi C, 0

    ; start with seg0[2]
    ldi A, 2

    ; fill seg0 with non-zero values
    fill0_loop:

        ; store "something" in seg0[A] (any non-zero value will do)
        stx seg0[A], D

        ; next index in A
        inc A

        ; are we done?
        cmp A, D

        ; jump back to start of the loop
        bne fill0_loop


    ; Simple sieve for first 16
    ldi B, 2  ; B holds current prime tested/processed

    seg0_loop:
        ; calculate flags for seg0[B]
        tstx seg0[B] ; test byte in RAM

        ; anything non-zero means prime found
        beq seg0_next

            ; print out
            out DISPLAY_NUM_DATA, B

            ; mark multiples, starting from next one
            mov A, B
            add A, A

            seg0_fill_m_loop:

                ; less than 16?
                cmp A, D
                bcc seg0_fill_m_end

                ; write zero at seg0[A]
                stx seg0[A], C

                ; calculate next multiple
                add A, B

                jmp seg0_fill_m_loop

            seg0_fill_m_end:

            ; store largest multiple at seg0[B]
            stx seg0[B], A

        seg0_next:

        ; next index in B
        inc B

        ; are we done?
        cmp B, D

        bne seg0_loop


    ; Continue with segmented sieve
    mov A, D

    seg_n_loop:
        st r_low, A

        ; Fill seg_n with non-zeros
        clr A
        seg_n0_loop:

            ; store "something" in seg0[A] (any non-zero value will do)
            stx seg_n[A], D

            ; next index in A
            inc A

            ; are we done?
            cmp A, D

            ; conditional jump back to start of the loop
            bne seg_n0_loop

        ; process items from seg0, starting with 2
        ldi B, 2

        seg_n_mark_loop:
            st p, B ; save for later

            ; load seg0[B], getting the latest calculated multiple
            ldx A, seg0[B] ; it also calculates flags accordingly

            beq seg_n_mark_next   ; jump over if not prime

                ; subtract, so that A becomes an index in seg_n[]
                ld B, r_low
                sub A, B

                seg_n_mark_mult_loop:
                    ; check at the beginning, because A could already
                    ; be >= 16
                    cmp A, D
                    bcc seg_n_mark_mult_end

                    ; write a zero over seg_n[A]
                    stx seg_n[A], C

                    ; add p for next multiple
                    ld B, p
                    add A, B

                    jmp seg_n_mark_mult_loop

                seg_n_mark_mult_end:

                ; add back r_low, so the A again becomes a multiple of prime
                ; instead of index in array
                ld B, r_low
                add A, B

                ; and store it into the seg0[p]
                st m, A
                ld B, p
                stx seg0[B], A

            seg_n_mark_next:

            ; next index in seg0
            ld B, p
            inc B

            ; done with seg0?
            cmp B, D

            ; next iteration
            bne seg_n_mark_loop

        ; segment done, print it out
        clr A
        seg_n_print_loop:

            ; check byte at seg_n[A]
            tstx seg_n[A]

            beq seg_n_print_skip

                ; add r_low to get real number
                ld B, r_low
                add B, A

                out DISPLAY_NUM_DATA, B

            seg_n_print_skip:

            ; next index in A
            inc A

            ; are we done?
            cmp A, D

            bne seg_n_print_loop


        ; next segment
        ld A, r_low
        add A, D

        ; all done
        bcc seg_n_loop


    hlt
    jmp sieve_start ; if hlt did not work/was overridden, start from the beginning

#bankdef bss
{
    #addr 0x80
}


; the seg0 array serves dual purpose
; - the fact that there is something non-zero at seg0[n] indicates that n is a prime
; - contents of seg0[n] is a largest (so far) calculated multiple of that n
; because seg0[0:1] are never used, re-use locations for m and p variables
; arrays are aligned to 16 byte boundary, so that bitwise OR can be used for
; calculations (just to demonstrate that And/Or unit works)
seg0:
p:
	#res 1
m:
	#res 1
	#res 14

seg_n:
	#res 16
r_low:
	#res 1

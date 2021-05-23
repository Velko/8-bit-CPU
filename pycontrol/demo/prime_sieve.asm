; The .def file can be generated using casmdefs.py tool
#include "velkocpu.def"

sieve_start:

    ; value of 16 is commonly used for comparisons, keep it
    ; in register for quick access
    ldi (D, 16)

    ldi (A, 2)

    ; fill seg0 with non-zero values
    fill0_loop:

        ; calculate target address of seg0[A] in B
        stx (seg0, A, A) ; store "something" there (for starters, any non-zero value will do)

        ; next index in A
        inc (A)

        ; are we done?
        cmp (A, D)

        ; emulate conditional jump back to start of the loop
        bne(fill0_loop)


    ; Simple sieve for first 16
    ldi (A, 2)

    seg0_loop:
        st (p, A)   ; store for later

        ; calculate flags for seg0[A]
        tstx (seg0, A) ; test byte in RAM

        beq(seg0_next)

            out(A)

            ; start from next multiple
            mov (B, A)
            add (A, B)

            seg0_fill_m_loop:

                ; less than 16?
                cmp (A, D)
                bcc(seg0_fill_m_end)

                ; store for later
                st (m, A)

                ; write zero at seg0[A]
                ldi (B, 0)
                stx (seg0, A, B)

                ; reload stored values and calculate
                ; next multiple
                ld (A, m)
                ld (B, p)
                add (A, B)

                jmp (seg0_fill_m_loop)

            seg0_fill_m_end:

            ; store largest multiple
            st (m, A)

            ; at address of seg0[p]
            ld (A, p)

            ld (B, m)
            stx (seg0, A, B)

        seg0_next:

        ; next index in A
        ld (A, p)
        inc (A)

        ; are we done?
        cmp (A, D)

        bne(seg0_loop)


    ; Continue with segmented sieve
    mov (A, D)

    seg_n_loop:
        st (r_low, A)

        ; Fill seg_n with non-zeros
        ldi (A, 0)
        seg_n0_loop:
            ; write non-zero in seg_n[A]
            stx (seg_n, A, D) ; can not write A, as it may be zero this time

            ; next index in A
            inc (A)

            ; are we done?
            cmp (A, D)

            ; conditional jump back to start of the loop
            bne(seg_n0_loop)

        ldi (A, 2)
        seg_n_mark_loop:
            st (p, A) ; save for later

            ; load seg0[A], getting the latest calculated multiple
            ldx (A, seg0, A) ; it also calculates flags accordingly

            beq(seg_n_mark_next)   ; jump over if not prime

                ; subtract, so that A becomes an index in seg_n[]
                ld (B, r_low)
                sub (A, B)

                seg_n_mark_mult_loop:
                    ; check at the beginning, because A could already
                    ; be >= 16
                    cmp (A, D)
                    bcc(seg_n_mark_mult_end)

                    ; store, as we will need A for other purposes
                    st (m, A)

                    ; address of seg_n[A]
                    ldi (B, 0)

                    ; write a zero over it
                    stx (seg_n, A, B)

                    ; reload A and add p for next multiple
                    ld (A, m)
                    ld (B, p)
                    add (A, B)

                    jmp (seg_n_mark_mult_loop)

                seg_n_mark_mult_end:

                ; add back r_low, so the A again becomes a multiple of prime
                ; instead of index in array
                ld (B, r_low)
                add (A, B)

                ; and store it into the seg0[p]
                st (m, A)
                ld (B, p)
                stx (seg0, B, A)

            seg_n_mark_next:

            ; next index in seg0
            ld (A, p)
            inc (A)

            ; done with seg0?
            cmp (A, D)

            ; next iteration
            bne(seg_n_mark_loop)

        ; segment done, print it out
        ldi (A, 0)
        seg_n_print_loop:

            ; check byte at seg_n[A]
            tstx(seg_n, A)

            beq(seg_n_print_skip)

                ; add r_low to get real number
                ld (B, r_low)
                add (B, A)

                out(B)

            seg_n_print_skip:

            ; next index in A
            inc (A)

            ; are we done?
            cmp (A, D)

            bne(seg_n_print_loop)


        ; next segment
        ld (A, r_low)
        add (A, D)

        ; all done
        bcc(seg_n_loop)


    hlt()
    jmp(sieve_start) ; if hlt did not work/was overridden, start from the beginning


; the seg0 array serves dual purpose
; - the fact that there is something non-zero at seg0[n] indicates that n is a prime
; - contents of seg0[n] is a largest (so far) calculated multiple of that n
; because seg0[0:1] are never used, re-use locations for m and p variables
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

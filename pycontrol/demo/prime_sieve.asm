; The .def file can be generated using casmdefs.py tool
#include "velkocpu.def"

bootloader:
    ; temporary hardware configuration is such that reads
    ; comes from ROM, but writes goes into RAM
    ; bootloader loops all 256 addresses, reads in and writes
    ; back (making a copy from ROM to RAM in the process)

    ; dummy instruction, will be replaced by jmp when loading
    ; is complete
    ldi (A, sieve_start)

    ldi (B, 0)
.loop:
    ldabs (A, B)
    stabs (B, A)
    ldi (A, 1)
    add (B, A)
    bcc(.loop)

    ; after address wrap-around B should be 0, the address we need;
    ; replace the value there with opcode for jmp (be careful with microcode updates)
    ldi (A, 0x24)
    stabs (B, A)

; run halt in a loop in case it is not wired properly
.haltloop:
    hlt()
    jmp (.haltloop)


    ; now the program
sieve_start:

    ldi (A, 2)

    ; fill seg0 with non-zero values
fill0_loop:
        ; calculate target address of seg0[A] in B
        ldi (B, seg0)
        add (B, A)

        ; store "something" in seg0[A] (any non-zero value will do)
        stabs (B, A)

        ; next index in A
        ldi (B, 1)
        add (A, B)

        ; are we done?
        ldi (B, 16)
        cmp (A, B)

        ; jump back to start of the loop
        bne(fill0_loop)


    ; Simple sieve for first 16
    ldi (A, 2)

seg0_loop:
        st (p, A)  ; store for later

        ; calculate flags for seg0[A]
        ldi (B, seg0)
        add (B, A)
        tstabs (B) ; test byte in RAM

        ; anything non-zero means prime found
        beq(seg0_next)

        ; print out
        out(A)

            ; mark multiples, starting from next one
            mov (B, A)
            add (A, B)

            seg0_fill_m_loop:

                ; less than 16?
                ldi (B, 16)
                cmp (A, B)
                bcc(seg0_fill_m_end)

                ; store for later
                st (m, A)
                ; write zero at seg0[A]
                ldi (B, seg0)
                add (B, A)
                ldi (A, 0)
                stabs (B, A)

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
            ldi (B, seg0)
            add (B, A)

            ld (A, m)
            stabs (B, A)

        seg0_next:

        ; next index in A
        ld (A, p)
        ldi (B, 1)
        add (A, B)

        ; are we done?
        ldi (B, 16)
        cmp (A, B)

        bne(seg0_loop)


    ; Continue with segmented sieve
    ldi (A, 16)

    seg_n_loop:
        st (r_low, A)

        ; Fill seg_n with non-zeros
        ldi (A, 0)
        seg_n0_loop:

            ; write non-zero in seg_n[A]
            ldi (B, seg_n)
            add (B, A)

            stabs(B, B) ; can not write A, as it may be zero this time

            ; next index in A
            ldi (B, 1)
            add (A, B)

            ; are we done?
            ldi (B, 16)
            cmp (A, B)

            ; conditional jump back to start of the loop
            bne(seg_n0_loop)

        ; process items from seg0, starting with 2
        ldi (A, 2)
        seg_n_mark_loop:
            st (p, A) ; save for later

            ; load seg0[A], getting the latest calculated multiple
            ldi (B, seg0)
            add (B, A)
            ldabs (A, B) ; it also calculates flags accordingly

            beq(seg_n_mark_next)   ; jump over if not prime

                ; subtract, so that A becomes an index in seg_n[]
                ld (B, r_low)
                sub (A, B)

                seg_n_mark_mult_loop:
                    ; check at the beginning, because A could already
                    ; be >= 16
                    ldi (B, 16)
                    cmp (A, B)
                    bcc(seg_n_mark_mult_end)

                    ; store, as we will need A for other purposes
                    st (m, A)

                    ; address of seg_n[A]
                    ldi (B, seg_n)
                    add (B, A)

                    ; write a zero over it
                    ldi (A, 0)
                    stabs (B, A)

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
                ld (A, p)
                ldi (B, seg0)
                add (B, A)
                ld (A, m)
                stabs (B, A)
            seg_n_mark_next:

            ; next index in seg0
            ld (A, p)
            ldi (B, 1)
            add (A, B)

            ; done with seg0?
            ldi (B, 16)
            cmp (A, B)

            ; next iteration
            bne(seg_n_mark_loop)

        ; segment done, print it out
        ldi (A, 0)
        seg_n_print_loop:

            ; check byte at seg_n[A]
            ldi (B, seg_n)
            add (B, A)
            tstabs(B)

            beq(seg_n_print_skip)

                ; add r_low to get real number
                ld (B, r_low)
                add (B, A)

                out(B)

            seg_n_print_skip:

            ; next index in A
            ldi (B, 1)
            add (A, B)

            ; are we done?
            ldi (B, 16)
            cmp (A, B)

            bne(seg_n_print_loop)


        ; next segment
        ld (A, r_low)
        ldi (B, 16)
        add (A, B)

        ; all done
        bcc(seg_n_loop)


    hlt()
    jmp(0) ; if hlt did not work/was overridden, start from the beginning

; original code placed data at 0xc0
; while it does not generally matter
; keeping it for verification purposes
#addr 0xc0
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

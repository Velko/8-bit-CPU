#!/usr/bin/python3

from libpins.markers import *

def run():

    print ("-------- segment: 0 (simple) -------", flush=True)

    ldi (A, 2)

    # fill seg0 with non-zero values
    while True:
        # calculate target address of seg0[A] in B
        ldi (B, seg0)
        add (B, A)

        stabs (B, A) # store "something" there (for starters, any non-zero value will do)

        # next index in A
        ldi (B, 1)
        add (A, B)

        # are we done?
        ldi (B, 16)
        cmp (A, B)

        # emulate conditional jump back to start of the loop
        if bne(): continue
        break


    # Simple sieve for first 16
    ldi (A, 2)

    while True:
        st (p, A)   # store for later

        # calculate flags for seg0[A]
        ldi (B, seg0)
        add (B, A)
        tstabs (B) # test byte in RAM

        if not beq(): # emulate jumping over block

            out(A)

            # start from next multiple
            mov (B, A)
            add (A, B)

            while True:

                # less than 16?
                ldi (B, 16)
                cmp (A, B)
                if bcc(): break

                # store for later
                st (m, A)

                # write zero at seg0[A]
                ldi (B, seg0)
                add (B, A)
                ldi (A, 0)
                stabs (B, A)

                # reload stored values and calculate
                # next multiple
                ld (A, m)
                ld (B, p)
                add (A, B)

            # store largest multiple
            st (m, A)

            # at address of seg0[p]
            ld (A, p)
            ldi (B, seg0)
            add (B, A)

            ld (A, m)
            stabs (B, A)

        # next index in A
        ld (A, p)
        ldi (B, 1)
        add (A, B)

        # are we done?
        ldi (B, 16)
        cmp (A, B)

        if bne(): continue
        break

    # Continue with segmented sieve
    ldi (A, 16)

    while True:
        st (r_low, A)
        print ("----------- segment: {}+ -----------".format(peek(A)), flush=True)

        # Fill seg_n with non-zeros
        ldi (A, 0)
        while True:
            # write non-zero in seg_n[A]
            ldi (B, seg_n)
            add (B, A)

            stabs(B, B) # can not write A, as it may be zero this time

            # next index in A
            ldi (B, 1)
            add (A, B)

            # are we done?
            ldi (B, 16)
            cmp (A, B)

            # emulate conditional jump back to start of the loop
            if bne(): continue
            break

        ldi (A, 2)
        while True:
            st (p, A) # save for later

            # load seg0[A], getting the latest calculated multiple
            ldi (B, seg0)
            add (B, A)
            ldabs (A, B) # it also calculates flags accordingly

            if not beq():   # jump over if not prime

                # subtract, so that A becomes an index in seg_n[]
                ld (B, r_low)
                sub (A, B)

                while True:
                    # check at the beginning, because A could already
                    # be >= 16
                    ldi (B, 16)
                    cmp (A, B)
                    if bcc(): break

                    # store, as we will need A for other purposes
                    st (m, A)

                    # address of seg_n[A]
                    ldi (B, seg_n)
                    add (B, A)

                    # write a zero over it
                    ldi (A, 0)
                    stabs (B, A)

                    # reload A and add p for next multiple
                    ld (A, m)
                    ld (B, p)
                    add (A, B)

                # add back r_low, so the A again becomes a multiple of prime
                # instead of index in array
                ld (B, r_low)
                add (A, B)

                # and store it into the seg0[p]
                st (m, A)
                ld (A, p)
                ldi (B, seg0)
                add (B, A)
                ld (A, m)
                stabs (B, A)

            # next index in seg0
            ld (A, p)
            ldi (B, 1)
            add (A, B)

            # done with seg0?
            ldi (B, 16)
            cmp (A, B)

            # next iteration
            if bne(): continue
            break

        # segment done, print it out
        ldi (A, 0)
        while True:

            # check byte at seg_n[A]
            ldi (B, seg_n)
            add (B, A)
            tstabs(B)

            if not beq():

                # add r_low to get real number
                ld (B, r_low)
                add (B, A)

                out(B)

            # next index in A
            ldi (B, 1)
            add (A, B)

            # are we done?
            ldi (B, 16)
            cmp (A, B)

            if bne(): continue
            break


        # next segment
        ld (A, r_low)
        ldi (B, 16)
        add (A, B)

        # all done
        if bcc(): continue
        break


    print ("----------- done -----------", flush=True)


# probably will need adjustments as the code above
# might not fit in first 128 bytes
org(0x80)
align(16)

p = Byte()
m = Byte()

# rewind addressing because seg0[0..1] are never accessed
# p and m can happily live there
rewind(2)

# the seg0 array serves dual purpose
# - the fact that there is something non-zero at seg0[n] indicates that n is a prime
# - contents of seg0[n] is a largest (so far) calculated multiple of that n
seg0 = Bytes(16)

seg_n = Bytes(16)
r_low = Byte()


if __name__ == "__main__":

    from libpins import PyAsmExec

    PyAsmExec.setup(globals())
    run()

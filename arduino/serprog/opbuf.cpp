#include "opbuf.h"
#include "serprog-proto.h"
#include "debug.h"
#include <string.h>


uint8_t chipmem[1024 * 128];
uint8_t idmem[] = {0xBF, 0xB5};

uint8_t *active_mem = chipmem;


#define CHIPSIZE    128 * 1024UL
#define ADDR_OFFSET  (0x1000000UL - CHIPSIZE)


void OpBuf::init()
{
    memset(chipmem, 0xFF, sizeof(chipmem));
    reset();
}

void OpBuf::reset()
{
    w_offset = 0;
}

uint8_t *OpBuf::write_into(size_t advance)
{
    uint8_t *curr = buffer + w_offset;
    w_offset+=advance;
    return curr;
}

const uint8_t writeb_seq[] = {
    S_CMD_O_WRITEB, 0x55, 0x55, 0xfe, 0xAA,
    S_CMD_O_WRITEB, 0xAA, 0x2A, 0xfe, 0x55,
    S_CMD_O_WRITEB, 0x55, 0x55, 0xfe, 0xA0,
    S_CMD_O_WRITEB
};

const uint8_t writenb_5556_seq[] = {
    S_CMD_O_WRITEB, 0x55, 0x55, 0xfe, 0xAA,
    S_CMD_O_WRITEB, 0xAA, 0x2A, 0xfe, 0x55,
    S_CMD_O_WRITEN, 0x02, 0x00, 0x00, 0xA0,
}


const uint8_t enter_id_seq[] = {
    S_CMD_O_WRITEB, 0x55, 0x55, 0xfe, 0xAA,
    S_CMD_O_WRITEB, 0xAA, 0x2A, 0xfe, 0x55,
    S_CMD_O_WRITEB, 0x55, 0x55, 0xfe, 0x90,
};


const uint8_t exit_id_seq[] = {
    S_CMD_O_WRITEB, 0x55, 0x55, 0xfe, 0xAA,
    S_CMD_O_WRITEB, 0xAA, 0x2A, 0xfe, 0x55,
    S_CMD_O_WRITEB, 0x55, 0x55, 0xfe, 0xF0,
};


void OpBuf::exec()
{
    for (uint8_t *opp = buffer; (opp - buffer) < w_offset; )
    {
        if (memcmp(opp, enter_id_seq, sizeof(enter_id_seq))==0)
        {
            dprintf("Enter ID\n");
            active_mem = idmem;
            opp += sizeof(enter_id_seq);
        }

        if (memcmp(opp, exit_id_seq, sizeof(exit_id_seq))==0)
        {
            dprintf("Exit ID\n");
            active_mem = chipmem;
            opp += sizeof(exit_id_seq);
        }


        if (memcmp(opp, writeb_seq, sizeof(writeb_seq))==0)
        {
            opp += sizeof(writeb_seq);
            uint32_t *aptr = (uint32_t *)opp;

            opp += 3;

            uint32_t addr = (*aptr & 0x00FFFFFF) - ADDR_OFFSET;
            uint8_t val = *opp;
            opp += 1;
            dprintf("write to chip ar %x, val %x\n", addr, val);
            chipmem[addr] = val;
        }
    }

    reset();
}
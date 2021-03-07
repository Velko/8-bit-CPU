#include "opbuf.h"

void OpBuf::init()
{
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

void OpBuf::exec()
{
    reset();
}
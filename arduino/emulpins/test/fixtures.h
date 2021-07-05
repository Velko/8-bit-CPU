#ifndef FIXTURES_H
#define FIXTURES_H

#include "op-defs.h"

struct BusStateFixture
{
    BusStateFixture();
};


#define MUX_VAL(MUX, BITS)    ((CTRL_DEFAULT & ~(MUX)) | (BITS))


#endif /* FIXTURES_H */
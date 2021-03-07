#ifndef OPBUF_H
#define OPBUF_H

#include <stdint.h>
#include <stddef.h>

#define OPBUF_SIZE      (256+7)

class OpBuf
{
    private:
        uint8_t buffer[OPBUF_SIZE];
        size_t w_offset;
    public:
        void init();
        void reset();
        uint8_t *write_into(size_t advance);
        size_t size() { return OPBUF_SIZE; }
        void exec();
};


#endif /* OPBUF_H */

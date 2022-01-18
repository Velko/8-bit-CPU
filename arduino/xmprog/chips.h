#ifndef CHIPS_H
#define CHIPS_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

struct chip_def {
    char name[20];
    uint16_t man_dev_id;
    uint32_t size;
    uint8_t socket;
    FILE *(*open_fn)(struct chip_def *chip);
    void (*erase_fn)(struct chip_def *chip, bool force);
};

#ifdef __cplusplus
extern "C" {
#endif

    FILE *chip_open_stream(const char *file_name);
    void chip_erase(const char *file_name, bool force);

#ifdef __cplusplus
}
#endif

#endif /* CHIPS_H */
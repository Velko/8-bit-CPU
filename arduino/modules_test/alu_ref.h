#ifndef ALU_REF_H
#define ALU_REF_H

#ifdef __cplusplus
extern "C" {
#endif

uint8_t flags_of_add8(uint8_t a, uint8_t b);
uint8_t flags_of_sub8(uint8_t a, uint8_t b);
uint8_t add8_set_carry(uint8_t a, uint8_t b);
uint8_t sub8_set_carry(uint8_t a, uint8_t b);

uint8_t flags_of_add8_with_c(uint8_t a, uint8_t b);
uint8_t flags_of_sub8_with_c(uint8_t a, uint8_t b);


#ifdef __cplusplus
}
#endif


#endif /* ALU_REF_H */
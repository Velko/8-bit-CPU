#ifndef MATH_OPS_H
#define MATH_OPS_H

#ifdef __cplusplus
extern "C" {
#endif

int add16(int a, int b);
int sub16(int a, int b);
uint8_t flags_of_add8(uint8_t a, uint8_t b);
uint8_t flags_of_sub8(uint8_t a, uint8_t b);
uint8_t add8_set_carry(uint8_t a, uint8_t b);
uint8_t sub8_set_carry(uint8_t a, uint8_t b);


#ifdef __cplusplus
}
#endif



#endif /* MATH_OPS_H */
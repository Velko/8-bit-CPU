#ifndef ALU_TESTS_H
#define ALU_TESTS_H

class ALU;

void alu_tests();

void alu_add_bytes(ALU &alu);
void alu_add_bytes_b(ALU &alu);
void alu_add_bytes_cset(ALU &alu);
void alu_sub_bytes(ALU &alu);
void alu_sub_bytes_b(ALU &alu);
void alu_sub_bytes_cset(ALU &alu);
void alu_add_16bit(ALU &alu);
void alu_sub_16bit(ALU &alu);

#endif /* ALU_TESTS_H */


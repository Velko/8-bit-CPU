#ifndef REGISTER_TESTS_H
#define REGISTER_TESTS_H

class Register;

void register_demo();
void register_load(int val);
void register_tests();

void reg_load_store_output(Register *r, int repeats, const char *label);


#endif /* REGISTER_TESTS_H */

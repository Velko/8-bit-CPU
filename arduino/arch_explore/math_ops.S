	.file	"math_ops.ctmpl"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
.global	add16
	.type	add16, @function
add16:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	add r24,r22
	adc r25,r23
	ret
	.size	add16, .-add16
.global	sub16
	.type	sub16, @function
sub16:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sub r24,r22
	sbc r25,r23
	ret
	.size	sub16, .-sub16
.global	flags_of_add8
	.type	flags_of_add8, @function
flags_of_add8:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	add r24,r22
	sts scratch,r24
	in r24,__SREG__
	ret
	.size	flags_of_add8, .-flags_of_add8
.global	flags_of_sub8
	.type	flags_of_sub8, @function
flags_of_sub8:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sub r24,r22
	sts scratch,r24
	in r24,__SREG__
	ret
	.size	flags_of_sub8, .-flags_of_sub8
.global	add8_set_carry
	.type	add8_set_carry, @function
add8_set_carry:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sec
	adc r24,r22
	ret
	.size	add8_set_carry, .-add8_set_carry
.global	sub8_set_carry
	.type	sub8_set_carry, @function
sub8_set_carry:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	sec
	sbc r24,r22
	ret
	.size	sub8_set_carry, .-sub8_set_carry
	.comm	scratch,1,1
	.ident	"GCC: (GNU) 5.4.0"
.global __do_clear_bss

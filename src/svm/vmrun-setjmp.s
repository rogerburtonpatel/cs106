	.arch armv8-a
	.text
	.cstring
	.align	3
lC0:
	.ascii "decode\0"
	.align	3
lC1:
	.ascii "call\0"
	.align	3
lC2:
	.ascii "%v\0"
	.align	3
lC3:
	.ascii "%v\12\0"
	.align	3
lC4:
	.ascii "%U\0"
	.align	3
lC5:
	.ascii "vmrun.c\0"
	.align	3
lC6:
	.ascii "a number\0"
	.align	3
lC7:
	.ascii "a string\0"
	.align	3
lC8:
	.ascii "Fatal error: nested check-error not allowed\12\0"
	.align	3
lC9:
	.ascii "check-error\0"
	.align	3
lC10:
	.ascii "attempting to push an error frame in check-error caused a Stack Overflow\0"
	.align	3
lC11:
	.ascii "a VM function\0"
	.align	3
lC12:
	.ascii "func->arity == 0\0"
	.align	3
lC13:
	.ascii "division by zero\0"
	.align	3
lC14:
	.ascii "a cons cell\0"
	.align	3
lC15:
	.ascii "attempting to return register %hhu, from non-function.\0"
	.align	3
lC16:
	.ascii "attempting to call function in register %hhu caused a Stack Overflow\0"
	.align	3
lC17:
	.ascii "Offending function:\0"
	.align	3
lC18:
	.ascii "attempting to call function in register %hhu caused a Register Window Overflow\0"
	.align	3
lC19:
	.ascii "func->arity == n\0"
	.align	3
lC20:
	.ascii "tailcall\0"
	.align	3
lC21:
	.ascii "attempting to tailcall function in register %hhucaused a Register Window Overflow\0"
	.align	3
lC22:
	.ascii "Opcode Not implemented!\0"
	.text
	.align	2
	.p2align 4,,11
	.globl _vmrun
_vmrun:
LFB44:
	sub	sp, sp, #224
LCFI0:
	stp	x29, x30, [sp, 16]
LCFI1:
	add	x29, sp, 16
	stp	x19, x20, [sp, 32]
LCFI2:
	mov	x19, x0
	str	x0, [sp, 128]
	ldr	w0, [x1, 4]
	stp	x21, x22, [sp, 48]
	stp	x23, x24, [sp, 64]
	stp	x25, x26, [sp, 80]
	stp	d8, d9, [sp, 96]
LCFI3:
	str	x1, [sp, 152]
	cmp	w0, 0
	ble	L2
	mov	x20, x1
	adrp	x0, lC0@PAGE
	add	x0, x0, lC0@PAGEOFF;momd
	bl	_svmdebug_value
	adrp	x1, lC1@PAGE
	str	x0, [sp, 144]
	add	x0, x1, lC1@PAGEOFF;momd
	add	x1, x20, 12
	mov	x20, x1
	str	x1, [sp, 112]
	bl	_svmdebug_value
	str	x20, [x19], 16
L187:
	str	x19, [sp, 136]
L158:
	ldr	x0, [sp, 112]
	ldr	w0, [x0]
	str	w0, [sp, 120]
	ldr	x0, [sp, 144]
	cbz	x0, L69
	ldp	x8, x4, [sp, 128]
	adrp	x0, ___stderrp@GOTPAGE
	ldr	x0, [x0, ___stderrp@GOTPAGEOFF]
	ldr	x2, [sp, 112]
	ldr	x1, [x8]
	ldr	w3, [sp, 120]
	ldr	x0, [x0]
	subs	x1, x2, x1
	add	x2, x1, 3
	ubfx	x6, x3, 8, 8
	csel	x2, x2, x1, mi
	ubfx	x5, x3, 16, 8
	ubfiz	x7, x3, 4, 8
	add	x6, x4, x6, lsl 4
	add	x5, x4, x5, lsl 4
	add	x7, x4, x7
	ubfx	x2, x2, 2, 32
	mov	x1, x8
	mov	x4, 0
	bl	_idump
L69:
	ldr	w0, [sp, 120]
	lsr	w0, w0, 24
	cmp	w0, 24
	beq	L4
	bls	L226
	cmp	w0, 37
	beq	L37
	bls	L227
	cmp	w0, 43
	beq	L54
	bls	L228
	cmp	w0, 46
	beq	L62
	bls	L229
	cmp	w0, 50
	beq	L66
	cmp	w0, 51
	bne	L230
	ldp	x1, x0, [sp, 112]
	sbfx	x0, x0, 0, 24
	add	w0, w0, 1
	add	x0, x1, w0, sxtw 2
	str	x0, [sp, 112]
	b	L158
	.p2align 2,,3
L226:
	cmp	w0, 12
	beq	L6
	bls	L231
	cmp	w0, 18
	beq	L23
	bls	L232
	cmp	w0, 21
	beq	L31
	bls	L233
	cmp	w0, 22
	beq	L234
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	bne	L132
L135:
	ldr	x0, [sp, 120]
	ubfiz	x1, x0, 4, 8
	add	x0, x19, x1
	ldr	w1, [x19, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	beq	L134
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 244
	bl	_typeerror
L134:
	ldr	x0, [sp, 120]
	fcmpe	d8, d9
	mov	w3, 1
	ubfx	x0, x0, 16, 8
	cset	w2, ge
	lsl	x0, x0, 4
	add	x1, x19, x0
	str	w3, [x19, x0]
	ldr	x19, [sp, 136]
	strb	w2, [x1, 8]
	b	L70
	.p2align 2,,3
L231:
	cmp	w0, 6
	beq	L8
	bls	L235
	cmp	w0, 9
	beq	L17
	bls	L236
	cmp	w0, 10
	beq	L237
	mov	x0, 50001
L223:
	ldr	w2, [sp, 120]
	ubfx	x1, x2, 16, 8
	add	x0, x0, w2, uxth
	ldr	x2, [sp, 128]
	add	x1, x19, x1, lsl 4
	add	x0, x2, x0, lsl 4
	ldp	x2, x3, [x0]
	stp	x2, x3, [x1]
	b	L70
	.p2align 2,,3
L227:
	cmp	w0, 31
	beq	L39
	bls	L238
	cmp	w0, 34
	beq	L48
	bls	L239
	cmp	w0, 35
	beq	L240
	ldr	w0, [sp, 120]
	mov	w3, 1
	ubfx	x1, x0, 8, 8
	ubfx	x0, x0, 16, 8
	lsl	x1, x1, 4
	lsl	x0, x0, 4
	add	x2, x19, x0
	ldr	w1, [x19, x1]
	str	w3, [x19, x0]
	cmp	w1, 3
	cset	w0, eq
	strb	w0, [x2, 8]
	b	L70
	.p2align 2,,3
L238:
	cmp	w0, 28
	beq	L41
	bls	L241
	cmp	w0, 29
	beq	L242
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L145
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 265
	bl	_typeerror
L145:
	fcvtzs	d0, d8
	mov	w2, 2
	ldr	x0, [sp, 120]
	neg	d0, d0
	ubfx	x0, x0, 16, 8
	lsl	x0, x0, 4
	scvtf	d0, d0
	add	x1, x19, x0
	str	w2, [x19, x0]
	ldr	x19, [sp, 136]
	str	d0, [x1, 8]
	b	L70
	.p2align 2,,3
L235:
	cmp	w0, 3
	beq	L10
	bls	L243
	cmp	w0, 4
	beq	L244
	ldr	x0, [sp, 128]
	ldrh	w1, [sp, 120]
	bl	_literal_value
	stp	x0, x1, [sp]
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;momd
	bl	_print
	.p2align 3,,7
L70:
	ldr	x0, [sp, 112]
	add	x0, x0, 4
	str	x0, [sp, 112]
	b	L187
	.p2align 2,,3
L228:
	cmp	w0, 40
	beq	L56
	bls	L245
	cmp	w0, 41
	beq	L246
	ldr	w1, [sp, 120]
	ubfx	x0, x1, 8, 8
	ubfx	x1, x1, 16, 8
	lsl	x0, x0, 4
	lsl	x1, x1, 4
	add	x2, x19, x0
	add	x3, x19, x1
	ldr	x1, [x19, x1]
	ldp	x4, x5, [x2]
	ldr	x6, [x3, 8]
	stp	x4, x5, [x3]
	str	x1, [x19, x0]
	str	x6, [x2, 8]
	stp	x1, x6, [sp, 168]
	b	L70
	.p2align 2,,3
L232:
	cmp	w0, 15
	beq	L25
	bls	L247
	cmp	w0, 16
	beq	L248
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfiz	x0, x0, 4, 8
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L115
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 197
	bl	_typeerror
L115:
	fcvtzs	d8, d8
	scvtf	d9, d8
	fcmp	d9, #0.0
	beq	L249
L114:
	ldr	x0, [sp, 120]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L117
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 202
	bl	_typeerror
L117:
	fcvtzs	d0, d8
	mov	w2, 2
	ldr	x0, [sp, 120]
	scvtf	d0, d0
	ubfx	x0, x0, 16, 8
	lsl	x0, x0, 4
	fdiv	d0, d0, d9
	add	x1, x19, x0
	str	w2, [x19, x0]
	ldr	x19, [sp, 136]
	str	d0, [x1, 8]
	b	L70
	.p2align 2,,3
L229:
	cmp	w0, 44
	beq	L250
	ldr	w0, [sp, 120]
	ubfx	x22, x0, 8, 8
	ubfx	x20, x0, 16, 8
	sub	w23, w0, w22
	mov	x25, x22
	mov	x21, x22
	lsl	x22, x22, 4
	and	w23, w23, 255
	add	x24, x19, x22
	ldr	w0, [x19, x22]
	cbz	w0, L251
L164:
	ldp	x2, x3, [x24]
	ldr	x22, [x24, 8]
	cmp	w0, 6
	beq	L168
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC11@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC11@PAGEOFF;momd
	mov	w5, 419
	bl	_typeerror
L168:
	ldr	x0, [sp, 128]
	mov	w1, 5000
	add	x0, x0, 942080
	ldrh	w0, [x0, 3472]
	cmp	w0, w1
	beq	L252
L167:
	ldr	x0, [sp, 128]
	mov	w1, 50000
	ldr	w3, [x22, 8]
	add	x0, x0, 933888
	ldr	w2, [x0, 11668]
	add	w0, w2, w21
	add	w0, w0, w3
	cmp	w0, w1
	bhi	L253
L170:
	ldr	x5, [sp, 128]
	ldr	w3, [x22]
	add	x1, x5, 942080
	ldrh	w0, [x1, 3472]
	add	w4, w0, 1
	strh	w4, [x1, 3472]
	ubfiz	x0, x0, 4, 16
	add	x0, x5, x0
	add	x0, x0, 851968
	ldr	x1, [sp, 112]
	str	x1, [x0, 13584]
	str	w2, [x0, 13592]
	str	w20, [x0, 13596]
	cmp	w3, w23
	bne	L254
	ldr	x1, [sp, 128]
	add	w21, w21, w2
	add	x0, x1, 933888
	add	x19, x1, 16
	add	x1, x22, 8
	str	x1, [sp, 112]
	ubfiz	x1, x21, 4, 32
	add	x19, x19, x1
	str	w21, [x0, 11668]
	b	L70
	.p2align 2,,3
L247:
	cmp	w0, 13
	beq	L255
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L97
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 166
	bl	_typeerror
L97:
	ldr	x0, [sp, 120]
	ubfiz	x1, x0, 4, 8
	add	x0, x19, x1
	ldr	w1, [x19, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	beq	L96
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 167
	bl	_typeerror
L96:
	ldr	x0, [sp, 120]
	fadd	d8, d8, d9
	ubfx	x0, x0, 16, 8
L222:
	lsl	x0, x0, 4
	mov	w2, 2
	add	x1, x19, x0
	str	w2, [x19, x0]
	ldr	x19, [sp, 136]
	str	d8, [x1, 8]
	b	L70
	.p2align 2,,3
L241:
	cmp	w0, 26
	beq	L43
	cmp	w0, 27
	bne	L256
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	x20, [x1, 8]
	cmp	w0, 5
	bne	L153
L154:
	ldr	x0, [sp, 120]
	ldp	x2, x3, [x20, 24]
	ubfx	x0, x0, 16, 8
	add	x0, x19, x0, lsl 4
	ldr	x19, [sp, 136]
	stp	x2, x3, [x0]
	b	L70
	.p2align 2,,3
L245:
	cmp	w0, 38
	beq	L257
	ldr	w0, [sp, 120]
	mov	w3, 1
	ubfx	x1, x0, 8, 8
	ubfx	x0, x0, 16, 8
	lsl	x1, x1, 4
	lsl	x0, x0, 4
	add	x2, x19, x0
	ldr	w1, [x19, x1]
	str	w3, [x19, x0]
	cmp	w1, 4
	cset	w0, eq
	strb	w0, [x2, 8]
	b	L70
L268:
	ldr	x0, [sp, 128]
	ldr	x1, [sp, 112]
	str	x1, [x0, 8]
L2:
	ldp	x29, x30, [sp, 16]
	ldp	x19, x20, [sp, 32]
	ldp	x21, x22, [sp, 48]
	ldp	x23, x24, [sp, 64]
	ldp	x25, x26, [sp, 80]
	ldp	d8, d9, [sp, 96]
	add	sp, sp, 224
LCFI4:
	ret
	.p2align 2,,3
L246:
LCFI5:
	ldr	w0, [sp, 120]
	ubfx	x1, x0, 8, 8
	ubfx	x0, x0, 16, 8
	add	x1, x19, x1, lsl 4
	add	x0, x19, x0, lsl 4
	ldp	x2, x3, [x1]
	stp	x2, x3, [x0]
	b	L70
	.p2align 2,,3
L248:
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfiz	x0, x0, 4, 8
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d9, [x1, 8]
	cmp	w0, 2
	beq	L109
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 183
	bl	_typeerror
L109:
	fcmp	d9, #0.0
	beq	L258
L108:
	ldr	x0, [sp, 120]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L111
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 188
	bl	_typeerror
L111:
	ldr	x0, [sp, 120]
	fdiv	d8, d8, d9
	ubfx	x0, x0, 16, 8
	b	L222
	.p2align 2,,3
L250:
	ldp	x1, x0, [sp, 120]
	add	x0, x0, 942080
	ubfx	x20, x1, 16, 8
	ldrh	w0, [x0, 3472]
	cbz	w0, L259
L159:
	ldr	x5, [sp, 128]
	sub	w0, w0, #1
	ubfiz	x2, x20, 4, 8
	and	w0, w0, 65535
	add	x2, x19, x2
	add	x3, x5, 942080
	ubfiz	x1, x0, 4, 16
	add	x4, x5, 933888
	ldp	x6, x7, [x2]
	strh	w0, [x3, 3472]
	add	x0, x5, x1
	add	x3, x5, 16
	add	x0, x0, 851968
	ldr	w2, [x0, 13592]
	ldr	w1, [x0, 13596]
	ldr	x0, [x0, 13584]
	str	w2, [x4, 11668]
	ubfiz	x2, x2, 4, 32
	str	x0, [sp, 112]
	add	x0, x3, x2
	str	x0, [sp, 136]
	tbnz	w1, #31, L260
	ldr	x0, [sp, 136]
	ldr	x19, [sp, 136]
	add	x1, x0, w1, sxtw 4
	stp	x6, x7, [x1]
	b	L70
	.p2align 2,,3
L255:
	ldr	w2, [sp, 120]
	mov	x0, 61146
	ubfx	x1, x2, 16, 8
	add	x0, x0, w2, uxth
	ldr	x2, [sp, 128]
	add	x1, x19, x1, lsl 4
	add	x0, x2, x0, lsl 4
	ldp	x2, x3, [x1]
	stp	x2, x3, [x0]
	b	L70
	.p2align 2,,3
L66:
	ldr	x0, [sp, 120]
	ubfx	x0, x0, 16, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldrb	w1, [x1, 8]
	cbz	w0, L157
	cmp	w0, 1
	bne	L70
	cbnz	w1, L70
L157:
	ldr	x0, [sp, 112]
	add	x0, x0, 4
	str	x0, [sp, 112]
	b	L70
	.p2align 2,,3
L257:
	ldr	w0, [sp, 120]
	mov	w3, 1
	ubfx	x1, x0, 8, 8
	ubfx	x0, x0, 16, 8
	lsl	x1, x1, 4
	lsl	x0, x0, 4
	add	x2, x19, x0
	ldr	w1, [x19, x1]
	str	w3, [x19, x0]
	cmp	w1, w3
	cset	w0, eq
	strb	w0, [x2, 8]
	b	L70
	.p2align 2,,3
L242:
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x0, 16, 8
	lsl	x0, x0, 4
	add	x20, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x20]
	ldr	d8, [x20, 8]
	cmp	w0, 2
	beq	L143
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 260
	bl	_typeerror
L143:
	fmov	d0, 1.0e+0
	mov	w0, 2
	ldr	x19, [sp, 136]
	fsub	d8, d8, d0
	str	w0, [x20]
	str	d8, [x20, 8]
	b	L70
	.p2align 2,,3
L43:
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	x20, [x1, 8]
	cmp	w0, 5
	beq	L152
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC14@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC14@PAGEOFF;momd
	mov	w5, 349
	bl	_typeerror
L152:
	ldr	x0, [sp, 120]
	ldp	x2, x3, [x20, 8]
	ubfx	x0, x0, 16, 8
	add	x0, x19, x0, lsl 4
	ldr	x19, [sp, 136]
	stp	x2, x3, [x0]
	b	L70
	.p2align 2,,3
L62:
	ldr	w0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x20, x0, 16, 8
	ubfx	x23, x0, 8, 8
	mov	x25, x20
	mov	x21, x20
	lsl	x20, x20, 4
	sub	w22, w23, w25
	add	x24, x19, x20
	and	w22, w22, 255
	ldr	w0, [x19, x20]
	cbz	w0, L261
L177:
	ldp	x2, x3, [x24]
	ldr	x20, [x24, 8]
	cmp	w0, 6
	beq	L181
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC11@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC11@PAGEOFF;momd
	mov	w5, 472
	bl	_typeerror
L181:
	ldr	x0, [sp, 128]
	mov	w1, 49999
	add	x0, x0, 933888
	ldr	w0, [x0, 11668]
	add	w0, w23, w0
	cmp	w0, w1
	bhi	L262
L182:
	add	x3, x19, 16
	sbfiz	x2, x21, 4, 32
	add	x3, x3, w22, uxtw 4
	.p2align 3,,7
L185:
	add	x0, x19, x2
	ldp	x0, x1, [x0]
	stp	x0, x1, [x19], 16
	cmp	x3, x19
	bne	L185
	ldr	w0, [x20]
	cmp	w0, w22
	bne	L263
	ldr	x19, [sp, 136]
	add	x0, x20, 8
	str	x0, [sp, 112]
	b	L70
	.p2align 2,,3
L56:
	ldr	w0, [sp, 120]
	mov	w3, 1
	ubfx	x1, x0, 8, 8
	ubfx	x0, x0, 16, 8
	lsl	x1, x1, 4
	lsl	x0, x0, 4
	add	x2, x19, x0
	ldr	w1, [x19, x1]
	str	w3, [x19, x0]
	cmp	w1, 0
	cset	w0, eq
	strb	w0, [x2, 8]
	b	L70
	.p2align 2,,3
L25:
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L101
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 172
	bl	_typeerror
L101:
	ldr	x0, [sp, 120]
	ubfiz	x1, x0, 4, 8
	add	x0, x19, x1
	ldr	w1, [x19, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	beq	L100
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 173
	bl	_typeerror
L100:
	ldr	x0, [sp, 120]
	fsub	d8, d8, d9
	ubfx	x0, x0, 16, 8
	b	L222
	.p2align 2,,3
L10:
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x0, 16, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L72
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 89
	bl	_typeerror
L72:
	fcvtzu	w1, d8
	adrp	x0, lC4@PAGE
	ldr	x19, [sp, 136]
	add	x0, x0, lC4@PAGEOFF;momd
	str	w1, [sp]
	bl	_print
	b	L70
	.p2align 2,,3
L41:
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x0, 16, 8
	lsl	x0, x0, 4
	add	x20, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x20]
	ldr	d8, [x20, 8]
	cmp	w0, 2
	beq	L141
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 256
	bl	_typeerror
L141:
	fmov	d0, 1.0e+0
	mov	w0, 2
	ldr	x19, [sp, 136]
	fadd	d8, d8, d0
	str	w0, [x20]
	str	d8, [x20, 8]
	b	L70
L132:
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 243
	bl	_typeerror
	b	L135
L153:
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC14@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC14@PAGEOFF;momd
	mov	w5, 352
	bl	_typeerror
	b	L154
	.p2align 2,,3
L31:
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L127
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 231
	bl	_typeerror
L127:
	ldr	x0, [sp, 120]
	ubfiz	x1, x0, 4, 8
	add	x0, x19, x1
	ldr	w1, [x19, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	beq	L126
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 232
	bl	_typeerror
L126:
	ldr	x0, [sp, 120]
	fcmpe	d8, d9
	mov	w3, 1
	ubfx	x0, x0, 16, 8
	cset	w2, gt
	lsl	x0, x0, 4
	add	x1, x19, x0
	str	w3, [x19, x0]
	ldr	x19, [sp, 136]
	strb	w2, [x1, 8]
	b	L70
	.p2align 2,,3
L8:
	ldr	x0, [sp, 120]
	adrp	x1, lC2@PAGE
	add	x1, x1, lC2@PAGEOFF;momd
	ubfx	x2, x0, 16, 8
	ldr	x0, [sp, 128]
	add	x2, x19, x2, lsl 4
	ldp	x2, x3, [x2]
	stp	x2, x3, [sp]
	bl	_runerror_p
	b	L70
L256:
	ldr	w1, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x1, 8, 8
	ubfiz	x1, x1, 4, 8
	add	x2, x19, x1
	lsl	x0, x0, 4
	add	x3, x19, x0
	ldr	w20, [x19, x1]
	ldr	x21, [x19, x1]
	ldr	x0, [x19, x0]
	str	x0, [sp, 168]
	ldr	x0, [x3, 8]
	str	x0, [sp, 176]
	ldr	x22, [x2, 8]
	cmp	w20, 4
	beq	L148
	cmp	w20, 5
	beq	L150
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC14@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC14@PAGEOFF;momd
	mov	x2, x21
	mov	x3, x22
	mov	w5, 338
	bl	_typeerror
L150:
	mov	w20, 5
L148:
	mov	x0, 36
	bl	_vmalloc_raw
	ldr	x1, [sp, 120]
	mov	w4, 2
	str	w4, [x0]
	bfi	x21, x20, 0, 32
	ldr	x4, [sp, 168]
	ubfx	x1, x1, 16, 8
	str	x4, [x0, 8]
	mov	w3, 5
	lsl	x1, x1, 4
	stp	x21, x22, [x0, 24]
	add	x2, x19, x1
	ldr	x4, [sp, 176]
	str	x4, [x0, 16]
	str	w3, [x19, x1]
	ldr	x19, [sp, 136]
	str	x0, [x2, 8]
	b	L70
	.p2align 2,,3
L4:
	ldr	w20, [sp, 120]
	ubfx	x0, x20, 8, 8
	ubfiz	x1, x20, 4, 8
	add	x1, x19, x1
	add	x0, x19, x0, lsl 4
	ldp	x2, x3, [x1]
	ldp	x0, x1, [x0]
	bl	_eqvalue
	ubfx	x1, x20, 16, 8
	mov	w3, 1
	lsl	x1, x1, 4
	add	x2, x19, x1
	str	w3, [x19, x1]
	strb	w0, [x2, 8]
	b	L70
	.p2align 2,,3
L237:
	bl	_error_mode
	str	x19, [sp, 136]
	cmp	w0, 1
	beq	L264
	ldr	w1, [sp, 120]
	ubfx	x0, x1, 16, 8
	mov	x1, x0
	str	x1, [sp, 160]
	lsl	x0, x0, 4
	ldr	w0, [x19, x0]
	cbnz	w0, L85
	ldr	x3, [sp, 112]
	ldr	x2, [sp, 152]
	ldr	x19, [sp, 128]
	ldr	w20, [sp, 160]
	mov	x0, x19
	mov	w1, w20
	bl	_lastglobalset
	adrp	x2, lC9@PAGE
	mov	x1, x0
	mov	w3, w20
	add	x2, x2, lC9@PAGEOFF;momd
	mov	x0, x19
	bl	_nilfunerror
L85:
	bl	_add_test
	bl	_enter_check_error
	adrp	x0, _testjmp@GOTPAGE
	ldr	x0, [x0, _testjmp@GOTPAGEOFF]
	bl	_setjmp
	cbnz	w0, L265
	ldr	x0, [sp, 128]
	mov	w1, 5000
	add	x0, x0, 942080
	ldrh	w0, [x0, 3472]
	cmp	w0, w1
	beq	L88
L91:
	ldr	x0, [sp, 160]
	ldr	x2, [sp, 136]
	ubfiz	x1, x0, 4, 8
	add	x0, x2, x1
	ldr	w1, [x2, x1]
	ldp	x2, x3, [x0]
	ldr	x20, [x0, 8]
	cmp	w1, 6
	beq	L90
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC11@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC11@PAGEOFF;momd
	mov	w5, 141
	bl	_typeerror
L90:
	ldr	w0, [x20]
	cbnz	w0, L266
	ldp	x5, x19, [sp, 128]
	ldrh	w2, [sp, 120]
	neg	w2, w2
	add	x1, x5, 942080
	add	x3, x5, 933888
	ldrh	w0, [x1, 3472]
	ldr	w3, [x3, 11668]
	add	w4, w0, 1
	strh	w4, [x1, 3472]
	ubfiz	x0, x0, 4, 16
	add	x0, x5, x0
	add	x0, x0, 851968
	ldr	x1, [sp, 112]
	str	x1, [x0, 13584]
	add	x1, x20, 8
	str	x1, [sp, 112]
	str	w3, [x0, 13592]
	str	w2, [x0, 13596]
	b	L70
L265:
	bl	_pass_test
	bl	_exit_check_error
	ldr	x3, [sp, 128]
	add	x1, x3, 942080
	add	x2, x3, 933888
	add	x19, x3, 16
	ldrh	w0, [x1, 3472]
	sub	w0, w0, #1
	and	w0, w0, 65535
	strh	w0, [x1, 3472]
	ubfiz	x0, x0, 4, 16
	add	x0, x3, x0
	add	x0, x0, 851968
	ldr	w1, [x0, 13592]
	ldr	x0, [x0, 13584]
	str	w1, [x2, 11668]
	ubfiz	x1, x1, 4, 32
	str	x0, [sp, 112]
	add	x19, x19, x1
	b	L70
	.p2align 2,,3
L88:
	bl	_exit_check_error
	ldr	x0, [sp, 128]
	adrp	x1, lC10@PAGE
	add	x1, x1, lC10@PAGEOFF;momd
	bl	_runerror
	b	L91
	.p2align 2,,3
L54:
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L156
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 357
	bl	_typeerror
L156:
	ldr	w0, [sp, 120]
	mov	w2, 2
	and	w1, w0, 255
	ubfx	x0, x0, 16, 8
	scvtf	d0, w1
	lsl	x0, x0, 4
	add	x1, x19, x0
	fadd	d0, d0, d8
	str	w2, [x19, x0]
	ldr	x19, [sp, 136]
	str	d0, [x1, 8]
	b	L70
	.p2align 2,,3
L17:
	ldr	x0, [sp, 128]
	ldrh	w1, [sp, 120]
	bl	_literal_value
	str	x19, [sp, 136]
	stp	x0, x1, [sp, 168]
	mov	w21, w0
	mov	x20, x1
	cmp	w0, 3
	beq	L79
	ldp	x2, x3, [sp, 168]
	adrp	x4, lC5@PAGE
	ldr	x0, [sp, 128]
	adrp	x1, lC7@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC7@PAGEOFF;momd
	mov	w5, 112
	bl	_typeerror
L79:
	ldr	x0, [sp, 120]
	add	x20, x20, 24
	mov	x1, x20
	ubfx	x2, x0, 16, 8
	ldr	x0, [sp, 128]
	add	x2, x19, x2, lsl 4
	ldp	x2, x3, [x2]
	bl	_check
	cmp	w21, 3
	beq	L81
	ldp	x2, x3, [sp, 168]
	adrp	x4, lC5@PAGE
	ldr	x0, [sp, 128]
	adrp	x1, lC7@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC7@PAGEOFF;momd
	mov	w5, 113
	bl	_typeerror
L81:
	ldp	x2, x3, [sp, 184]
	mov	x0, 1
	ldr	x19, [sp, 136]
	mov	x1, x20
	bfi	x2, x0, 0, 32
	bfi	x3, x0, 0, 8
	ldr	x0, [sp, 128]
	stp	x2, x3, [sp, 184]
	bl	_expect
	b	L70
	.p2align 2,,3
L48:
	ldr	w0, [sp, 120]
	mov	w3, 1
	ubfx	x1, x0, 8, 8
	ubfx	x0, x0, 16, 8
	lsl	x1, x1, 4
	lsl	x0, x0, 4
	add	x2, x19, x0
	ldr	w1, [x19, x1]
	str	w3, [x19, x0]
	sub	w0, w1, #6
	cmp	w0, w3
	cset	w0, ls
	strb	w0, [x2, 8]
	b	L70
	.p2align 2,,3
L240:
	ldr	w0, [sp, 120]
	mov	w3, 1
	ubfx	x1, x0, 8, 8
	ubfx	x0, x0, 16, 8
	lsl	x1, x1, 4
	lsl	x0, x0, 4
	add	x2, x19, x0
	ldr	w1, [x19, x1]
	str	w3, [x19, x0]
	cmp	w1, 2
	cset	w0, eq
	strb	w0, [x2, 8]
	b	L70
	.p2align 2,,3
L37:
	ldr	w0, [sp, 120]
	mov	w3, 1
	ubfx	x1, x0, 8, 8
	ubfx	x0, x0, 16, 8
	lsl	x1, x1, 4
	lsl	x0, x0, 4
	add	x2, x19, x0
	ldr	w1, [x19, x1]
	str	w3, [x19, x0]
	cmp	w1, 5
	cset	w0, eq
	strb	w0, [x2, 8]
	b	L70
	.p2align 2,,3
L6:
	mov	x0, 61146
	b	L223
L230:
	adrp	x0, lC22@PAGE
	add	x0, x0, lC22@PAGEOFF;momd
	bl	_puts
	b	L70
	.p2align 2,,3
L23:
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L105
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 177
	bl	_typeerror
L105:
	ldr	x0, [sp, 120]
	ubfiz	x1, x0, 4, 8
	add	x0, x19, x1
	ldr	w1, [x19, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	beq	L104
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 178
	bl	_typeerror
L104:
	ldr	x0, [sp, 120]
	fmul	d8, d8, d9
	ubfx	x0, x0, 16, 8
	b	L222
	.p2align 2,,3
L244:
	ldr	x0, [sp, 128]
	ldrh	w1, [sp, 120]
	bl	_literal_value
	stp	x0, x1, [sp]
	adrp	x0, lC2@PAGE
	add	x0, x0, lC2@PAGEOFF;momd
	bl	_print
	b	L70
	.p2align 2,,3
L39:
	ldr	x0, [sp, 120]
	mov	w1, 1
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x3, x19, x0
	ldr	w2, [x19, x0]
	ldrb	w0, [x3, 8]
	cbz	w2, L146
	eor	w0, w0, w1
	cmp	w2, w1
	csel	w1, w0, wzr, eq
L146:
	ldr	x0, [sp, 120]
	mov	w3, 1
	ubfx	x0, x0, 16, 8
	lsl	x0, x0, 4
	add	x2, x19, x0
	str	w3, [x19, x0]
	strb	w1, [x2, 8]
	b	L70
	.p2align 2,,3
L234:
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L139
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 249
	bl	_typeerror
L139:
	ldr	x0, [sp, 120]
	ubfiz	x1, x0, 4, 8
	add	x0, x19, x1
	ldr	w1, [x19, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	beq	L138
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 250
	bl	_typeerror
L138:
	ldr	x0, [sp, 120]
	fcmpe	d8, d9
	mov	w3, 1
	ubfx	x0, x0, 16, 8
	cset	w2, ls
	lsl	x0, x0, 4
	add	x1, x19, x0
	str	w3, [x19, x0]
	ldr	x19, [sp, 136]
	strb	w2, [x1, 8]
	b	L70
L262:
	bl	_error_mode
	cbnz	w0, L184
	adrp	x23, ___stderrp@GOTPAGE
	ldr	x23, [x23, ___stderrp@GOTPAGEOFF]
	mov	x2, 19
	mov	x1, 1
	adrp	x0, lC17@PAGE
	add	x0, x0, lC17@PAGEOFF;momd
	ldr	x3, [x23]
	bl	_fwrite
	ldr	x2, [sp, 200]
	mov	x1, 6
	ldr	x0, [x23]
	mov	x3, x20
	bfi	x2, x1, 0, 32
	str	x2, [sp, 200]
	ldr	x1, [sp, 128]
	bl	_fprintfunname
	ldr	x1, [x23]
	mov	w0, 10
	bl	_fputc
L184:
	ldr	x0, [sp, 128]
	str	w21, [sp]
	adrp	x1, lC21@PAGE
	add	x1, x1, lC21@PAGEOFF;momd
	bl	_runerror
	b	L182
L261:
	ldr	x3, [sp, 112]
	mov	w1, w25
	ldr	x2, [sp, 152]
	ldr	x26, [sp, 128]
	mov	x0, x26
	bl	_lastglobalset
	mov	w3, w25
	mov	x1, x0
	adrp	x2, lC20@PAGE
	mov	x0, x26
	add	x2, x2, lC20@PAGEOFF;momd
	bl	_nilfunerror
	ldr	w0, [x19, x20]
	b	L177
L259:
	ldr	x21, [sp, 128]
	str	w20, [sp]
	adrp	x1, lC15@PAGE
	add	x1, x1, lC15@PAGEOFF;momd
	mov	x0, x21
	bl	_runerror
	add	x0, x21, 942080
	ldrh	w0, [x0, 3472]
	b	L159
L258:
	ldr	x0, [sp, 128]
	adrp	x1, lC13@PAGE
	add	x1, x1, lC13@PAGEOFF;momd
	bl	_runerror
	b	L108
L253:
	bl	_error_mode
	cbnz	w0, L175
	adrp	x19, ___stderrp@GOTPAGE
	ldr	x19, [x19, ___stderrp@GOTPAGEOFF]
	mov	x2, 19
	mov	x1, 1
	adrp	x0, lC17@PAGE
	add	x0, x0, lC17@PAGEOFF;momd
	ldr	x3, [x19]
	bl	_fwrite
	ldr	x2, [sp, 208]
	mov	x1, 6
	ldr	x0, [x19]
	mov	x3, x22
	bfi	x2, x1, 0, 32
	str	x2, [sp, 208]
	ldr	x1, [sp, 128]
	bl	_fprintfunname
	ldr	x1, [x19]
	mov	w0, 10
	bl	_fputc
L175:
	ldr	x19, [sp, 128]
	str	w21, [sp]
	adrp	x1, lC18@PAGE
	add	x1, x1, lC18@PAGEOFF;momd
	mov	x0, x19
	bl	_runerror
	add	x0, x19, 933888
	ldr	w2, [x0, 11668]
	b	L170
L249:
	ldr	x0, [sp, 128]
	adrp	x1, lC13@PAGE
	add	x1, x1, lC13@PAGEOFF;momd
	bl	_runerror
	b	L114
L251:
	ldr	x3, [sp, 112]
	mov	w1, w25
	ldr	x2, [sp, 152]
	ldr	x26, [sp, 128]
	mov	x0, x26
	bl	_lastglobalset
	mov	w3, w25
	mov	x1, x0
	adrp	x2, lC1@PAGE
	mov	x0, x26
	add	x2, x2, lC1@PAGEOFF;momd
	bl	_nilfunerror
	ldr	w0, [x19, x22]
	b	L164
L260:
	neg	w1, w1
	mov	x0, x5
	and	w1, w1, 65535
	bl	_literal_value
	stp	x0, x1, [sp, 168]
	mov	x19, x1
	cmp	w0, 3
	beq	L163
	ldp	x2, x3, [sp, 168]
	adrp	x4, lC5@PAGE
	ldr	x0, [sp, 128]
	adrp	x1, lC7@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC7@PAGEOFF;momd
	mov	w5, 396
	bl	_typeerror
L163:
	ldr	x0, [sp, 128]
	add	x1, x19, 24
	bl	_fail_check_error
	ldr	x19, [sp, 136]
	b	L70
L252:
	bl	_error_mode
	cbnz	w0, L172
	adrp	x19, ___stderrp@GOTPAGE
	ldr	x19, [x19, ___stderrp@GOTPAGEOFF]
	mov	x2, 19
	mov	x1, 1
	adrp	x0, lC17@PAGE
	add	x0, x0, lC17@PAGEOFF;momd
	ldr	x3, [x19]
	bl	_fwrite
	ldr	x2, [sp, 216]
	mov	x1, 6
	ldr	x0, [x19]
	mov	x3, x22
	bfi	x2, x1, 0, 32
	str	x2, [sp, 216]
	ldr	x1, [sp, 128]
	bl	_fprintfunname
	ldr	x1, [x19]
	mov	w0, 10
	bl	_fputc
L172:
	ldr	x0, [sp, 128]
	str	w21, [sp]
	adrp	x1, lC16@PAGE
	add	x1, x1, lC16@PAGEOFF;momd
	bl	_runerror
	b	L167
L239:
	cmp	w0, 32
	beq	L267
	ldr	w20, [sp, 120]
	ubfx	x0, x20, 8, 8
	add	x0, x19, x0, lsl 4
	ldp	x0, x1, [x0]
	bl	_hashvalue
	ucvtf	d0, w0
	ubfx	x1, x20, 16, 8
	mov	w2, 2
	lsl	x0, x1, 4
	add	x1, x19, x0
	str	w2, [x19, x0]
	str	d0, [x1, 8]
	b	L70
L267:
	ldr	x0, [sp, 120]
	mov	x1, 1
	ldr	x2, [sp, 168]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	bfi	x2, x1, 0, 32
	str	x2, [sp, 168]
	add	x2, x19, x0
	mov	w1, 0
	ldr	w0, [x19, x0]
	ldrb	w2, [x2, 8]
	cbz	w0, L147
	cmp	w0, 1
	csinc	w1, w2, wzr, eq
L147:
	ldr	x0, [sp, 120]
	ldp	x3, x2, [sp, 168]
	ubfx	x0, x0, 16, 8
	lsl	x0, x0, 4
	bfi	x2, x1, 0, 8
	add	x1, x19, x0
	str	x3, [x19, x0]
	str	x2, [sp, 176]
	str	x2, [x1, 8]
	b	L70
L243:
	cmp	w0, 1
	beq	L12
	cmp	w0, 2
	bne	L268
	ldr	x0, [sp, 120]
	ubfx	x1, x0, 16, 8
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;momd
	add	x1, x19, x1, lsl 4
	ldp	x2, x3, [x1]
	stp	x2, x3, [sp]
	bl	_print
	b	L70
L12:
	ldr	x0, [sp, 120]
	ubfx	x1, x0, 16, 8
	adrp	x0, lC2@PAGE
	add	x0, x0, lC2@PAGEOFF;momd
	add	x1, x19, x1, lsl 4
	ldp	x2, x3, [x1]
	stp	x2, x3, [sp]
	bl	_print
	b	L70
L233:
	cmp	w0, 19
	beq	L269
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L131
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 237
	bl	_typeerror
L131:
	ldr	x0, [sp, 120]
	ubfiz	x1, x0, 4, 8
	add	x0, x19, x1
	ldr	w1, [x19, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	beq	L130
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 238
	bl	_typeerror
L130:
	ldr	x0, [sp, 120]
	fcmpe	d8, d9
	mov	w3, 1
	ubfx	x0, x0, 16, 8
	cset	w2, mi
	lsl	x0, x0, 4
	add	x1, x19, x0
	str	w3, [x19, x0]
	ldr	x19, [sp, 136]
	strb	w2, [x1, 8]
	b	L70
L269:
	ldr	x0, [sp, 120]
	str	x19, [sp, 136]
	ubfiz	x0, x0, 4, 8
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L121
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 210
	bl	_typeerror
L121:
	fcvtzs	x20, d8
	cbz	x20, L270
L120:
	ldr	x0, [sp, 120]
	ubfx	x0, x0, 8, 8
	lsl	x0, x0, 4
	add	x1, x19, x0
	ldr	w0, [x19, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L123
	ldr	x0, [sp, 128]
	adrp	x4, lC5@PAGE
	adrp	x1, lC6@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC6@PAGEOFF;momd
	mov	w5, 215
	bl	_typeerror
L123:
	fcvtzs	x1, d8
	mov	w4, 2
	ldr	x0, [sp, 120]
	ubfx	x2, x0, 16, 8
	sdiv	x0, x1, x20
	lsl	x2, x2, 4
	add	x3, x19, x2
	msub	x0, x0, x20, x1
	str	w4, [x19, x2]
	ldr	x19, [sp, 136]
	scvtf	d0, x0
	str	d0, [x3, 8]
	b	L70
L270:
	ldr	x0, [sp, 128]
	adrp	x1, lC13@PAGE
	add	x1, x1, lC13@PAGEOFF;momd
	bl	_runerror
	b	L120
L236:
	cmp	w0, 7
	beq	L271
	ldr	x0, [sp, 128]
	ldrh	w1, [sp, 120]
	bl	_literal_value
	str	x19, [sp, 136]
	stp	x0, x1, [sp, 168]
	mov	x20, x1
	cmp	w0, 3
	beq	L76
	ldp	x2, x3, [sp, 168]
	adrp	x4, lC5@PAGE
	ldr	x0, [sp, 128]
	adrp	x1, lC7@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC7@PAGEOFF;momd
	mov	w5, 107
	bl	_typeerror
L76:
	ldr	x0, [sp, 120]
	add	x1, x20, 24
	ubfx	x2, x0, 16, 8
	add	x2, x19, x2, lsl 4
	ldp	x0, x19, [sp, 128]
	ldp	x2, x3, [x2]
	bl	_expect
	b	L70
L271:
	ldr	x0, [sp, 128]
	ldrh	w1, [sp, 120]
	bl	_literal_value
	str	x19, [sp, 136]
	stp	x0, x1, [sp, 168]
	mov	x20, x1
	cmp	w0, 3
	beq	L74
	ldp	x2, x3, [sp, 168]
	adrp	x4, lC5@PAGE
	ldr	x0, [sp, 128]
	adrp	x1, lC7@PAGE
	add	x4, x4, lC5@PAGEOFF;momd
	add	x1, x1, lC7@PAGEOFF;momd
	mov	w5, 102
	bl	_typeerror
L74:
	ldr	x0, [sp, 120]
	add	x1, x20, 24
	ubfx	x2, x0, 16, 8
	add	x2, x19, x2, lsl 4
	ldp	x0, x19, [sp, 128]
	ldp	x2, x3, [x2]
	bl	_check
	b	L70
L264:
	adrp	x3, ___stderrp@GOTPAGE
	ldr	x3, [x3, ___stderrp@GOTPAGEOFF]
	mov	x2, 44
	mov	x1, 1
	adrp	x0, lC8@PAGE
	add	x0, x0, lC8@PAGEOFF;momd
	ldr	x3, [x3]
	bl	_fwrite
	bl	_abort
L266:
	adrp	x3, lC12@PAGE
	adrp	x1, lC5@PAGE
	adrp	x0, ___func__.0@PAGE
	add	x3, x3, lC12@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	add	x0, x0, ___func__.0@PAGEOFF;momd
	mov	w2, 142
	bl	___assert_rtn
L263:
	adrp	x3, lC19@PAGE
	adrp	x1, lC5@PAGE
	adrp	x0, ___func__.0@PAGE
	add	x3, x3, lC19@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	add	x0, x0, ___func__.0@PAGEOFF;momd
	mov	w2, 490
	bl	___assert_rtn
L254:
	adrp	x3, lC19@PAGE
	adrp	x1, lC5@PAGE
	adrp	x0, ___func__.0@PAGE
	add	x3, x3, lC19@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	add	x0, x0, ___func__.0@PAGEOFF;momd
	mov	w2, 448
	bl	___assert_rtn
LFE44:
	.const
	.align	3
___func__.0:
	.ascii "vmrun\0"
	.section __TEXT,__eh_frame,coalesced,no_toc+strip_static_syms+live_support
EH_frame1:
	.set L$set$0,LECIE1-LSCIE1
	.long L$set$0
LSCIE1:
	.long	0
	.byte	0x1
	.ascii "zR\0"
	.uleb128 0x1
	.sleb128 -8
	.byte	0x1e
	.uleb128 0x1
	.byte	0x10
	.byte	0xc
	.uleb128 0x1f
	.uleb128 0
	.align	3
LECIE1:
LSFDE1:
	.set L$set$1,LEFDE1-LASFDE1
	.long L$set$1
LASFDE1:
	.long	LASFDE1-EH_frame1
	.quad	LFB44-.
	.set L$set$2,LFE44-LFB44
	.quad L$set$2
	.uleb128 0
	.byte	0x4
	.set L$set$3,LCFI0-LFB44
	.long L$set$3
	.byte	0xe
	.uleb128 0xe0
	.byte	0x4
	.set L$set$4,LCFI1-LCFI0
	.long L$set$4
	.byte	0x9d
	.uleb128 0x1a
	.byte	0x9e
	.uleb128 0x19
	.byte	0x4
	.set L$set$5,LCFI2-LCFI1
	.long L$set$5
	.byte	0x93
	.uleb128 0x18
	.byte	0x94
	.uleb128 0x17
	.byte	0x4
	.set L$set$6,LCFI3-LCFI2
	.long L$set$6
	.byte	0x95
	.uleb128 0x16
	.byte	0x96
	.uleb128 0x15
	.byte	0x97
	.uleb128 0x14
	.byte	0x98
	.uleb128 0x13
	.byte	0x99
	.uleb128 0x12
	.byte	0x9a
	.uleb128 0x11
	.byte	0x5
	.uleb128 0x48
	.uleb128 0x10
	.byte	0x5
	.uleb128 0x49
	.uleb128 0xf
	.byte	0x4
	.set L$set$7,LCFI4-LCFI3
	.long L$set$7
	.byte	0xa
	.byte	0xdd
	.byte	0xde
	.byte	0xd9
	.byte	0xda
	.byte	0xd7
	.byte	0xd8
	.byte	0xd5
	.byte	0xd6
	.byte	0xd3
	.byte	0xd4
	.byte	0x6
	.uleb128 0x48
	.byte	0x6
	.uleb128 0x49
	.byte	0xe
	.uleb128 0
	.byte	0x4
	.set L$set$8,LCFI5-LCFI4
	.long L$set$8
	.byte	0xb
	.align	3
LEFDE1:
	.ident	"GCC: (Homebrew GCC 12.2.0) 12.2.0"
	.subsections_via_symbols

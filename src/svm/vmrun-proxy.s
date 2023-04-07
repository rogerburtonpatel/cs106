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
	.ascii "vmrun.c\0"
	.align	3
lC5:
	.ascii "a number\0"
	.align	3
lC6:
	.ascii "%U\0"
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
	.ascii "Offending function:\0"
	.align	3
lC17:
	.ascii "attempting to call function in register %hhu caused a Stack Overflow\0"
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
	ldr	w0, [x1, 4]
	cmp	w0, 0
	ble	L138
	stp	x21, x22, [sp, 48]
LCFI3:
	mov	x21, x19
	adrp	x0, lC0@PAGE
	add	x0, x0, lC0@PAGEOFF;momd
	stp	x23, x24, [sp, 64]
LCFI4:
	stp	x25, x26, [sp, 80]
LCFI5:
	mov	x25, x1
	stp	x27, x28, [sp, 96]
LCFI6:
	add	x27, x25, 12
	stp	d8, d9, [sp, 112]
LCFI7:
	bl	_svmdebug_value
	mov	x20, x0
	adrp	x0, lC1@PAGE
	add	x0, x0, lC1@PAGEOFF;momd
	bl	_svmdebug_value
	str	x27, [x21], 16
	mov	x28, x21
	str	x28, [sp, 136]
	adrp	x21, ___stderrp@GOTPAGE
	ldr	x21, [x21, ___stderrp@GOTPAGEOFF]
	.p2align 3,,7
L3:
	ldr	w26, [x27]
	cbz	x20, L4
	ldr	x1, [x19]
	ubfx	x6, x26, 8, 8
	ldr	x0, [x21]
	subs	x1, x27, x1
	add	x2, x1, 3
	ubfx	x5, x26, 16, 8
	csel	x2, x2, x1, mi
	ubfiz	x7, x26, 4, 8
	add	x6, x28, x6, lsl 4
	add	x5, x28, x5, lsl 4
	add	x7, x28, x7
	mov	w3, w26
	ubfx	x2, x2, 2, 32
	mov	x1, x19
	mov	x4, 0
	bl	_idump
L4:
	lsr	w0, w26, 24
	cmp	w0, 24
	beq	L5
	bhi	L6
	cmp	w0, 12
	beq	L7
	bhi	L8
	cmp	w0, 6
	beq	L9
	bls	L265
	cmp	w0, 9
	beq	L18
	bls	L266
	cmp	w0, 10
	beq	L267
	mov	x0, 50001
L263:
	add	x0, x0, w26, uxth
	ubfx	x1, x26, 16, 8
	add	x0, x19, x0, lsl 4
	add	x1, x28, x1, lsl 4
	ldp	x2, x3, [x0]
	stp	x2, x3, [x1]
L71:
	add	x27, x27, 4
	b	L3
	.p2align 2,,3
L265:
	cmp	w0, 3
	beq	L11
	bls	L268
	cmp	w0, 4
	beq	L269
	and	w1, w26, 65535
	mov	x0, x19
	bl	_literal_value
	stp	x0, x1, [sp]
	add	x27, x27, 4
	adrp	x0, lC3@PAGE
	add	x0, x0, lC3@PAGEOFF;momd
	bl	_print
	b	L3
	.p2align 2,,3
L8:
	cmp	w0, 18
	beq	L24
	bls	L270
	cmp	w0, 21
	beq	L32
	bls	L271
	cmp	w0, 22
	beq	L272
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	bne	L273
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	bne	L274
L104:
	ubfx	x0, x26, 16, 8
	fcmpe	d9, d8
	mov	w3, 1
	lsl	x0, x0, 4
	add	x1, x28, x0
	cset	w2, ls
	str	w3, [x28, x0]
	strb	w2, [x1, 8]
L313:
	add	x27, x27, 4
	b	L3
	.p2align 2,,3
L270:
	cmp	w0, 15
	beq	L26
	bls	L275
	cmp	w0, 16
	beq	L276
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	bne	L277
	fcvtzs	d9, d9
	scvtf	d9, d9
	fcmp	d9, #0.0
	beq	L278
L92:
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	bne	L279
L93:
	fcvtzs	d0, d8
	ubfx	x0, x26, 16, 8
	mov	w2, 2
	add	x27, x27, 4
	lsl	x0, x0, 4
	add	x1, x28, x0
	scvtf	d0, d0
	str	w2, [x28, x0]
	fdiv	d0, d0, d9
	str	d0, [x1, 8]
	b	L3
L275:
	cmp	w0, 13
	beq	L280
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	bne	L281
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	bne	L282
L83:
	fadd	d0, d8, d9
	ubfx	x0, x26, 16, 8
L262:
	lsl	x0, x0, 4
	mov	w2, 2
	add	x1, x28, x0
	add	x27, x27, 4
	str	w2, [x28, x0]
	str	d0, [x1, 8]
	b	L3
	.p2align 2,,3
L6:
	cmp	w0, 37
	beq	L38
	bhi	L39
	cmp	w0, 31
	beq	L40
	bls	L283
	cmp	w0, 34
	beq	L49
	bls	L284
	cmp	w0, 35
	beq	L285
	ubfx	x1, x26, 8, 8
	ubfx	x0, x26, 16, 8
	mov	w3, 1
	add	x27, x27, 4
	lsl	x1, x1, 4
	lsl	x0, x0, 4
	add	x2, x28, x0
	ldr	w1, [x28, x1]
	str	w3, [x28, x0]
	cmp	w1, 3
	cset	w0, eq
	strb	w0, [x2, 8]
	b	L3
	.p2align 2,,3
L39:
	cmp	w0, 43
	beq	L55
	bls	L286
	cmp	w0, 46
	beq	L63
	bls	L287
	cmp	w0, 50
	bne	L288
	ubfx	x0, x26, 16, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	cbz	w0, L115
	cmp	w0, 1
	bne	L71
	ldrb	w0, [x1, 8]
	cbnz	w0, L71
L115:
	add	x27, x27, 4
	add	x27, x27, 4
	b	L3
	.p2align 2,,3
L288:
	cmp	w0, 51
	bne	L289
	sbfx	x0, x26, 0, 24
	add	w0, w0, 1
	add	x27, x27, w0, sxtw 2
	b	L3
	.p2align 2,,3
L286:
	cmp	w0, 40
	beq	L57
	bls	L290
	cmp	w0, 41
	beq	L291
	ubfx	x0, x26, 8, 8
	ubfx	x1, x26, 16, 8
	add	x27, x27, 4
	lsl	x0, x0, 4
	lsl	x1, x1, 4
	add	x4, x28, x0
	add	x5, x28, x1
	ldr	x22, [x28, x1]
	ldp	x2, x3, [x4]
	ldr	x23, [x5, 8]
	stp	x2, x3, [x5]
	str	x22, [x28, x0]
	str	x23, [x4, 8]
	b	L3
	.p2align 2,,3
L283:
	cmp	w0, 28
	beq	L42
	bls	L292
	cmp	w0, 29
	beq	L293
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	bne	L294
L107:
	fcvtzs	d0, d8
	ubfx	x0, x26, 16, 8
	mov	w2, 2
	add	x27, x27, 4
	lsl	x0, x0, 4
	add	x1, x28, x0
	neg	d0, d0
	str	w2, [x28, x0]
	scvtf	d0, d0
	str	d0, [x1, 8]
	b	L3
L292:
	cmp	w0, 26
	beq	L44
	cmp	w0, 27
	bne	L295
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x3, x28, x0
	ldr	w1, [x28, x0]
	ldr	x2, [x28, x0]
	ldr	x24, [x3, 8]
	cmp	w1, 5
	bne	L296
	ubfx	x8, x26, 16, 8
	ldp	x0, x1, [x24, 24]
	add	x8, x28, x8, lsl 4
	stp	x0, x1, [x8]
L329:
	add	x27, x27, 4
	b	L3
L290:
	cmp	w0, 38
	beq	L297
	ubfx	x1, x26, 8, 8
	ubfx	x0, x26, 16, 8
	mov	w3, 1
	add	x27, x27, 4
	lsl	x1, x1, 4
	lsl	x0, x0, 4
	add	x2, x28, x0
	ldr	w1, [x28, x1]
	str	w3, [x28, x0]
	cmp	w1, 4
	cset	w0, eq
	strb	w0, [x2, 8]
	b	L3
L336:
	ldp	x21, x22, [sp, 48]
LCFI8:
	ldp	x23, x24, [sp, 64]
LCFI9:
	ldp	x25, x26, [sp, 80]
LCFI10:
	ldp	d8, d9, [sp, 112]
LCFI11:
	str	x27, [x19, 8]
	ldp	x27, x28, [sp, 96]
LCFI12:
L138:
	ldp	x29, x30, [sp, 16]
	ldp	x19, x20, [sp, 32]
	add	sp, sp, 224
LCFI13:
	ret
	.p2align 2,,3
L57:
LCFI14:
	ubfx	x1, x26, 8, 8
	ubfx	x0, x26, 16, 8
	mov	w3, 1
	add	x27, x27, 4
	lsl	x1, x1, 4
	lsl	x0, x0, 4
	add	x2, x28, x0
	ldr	w1, [x28, x1]
	str	w3, [x28, x0]
	cmp	w1, 0
	cset	w0, eq
	strb	w0, [x2, 8]
	b	L3
	.p2align 2,,3
L40:
	ubfx	x0, x26, 8, 8
	mov	w1, 1
	lsl	x0, x0, 4
	add	x3, x28, x0
	ldr	w2, [x28, x0]
	ldrb	w0, [x3, 8]
	cbz	w2, L108
	eor	w0, w0, w1
	cmp	w2, w1
	csel	w1, w0, wzr, eq
L108:
	ubfx	x0, x26, 16, 8
	mov	w3, 1
	add	x27, x27, 4
	lsl	x0, x0, 4
	add	x2, x28, x0
	str	w3, [x28, x0]
	strb	w1, [x2, 8]
	b	L3
	.p2align 2,,3
L291:
	ubfx	x1, x26, 8, 8
	ubfx	x0, x26, 16, 8
	add	x27, x27, 4
	add	x1, x28, x1, lsl 4
	add	x0, x28, x0, lsl 4
	ldp	x2, x3, [x1]
	stp	x2, x3, [x0]
	b	L3
	.p2align 2,,3
L55:
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	bne	L298
L114:
	and	w1, w26, 255
	ubfx	x0, x26, 16, 8
	mov	w2, 2
	add	x27, x27, 4
	scvtf	d0, w1
	lsl	x0, x0, 4
	add	x1, x28, x0
	str	w2, [x28, x0]
	fadd	d0, d0, d8
	str	d0, [x1, 8]
	b	L3
	.p2align 2,,3
L38:
	ubfx	x1, x26, 8, 8
	ubfx	x0, x26, 16, 8
	mov	w3, 1
	add	x27, x27, 4
	lsl	x1, x1, 4
	lsl	x0, x0, 4
	add	x2, x28, x0
	ldr	w1, [x28, x1]
	str	w3, [x28, x0]
	cmp	w1, 5
	cset	w0, eq
	strb	w0, [x2, 8]
	b	L3
	.p2align 2,,3
L276:
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	bne	L299
	fcmp	d9, #0.0
	beq	L300
L89:
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	bne	L301
L90:
	fdiv	d0, d8, d9
	ubfx	x0, x26, 16, 8
	b	L262
	.p2align 2,,3
L26:
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	bne	L302
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	bne	L303
L85:
	fsub	d0, d8, d9
	ubfx	x0, x26, 16, 8
	b	L262
	.p2align 2,,3
L63:
	ubfx	x24, x26, 16, 8
	ubfx	x6, x26, 8, 8
	sub	w0, w6, w24
	str	x24, [sp, 144]
	lsl	x4, x24, 4
	and	w0, w0, 255
	mov	w26, w0
	add	x5, x28, x4
	ldr	w0, [x28, x4]
	cbz	w0, L304
	ldp	x2, x3, [x5]
	ldr	x27, [x5, 8]
	cmp	w0, 6
	bne	L305
L129:
	add	x0, x19, 933888
	mov	w1, 49999
	ldr	w0, [x0, 11668]
	add	w6, w6, w0
	cmp	w6, w1
	bhi	L306
L130:
	add	x4, x28, 16
	lsl	x24, x24, 4
	add	x4, x4, w26, uxtw 4
	mov	x0, x28
	.p2align 3,,7
L132:
	add	x1, x0, x24
	ldp	x2, x3, [x1]
	stp	x2, x3, [x0], 16
	cmp	x4, x0
	bne	L132
	ldr	w0, [x27]
	cmp	w0, w26
	bne	L307
	add	x27, x27, 8
	add	x27, x27, 4
	b	L3
L289:
	adrp	x0, lC22@PAGE
	add	x27, x27, 4
	add	x0, x0, lC22@PAGEOFF;momd
	bl	_puts
	b	L3
	.p2align 2,,3
L285:
	ubfx	x1, x26, 8, 8
	ubfx	x0, x26, 16, 8
	mov	w3, 1
	add	x27, x27, 4
	lsl	x1, x1, 4
	lsl	x0, x0, 4
	add	x2, x28, x0
	ldr	w1, [x28, x1]
	str	w3, [x28, x0]
	cmp	w1, 2
	cset	w0, eq
	strb	w0, [x2, 8]
	b	L3
	.p2align 2,,3
L49:
	ubfx	x1, x26, 8, 8
	ubfx	x0, x26, 16, 8
	mov	w3, 1
	add	x27, x27, 4
	lsl	x1, x1, 4
	lsl	x0, x0, 4
	add	x2, x28, x0
	ldr	w1, [x28, x1]
	str	w3, [x28, x0]
	sub	w0, w1, #6
	cmp	w0, w3
	cset	w0, ls
	strb	w0, [x2, 8]
	b	L3
L295:
	ubfx	x0, x26, 8, 8
	ubfiz	x1, x26, 4, 8
	add	x4, x28, x1
	lsl	x0, x0, 4
	add	x5, x28, x0
	ldr	w3, [x28, x1]
	ldr	x24, [x28, x1]
	ldr	x22, [x28, x0]
	ldr	x0, [x4, 8]
	str	x0, [sp, 144]
	ldr	x23, [x5, 8]
	cmp	w3, 4
	beq	L110
	cmp	w3, 5
	bne	L308
	mov	w3, 5
L110:
	mov	x0, 36
	str	w3, [sp, 152]
	bl	_vmalloc_raw
	stp	x22, x23, [x0, 8]
	ldr	w3, [sp, 152]
	ubfx	x1, x26, 16, 8
	mov	w4, 2
	str	w4, [x0]
	mov	w2, 5
	lsl	x1, x1, 4
	bfi	x24, x3, 0, 32
	ldr	x4, [sp, 144]
	add	x3, x28, x1
	str	x24, [x0, 24]
	add	x27, x27, 4
	str	x4, [x0, 32]
	str	w2, [x28, x1]
	str	x0, [x3, 8]
	b	L3
	.p2align 2,,3
L44:
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x3, x28, x0
	ldr	w1, [x28, x0]
	ldr	x2, [x28, x0]
	ldr	x24, [x3, 8]
	cmp	w1, 5
	bne	L309
	ubfx	x8, x26, 16, 8
	ldp	x0, x1, [x24, 8]
	add	x8, x28, x8, lsl 4
	stp	x0, x1, [x8]
L330:
	add	x27, x27, 4
	b	L3
	.p2align 2,,3
L293:
	ubfx	x0, x26, 16, 8
	lsl	x0, x0, 4
	add	x24, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x24]
	ldr	d8, [x24, 8]
	cmp	w0, 2
	bne	L310
	fmov	d0, 1.0e+0
	mov	w0, 2
	str	w0, [x24]
	fsub	d0, d8, d0
	str	d0, [x24, 8]
L328:
	add	x27, x27, 4
	b	L3
	.p2align 2,,3
L42:
	ubfx	x0, x26, 16, 8
	lsl	x0, x0, 4
	add	x24, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x24]
	ldr	d8, [x24, 8]
	cmp	w0, 2
	bne	L311
	fmov	d0, 1.0e+0
	mov	w0, 2
	str	w0, [x24]
	fadd	d0, d8, d0
	str	d0, [x24, 8]
L327:
	add	x27, x27, 4
	b	L3
	.p2align 2,,3
L272:
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d9, [x1, 8]
	cmp	w0, 2
	bne	L312
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d8, [x0, 8]
	cmp	w1, 2
	beq	L104
L326:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 250
	bl	_typeerror
	fcmpe	d9, d8
	ubfx	x0, x26, 16, 8
	mov	w3, 1
	lsl	x0, x0, 4
	add	x1, x28, x0
	cset	w2, ls
	str	w3, [x28, x0]
	strb	w2, [x1, 8]
	b	L313
	.p2align 2,,3
L32:
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d9, [x1, 8]
	cmp	w0, 2
	bne	L314
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d8, [x0, 8]
	cmp	w1, 2
	bne	L315
L98:
	ubfx	x0, x26, 16, 8
	fcmpe	d9, d8
	mov	w3, 1
	lsl	x0, x0, 4
	add	x1, x28, x0
	cset	w2, gt
	str	w3, [x28, x0]
	strb	w2, [x1, 8]
L325:
	add	x27, x27, 4
	b	L3
	.p2align 2,,3
L24:
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	bne	L316
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	bne	L317
L87:
	fmul	d0, d8, d9
	ubfx	x0, x26, 16, 8
	b	L262
	.p2align 2,,3
L9:
	ubfx	x8, x26, 16, 8
	mov	x0, x19
	adrp	x1, lC2@PAGE
	add	x27, x27, 4
	add	x8, x28, x8, lsl 4
	add	x1, x1, lC2@PAGEOFF;momd
	ldp	x2, x3, [x8]
	stp	x2, x3, [sp]
	bl	_runerror_p
	b	L3
	.p2align 2,,3
L267:
	bl	_error_mode
	cmp	w0, 1
	beq	L318
	ubfx	x0, x26, 16, 8
	mov	x1, x0
	lsl	x0, x0, 4
	add	x24, x28, x0
	ldr	w0, [x28, x0]
	cbz	w0, L319
	bl	_add_test
	bl	_enter_check_error
	adrp	x0, _testjmp@GOTPAGE
	ldr	x0, [x0, _testjmp@GOTPAGEOFF]
	bl	_setjmp_proxy
	cbnz	w0, L78
L332:
	add	x6, x19, 942080
	mov	w0, 5000
	ldrh	w1, [x6, 3472]
	cmp	w1, w0
	beq	L320
L79:
	ldr	w0, [x24]
	ldp	x2, x3, [x24]
	ldr	x24, [x24, 8]
	cmp	w0, 6
	bne	L321
L80:
	ldr	w0, [x24]
	cbnz	w0, L322
	ldrh	w0, [x6, 3472]
	add	x2, x19, 933888
	and	w1, w26, 65535
	add	w3, w0, 1
	neg	w1, w1
	ubfiz	x0, x0, 4, 16
	ldr	w2, [x2, 11668]
	add	x0, x19, x0
	strh	w3, [x6, 3472]
	add	x0, x0, 851968
	str	x27, [x0, 13584]
	add	x27, x24, 8
	add	x27, x27, 4
	str	w2, [x0, 13592]
	str	w1, [x0, 13596]
	b	L3
	.p2align 2,,3
L18:
	and	w1, w26, 65535
	mov	x0, x19
	bl	_literal_value
	mov	x22, x0
	ubfx	x8, x26, 16, 8
	mov	x23, x1
	add	x24, x28, x8, lsl 4
	cmp	w0, 3
	bne	L323
	ldp	x2, x3, [x24]
	add	x6, x1, 24
	mov	x1, x6
	mov	x0, x19
	str	x6, [sp, 144]
	bl	_check
	ldr	x6, [sp, 144]
L134:
	mov	x0, 1
	ldp	x2, x3, [sp, 160]
	mov	x1, x6
	add	x27, x27, 4
	bfi	x2, x0, 0, 32
	bfi	x3, x0, 0, 8
	mov	x0, x19
	stp	x2, x3, [sp, 160]
	bl	_expect
	b	L3
	.p2align 2,,3
L269:
	and	w1, w26, 65535
	mov	x0, x19
	bl	_literal_value
	stp	x0, x1, [sp]
	add	x27, x27, 4
	adrp	x0, lC2@PAGE
	add	x0, x0, lC2@PAGEOFF;momd
	bl	_print
	b	L3
	.p2align 2,,3
L11:
	ubfx	x0, x26, 16, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	bne	L324
	fcvtzu	w1, d8
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;momd
	str	w1, [sp]
	bl	_print
L331:
	add	x27, x27, 4
	b	L3
	.p2align 2,,3
L280:
	ubfx	x1, x26, 16, 8
	mov	x0, 61146
	add	x0, x0, w26, uxth
	add	x27, x27, 4
	add	x1, x28, x1, lsl 4
	add	x0, x19, x0, lsl 4
	ldp	x2, x3, [x1]
	stp	x2, x3, [x0]
	b	L3
	.p2align 2,,3
L7:
	mov	x0, 61146
	b	L263
	.p2align 2,,3
L5:
	ubfx	x0, x26, 8, 8
	ubfiz	x1, x26, 4, 8
	add	x1, x28, x1
	add	x27, x27, 4
	add	x0, x28, x0, lsl 4
	ldp	x2, x3, [x1]
	ldp	x0, x1, [x0]
	bl	_eqvalue
	ubfx	x1, x26, 16, 8
	mov	w3, 1
	lsl	x1, x1, 4
	add	x2, x28, x1
	str	w3, [x28, x1]
	strb	w0, [x2, 8]
	b	L3
	.p2align 2,,3
L297:
	ubfx	x1, x26, 8, 8
	ubfx	x0, x26, 16, 8
	mov	w3, 1
	add	x27, x27, 4
	lsl	x1, x1, 4
	lsl	x0, x0, 4
	add	x2, x28, x0
	ldr	w1, [x28, x1]
	str	w3, [x28, x0]
	cmp	w1, w3
	cset	w0, eq
	strb	w0, [x2, 8]
	b	L3
L317:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 178
	bl	_typeerror
	fmul	d0, d8, d9
	ubfx	x0, x26, 16, 8
	b	L262
L316:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 177
	bl	_typeerror
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	beq	L87
	b	L317
L315:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 232
	bl	_typeerror
	fcmpe	d9, d8
	ubfx	x0, x26, 16, 8
	mov	w3, 1
	lsl	x0, x0, 4
	add	x1, x28, x0
	cset	w2, gt
	str	w3, [x28, x0]
	strb	w2, [x1, 8]
	b	L325
L314:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 231
	bl	_typeerror
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d8, [x0, 8]
	cmp	w1, 2
	beq	L98
	b	L315
L312:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 249
	bl	_typeerror
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d8, [x0, 8]
	cmp	w1, 2
	beq	L104
	b	L326
L311:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 256
	bl	_typeerror
	fmov	d0, 1.0e+0
	mov	w0, 2
	str	w0, [x24]
	fadd	d0, d8, d0
	str	d0, [x24, 8]
	b	L327
L310:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 260
	bl	_typeerror
	fmov	d0, 1.0e+0
	mov	w0, 2
	str	w0, [x24]
	fsub	d0, d8, d0
	str	d0, [x24, 8]
	b	L328
L296:
	mov	x0, x19
	mov	x3, x24
	adrp	x4, lC4@PAGE
	adrp	x1, lC14@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC14@PAGEOFF;momd
	mov	w5, 352
	bl	_typeerror
	ubfx	x8, x26, 16, 8
	ldp	x0, x1, [x24, 24]
	add	x8, x28, x8, lsl 4
	stp	x0, x1, [x8]
	b	L329
L294:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 265
	bl	_typeerror
	b	L107
L301:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 188
	bl	_typeerror
	fdiv	d0, d8, d9
	ubfx	x0, x26, 16, 8
	b	L262
L299:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 183
	bl	_typeerror
	fcmp	d9, #0.0
	bne	L89
	b	L300
L298:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 357
	bl	_typeerror
	b	L114
L305:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC11@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC11@PAGEOFF;momd
	mov	w5, 472
	str	w6, [sp, 152]
	bl	_typeerror
	add	x0, x19, 933888
	ldr	w6, [sp, 152]
	mov	w1, 49999
	ldr	w0, [x0, 11668]
	add	w6, w6, w0
	cmp	w6, w1
	bls	L130
	b	L306
L303:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 173
	bl	_typeerror
	fsub	d0, d8, d9
	ubfx	x0, x26, 16, 8
	b	L262
L302:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 172
	bl	_typeerror
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	beq	L85
	b	L303
L309:
	mov	x0, x19
	mov	x3, x24
	adrp	x4, lC4@PAGE
	adrp	x1, lC14@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC14@PAGEOFF;momd
	mov	w5, 349
	bl	_typeerror
	ubfx	x8, x26, 16, 8
	ldp	x0, x1, [x24, 8]
	add	x8, x28, x8, lsl 4
	stp	x0, x1, [x8]
	b	L330
L282:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 167
	bl	_typeerror
	b	L83
L281:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 166
	bl	_typeerror
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	beq	L83
	b	L282
L279:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 202
	bl	_typeerror
	b	L93
L277:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 197
	bl	_typeerror
	fcvtzs	d9, d9
	scvtf	d9, d9
	fcmp	d9, #0.0
	bne	L92
	b	L278
L274:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 244
	bl	_typeerror
	fcmpe	d9, d8
	ubfx	x0, x26, 16, 8
	mov	w3, 1
	lsl	x0, x0, 4
	add	x1, x28, x0
	cset	w2, ls
	str	w3, [x28, x0]
	strb	w2, [x1, 8]
	b	L313
L273:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	w5, 243
	bl	_typeerror
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d9, [x0, 8]
	cmp	w1, 2
	beq	L104
	b	L274
L323:
	adrp	x7, lC7@PAGE
	add	x26, x7, lC7@PAGEOFF;momd
	mov	w5, 112
	mov	x1, x26
	mov	x2, x22
	mov	x3, x23
	mov	x0, x19
	adrp	x4, lC4@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	str	x4, [sp, 152]
	bl	_typeerror
	ldp	x2, x3, [x24]
	add	x6, x23, 24
	mov	x1, x6
	mov	x0, x19
	str	x6, [sp, 144]
	bl	_check
	ldr	x4, [sp, 152]
	mov	x1, x26
	mov	x2, x22
	mov	x3, x23
	mov	x0, x19
	mov	w5, 113
	bl	_typeerror
	ldr	x6, [sp, 144]
	b	L134
L324:
	adrp	x1, lC5@PAGE
	add	x1, x1, lC5@PAGEOFF;momd
	mov	x0, x19
	mov	w5, 89
	adrp	x4, lC4@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	bl	_typeerror
	fcvtzu	w1, d8
	adrp	x0, lC6@PAGE
	add	x0, x0, lC6@PAGEOFF;momd
	str	w1, [sp]
	bl	_print
	b	L331
L278:
	mov	x0, x19
	adrp	x1, lC13@PAGE
	add	x1, x1, lC13@PAGEOFF;momd
	bl	_runerror
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L93
	b	L279
L78:
	bl	_pass_test
	bl	_exit_check_error
	add	x1, x19, 942080
	add	x2, x19, 933888
	ldrh	w0, [x1, 3472]
	sub	w0, w0, #1
	and	w0, w0, 65535
	strh	w0, [x1, 3472]
	ubfiz	x0, x0, 4, 16
	add	x0, x19, x0
	add	x0, x0, 851968
	ldr	w1, [x0, 13592]
	ldr	x27, [x0, 13584]
	str	w1, [x2, 11668]
	ldr	x0, [sp, 136]
	ubfiz	x1, x1, 4, 32
	add	x27, x27, 4
	add	x28, x0, x1
	b	L3
L304:
	mov	x3, x27
	mov	x2, x25
	mov	w1, w24
	mov	x0, x19
	str	w24, [sp, 152]
	str	x5, [sp, 176]
	str	w6, [sp, 184]
	str	x4, [sp, 192]
	bl	_lastglobalset
	ldr	w7, [sp, 152]
	mov	x1, x0
	adrp	x2, lC20@PAGE
	mov	x0, x19
	add	x2, x2, lC20@PAGEOFF;momd
	mov	w3, w7
	bl	_nilfunerror
	ldr	x4, [sp, 192]
	ldr	x5, [sp, 176]
	ldr	w0, [x28, x4]
	ldr	w6, [sp, 184]
	ldp	x2, x3, [x5]
	ldr	x27, [x5, 8]
	cmp	w0, 6
	beq	L129
	b	L305
L319:
	and	w4, w1, 255
	mov	x3, x27
	mov	w1, w4
	mov	x2, x25
	mov	x0, x19
	str	w4, [sp, 144]
	bl	_lastglobalset
	mov	x1, x0
	ldr	w4, [sp, 144]
	mov	x0, x19
	adrp	x2, lC9@PAGE
	add	x2, x2, lC9@PAGEOFF;momd
	mov	w3, w4
	bl	_nilfunerror
	bl	_add_test
	bl	_enter_check_error
	adrp	x0, _testjmp@GOTPAGE
	ldr	x0, [x0, _testjmp@GOTPAGEOFF]
	bl	_setjmp_proxy
	cbz	w0, L332
	b	L78
L306:
	bl	_error_mode
	cbz	w0, L333
L131:
	ldr	w0, [sp, 144]
	adrp	x1, lC21@PAGE
	str	w0, [sp]
	add	x1, x1, lC21@PAGEOFF;momd
	mov	x0, x19
	bl	_runerror
	b	L130
L300:
	mov	x0, x19
	adrp	x1, lC13@PAGE
	add	x1, x1, lC13@PAGEOFF;momd
	bl	_runerror
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L90
	b	L301
L308:
	mov	x3, x0
	mov	x2, x24
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC14@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC14@PAGEOFF;momd
	mov	w5, 338
	bl	_typeerror
	mov	w3, 5
	b	L110
L321:
	mov	x0, x19
	adrp	x4, lC4@PAGE
	adrp	x1, lC11@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC11@PAGEOFF;momd
	mov	w5, 141
	str	x6, [sp, 144]
	bl	_typeerror
	ldr	x6, [sp, 144]
	b	L80
L320:
	str	x6, [sp, 144]
	bl	_exit_check_error
	mov	x0, x19
	adrp	x1, lC10@PAGE
	add	x1, x1, lC10@PAGEOFF;momd
	bl	_runerror
	ldr	x6, [sp, 144]
	b	L79
L333:
	adrp	x4, ___stderrp@GOTPAGE
	ldr	x4, [x4, ___stderrp@GOTPAGEOFF]
	mov	x2, 19
	mov	x1, 1
	adrp	x0, lC16@PAGE
	add	x0, x0, lC16@PAGEOFF;momd
	str	x4, [sp, 152]
	ldr	x3, [x4]
	bl	_fwrite
	ldr	x4, [sp, 152]
	mov	x1, 6
	ldr	x2, [sp, 200]
	mov	x3, x27
	ldr	x0, [x4]
	bfi	x2, x1, 0, 32
	mov	x1, x19
	str	x2, [sp, 200]
	bl	_fprintfunname
	ldr	x4, [sp, 152]
	mov	w0, 10
	ldr	x1, [x4]
	bl	_fputc
	b	L131
L271:
	cmp	w0, 19
	beq	L334
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d9, [x1, 8]
	cmp	w0, 2
	beq	L99
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	x0, x19
	mov	w5, 237
	bl	_typeerror
L99:
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d8, [x0, 8]
	cmp	w1, 2
	beq	L100
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	x0, x19
	mov	w5, 238
	bl	_typeerror
L100:
	ubfx	x0, x26, 16, 8
	fcmpe	d9, d8
	mov	w3, 1
	add	x27, x27, 4
	lsl	x0, x0, 4
	add	x1, x28, x0
	cset	w2, mi
	str	w3, [x28, x0]
	strb	w2, [x1, 8]
	b	L3
L334:
	ubfiz	x1, x26, 4, 8
	add	x0, x28, x1
	ldr	w1, [x28, x1]
	ldp	x2, x3, [x0]
	ldr	d8, [x0, 8]
	cmp	w1, 2
	beq	L94
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	x0, x19
	mov	w5, 210
	bl	_typeerror
L94:
	fcvtzs	x24, d8
	cbz	x24, L335
L95:
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldp	x2, x3, [x1]
	ldr	d8, [x1, 8]
	cmp	w0, 2
	beq	L96
	adrp	x4, lC4@PAGE
	adrp	x1, lC5@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC5@PAGEOFF;momd
	mov	x0, x19
	mov	w5, 215
	bl	_typeerror
L96:
	fcvtzs	x1, d8
	ubfx	x2, x26, 16, 8
	mov	w4, 2
	add	x27, x27, 4
	lsl	x2, x2, 4
	add	x3, x28, x2
	sdiv	x0, x1, x24
	str	w4, [x28, x2]
	msub	x0, x0, x24, x1
	scvtf	d0, x0
	str	d0, [x3, 8]
	b	L3
L335:
	mov	x0, x19
	adrp	x1, lC13@PAGE
	add	x1, x1, lC13@PAGEOFF;momd
	bl	_runerror
	b	L95
L268:
	cmp	w0, 1
	beq	L13
	cmp	w0, 2
	bne	L336
	ubfx	x8, x26, 16, 8
	adrp	x0, lC3@PAGE
	add	x27, x27, 4
	add	x0, x0, lC3@PAGEOFF;momd
	add	x8, x28, x8, lsl 4
	ldp	x2, x3, [x8]
	stp	x2, x3, [sp]
	bl	_print
	b	L3
L13:
	ubfx	x8, x26, 16, 8
	adrp	x0, lC2@PAGE
	add	x27, x27, 4
	add	x0, x0, lC2@PAGEOFF;momd
	add	x8, x28, x8, lsl 4
	ldp	x2, x3, [x8]
	stp	x2, x3, [sp]
	bl	_print
	b	L3
L266:
	cmp	w0, 7
	beq	L337
	and	w1, w26, 65535
	mov	x0, x19
	bl	_literal_value
	mov	x22, x0
	mov	x23, x1
	cmp	w0, 3
	beq	L74
	adrp	x4, lC4@PAGE
	adrp	x1, lC7@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC7@PAGEOFF;momd
	mov	x2, x22
	mov	x3, x23
	mov	x0, x19
	mov	w5, 107
	bl	_typeerror
L74:
	ubfx	x2, x26, 16, 8
	add	x1, x23, 24
	mov	x0, x19
	add	x27, x27, 4
	add	x2, x28, x2, lsl 4
	ldp	x2, x3, [x2]
	bl	_expect
	b	L3
L337:
	and	w1, w26, 65535
	mov	x0, x19
	bl	_literal_value
	mov	x22, x0
	mov	x23, x1
	cmp	w0, 3
	beq	L73
	adrp	x4, lC4@PAGE
	adrp	x1, lC7@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC7@PAGEOFF;momd
	mov	x2, x22
	mov	x3, x23
	mov	x0, x19
	mov	w5, 102
	bl	_typeerror
L73:
	ubfx	x2, x26, 16, 8
	add	x1, x23, 24
	mov	x0, x19
	add	x27, x27, 4
	add	x2, x28, x2, lsl 4
	ldp	x2, x3, [x2]
	bl	_check
	b	L3
L318:
	adrp	x3, ___stderrp@GOTPAGE
	ldr	x3, [x3, ___stderrp@GOTPAGEOFF]
	mov	x2, 44
	mov	x1, 1
	adrp	x0, lC8@PAGE
	add	x0, x0, lC8@PAGEOFF;momd
	ldr	x3, [x3]
	bl	_fwrite
	bl	_abort
L287:
	cmp	w0, 44
	beq	L338
	ubfx	x4, x26, 8, 8
	sub	w0, w26, w4
	mov	x6, x4
	mov	x24, x4
	lsl	x4, x4, 4
	and	w0, w0, 255
	str	w0, [sp, 144]
	ubfx	x0, x26, 16, 8
	str	x0, [sp, 152]
	ldr	w0, [x28, x4]
	add	x5, x28, x4
	cbz	w0, L339
L121:
	ldp	x2, x3, [x5]
	ldr	x28, [x5, 8]
	cmp	w0, 6
	beq	L122
	adrp	x4, lC4@PAGE
	adrp	x1, lC11@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC11@PAGEOFF;momd
	mov	x0, x19
	mov	w5, 419
	bl	_typeerror
L122:
	add	x6, x19, 942080
	mov	w0, 5000
	ldrh	w1, [x6, 3472]
	cmp	w1, w0
	beq	L340
L123:
	add	x26, x19, 933888
	ldr	w3, [x28, 8]
	mov	w1, 50000
	ldr	w2, [x26, 11668]
	add	w0, w2, w24
	add	w0, w0, w3
	cmp	w0, w1
	bhi	L341
L125:
	ldrh	w1, [x6, 3472]
	ldr	w3, [x28]
	ubfiz	x0, x1, 4, 16
	add	w1, w1, 1
	add	x0, x19, x0
	strh	w1, [x6, 3472]
	add	x0, x0, 851968
	ldr	w1, [sp, 152]
	str	x27, [x0, 13584]
	str	w2, [x0, 13592]
	str	w1, [x0, 13596]
	ldr	w0, [sp, 144]
	cmp	w3, w0
	bne	L342
	ldr	x0, [sp, 136]
	add	w24, w24, w2
	add	x27, x28, 8
	str	w24, [x26, 11668]
	ubfiz	x24, x24, 4, 32
	add	x27, x27, 4
	add	x28, x0, x24
	b	L3
L338:
	add	x6, x19, 942080
	ubfx	x26, x26, 16, 8
	ldrh	w0, [x6, 3472]
	cbz	w0, L343
L117:
	sub	w0, w0, #1
	ubfiz	x1, x26, 4, 8
	and	w0, w0, 65535
	strh	w0, [x6, 3472]
	add	x1, x28, x1
	add	x3, x19, 933888
	ubfiz	x0, x0, 4, 16
	add	x0, x19, x0
	add	x0, x0, 851968
	ldp	x4, x5, [x1]
	ldr	w2, [x0, 13596]
	ldr	w1, [x0, 13592]
	ldr	x27, [x0, 13584]
	str	w1, [x3, 11668]
	ldr	x0, [sp, 136]
	ubfiz	x1, x1, 4, 32
	add	x28, x0, x1
	tbnz	w2, #31, L344
	add	x2, x28, w2, sxtw 4
	add	x27, x27, 4
	stp	x4, x5, [x2]
	b	L3
L339:
	mov	w1, w6
	mov	x3, x27
	mov	x2, x25
	mov	x0, x19
	str	w6, [sp, 176]
	stp	x5, x4, [sp, 184]
	bl	_lastglobalset
	ldr	w6, [sp, 176]
	mov	x1, x0
	adrp	x0, lC1@PAGE
	mov	w3, w6
	add	x2, x0, lC1@PAGEOFF;momd
	mov	x0, x19
	bl	_nilfunerror
	ldp	x5, x4, [sp, 184]
	ldr	w0, [x28, x4]
	b	L121
L343:
	str	w26, [sp]
	mov	x0, x19
	adrp	x1, lC15@PAGE
	add	x1, x1, lC15@PAGEOFF;momd
	str	x6, [sp, 144]
	bl	_runerror
	ldr	x6, [sp, 144]
	ldrh	w0, [x6, 3472]
	b	L117
L341:
	str	x6, [sp, 176]
	bl	_error_mode
	ldr	x6, [sp, 176]
	cbz	w0, L345
L126:
	str	w24, [sp]
	mov	x0, x19
	adrp	x1, lC18@PAGE
	add	x1, x1, lC18@PAGEOFF;momd
	str	x6, [sp, 176]
	bl	_runerror
	ldr	x6, [sp, 176]
	ldr	w2, [x26, 11668]
	b	L125
L344:
	neg	w1, w2
	mov	x0, x19
	and	w1, w1, 65535
	bl	_literal_value
	mov	x22, x0
	mov	x23, x1
	cmp	w0, 3
	beq	L119
	adrp	x4, lC4@PAGE
	adrp	x1, lC7@PAGE
	add	x4, x4, lC4@PAGEOFF;momd
	add	x1, x1, lC7@PAGEOFF;momd
	mov	x2, x22
	mov	x3, x23
	mov	x0, x19
	mov	w5, 396
	bl	_typeerror
L119:
	add	x1, x23, 24
	mov	x0, x19
	add	x27, x27, 4
	bl	_fail_check_error
	b	L3
L340:
	str	x6, [sp, 176]
	bl	_error_mode
	ldr	x6, [sp, 176]
	cbz	w0, L346
L124:
	str	w24, [sp]
	mov	x0, x19
	adrp	x1, lC17@PAGE
	add	x1, x1, lC17@PAGEOFF;momd
	str	x6, [sp, 176]
	bl	_runerror
	ldr	x6, [sp, 176]
	b	L123
L345:
	adrp	x5, ___stderrp@GOTPAGE
	ldr	x5, [x5, ___stderrp@GOTPAGEOFF]
	mov	x2, 19
	mov	x1, 1
	adrp	x0, lC16@PAGE
	add	x0, x0, lC16@PAGEOFF;momd
	stp	x5, x6, [sp, 176]
	ldr	x3, [x5]
	bl	_fwrite
	ldr	x5, [sp, 176]
	mov	x1, 6
	ldr	x2, [sp, 208]
	mov	x3, x28
	ldr	x0, [x5]
	bfi	x2, x1, 0, 32
	mov	x1, x19
	str	x2, [sp, 208]
	bl	_fprintfunname
	ldr	x5, [sp, 176]
	mov	w0, 10
	ldr	x1, [x5]
	bl	_fputc
	ldr	x6, [sp, 184]
	b	L126
L346:
	adrp	x4, ___stderrp@GOTPAGE
	ldr	x4, [x4, ___stderrp@GOTPAGEOFF]
	mov	x2, 19
	mov	x1, 1
	adrp	x0, lC16@PAGE
	mov	x26, x4
	add	x0, x0, lC16@PAGEOFF;momd
	ldr	x3, [x4]
	bl	_fwrite
	ldr	x0, [x26]
	mov	x1, 6
	ldr	x2, [sp, 216]
	mov	x3, x28
	bfi	x2, x1, 0, 32
	mov	x1, x19
	str	x2, [sp, 216]
	bl	_fprintfunname
	ldr	x1, [x26]
	mov	w0, 10
	bl	_fputc
	ldr	x6, [sp, 176]
	b	L124
L284:
	cmp	w0, 32
	beq	L347
	ubfx	x0, x26, 8, 8
	add	x27, x27, 4
	add	x0, x28, x0, lsl 4
	ldp	x0, x1, [x0]
	bl	_hashvalue
	ucvtf	d0, w0
	ubfx	x8, x26, 16, 8
	mov	w2, 2
	lsl	x0, x8, 4
	add	x1, x28, x0
	str	w2, [x28, x0]
	str	d0, [x1, 8]
	b	L3
L347:
	ubfx	x0, x26, 8, 8
	lsl	x0, x0, 4
	add	x1, x28, x0
	ldr	w0, [x28, x0]
	ldrb	w1, [x1, 8]
	cbz	w0, L137
	cmp	w0, 1
	csinc	w1, w1, wzr, eq
L109:
	ubfx	x0, x26, 16, 8
	bfi	x23, x1, 0, 8
	mov	x2, 1
	add	x27, x27, 4
	lsl	x0, x0, 4
	bfi	x22, x2, 0, 32
	add	x1, x28, x0
	str	x22, [x28, x0]
	str	x23, [x1, 8]
	b	L3
L137:
	mov	w1, 0
	b	L109
L342:
	adrp	x3, lC19@PAGE
	adrp	x1, lC4@PAGE
	adrp	x0, ___func__.0@PAGE
	add	x3, x3, lC19@PAGEOFF;momd
	add	x1, x1, lC4@PAGEOFF;momd
	add	x0, x0, ___func__.0@PAGEOFF;momd
	mov	w2, 448
	bl	___assert_rtn
L307:
	adrp	x3, lC19@PAGE
	adrp	x1, lC4@PAGE
	adrp	x0, ___func__.0@PAGE
	add	x3, x3, lC19@PAGEOFF;momd
	add	x1, x1, lC4@PAGEOFF;momd
	add	x0, x0, ___func__.0@PAGEOFF;momd
	mov	w2, 490
	bl	___assert_rtn
L322:
	adrp	x3, lC12@PAGE
	adrp	x1, lC4@PAGE
	adrp	x0, ___func__.0@PAGE
	add	x3, x3, lC12@PAGEOFF;momd
	add	x1, x1, lC4@PAGEOFF;momd
	add	x0, x0, ___func__.0@PAGEOFF;momd
	mov	w2, 142
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
	.byte	0x96
	.uleb128 0x15
	.byte	0x95
	.uleb128 0x16
	.byte	0x4
	.set L$set$7,LCFI4-LCFI3
	.long L$set$7
	.byte	0x98
	.uleb128 0x13
	.byte	0x97
	.uleb128 0x14
	.byte	0x4
	.set L$set$8,LCFI5-LCFI4
	.long L$set$8
	.byte	0x9a
	.uleb128 0x11
	.byte	0x99
	.uleb128 0x12
	.byte	0x4
	.set L$set$9,LCFI6-LCFI5
	.long L$set$9
	.byte	0x9c
	.uleb128 0xf
	.byte	0x9b
	.uleb128 0x10
	.byte	0x4
	.set L$set$10,LCFI7-LCFI6
	.long L$set$10
	.byte	0x5
	.uleb128 0x49
	.uleb128 0xd
	.byte	0x5
	.uleb128 0x48
	.uleb128 0xe
	.byte	0x4
	.set L$set$11,LCFI8-LCFI7
	.long L$set$11
	.byte	0xd6
	.byte	0xd5
	.byte	0x4
	.set L$set$12,LCFI9-LCFI8
	.long L$set$12
	.byte	0xd8
	.byte	0xd7
	.byte	0x4
	.set L$set$13,LCFI10-LCFI9
	.long L$set$13
	.byte	0xda
	.byte	0xd9
	.byte	0x4
	.set L$set$14,LCFI11-LCFI10
	.long L$set$14
	.byte	0x6
	.uleb128 0x49
	.byte	0x6
	.uleb128 0x48
	.byte	0x4
	.set L$set$15,LCFI12-LCFI11
	.long L$set$15
	.byte	0xdc
	.byte	0xdb
	.byte	0x4
	.set L$set$16,LCFI13-LCFI12
	.long L$set$16
	.byte	0xdd
	.byte	0xde
	.byte	0xd3
	.byte	0xd4
	.byte	0xe
	.uleb128 0
	.byte	0x4
	.set L$set$17,LCFI14-LCFI13
	.long L$set$17
	.byte	0xe
	.uleb128 0xe0
	.byte	0x93
	.uleb128 0x18
	.byte	0x94
	.uleb128 0x17
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
	.byte	0x9b
	.uleb128 0x10
	.byte	0x9c
	.uleb128 0xf
	.byte	0x9d
	.uleb128 0x1a
	.byte	0x9e
	.uleb128 0x19
	.byte	0x5
	.uleb128 0x48
	.uleb128 0xe
	.byte	0x5
	.uleb128 0x49
	.uleb128 0xd
	.align	3
LEFDE1:
	.ident	"GCC: (Homebrew GCC 12.2.0) 12.2.0"
	.subsections_via_symbols

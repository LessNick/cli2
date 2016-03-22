;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #3B divide16_16
;---------------------------------------
; Деление 16-битного числа на 16-битное число
; i: HL / DE
; o: BC, HL - остаток
;---------------------------------------
_divide16_16	ld	a,e
		or	d
		ret	z

		xor	a
		ld	c,a
		ld	b,a
		ex	de,hl

divide16_01	inc	b
		bit	7,h
		jr	nz,divide16_02

		add	hl,hl
		jr	divide16_01

divide16_02	ex	de,hl

divide16_03	or	a
		sbc	hl,de
		jr	nc,divide16_04
		add	hl,de

divide16_04	ccf
		rl	c
		rl	a
		rr	d
		rr	e
		djnz	divide16_03
		
		ld	b,a
		ret
;---------------------------------------

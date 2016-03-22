;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #3A mult16x8
;---------------------------------------
; Умножение 16-битного числа на 8-битное
; i: HL - 16-битное число, A' - 8-битное число
; o: DE - старшая часть, HL - младшая часть
;---------------------------------------
		ex	af,af'
_mult16x8	ld	de,#0000
		ld	(mult16x8_2 + 1),de
	        cp      #00
		jr	nz,mult16x8_00
		ld	hl,#0000
		ret

mult16x8_00	cp	#01
		ret	z

		push	bc
		dec	a
		ld	b,a
		ld	c,0
		push	hl
		pop	de

mult16x8_0	add	hl,de
		jr	nc,mult16x8_1
		push	de
		ld	de,(mult16x8_2 + 1)
		inc	de
		ld	(mult16x8_2 + 1),de
		pop	de
mult16x8_1	djnz	mult16x8_0

mult16x8_2	ld	de,#0000
		pop	bc
		ret
;---------------------------------------

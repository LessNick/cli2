;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #35 str2int
;---------------------------------------
; Преобразовать строку в число
; i: HL - адрес начала строки
; o: HL - число
;    DE - следующая позиция в строке после числа
;    A = #ff - ошибка
;---------------------------------------
_str2int	ld	bc,#0000
		ld	de,#0000
		ex	de,hl
		ld	(intBuffer),hl
		ex	de,hl

calcLen		ld	a,(hl)
		cp	#20					; end as space
		jr	z,calcVal
		cp	#00					; end as zero
		jr	z,calcVal
		cp	"0"
		jr	c,wrongValue
		cp	"9"+1
		jr	nc,wrongValue
		inc	b
		inc	hl
		jr	calcLen

calcVal		ld	(calcStrNext+1),hl
		ld	a,b
		cp	#00
		jr	z,wrongValue

		ld	(calcEnd+1),a
		ld	b,#00

calcLoop	dec	hl
		ld	a,(hl)
		sub	#30					; ascii 0

		push	hl
		push	bc

		push	af
		ld	a,b
		or	c
		jr	nz,calcSkip
		pop	af
		ld	h,0
		ld	l,a
		ld      (intBuffer),hl
		pop	af
		ld	bc,10
		jr	calcNext

calcSkip	pop	af
		push	bc
		pop	hl
		call	_mult16x8
		ex	de,hl
		ld	hl,(intBuffer)
		add	hl,de
		ld      (intBuffer),hl

		pop	hl					; bc
		ld	a,10
		call    _mult16x8
		push	hl
		pop	bc

calcNext	pop	hl

calcEnd		ld	a,#00
		dec	a
		ld	(calcEnd+1),a
		cp	#00
		jr	nz,calcLoop
		ld	hl,(intBuffer)
calcStrNext	ld	de,#0000
		xor	a					; ok
		ret

wrongValue	ld	hl,#0000
		ld	a,#ff					; error!
		ret
;---------------------------------------
intBuffer	dw	#0000
;---------------------------------------

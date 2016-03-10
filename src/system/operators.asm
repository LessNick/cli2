;---------------------------------------
; CLi² (Command Line Interface) parser & commands
; 2016 © breeze/fishbone crew
;---------------------------------------
; Embedded operators started with dot
;---------------------------------------
_opSet		ex	de,hl
		
		ld	a,(hl)
		cp	#00
		jp	z,_printErrParams

		call	_upperCase				; приводим к a->A
		cp	"A"
		jp	c,_printErrParams
		cp	"Z"+1
		jp	nc,_printErrParams
		sub	"A"
		sla	a					; *2
		inc	hl
		push	hl					; hl = rBuffer
		ld	hl,op_varA
		ld	b,0
		ld	c,a
		add	hl,bc					; hl - адрес переменной
		ld	(_opSetAddr+1),hl

		pop	de

		call	_eatSpaces
		ld	a,(de)
		cp	"="
		jp	nz,_printErrParams
		inc	de
		call	_eatSpaces
		ex	hl,de					; hl,string addr
		ld	a,(hl)
		cp	"-"
		jr	nz,_opSetSkip
		inc	hl
		call	_opGetValue

		set 	7,h
		jr	_opSetSkip2

_opSetSkip	call	_opGetValue
		

_opSetSkip2	push	hl		
		pop	bc					; bc - value

_opSetAddr	ld	hl,#0000
		ld	(hl),c
		inc	hl
		ld	(hl),b
		xor	a					; ошибок нет
		ret

_opGetValue 	call	_str2int
		ld	a,h
		cp	#7f+1
		ret	c
		pop	af
		jp	_printErrLimits
;---------------

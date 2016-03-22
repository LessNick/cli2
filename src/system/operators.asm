;---------------------------------------
; CLi² (Command Line Interface) parser & commands
; 2016 © breeze/fishbone crew
;---------------------------------------
; Embedded operators started with dot
;---------------------------------------
_opSet		call	storeRam0
		ld	a,varBank
		call	_setRamPage0
		call	_opSet_begin
		jp	reStoreRam0

_opSet_begin	ex	de,hl					; в HL - начало строки
		
		ld	a,(hl)
		cp	#00
		jp	z,_printErrParams

		call	upperCase				; приводим к a->A
		cp	"A"
		jp	c,_printErrParams
		cp	"Z"+1
		jp	nc,_printErrParams
		sub	"A"
		ld	(_opForA+1),a
		ld	(_ost_pos+1),a
		ld	(_opSetStrPos+1),a
		
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

_opSetSkip	push	hl
		cp	"\""
		jr	z,_opSetString
		cp	"u"
		jr	nz,_opSetSkip1
		inc	hl
		ld	a,(hl)
		cp	"n"
		jr	nz,_opSetSkip1
		inc	hl
		ld	a,(hl)
		cp	"d"
		jr	nz,_opSetSkip1
		inc	hl
		ld	a,(hl)
		cp	"e"
		jr	nz,_opSetSkip1
		inc	hl
		ld	a,(hl)
		cp	"f"
		jr	nz,_opSetSkip1
		pop	hl
		
		ld	hl,#0000				; 0
		call	_opSetSkip2
		
		xor	a
		ld	(_ost_type+1),a
		jr	_opSetType

_opSetSkip1	pop	hl
		call	_opGetValue

_opSetSkip2	push	hl		
		pop	bc					; bc - value

_opSetAddr	ld	hl,#0000
		ld	(hl),c
		inc	hl
		ld	(hl),b

_opSetNext	ld	a,#01					; int
		ld	(_ost_type+1),a
		call	_opSetType
		xor	a					; ошибок нет
		ret

_opGetValue 	call	_str2int
		cp	#ff					; не число!
		jr	nz,_opGetValueSkip
		pop	af
		jp	printErrNun

_opGetValueSkip	ld	a,h
		cp	#7f+1
		ret	c
		pop	af
		jp	printErrLimits

_opSetString	ld	hl,op_strA
_opSetStrPos	ld	b,#00
		ld	c,#00
		add	hl,bc
		ex	de,hl
		pop	hl

_oss_loop	inc	hl
		ld	a,(hl)
		cp	"\""
		jr	z,_oss_end
		cp	#00
		jp	z,_printErrParams
		ld	(de),a
		inc	de
		jr	_oss_loop

_oss_end	ld	a,#02					; String
		ld	(_opSetNext+1),a
		jr	_opSetNext

;---------------
_opSetType	ld	hl,op_typeA				; установить тип переменной
		ld	b,#00
_ost_pos	ld	c,#00
		add	hl,bc
_ost_type	ld	a,#00					; тип переменной 00 - undef, 01 - int, 02 - str
		ld	(hl),a
		ret
;---------------------------------------
_opFor		ld	a,varBank
		call	_setRamPage0

		call	_opSet
		push	de					; следущеее место TO
_opForA		ld	a,#00
		sla	a					; *2
		sla	a					; *4
		ld	hl,op_cycleA
		ld	b,0
		ld	c,a
		add	hl,bc					; hl - адрес циклов
		push	hl
		inc	hl
		inc	hl
		ld	(_opForTo+1),hl
		ld	hl,(_opSetAddr+1)
		ld	c,(hl)
		inc	hl
		ld	b,(hl)
		pop	hl
		ld	(hl),c
		inc	hl
		ld	(hl),b					; проиницализировали старт FOR
		pop	de

		call	_eatSpaces
		ld	a,(de)
		call	upperCase
		cp	"T"
		jp	nz,_printErrParams
		inc	de
		ld	a,(de)
		call	upperCase
		cp	"O"
		jp	nz,_printErrParams
		inc	de
		call	_eatSpaces
		ex	hl,de
		call	_opGetValue
		push	hl
		pop	bc
_opForTo	ld	hl,#0000
		ld	(hl),c
		inc	hl
		ld	(hl),b
		jp	reStoreRam0

;---------------------------------------
_opNext		
		ret

;---------------------------------------

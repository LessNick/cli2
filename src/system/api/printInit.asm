;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #0C printInit
;---------------------------------------
; Ининциализация печати
;---------------------------------------
_printInit	ld	de,#0000				; начальная инициализация
		ld	(printX),de
		call	getFullColor
		ld	(currentColor),a

printClear	xor	a
		ld	(printX),a
		ld	hl,bufer256				; очистка буфера256 (ASCII)
		ld	de,bufer256+1
		ld	bc,127
		ld	a," "
		ld	(hl),a
		ldir

		ld	hl,bufer256+128				; очистка буфера256 (Colors)
		ld	de,bufer256+129
		ld	bc,127
		ld	a,(currentColor)
		ld	(hl),a
		ldir

		ld	hl,bufer256
		ld	a,#01
		ld	bc,#0000
		jp	bufferUpdate
;---------------------------------------

;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #0D editInit
;---------------------------------------
; Ининциализация печати (линия ввода данных 1>)
;---------------------------------------
_editInit	ld	de,#0000				; начальная инициализация
		ld	(printEX),de

editClear	ld	hl,edit256				; очистка редактируемой строки 256 (ASCII)
		ld	de,edit256+1
		ld	bc,127
		ld	a," "
		ld	(hl),a
		ldir

		ld	hl,edit256+128				; очистка буфера256 (Colors)
		ld	de,edit256+129
		ld	bc,127
		ld	a,(currentColor)
		ld	(hl),a
		ldir

		ret
;---------------
printEX		dw	#0000					; позиция X для печати в edit256
;---------------------------------------

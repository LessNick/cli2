;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #3E eatSpaces
;---------------------------------------
; Удалить лишние пробелы перед словом
; i: DE - адрес начала строки для проверки
; o: DE - адрес начала строки
;---------------------------------------
_eatSpaces	ld	a,(de)
		cp	#00
		ret	z				; if reach to the end of buffer
		cp	#20				; check for space
		ret	nz
		inc	de
		jp	_eatSpaces
;---------------------------------------

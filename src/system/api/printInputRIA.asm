;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #1E printInputRIA
;---------------------------------------
; Вывести сообщение в консоль и ожидать нажатия (R/I/A)
;  i: HL - адрес строки, заканчивающейся #00
;  o: A - "r", "i" или "a"
;---------------------------------------
_printInputRIA	halt
		call	_printErrorString
		
		ld	hl,returnMsg
		call	_printString

inputRIALoop	halt
		call	_getKey
		cp	"r"
		ret	z
		cp	"i"
		ret	z
		cp	"a"
		ret	z
		jr	inputRIALoop

;---------------------------------------

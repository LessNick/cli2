;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #1D printInputYN
;---------------------------------------
; Вывести сообщение в консоль и ожидать нажатия (Y/N)
;  i: HL - адрес строки, заканчивающейся #00
;  o: A - "y" или "n"
;---------------------------------------
_printInputYN	halt
		call	_printWarningString

		ld	hl,returnMsg
		call	_printString

inputYNLoop	halt
		call	_getKey
		cp	"y"
		ret	z
		cp	"n"
		ret	z
		jr	inputYNLoop
;---------------------------------------

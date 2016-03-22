;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #1C printContinue
;---------------------------------------
; Вывести сообщение (press any key to contonue) в консоль
;---------------------------------------
_printContinue	halt
		ld	hl,continueMgs
		jp	_printString
;---------------------------------------

;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #19 printFileNotFound
;---------------------------------------
; Вывести сообщение об ошибке (file not found) в консоль
;---------------------------------------
_printFileNotFound
		push	hl
		ld	hl,fileNotFoundMsg
		ld	b,#ff
		call	_printErrorString
		pop	hl
		ld	b,#00
		call	_printErrorString
		ld	hl,fileNotFoundMsg0
		jp	_printErrorString
;---------------------------------------

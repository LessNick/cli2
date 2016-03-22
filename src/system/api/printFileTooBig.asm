;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #1A printFileTooBig
;---------------------------------------
; Вывести сообщение об ошибке (file too big) в консоль
;---------------------------------------
_printFileTooBig
		ld	hl,errorFileTooBig
		ld	b,#ff
		jp	_printErrorString
;---------------------------------------

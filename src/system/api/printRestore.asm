;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #1B printRestore
;---------------------------------------
; Восстановить Ink & Paper по умолчанию и сделать перевод строки
;---------------------------------------
_printRestore	ld	hl,restoreMsg
		call	_printString

printReturn	ld	hl,returnMsg
		jp	_printString

;---------------------------------------

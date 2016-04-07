;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #01 reInitSystem
;---------------------------------------
; Переинициализация системы (вторичный «тёплый» пуск)
;---------------------------------------

_reInitSystem	call	_switchTxtMode
		call	_clearIBuffer
		call	_printInit
		call	_editInit
		call	_setInterrupt
		xor	a
		ld	(disableDrivers+1),a
		ret

;---------------------------------------

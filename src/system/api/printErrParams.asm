;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #18 printErrParams
;---------------------------------------
; Вывести сообщение об ошибке (wrong parametrs) в консоль
;---------------------------------------
_printErrParams	ld	hl,errorParamsMsg
;---------------
printEP		ld	b,#ff
		jp	_printErrorString

;---------------
printErrNun	ld	hl,errorNunMsg
		jr	printEP

;---------------
printErrLimits	ld	hl,errorLimitMsg
		jr	printEP
;---------------------------------------

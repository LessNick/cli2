;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #15 printStatusString
;---------------------------------------
; Вывести информационное сообщение (status) в консоль как в Linux (начинающиеся с " * ")
;---------------------------------------
_printStatusString
		push	hl
		ld	a,(colorOk)
		ld	hl,iAsteriskMsg
		call	printColorStr
		pop	hl
		ld	a,(colorHelp)
		call	printColorStr
		jp	checkUpdate
;---------------------------------------

;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #16 printStatusOk
;---------------------------------------
; Дополнить сообщение (status) [  OK  ]
;---------------------------------------
_printStatusOk	call	printOpenBracket
		ld	a,(colorOk)
		ld	hl,iOkMsg
		call	printColorStr	
;---------------
printCloseBracket
		ld	hl,iCloseBracketMsg
		jp	_printString
;---------------
printOpenBracket
		ld	a,68					; 11 позиций до правой границы экрна
		ld	(printX),a
		ld	hl,iOpenBracketMsg
		jp	_printString
;---------------------------------------

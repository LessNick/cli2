;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #17 printStatusError
;---------------------------------------
; Дополнить сообщение (status) [ERROR!]
;---------------------------------------
_printStatusError
		call	printOpenBracket
		ld	a,(colorError)
		ld	hl,iErrorMsg
		call	printColorStr
		jp	printCloseBracket
;---------------------------------------

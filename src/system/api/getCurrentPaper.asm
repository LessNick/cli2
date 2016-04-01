;---------------------------------------
; CLi² (Command Line Interface) API
; 2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #61 getCurrentPaper
;---------------------------------------
; Получить текущий цвет (Paper) печати
; i:A' - номер цвета из палитры (0-15)
;---------------------------------------
_getCurrentPaper
		ld	a,(currentColor)
		and	%11110000
		srl	a
		srl	a
		srl	a
		srl	a
		ret
;---------------------------------------

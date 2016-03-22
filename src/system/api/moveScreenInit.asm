;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #42 moveScreenInit
;---------------------------------------
; Инициализировать графический экран в 0,0
;---------------------------------------
_moveScreenInit	push	hl					; Инициализация позиций всех экранов
		ld	hl,#0000
		ld	(mXoffset1),hl
		ld	(mYoffset1),hl
		ld	(mXoffset2),hl
		ld	(mYoffset2),hl
		ld	(mXoffset3),hl
		ld	(mYoffset3),hl
		pop	hl
		ret
;---------------------------------------

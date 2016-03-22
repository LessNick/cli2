;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #43 moveScreenUp
;---------------------------------------
; Сдвинуть текущий графический экран вверх
; i: A' - количество пикселей
;---------------------------------------
_moveScreenUp	call	getCurScrYToHL
		cp	#00
		ret	z					; текстовый режим не скроллим!	
		call	getHLfromAddr
		ex	af,af'
		ld	b,#00
		ld	c,a
		add	hl,bc
		call	setHLToCurScrY
		jr	moveScreenUpdate
;---------------------------------------

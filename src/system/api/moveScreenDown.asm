;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #44 moveScreenDown
;---------------------------------------
; Сдвинуть текущий графический экран вниз
; i: A' - количество пикселей
;---------------------------------------
_moveScreenDown	call	getCurScrYToHL
		cp	#00
		ret	z					; текстовый режим не скроллим!
		call	getHLfromAddr
		ex	af,af'
		ld	b,#00
		ld	c,a
		sbc	hl,bc
		call	setHLToCurScrY
		jr	moveScreenUpdate
;---------------------------------------

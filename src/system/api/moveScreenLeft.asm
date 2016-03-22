;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #45 moveScreenLeft
;---------------------------------------
; Сдвинуть текущий графический экран влево
; i: A' - количество пикселей
;---------------------------------------
_moveScreenLeft	call	getCurScrXToHL
		cp	#00
		ret	z					; текстовый режим не скроллим!
		call	getHLfromAddr
		ex	af,af'
		ld	b,#00
		ld	c,a
		sbc	hl,bc
		call	setHLToCurScrX
		jr	moveScreenUpdate
;---------------------------------------

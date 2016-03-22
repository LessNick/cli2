;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #46 moveScreenRight
;---------------------------------------
; Сдвинуть текущий графический экран вправо
; i: A' - количество пикселей
;---------------------------------------
_moveScreenRight
		call	getCurScrXToHL
		cp	#00
		ret	z					; текстовый режим не скроллим!
		call	getHLfromAddr
		ex	af,af'
		ld	b,#00
		ld	c,a
		add	hl,bc
		call	setHLToCurScrX
;---------------
moveScreenUpdate
		call	getCurScrXToHL
		call	getHLfromAddr
		call	setGXoff
		call	getCurScrYToHL
		call	getHLfromAddr
		jr	setGYoff
;---------------
setGXoff	ld	a,l
		ld	bc,tsGXoffsL
		out	(c),a
		ld	a,h
		ld	bc,tsGXoffsH
		out	(c),a
		ret
;---------------
setGYoff	ld	a,l
		ld	bc,tsGYoffsL
		out	(c),a
		ld	a,h
		ld	bc,tsGYoffsH
		out	(c),a
		ret
;---------------
getCurScrXToHL	ld	a,(currentScreen)
getCurScrXToHL_	cp	#00
		ld	hl,mXoffset0
		ret	z
getCurScrXToHL0	ld	hl,mXoffset1
		cp	#01
		ret	z
		ld	hl,mXoffset2
		cp	#02
		ret	z
		ld	hl,mXoffset3
		ret
;---------------
getCurScrYToHL	ld	a,(currentScreen)
getCurScrYToHL_	cp	#00
		ld	hl,mYoffset0
		ret	z
getCurScrYToHL0	ld	hl,mYoffset1
		cp	#01
		ret	z
		ld	hl,mYoffset2
		cp	#02
		ret	z
		ld	hl,mYoffset3
		ret
;---------------
setHLToCurScrX	ex	de,hl				; de значение
		call	getCurScrXToHL			; в hl аддр
setDEToAddrHL	ld	(hl),e
		inc	hl
		ld	(hl),d
		ret
;---------------
setHLToCurScrY	ex	de,hl				; de значение
		call	getCurScrYToHL			; в hl аддр
		jr	setDEToAddrHL
;---------------
getHLfromAddr	ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		ret
;---------------------------------------

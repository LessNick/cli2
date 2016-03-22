;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #04 clearTxtMemory
;---------------------------------------
; Очистить всю память выделенную для текстового режима
;---------------------------------------
_clearTxtMemory	call	storeRam3
		ld	a,#00					; Включаем страницу с текстовым режимом
; 		call	switchMemBank
		call	setRamPage3

		ld	hl,#c000+128				; блок атрибутов
		ld	de,#c001+128

		call	getFullColor
		call	clearBlock

		ld	hl,#c000				; блок символов
		ld	de,#c001
		ld	a," "
		call	clearBlock

		call	reStoreRam3

;---------------
restoreBorder	ld	a,(colorBorder)
setBorder	ld	bc,tsBorder
		out	(c),a
		ret

;---------------------------------------
getFullColor	ld	a,(colorPaper)
		sla	a
		sla	a
		sla	a
		sla	a
		ld	c,a
		ld	a,(colorInk)
		or	c
		ret

;---------------------------------------
clearBlock	ld	b,64
clearLoop	push	bc,de,hl
		ld	bc,127
		ld	(hl),a
		ldir
		pop	hl,de,bc
		inc	h
		inc	d
		djnz	clearLoop
		ret
;---------------------------------------
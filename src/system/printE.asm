;---------------------------------------
; CLi² (Command Line Interface) editline print
; 2013,2014 © breeze/fishbone crew
;---------------------------------------



;---------------------------------------


;---------------------------------------
_showCursor
curTimeOut	ld	a,#00
		cp	#00
		jr	z,sc_01
		dec	a
		ld	(curTimeOut+1),a
		ret

sc_01		ld	hl,curAnimPos
		ld	a,(hl)
		add	a,a
		ld	d,#00
		ld	e,a
		inc	(hl)
		ld	hl,curAnim
		add	hl,de					; frame
		ld	a,(hl)
		cp	#00
		jr	nz,sc_02

		ld	(curAnimPos),a
		ld	hl,curAnim
		ld	a,(hl)

sc_02		ld	(curTimeOut+1),a
		inc	hl
		ld	a,(hl)
		and	%00001111
		ld	c,a
		ld	a,(currentColor)
		and	%11110000
		or	c
		ld	(currentColor),a
		ld	a,(cursorType)
		call	printEChar
		call	getFullColor
		ld	(currentColor),a
		ret

;---------------------------------------
; in A - ASCII code
_printKey	push	af
;---------------
		ld	a,(iBufferPos)
		;cp	iBufferSize-1
		cp	80-2-1					; TODO: iBufferSize
		jr	z,buffOverload				; Конец строки! Бип и выход!

		ld	hl,iBuffer
		ld	b,#00
		ld	c,a
		add	hl,bc
		inc	a
		ld	(iBufferPos),a

		ld	a,(keyInsOver)
		cp	#01					; over
		jr	z,_printKeyCont

;---------------
		push	hl
								; BC - позиция
		ld	hl,127
		sbc	hl,bc
		push	hl
		pop	bc
		ld	hl,edit256+126
		ld	de,edit256+127
		lddr

pKskipInc	pop	hl
	
;---------------
_printKeyCont	pop	af

		ld	(hl),a
		call	printEChar
		
		ld	a,(printEX)
		inc	a
		cp	80					; Конец буфера edit256
		jr	nz,printKey_00
		call	printEUp
		xor	a

printKey_00	ld	(printEX),a

		ld	a,(iBufferPos)
		ld	b,0
		ld	c,a
		ld	hl,iBuffer
		add	hl,bc
		ld	a,(hl)
		ld	(storeKey),a
		ret

buffOverload	pop	af

		ld	a,#02
		jp	_borderIndicate

;---------------------------------------

;---------------------------------------









;---------------------------------------


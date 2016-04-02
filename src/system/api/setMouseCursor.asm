;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #58 setMouseCursor
;---------------------------------------
; Установить внешний вид курсора мыши
; i: A' - внешний вид:
;	  0 - курсор по умолчанию
;	  1 - часы
;	  2 - выделение
;	  3 - рука
;---------------------------------------
_setMouseCursor	ex	af,af'					; in A' - тип курсора (на самом деле номер фазы)	
;---------------------------------------
setCursorPhase	push	hl,de,bc

		push	af					; in A - номер фазы

		ld	a,(cursorSFile+1)
		and	%00000111
		ld	h,#00
		ld	l,a
		pop	af
		call	_mult16x8				; in: hl * a
 								; out:hl,low de,high
		ld	a,l

		push	af
		and	%00000011
		rrca
		rrca
		ld	c,a
		ld	a,(cursorSBitmapX)
		and	%00111111
		or	c
		ld	(cursorSBitmapX),a
		pop	af

		and	%00111100
		srl	a
		srl	a
		ld	c,a

		ld	a,(cursorSBitmapY)
		and	%11110000
		or	c
		ld	(cursorSBitmapY),a

		pop	bc,de,hl
		ret
;---------------------------------------

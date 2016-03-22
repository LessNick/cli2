;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #21 clearIBuffer
;---------------------------------------
; Очистить буффер ввода
;---------------------------------------
_clearIBuffer	ld	hl,iBuffer
		ld	de,iBuffer+1
		ld	bc,iBufferSize-1
		xor	a
		ld	(iBufferPos),a
		ld	(hl),a
		ldir
 		ret
;---------------------------------------

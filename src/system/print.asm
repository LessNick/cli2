;---------------------------------------
; CLi² (Command Line Interface) main print
; 2013,2014 © breeze/fishbone crew
;---------------------------------------


;---------------------------------------
_printStringLen	ld	(pslCurrent+1),a			; печать строки определённой длины, не ожидая #00 в конце!
pslCurrent	ld	a,#00
		push	af
		ld	a,(hl)
		call	printSChar
		pop	af
		dec	a
		cp	#00
		jp	z,printSExit
		jr	_printStringLen
;---------------





printSpaceStr	ld	a," "
		ld	(printExitCode+1),a
		call	_printString
		xor	a
		ld	(printExitCode+1),a
		ret







;---------------------------------------
















;---------------------------------------

;---------------------------------------

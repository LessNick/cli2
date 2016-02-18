; _showVersion	call	_getCliVersion
; 		push	hl
; 		ld	h,#00

; 		ld	de,minorVerMsg
; 		call	_fourbit2str
; 		pop	hl

; 		ld	l,h
; 		ld	h,#00

; 		ld	de,majorVerMsg
; 		call	_fourbit2str

; 		ld	hl,cliVersionMsg
; 		call	_printString
		
; 		jp	_printRestore

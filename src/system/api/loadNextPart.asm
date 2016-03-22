;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #26 loadNextPart
;---------------------------------------
; Загрузить следующую часть файла по указанному адресу
; o: A = #ff ошибка, A' = eFileEnd - конец файла
;---------------------------------------
_loadNextPart	;call	_restoreWcBank
		ld	hl,(loadFileBlocks)
		ld	a,h
		or	l
		jr	nz,loadFileCheck
		ld	a,eFileEnd
		ex	af,af'
		ld	a,#ff
		ret

;---------------
loadFileCheck	ld	c,#00
		ld	b,#00
		sbc	hl,bc
		jr	c,loadFileEnd
		ld	(loadFileBlocks),hl

		ld	b,c
loadFileAddr	ld	hl,#0000
		call	load512bytes
		xor	a
		ret

loadFileEnd	ld	de,(loadFileBlocks)
		ld	b,e
		xor	a
		ld	(loadFileBlocks),a
		ld	(loadFileBlocks+1),a
		call	loadFileAddr
		call	restorePath
		xor	a
		ret
;---------------------------------------

;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #25 loadFileParts
;---------------------------------------
; Загрузить часть файла по указанному адресу
;  i: HL - адрес строки именем файла (или путём до него)
;     DE - адрес загрузки файла
;     BC - размер загружаемой части в блоках (по 512б)
;      A' - банк памяти для загрузки файла
;  o: A = #ff ошибка, A' = код ошибки
;---------------------------------------
_loadFileParts	ex	af,af'
		ld	(loadFileBank+1),a			; a - банка загрузки
	
		ld	a,b
		ld	(loadFileCheck+1),a			; b - размер одной загружаемой части в блоках (по 512б)
		ld	(loadFileAddr+1),de			; de - aдрес загрузки

		call	storePath
		call	checkIsPath				; hl - адрес строки с именем файла
							
		ld	a,flagFile				; file
		call	prepareEntry
			
		call	eSearch
		jp	z,loadFileFNF+1				; +1 не нужно восстанавливать pop de			
		
		call	storeFileLen

		call	setFileBegin
		call	prepareSize
		ld	(loadFileBlocks),bc

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
loadFileBank	ld	c,#00
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

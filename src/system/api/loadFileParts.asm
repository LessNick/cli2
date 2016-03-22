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
;  o: A = #ff ошибка, A' = код ошибки
;---------------------------------------
_loadFileParts	ld	a,b
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
; Важно! Следом должен идти файл loadNextPart.asm
;---------------------------------------

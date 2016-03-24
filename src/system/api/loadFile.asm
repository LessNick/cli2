;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #23 loadFile
;---------------------------------------
; Загрузить файл по указанному адресу
;  i: HL - адрес строки именем файла (или путём до него)
;     DE - адрес загрузки файла
;     A' = #00 - восстановить путь после загрузки файла
;          #01 - остаться на новом пути откуда загружен файл
;  o: A = #ff ошибка, A' = код ошибки
;     BC - размер загруженного файла
;---------------------------------------
_loadFile	xor	a
		ld	(checkLimit+1),a
		ex	af,af'
		cp	#01
		jr	z,loadFile_00				; загрузка файла без восстановления пути

_loadFile0	call	storePath				; загрузка файла с восстановлением пути
		call	loadFile_00
		push	bc
		call	restorePath
		pop	bc
		ret

loadFile_00	push	de					; de - aдрес загрузки
		call	checkIsPath				; hl - адрес строки с именем файла
							
		ld	a,flagFile				; file
		call	prepareEntry
			
		call	eSearch
		jr	z,loadFileFNF				
		
		call	storeFileLen
		ld	a,d
		or	e
		jr	nz,loadFileTooBig
		
		pop	bc					; DE -> BC
		push	bc					; в BC адрес загрузки
		
		push	hl
		add	hl,bc
		jr	c,loadFileTooBig-1			; если вылетаем за границу адресного пространства (>#ffff)

		pop	hl					; hl - размер файла?
		ld	(loadFileSize+1),hl

checkLimit	ld	a,#00
		cp	#00
		jr	z,loadFile_01

		ld	a,h
checkLimit_01	cp	#00
		jr	nz,loadWrongSize

		ld	a,l
checkLimit_02	cp	#00
		jr	nz,loadWrongSize		

loadFile_01	call	setFileBegin
		call	prepareSize
		ld	a,b
		cp	#00
		jr	nz,loadFileTooBig
		ld	b,c

		pop	hl
		call	load512bytes

		xor	a
loadFileSize	ld	bc,#0000				; на выходе в BC - размер файла
		ret

loadWrongSize	pop	hl
		ld	a,eFileWrongSize
		ex	af,af'
		jr	loadFileError

		pop	af
loadFileTooBig	pop	af
		call	_printFileTooBig
		ld	a,eFileTooBig
		ex	af,af'
		jr	loadFileError

loadFileFNF	pop	de
		ld	a,eFileNotFound
		ex	af,af'

loadFileError	call	restorePath
		ld	a,#ff					; exit with error
		ret

;---------------
storePath	push	hl,de,bc,af
		ld	hl,pathBString
		ld	de,pathBString+1
		ld	bc,pathStrSize
		xor	a
		ld	(hl),a
		ldir

		ld	de,pathBString
storePathCall	ld	hl,pathString
storeLoop	ld	a,(hl)
		cp	#00
		jr	z,storePathExit
		cp	#0d
		jr	z,storePathExit
		ld	(de),a
		inc	hl
		inc	de
		jr	storeLoop

storePathExit	pop	af,bc,de,hl
		ret

;---------------
restorePath	ld	de,pathBString
restorePath_1	push	af
		ex	af,af'
		push	af
		call	_changeDir
		pop	af
		ex	af,af'
		pop	af
		ret

;---------------
checkIsPath	push	hl
		xor	a
		ld	(needCd+1),a
		ld	(pathCd+1),hl

cipLoop		ld	a,(hl)					; цикл: проверка всей строки на наличие /
		cp	#00
		jr	z,needCd
		
		cp	"/"
		jr	nz,cipNext
		
		ld	a,#01
		ld	(needCd+1),a	
		ld	(pathCd+1),hl

cipNext		inc	hl
		jr	cipLoop

needCd		ld	a,#00					; need cd?
		cp	#00
		jr	z,cipExit

pathCd		ld	hl,#0000
		xor	a
		ld	(hl),a

		pop	de
		ld	a,(de)
		cp	#00					; root ?
		jr	nz,pathCd_00
		ld	de,rootPath
		
pathCd_00	push	hl
		call	_changeDir
		pop	hl

		ld	a,"/"
		ld	(hl),a
		inc	hl
		ret

cipExit		pop	hl
		xor	a
		ex	af,af'
		xor	a
		ret

;---------------
prepareEntry	call	clearEntryForSearch
		push	af
		xor	a
		ld	(entryQuote+1),a
		pop	af

		ld	de,entryForSearch

entryLoop	ld	(de),a
		inc	de
		ld	a,(hl)
		inc	hl

		cp	"\""
		jr	nz, entrySkip

entryQuote	ld	a,#00
		cp	#01					; end quote
		ret	z

		xor	#01
		ld	(entryQuote+1),a
		ld	a,(hl)
		inc	hl

entrySkip	cp	#00
		ret	z
		cp	" "
		ret	z
		cp	"/"
		ret	z
		cp	97					; a
		jr	c,entryLoop
		cp	123					; }
		jr	nc,entryLoop
		sub	#20
		jr	entryLoop

;---------------
eSearch		ld	hl,entryForSearch
;---------------
searchEntry	ld	a,_FENTRY
		jp	wcKernel

;---------------
setFileBegin	ld	a,_GFILE
		jp	wcKernel

;---------------
storeFileLen	ld	(fileLength),hl
		ld	(fileLength+2),de
		ret

;---------------
prepareSize	ld	hl,(fileLength+2)		; старшая часть размера
		ld	a,128				;	hl * 128 (128 блоков по 512б в 1 единице старшей части размера)
		call	_mult16x8			; de = high, hl = low

		push	hl
		ld	hl,(fileLength)			; младшая часть размера

		ld	de,512				;	hl / 512
		call	_divide16_16			; bc, hl - остаток

		ld	a,h
		or	l
		jr	z,noOst
		inc	bc

noOst		pop	hl
		add	hl,bc
		push	hl
		pop	bc				; на выходе количестов блоков по 512 в hl

		ret
;---------------------------------------

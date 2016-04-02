;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2016 © breeze/fishbone crew
;---------------------------------------------
; dir - read directory
;---------------------------------------------
_dir		ex	de,hl
		
		ld	a,(hl)
		cp	#00
		jr	z,dirPath

		push	hl
		call	storePath
		pop	de
		call	_changeDir
		
		cp	#ff
		jr	nz,dirPath
		
		ld	hl,dirNotFoundMsg
		ld	b,#ff
		call	_printErrorString
		xor	a

		call	restorePath
		ret

; dirChanged	call	dirPath
; 		jr	dirExit

dirPath		ld	a,(lsPathCount)					; path counter
		cp	#00
		jr	nz,dirNotRoot

		call	pathToRoot
		jr	dirBegin

dirNotRoot	ld	hl,rootSearch
		call	searchEntry
		jp	z,dirCantReadDir

dirBegin	xor	a
		ld	(dirCount+1),a
		ld	(itemsCount+1),a

		call	setFileBegin

dirReadAgain	call	clearBuffer
		
		di

		ld	hl,bufferAddr
		ld	c,bufferBank
		ld	b,#01						; 1 block 512b
		call	load512bytes

		ei

		ld	hl,bufferAddr

dirLoop		ld	a,(hl)
		cp	#00
		jp	z,dirEnd						; если #00 конец записей

		push	hl
		pop	ix
		bit	3,(ix+11)
		jr	nz,dirSkip+1					; если 1, то запись это ID тома
		ld	a,(hl)
		cp	#e5
		jr	z,dirSkip+1

		push	hl
		call	dirCopyName

		bit	4,(ix+11)
		jr	z,dirNext_00					; если 1, то каталог
		ld	a,(colorDir)
		jr	dirNext

dirNext_00	bit	0,(ix+11)
		jr	z,dirNext_01					; если 1, то файл только для чтения
		ld	a,(colorRO)
		jr	dirNext

dirNext_01	bit	1,(ix+11)
		jr	z,dirNext_02					; если 1, то файл скрытый
		ld	a,(colorHidden)
		jr	dirNext

dirNext_02	bit	2,(ix+11)
		jr	z,dirNext_03					; если 1, то файл системный
		ld	a,(colorSystem)
		jr	dirNext

dirNext_03	bit	5,(ix+11)
		jr	z,dirNext_04					; если 1, то файл архивный
		ld	a,(colorArch)
		jr	dirNext

dirNext_04	ld	a,(colorFile)					; в противном случает - обычный файл

dirNext		ld	(de),a

dirCount		ld	a,#00
		inc	a
		ld	(dirCount+1),a
		cp	#06
		jr	nz,dirSkip
		xor	a
		ld	(dirCount+1),a

		ld	hl,fileOneLine
		call	_printString

dirSkip		pop	hl

itemsCount	ld	a,#00
		inc	a
		ld	(itemsCount+1),a
		cp	16						; 16 записей на сектор
		jr	z,dirLoadNext

		ld	bc,32						; 32 byte = 1 item
		add	hl,bc
		jp	dirLoop

dirEnd		ld	a,(dirCount+1)
		cp	#00
		jr	z,dirEnd_01

dirEnd_00	ld	hl,nameEmpty
		call	dirCopyName
		ld	a,(dirCount+1)
		inc	a
		ld	(dirCount+1),a
		cp	#06
		jr	nz,dirEnd_00			

		ld	hl,fileOneLine
		call	_printString
			
dirEnd_01	call	_printRestore
		ret

dirLoadNext	xor	a
		ld	(itemsCount+1),a
		jp 	dirReadAgain

clearBuffer	ld	hl,bufferAddr
		ld	de,bufferAddr+1
		ld	bc,#1fff
		xor	a
		ld	(hl),a
		ldir
		ret

dirCopyName	push	hl
		ld	hl,fileOneLine
		ld	b,0
		ld	a,(dirCount+1)
		ld	c,a
		add	a,a
		add	a,a
		add	a,a
		add	a,a
		sbc	c
		ld	c,a
		add	hl,bc
		ex	de,hl
		pop	hl
		inc	de
		push	de
		inc	de
			
		ld	bc,#0000
dirCopyLoop	ld	a,(hl)
		cp	" "
		jr	z,dirCopySkip
		ld	(de),a
		inc	de
		inc	c						; счётчик символов отпечатано (позиция)
dirCopySkip	inc	b						; счётчик символов всего (позиция)
		inc	hl
		ld	a,b
		cp	11
		jr	z,dirCopyRet
		cp	8						; 8.3
		jr	nz,dirCopyLoop
		ld	a,(hl)
		cp	" "
		jr	z,dirCopyRet
		ld	a,"."
		inc	c
		ld	(de),a
		inc	de
		jr	dirCopyLoop

dirCopyRet	ld	a,c
		cp	12
		jr	nc,dirCopyRet_0
		ld	a," "
		ld	(de),a
		inc	c
		inc	de
		jr	dirCopyRet

dirCopyRet_0	pop	de
		ret

dirCantReadDir	ld	hl,cantReadDirMsg
		ld	b,#ff
		jp	_printErrorString

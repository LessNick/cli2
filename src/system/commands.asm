;---------------------------------------
; CLi² (Command Line Interface) parser & commands
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; Command line parser
;---------------------------------------
; In: de, command string addr
;	  hl, table of commands list
;         bc, номер текущей строки в SH скрипте, =1 просто вызов
; Out:a,#ff = command not found
;     a,#00 - command found, hl - addr params start
;---------------------------------------
showHelp
;---------------
; Внутренние команды
;---------------
		ld	hl,helpMsg
		call	_printOkString
		ld	hl,helpMsg1
		call	_printOkString

		ld	hl,cmdTable
		call	showEmbedded

		ld	hl,returnMsg
		call	_printString

		ld	hl,helpMsg2
		call	_printOkString
		ld	hl,helpMsg1
		call	_printOkString

		ld	a,cLemonCream
		call	setInk

		ld	hl,opTable
		call	showEmbedded

		ld	hl,returnMsg
		call	_printString
		ld	hl,helpMsg
		call	_printOkString
		ld	hl,helpMsg3
		call	_printOkString

		call	showExternal
		ld	hl,returnMsg
		jp	_printString
;---------------
showEmbedded
shLoop_0	ld	de,tmpPrintStr
		push	hl
		push	de

		inc	de
		ld	hl,tmpPrintStr
		ld	bc,254
		xor	a
		ld	(hl),a
		ldir

		pop	de
		pop	hl

		ld	c,#00				; длина команды
shLoop_1	ld	a,(hl)
		cp	"*"
		jr	z,shPrint_0
		ld	(de),a
		inc	c
		inc	hl
		inc	de
		jr	shLoop_1

shPrint_0	push	hl,bc
		ld	hl,tmpPrintStr
		call	_printString
		pop	bc
		ld	a,c
		cp	13
		jr	nc,shSkip_0
		ld	a,13
		sbc	c
		call	codeSkip

shSkip_0	pop	hl

		inc	hl				; +*

		inc	hl
		inc	hl				; +addr

		ld	a,(hl)
		cp	#00				; конец таблицы
		jr	nz,shLoop_0

		ld	hl,returnMsg
		jp	_printString

;---------------
showExternal	call	storeRam3

		ld	a,scopeBinBank
		call	setRamPage3

		ld	hl,scopeBinAddr
seLoop_0	ld	de,tmpPrintStr
		push	hl
		push	de

		inc	de
		ld	hl,tmpPrintStr
		ld	bc,254
		xor	a
		ld	(hl),a
		ldir

		pop	de
		pop	hl

		ld	a,(hl)
		cp	#00
		jp	z,seEnd

		ld	bc,8
		ldir

		push	hl
		ld	hl,tmpPrintStr
		call	_printString
		ld	a,c
		cp	#00
		jr	z,seSkip_0
		ld	a,1+3				; 8 + 2 + 3 = 13
		call	codeSkip
seSkip_0	pop	hl
		jr	seLoop_0

seEnd		ld	hl,returnMsg
		call	_printString

		jp	reStoreRam3

;---------------------------------------
scopeBinary	ld	a,scopeBinBank
		call	setRamPage3

		call	clearScopeBin
		call	storePath
		
		ld	de,scopeBinAddr
		ld	(sbCopyName+1),de

		ld	de,binPath
		call	changeDir
		cp	#ff				; not found /bin?
		ret	z

		ld	a,fSetDir
		call	fatDriver

sbLoop		ld	de,lsBuffer
		ld	a,fGetNextEntryDir
		call	fatDriver
		jr	z,sbEnd				; конец директории

		ld	hl,lsBuffer+12			; флаги файла
		
		bit	3,(hl)
		jr	nz,sbLoop			; если 1, то запись это ID тома

		bit	4,(hl)				; если 1, то каталог
		jr	nz,sbLoop

		inc	hl				; Начало имени
		ld	a,(hl)
		cp	"."				; Пропустить файлы «.» и «..»
		jr	z,sbLoop

		push	hl
sbChek0		ld	a,(hl)
		cp	#00
		jr	z,sbSkipFile
		cp	"."
		jr	z,sbChek1
		inc	hl
		jr	sbChek0

sbChek1		inc	hl
		ld	a,(hl)
		cp	" "				; 1) три пробела в расширении !
		jr	nz,sbSkipFile

		inc	hl
		ld	a,(hl)
		cp	" "				; 2) три пробела в расширении !
		jr	nz,sbSkipFile

		inc	hl
		ld	a,(hl)
		cp	" "				; 3) три пробела в расширении !
		jr	nz,sbSkipFile

		inc	hl
		ld	a,(hl)
		cp	#00				; И дальше ничего!
		jr	nz,sbSkipFile

		pop	hl

sbCopyName	ld	de,scopeBinAddr
		push	de
		ld	b,#08				; Имя файла не длиннее 8 символов
sbCopyLoop	ld	a,(hl)
		cp	"."				; Если имя корече 8 символов
		jr	z,sbCopyEnd
		ld	(de),a
		inc	hl
		inc	de
		djnz	sbCopyLoop
		
sbCopyEnd	pop	hl
		ld	bc,#08
		add	hl,bc
		ld	(sbCopyName+1),hl
		jr	sbLoop

sbSkipFile	pop	af
		jr	sbLoop

sbEnd		call	restorePath

		xor	a					; no error
		ld	hl,(sbCopyName+1)
		ld	(hl),a
		ret

clearScopeBin	ld	hl,scopeBinAddr
		ld	de,scopeBinAddr+1
		ld	bc,palAddr-scopeBinAddr-1
		ld	a," "
		ld	(hl),a
		ldir
		ret

;---------------------------------------
store2byte	ld	a,l
		ld	(de),a
		inc	hl
		inc	de
		ld	a,h
		ld	(de),a
		inc	de
		ret

prepareSaveEntry
		push	hl
		push	de
		
		call	clearEntryForSearch
		ld	de,entryForSearch
		ld	(de),a					; fileFlag
		inc	de

		push	bc					; bc -> hl
		pop	hl
		
		call	store2byte

		pop	hl					; de -> hl

		call	store2byte

		pop	hl					; имя

pseLoop		ld	a,(hl)
		cp	#00
		ret	z
		ld	(de),a
 		inc	hl
 		inc	de
 		jr	pseLoop

;---------------------------------------
clearEntryForSearch
		push	hl,de,bc,af
		ld	hl,entryForSearch
		ld	de,entryForSearch+1
		ld	bc,254
		xor	a
		ld	(hl),a
		ldir
		pop	af,bc,de,hl
		ret

;---------------------------------------
changeDirCmd	call	changeDir
		cp	#ff
		ret	nz
		ld	hl,dirNotFoundMsg
		ld	b,#ff
		jp	_printErrorString

;---------------------------------------
changeDir	ex	de,hl					; hl params
		ld	a,(hl)
		cp	"/"
		call	z,resetToRoot

		push	hl
cdLoop		ld	a,(hl)
		cp	#00
		jr	z,cdLastCheck
		cp	"/"
		jr	z,changeNow
		inc	hl
		jr	cdLoop

changeNow	ex	de,hl
		xor	a
		ld	(de),a					; end current pos
		pop	hl
		
		push	de					; store next pos

		ld	a,flagDir				; directory
		call	prepareEntry

		call	eSearch
		jp	z,cdNotFound-1

		call	setDirBegin

		call	setPathString

		pop	hl
		ld	a,"/"
		ld	(hl),a
		inc	hl
		jr	cdLoop-1

cdLastCheck	pop	hl
		ld	a,(hl)
		cp	#00
		jp	z,cdExitOk

		ld	a,flagDir				; directory
		call	prepareEntry

		call	eSearch
		jr	z,cdNotFound

		call	setDirBegin

		call	setPathString

		jr	cdExitOk

setPathString	ld	hl,entryForSearch+1
		ld	a,(hl)
		cp	"."
		jr	nz,incPath
		inc	hl
		ld	a,(hl)
		cp	"."
		jr	z,decPath
		cp	#00					; single dir .
		ret	z
		jr	incPath

decPath		ld	a,(lsPathCount)
		dec	a
		ld	(lsPathCount),a

		ld	hl,pathString
		ld	bc,(pathStrPos)
		add	hl,bc
		ld	e,#00
		ld	(hl),e					; pos
		dec	hl
		dec	bc

cdDelLoop	ld	(hl),e					; /
		dec	hl
		dec	bc
		ld	a,(hl)
		cp	"/"
		jr	nz,cdDelLoop
		inc	bc
		ld	(pathStrPos),bc
		ret

incPath		ld	a,(lsPathCount)
		inc	a
		ld	(lsPathCount),a

		ld	hl,pathString
		ld	bc,(pathStrPos)
		add	hl,bc
		ex	de,hl

		ld	hl,entryForSearch+1
cdLoopPath	ld	a,(hl)
		cp	#00
		jr	z,cdEndPath
		ld	(de),a
		inc	hl
		inc	de
		inc	bc
		jr	cdLoopPath

cdEndPath	ld	a,"/"
		ld	(de),a
		inc	bc
		ld	(pathStrPos),bc
		ret

		pop	hl

cdNotFound	ld	hl,pathString
		ld	bc,(pathStrPos)
		add	hl,bc
		ld	a,#0d
		ld	(hl),a
		
		ld	a,#ff					; error
		ret

cdExitOk	ld	hl,pathString
		ld	bc,(pathStrPos)
		add	hl,bc
		ld	a,#0d
		ld	(hl),a

		xor	a					; alt no error
		ex	af,af'
		xor	a					; no error
		ret

resetToRoot	inc	hl
		push	hl
		call	pathToRoot
		xor	a
		ld	(lsPathCount),a
		call	_initPath
		pop	hl
		ret

;---------------------------------------
_initPath	ld	hl,pathString
		ld	de,pathString+1
		ld	bc,pathStrSize-1
		xor	a
		ld	(hl),a
		ldir
			
		ld	bc,#0001
		ld	(pathStrPos),bc
		ld	a,"/"
		ld	(pathString),a
		ld	a,#0d
		ld	(pathString+1),a
		xor	a
		ld	(lsPathCount),a
		ret

;---------------------------------------
clearScreen	ex	de,hl
		ld	a,(hl)
		cp	#00
		jr	z,clearTxtScreen

		cp	"-"
		jr	nz,clearTxtScreen
		inc	hl
		ld	a,(hl)
		cp	"g"
		jr	nz,clearTxtScreen
		inc	hl

		ex	de,hl
		call	_getNumberFromParams
		cp	#ff
		jp	z,_printErrParams
		ld	a,h
		cp	#00
		jp	nz,_printErrParams
		ld	a,l
		cp	#04
		jp	nc,_printErrParams
		
		ld	c,#00				; номер цвета
		jp	_clearGfxMemory+1

		
clearTxtScreen	xor	a
		jp	PR_POZ

;---------------------------------------
pathWorkDir	ld	hl,pathString
		call	_printString
		jp	printReturn

;---------------------------------------
switchScreen	ex	de,hl
		call	_str2int
		ld	a,h
		cp	#00
		jp	nz,_printErrParams
		
		ld	a,l
		cp	#00
		jp	z,_switchTxtMode
		
		ld	b,a
		cp	#04
		jp	c,_switchGfxMode
		
		jp	_printErrParams

;---------------------------------------
_runApp		call	_run
		cp	#ff
		ret	nz
		ld	hl,wrongAppMsg
		ld	b,a				; #ff
		jp	_printErrorString

;---------------------------------------
scopeBinaryCmd	call	scopeBinary
		cp	#ff
		jr	z,scopeBinaryErr
		
		ld	hl,okBinMgs
		jp	_printOkString

scopeBinaryErr	ld	hl,errorBinMgs
		ld	b,#ff
		jp	_printErrorString

;---------------------------------------
locale		ex	de,hl
		ld	a,(hl)
		cp	#00
		jr	z,showLocale

		ld	de,sysLocale
		call	upperCase
		ld	(de),a
		inc	hl
		inc	de
		ld	a,(hl)
		call	upperCase
		ld	(de),a
		ret

showLocale	call	_getLocale
		push	hl
		ld	a,h
		call	printSChar
		pop	hl
		ld	a,l
		call	printSChar
		jp	printReturn
;---------------------------------------

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
_showHelp	ld	hl,helpMsg
		call	_printOkString
		ld	hl,helpMsg1
		call	_printOkString

		ld	hl,cmdTable

newLine		ld	de,helpOneLine
		ld	c,0
helpAgain	ld	b,10

helpLoop	ld	a,(hl)
		cp	#00
		jr	z,helpLast

		cp	"*"
		jr	nz,helpSkip

		inc	hl
		inc	hl
		inc	hl

helpSpace	ld	a," "
		ld	(de),a
		inc	de
		djnz	helpSpace

		inc	c
		ld	a,c
		cp	8
		jr	nz,helpAgain

		push	hl,de,bc
		
		ld	hl,helpOneLine
		call	_printString

		call	clearOneLine

		pop	bc,de,hl
		jr	newLine

helpSkip	ld	(de),a
		inc	de
		inc	hl
		dec	b
		jr	helpLoop

clearOneLine	ld	hl,helpOneLine
		ld	de,helpOneLine+1
		ld	bc,10*8-1
		ld	a," "
		ld	(hl),a
		ldir
		ret

helpLast	ld	hl,helpOneLine
		call	_printString

;---------------
		ld	hl,returnMsg
		call	_printString
		ld	hl,helpMsg
		call	_printOkString
		ld	hl,helpMsg2
		call	_printOkString

		ld	a,scopeBinBank
		call	setRamPage3

		call	clearOneLine

		ld	hl,scopeBinAddr
		ld	de,helpOneLine
		xor	a
		ld	(helpCount+1),a

helpLoop2	ld	a,(hl)
		cp	#00
		jr	z,helpExit

		ld	b,8
helpCopy	ld	a,(hl)
		ld	(de),a
		inc	hl
		inc	de
		djnz	helpCopy
		
helpCount	ld	a,#00
		inc	a
		ld	(helpCount+1),a
		cp	8
		jr	nz,helpSkip2
		xor	a
		ld	(helpCount+1),a
		push	hl,de
		ld	hl,helpOneLine
		call	_printString
		call	clearOneLine
		pop	de,hl
		ld	de,helpOneLine
		jr	helpLoop2

helpSkip2	inc	de
		inc	de
		jr	helpLoop2


helpExit	ld	hl,helpOneLine
		call	_printString
		jp	_printRestore

;---------------------------------------
scopeBinary	ld	a,scopeBinBank
		call	setRamPage3

		call	clearScopeBin
		call	storePath
		
		ld	de,scopeBinAddr
		ld	(sbCopyName+1),de

		ld	de,binPath
		call	_changeDir
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
_changeDirCmd	call	_changeDir
		cp	#ff
		ret	nz
		ld	hl,dirNotFoundMsg
		ld	b,#ff
		jp	_printErrorString

;---------------------------------------
_changeDir	ex	de,hl					; hl params
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
_clearScreen	ex	de,hl
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
_pathWorkDir	ld	hl,pathString
		call	_printString
		jp	printReturn

;---------------------------------------
_switchScreen	ex	de,hl
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
_scopeBinaryCmd	call	scopeBinary
		cp	#ff
		jr	z,_scopeBinaryErr
		
		ld	hl,okBinMgs
		jp	_printOkString

_scopeBinaryErr	ld	hl,errorBinMgs
		ld	b,#ff
		jp	_printErrorString

;---------------------------------------
_locale		ex	de,hl
		ld	a,(hl)
		cp	#00
		jr	z,_showLocale

		ld	de,sysLocale
		call	upperCase
		ld	(de),a
		inc	hl
		inc	de
		ld	a,(hl)
		call	upperCase
		ld	(de),a
		ret

_showLocale	call	_getLocale
		push	hl
		ld	a,h
		call	printSChar
		pop	hl
		ld	a,l
		call	printSChar
		jp	printReturn
;---------------------------------------

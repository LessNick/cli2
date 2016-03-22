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
		cp	"A"
		jr	c,helpPaste
		cp	"Z"
		jr	nc,helpPaste
		add	32
helpPaste	ld	(de),a
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
_scopeBinary	ld	a,scopeBinBank
		call	setRamPage3

		call	clearScopeBin
		call	storePath
		
		ld	de,scopeBinAddr
		ld	(sbCopyName+1),de

		ld	de,binPath
		call	_changeDir
		cp	#ff				; not found /bin?
		ret	z

		call	setFileBegin

sbReadAgain	call	_clearBuffer

		ld	hl,bufferAddr
		ld	b,#01				; 1 block 512b
		call	load512bytes

		ld	hl,bufferAddr

sbLoop		ld	a,(hl)
		cp	#00
		jp	z,sbEnd

		push	hl
		pop	ix
		bit	3,(ix+11)
		jr	nz,sbSkip			; если 1, то запись это ID тома
		
		bit	4,(ix+11)
		jr	nz,sbSkip			; если 1, то каталог
		
		ld	a,(hl)
		cp	#e5
		jr	z,sbSkip

		push	hl
		call	sbCopyName
		pop	hl

sbSkip		
sbCount		ld	a,#00
		inc	a
		ld	(sbCount+1),a
		cp	16					; 16 записей на сектор
		jr	z,sbLoadNext

		ld	bc,32					; 32 byte = 1 item
		add	hl,bc
		jp	sbLoop

sbLoadNext	xor	a
		ld	(sbCount+1),a
		jp 	sbReadAgain

sbEnd		call	restorePath

		xor	a					; no error
		ret

sbCopyName	ld	de,scopeBinAddr

		push	hl
		push	de
		ld 	de,#08
		add	hl,de
		ld	a,(hl)
		cp	" "
		jr	nz,sbSkipFile
		inc	hl
		ld	a,(hl)
		cp	" "
		jr	nz,sbSkipFile
		inc	hl
		ld	a,(hl)
		cp	" "
		jr	nz,sbSkipFile
		pop	de
		pop	hl

		ld	b,8					; 16384 / 8 = 2048 bin files		
sbCopy		ld	a,(hl)
		cp	"A"
		jr	c,sbPaste
		cp	"Z"
		jr	nc,sbPaste
		add	32
sbPaste		ld	(de),a
		inc	hl
		inc	de
		djnz	sbCopy

		ld	(sbCopyName+1),de
		ret

sbSkipFile	pop	de
		pop	hl
		ret


clearScopeBin	ld	hl,scopeBinAddr
		ld	de,scopeBinAddr+1
		ld	bc,palAddr-scopeBinAddr-1
		xor	a
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

_prepareSaveEntry
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

		ld	b,8
pseLoop_2	ld	a,(hl)
		cp	#00
		ret	z
		cp	"."
		jr	z,pseDot

		ld	(de),a
		inc	hl
		inc	de
		dec	b
		jr	pseLoop_2

pseDot		ld	a,b
		cp	#00
		jr	z,pseDotSkip

		ld	a," "
pseDotLoop	ld	(de),a
		inc	de
		djnz	pseDotLoop

pseDotSkip	inc	hl
		ld	a,(hl)
		cp	#00
		ret	z
		ld	(de),a
		inc	de
		jr	pseDotSkip

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

		call	_setDirBegin

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

		call	_setDirBegin

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
		ld	a,(lsPathCount)
		cp	#00
		ret	z					; alredy root
		push	hl
		call	_pathToRoot
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
_scopeBinaryCmd	call	_scopeBinary
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

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
_parseLine	ld	(_plStrNumber+1),bc
		call	_scanForReplace				; поиск и замена переменных в строке
		cp	#ff
		ret	z					; ошибка замены строки

		call	_checkIsExec				; ./filename
		cp	#ff
		ret	nz					; команда исполняемый файл - выход

		xor	a					; сброс флагов
		ld	hl,opTable
		push	de
_plStrNumber	ld	bc,#0000
		call	_parser
		pop	de
		
		cp	#ff
		ret	nz					; команда начинается с точки и является оператором - выход

		xor	a					; сброс флагов
		ld	hl,cmdTable
		push	de
		call	_parser
		pop	de
		
		cp	#ff
		ret	nz					; команда найдена во встроенных - выход
		
		call	_checkIsBin
		cp	#ff
		ret	nz					; команда найдена во внешних (/bin) - выход
		
		call	_printInit

		ld	hl,unknownCmdMsg			; вывести сообщение об ошибке - команда не найдена
		ld	b,#ff
		jp	_printErrorString

;---------------------------------------
_scanForReplace	ld	a,varBank
		call	_setRamPage0
		push	de
		ld	hl,rBuffer
		push	hl
		ld	de,rBuffer+1
		ld	bc,rBufferSize-1
		xor	a
		ld	(hl),a
		ldir						; очищаем новый буфер
		pop	hl
		pop	de
		push	hl					; в DE на выходе будет rBuffer

_sfr_loop	ld	a,(de)
		cp	#00					; конец строки
		jr	z,_sfr_exit
		cp	"%"					; поиск переменной начинающейся с %
		jr	nz,_sfr_next
		inc	de
		ld	a,(de)
		cp	"%"					; %% - просто символ %
		jr	z,_sfr_next
		call	_upperCase				; приводим к a->A
		cp	"A"
		jr	c,_sfr_err
		cp	"Z"+1
		jr	nc,_sfr_err
		sub	"A"
		
		inc	de
		ld	(_sfr_cont+1),de

		push	hl,af
		ld	hl,op_typeA
		ld	b,0
		ld	c,a
		add	hl,bc
		ld	a,(hl)
		cp	#00					; undefined variable
		jr	z,_sfr_undef
		cp	#02					; string variable
		jr	z,_sfr_string
		pop	af,hl

		sla	a					; *2
		push	hl					; hl = rBuffer
		ld	hl,op_varA
		ld	b,0
		ld	c,a
		add	hl,bc
		ld	c,(hl)
		inc	hl
		ld	b,(hl)
		pop	hl					; hl = rBuffer
		
		bit 	7,b
		jr	z,_sfr_skip

		res	7,b

		ld	a,"-"
		ld	(hl),a
		inc	hl

_sfr_skip	push	de,hl
		ld	de,rBufferNumber
		push	de					; de = rBufferNumber
		push	bc
		pop	hl					; bc -> hl = значение
		call	_int2str
		pop	de					; de = rBufferNumber
		pop	hl					; hl = получатель rBuffer

_sfr_sLoop	ld	a,(de)
		cp	"0"
		jr	nz,_sfr_skip1a
		inc	de
		jr	_sfr_sLoop

_sfr_skip1a	cp	#00
		jr	nz,_sfr_skip1b
		ld	a,"0"
		ld	(hl),a
		jr	_sfr_skip2

_sfr_skip1b	ld	(hl),a
		inc	hl

		inc	de
		ld	a,(de)
		cp	#00
		jr	nz,_sfr_skip1b

_sfr_skip2	pop	de
		jr	_sfr_loop

_sfr_next	ld	(hl),a

_sfr_next2	inc	hl
		inc	de
		jr	_sfr_loop

_sfr_exit	pop	de
		call	_restoreWcBank
		xor	a					; ошибок нет
		ret

_sfr_err	pop	de
		call	_printErrParams
		call	_restoreWcBank
		ld	a,#ff					; ошибка замены
		ret
;---------------
_sfr_undef	pop	af,hl
		ld	de,undefVarMsg
_sfr_undefLoop	ld	a,(de)
		cp	#00
		jr	z,_sfr_cont	
		ld	(hl),a
		inc	de
		inc	hl
		jr	_sfr_undefLoop
;---------------
_sfr_string	pop	af
		ld	hl,op_strA
		ld	b,a
		ld	c,0
		add	hl,bc
		ex	de,hl
		pop	hl

_sfr_strLoop	ld	a,(de)
		cp	#00
		jp	z,_sfr_cont
		ld	(hl),a
		inc	de
		inc	hl
		jr	_sfr_strLoop
;---------------
_sfr_cont	ld	de,#0000
		jp	_sfr_loop
;---------------------------------------
_upperCase	cp	"a"					; Делает символ большим
		ret	c
		cp	"z"+1
		ret	nc
		sub	32
		ret

_lowerCase	cp	"A"					; Делает символ маленьким
		ret	c
		cp	"Z"+1
		ret	nc
		add	32
		ret
;---------------------------------------
_parser		call	_eatSpaces
		ld	(storeAddr),de

		ld	a,(de)
		cp	"#"				; first simbol comment
		ret	z
		cp	";"				; first simbol comment
		ret	z

parse_start	ld      a,(de)
		cp	#00				; space means end of buffer
		jp	z,end_of_command
		cp	" "				; space means end of command
		jp	z,end_of_command

		call	_lowerCase

parse_skip	cp	(hl)				; Compare a with first character in command table
		jp	nz,next_command			; Move HL to point to the first character of the next command in the table
		inc	de
		inc	hl
		jr	parse_start

next_command	push 	af
		ld	a,"*"
		cp	(hl)				; Is it the end off command * ?
		jp	z,forward			; Yes inc HL 3 times to set to begining of next command in the table

		ld	a,#00				; Table end reached ?
		cp	(hl)
		jp	z,no_match
		pop	af
		inc	hl
            	jp	next_command

forward		pop	af
		inc	hl
		inc	hl
		inc	hl
		ld	de,(storeAddr)
		jp	parse_start

end_of_command	call	_eatSpaces
		ld	a,(hl)
		cp	"*"
		jr	nz,no_match+1

		inc	hl				; increase to *
							; Increase to point to jump vector for command
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		ld	(storeAddr),de
		jp	(hl)				; de - addr start params
							; bc - number of current string

no_match	pop	af
							; Routine to print "Unkown command error"
		ld	a,#ff
		ret

_eatSpaces	ld	a,(de)
		cp	#00
		ret	z				; if reach to the end of buffer
		cp	#20				; check for space
		ret	nz
		inc	de
		jp	_eatSpaces

storeAddr	dw	#0000

;---------------------------------------
_checkIsExec	push	de
		call	_eatSpaces
		ld	a,(de)
		cp	"."
		jr	nz,noExec
		inc	de
		ld	a,(de)
		cp	"/"
		jr	nz,noExec
		inc	de					; file exec
;---------------
		push	de
execLoop	ld	a,(de)
		cp	#00
		jr	z,execEnd
		cp	" "
		jr	z,execEnd
		inc	de
		jr	execLoop

execEnd		xor	a
		ex	de,hl
		ld	(hl),a
		inc	hl
		pop	de
;---------------
		call	_runApp
		pop	de					; de
		xor	a
		ret

noExec		pop	de
		ld	a,#ff					; no exec
		ret

;---------------------------------------
_checkIsBin	push	de
		
		ld	a,scopeBinBank
		call	switchMemBank

		ld	hl,cibFile
		ld	de,cibFile+1
		ld	bc,7
		xor	a
		ld	(hl),a
		ldir

		pop	de
		call	_eatSpaces
		ex	de,hl

		ld	de,scopeBinAddr				; hl - файл, de- таблица
cibLoop		ld	b,8
		push	de
		push	hl

cibLoop_00	ld	a,(de)
		cp	#00
		jr	z,cibError				; конец таблицы
		
		ld	c,a
		ld	a,(hl)
		cp	c
		jr	nz,cibNext				; если не равны следующий в таблице

		inc	hl
		inc	de
		
		ld	a,(hl)

		cp	" "					; конец имени файла
		jr	z,cibLoop_01a
							
		cp	#00					; конец имени файла
		jr	nz,cibLoop_02
		
cibLoop_01	ld	a,(de)
		cp	" "					; конец файла в таблице = ок
		jr	z,cibOk
		
		ld	a,b
		cp	#01					; конец файла в таблице по длине (8-1) = ок
		jr	z,cibOk

		jr	cibNext

cibLoop_01a	inc	hl
		ld	(cibParams+1),hl
		jr	cibLoop_01

cibLoop_02	djnz	cibLoop_00				; file found
		jr	cibOk

cibNext		pop	hl
		pop	de
		ex	de,hl
		ld	bc,8
		add	hl,bc
		ex	de,hl	
		jr	cibLoop

cibOk		ld	(cibParams+1),hl
		pop	hl
		pop	de
		ld	de,cibFile
		ld	b,8

		xor	a
		ld	(cibOk_00+1),a

cibOk_00	ld	a,#00
		cp	#00
		jr	nz,cibOk_EndName
		ld	a,(hl)
		cp	" "
		jr	nz,cibOk_01
		ld	a,#01
		ld	(cibOk_00+1),a

cibOk_EndName	xor	a
cibOk_01	ld	(de),a
		inc	hl
		inc	de
		djnz	cibOk_00

		ld	hl,cdBinPath
		ld	de,cibPath
		ld	bc,cibPath-cdBinPath
		ldir

		ld	de,cibPath
cibParams	ld	hl,#0000

		call	_runApp
		xor	a,#00					; no err
		ret

cibError	pop	hl
		pop	de
		ld	a,#ff					; err
		ret

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
		call	switchMemBank

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
		call	switchMemBank

		call	clearScopeBin
		call	_storePath
		
		ld	de,scopeBinAddr
		ld	(sbCopyName+1),de

		ld	de,binPath
		call	_changeDir
		cp	#ff				; not found /bin?
		ret	z

		call	_setFileBegin

sbReadAgain	call	_clearBuffer

		ld	hl,bufferAddr
		ld	b,#01				; 1 block 512b
		call	_load512bytes

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

sbEnd		call	_restorePath

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
_prepareEntry	call	clearEntryForSearch
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

;---------------------------------------
; _loadRes	ld	a,loadResident				; hl params
; 		ex	de,hl
; 		call	_resApi
; 		cp	#ff
; 		ret	nz
; 		ld	hl,wrongResMsg
; 		ld	b,a				; #ff
; 		jp	_printErrorString

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
		call	_prepareEntry

		call	_eSearch
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
		call	_prepareEntry

		call	_eSearch
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
_eSearch	ld	hl,entryForSearch
		jp	_searchEntry

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
_closeCli	pop	af
		pop	af
		pop	af
		jp	_exitSystem

;---------------------------------------
_pathWorkDir	ld	hl,pathString
		call	_printString
		jp	_printReturn

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
_prepareSize	ld	hl,(fileLength+2)		; старшая часть размера

		;	hl * 128 (128 блоков по 512б в 1 единице старшей части размера)

		ld	a,128
		call	_mult16x8			; de = high, hl = low

		push	hl
		ld	hl,(fileLength)			; младшая часть размера

		;	hl / 512
		ld	de,512
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
		call	_upperCase
		ld	(de),a
		inc	hl
		inc	de
		ld	a,(hl)
		call	_upperCase
		ld	(de),a
		ret

_showLocale	call	_getLocale
		push	hl
		ld	a,h
		call	printSChar
		pop	hl
		ld	a,l
		call	printSChar
		jp	_printReturn
;---------------------------------------

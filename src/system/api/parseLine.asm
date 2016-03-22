;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #3C parseLine
;---------------------------------------
; Обработка ввёдённой строки с командой и параметрами
; i: DE - адрес начала строки
; o:  A - #ff - ошибка
;---------------------------------------
_parseLine	ld	(_plStrNumber+1),bc
		call	scanForReplace				; поиск и замена переменных в строке
		cp	#ff
		ret	z					; ошибка замены строки

		call	checkIsExec				; ./filename
		cp	#ff
		ret	nz					; команда исполняемый файл - выход

		xor	a					; сброс флагов
		ld	hl,opTable
		push	de
_plStrNumber	ld	bc,#0000
		call	parser
		pop	de
		
		cp	#ff
		ret	nz					; команда начинается с точки и является оператором - выход

		xor	a					; сброс флагов
		ld	hl,cmdTable
		push	de
		call	parser
		pop	de
		
		cp	#ff
		ret	nz					; команда найдена во встроенных - выход
		
		call	checkIsBin
		cp	#ff
		ret	nz					; команда найдена во внешних (/bin) - выход
		
		call	_printInit

		ld	hl,unknownCmdMsg			; вывести сообщение об ошибке - команда не найдена
		ld	b,#ff
		jp	_printErrorString

;---------------------------------------
scanForReplace	call	storeRam0
		ld	a,varBank
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

sfr_loop	ld	a,(de)
		cp	#00					; конец строки
		jr	z,sfr_exit
		cp	"%"					; поиск переменной начинающейся с %
		jr	nz,sfr_next
		inc	de
		ld	a,(de)
		cp	"%"					; %% - просто символ %
		jr	z,sfr_next
		call	upperCase				; приводим к a->A
		cp	"A"
		jr	c,sfr_err
		cp	"Z"+1
		jr	nc,sfr_err
		sub	"A"
		
		inc	de
		ld	(sfr_cont+1),de

		push	hl,af
		ld	hl,op_typeA
		ld	b,0
		ld	c,a
		add	hl,bc
		ld	a,(hl)
		cp	#00					; undefined variable
		jr	z,sfr_undef
		cp	#02					; string variable
		jr	z,sfr_string
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
		jr	z,sfr_skip

		res	7,b

		ld	a,"-"
		ld	(hl),a
		inc	hl

sfr_skip	push	de,hl
		ld	de,rBufferNumber
		push	de					; de = rBufferNumber
		push	bc
		pop	hl					; bc -> hl = значение
		call	_int2str
		pop	de					; de = rBufferNumber
		pop	hl					; hl = получатель rBuffer

sfr_sLoop	ld	a,(de)
		cp	"0"
		jr	nz,sfr_skip1a
		inc	de
		jr	sfr_sLoop

sfr_skip1a	cp	#00
		jr	nz,sfr_skip1b
		ld	a,"0"
		ld	(hl),a
		jr	sfr_skip2

sfr_skip1b	ld	(hl),a
		inc	hl

		inc	de
		ld	a,(de)
		cp	#00
		jr	nz,sfr_skip1b

sfr_skip2	pop	de
		jr	sfr_loop

sfr_next	ld	(hl),a

sfr_next2	inc	hl
		inc	de
		jr	sfr_loop

sfr_exit	pop	de
		xor	a					; ошибок нет
		jp	reStoreRam0

sfr_err		pop	de
		call	_printErrParams
		ld	a,#ff					; ошибка замены
		jp	reStoreRam0

;---------------
sfr_undef	pop	af,hl
		ld	de,undefVarMsg
sfr_undefLoop	ld	a,(de)
		cp	#00
		jr	z,sfr_cont	
		ld	(hl),a
		inc	de
		inc	hl
		jr	sfr_undefLoop
;---------------
sfr_string	pop	af
		ld	hl,op_strA
		ld	b,a
		ld	c,0
		add	hl,bc
		ex	de,hl
		pop	hl

sfr_strLoop	ld	a,(de)
		cp	#00
		jp	z,sfr_cont
		ld	(hl),a
		inc	de
		inc	hl
		jr	sfr_strLoop
;---------------
sfr_cont	ld	de,#0000
		jp	sfr_loop

;---------------------------------------
checkIsExec	push	de
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
parser		call	_eatSpaces
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

		call	lowerCase

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

storeAddr	dw	#0000

;---------------------------------------
checkIsBin	push	de
		
		ld	a,scopeBinBank
		call	setRamPage3

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
		xor	a					; no err
		ret

cibError	pop	hl
		pop	de
		ld	a,#ff					; err
		ret

;---------------------------------------
upperCase	cp	"a"					; Делает символ большим
		ret	c
		cp	"z"+1
		ret	nc
		sub	32
		ret

lowerCase	cp	"A"					; Делает символ маленьким
		ret	c
		cp	"Z"+1
		ret	nc
		add	32
		ret
;---------------------------------------

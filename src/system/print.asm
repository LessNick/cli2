;---------------------------------------
; CLi² (Command Line Interface) main print
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
_printInit	ld	de,#0000				; начальная инициализация
		ld	(printX),de
		call	_getFullColor
		ld	(currentColor),a

printClear	xor	a
		ld	(printX),a
		ld	hl,bufer256				; очистка буфера256 (ASCII)
		ld	de,bufer256+1
		ld	bc,127
		ld	a," "
		ld	(hl),a
		ldir

		ld	hl,bufer256+128				; очистка буфера256 (Colors)
		ld	de,bufer256+129
		ld	bc,127
		ld	a,(currentColor)
		ld	(hl),a
		ldir

		ld	hl,bufer256
		ld	a,#01
		ld	bc,#0000
		call	_bufferUpdate
		ret

;---------------------------------------
_printStringLen	ld	(pslCurrent+1),a			; печать строки определённой длины, не ожидая #00 в конце!
pslCurrent	ld	a,#00
		push	af
		ld	a,(hl)
		call	printSChar
		pop	af
		dec	a
		cp	#00
		jp	z,printSExit
		jr	_printStringLen
;---------------

_printCodeDisable
		ld	a,b
		ld	(printFixCode+1),a			; запретить (1), разрешить (0) печать управляющих символов (кроме #0d #0a)
		ret

_printWithScroll
		ld	a,b
		ld	(printScrollEnable+1),a			; разрешить (1) / запретить (0) спрашивать Scroll при выводе теста
		ret

printSpaceStr	ld	a," "
		ld	(printExitCode+1),a
		call	_printString
		xor	a
		ld	(printExitCode+1),a
		ret

_printSkipCodes	pop	af					; Игнорировать управляющие коды (кроме #OD/#OA), вывести как есть.
		jr	printFixSkip

_printString	xor	a					; Печать строки
		ld	(strLen),a

printSLoop	ld	a,(hl)
printExitCode	cp	#00					; Управляющий код: 0 - выход
		jp	z,printSExit

		push	af
printFixCode	ld	a,#00					; Если 1, не использовать управляющие коды
		cp	#01
		jr	z,_printSkipCodes
		pop	af

		cp	#09					; Управляющий код: 09 - tab
		jp	z,codeTab
		
		cp	#0C					; Управляющий код: 12 - delete
		jp	z,codeDelete
		cp	#0F					; Управляющий код: 15 - system ink код системного цвета
		jp	z,codeSysInk
		cp	#10					; Управляющий код: 16 - ink
		jp	z,codeInk
		cp	#11					; Управляющий код: 17 - paper
		jp	z,codePaper
		cp	#12					; Управляющий код: 18 - system paper код системного цвета
		jp	z,codeSysPaper
		cp	#14					; Управляющий код: 20 - inverse
		jp	z,codeInverse
		cp	#16					; Управляющий код: 22 - at x,y
		jp	z,codeAt
		cp	"\\"					; Управляющий код: \xNN - где NN шестнадцатеричное значение
		jp	z,codeESC

printFixSkip	cp	#0D					; Управляющий код: 13 - new line (enter) windows
		jp	z,codeEnter
		cp	#0A					; Управляющий код: 10 - new line (enter) unix
		jp	z,codeEnter

printS		call	printSChar
		jp	printSLoop

printSChar	push	hl
		call	printChar
		
		ld	a,(strLen)
		inc	a
		ld	(strLen),a
		
		ld	a,(printX)
		inc	a
		cp	80					; Конец буфера256
		jr	z,printS_00

		ld	(printX),a

		pop	hl
		inc	hl
		ret

printSExit	ld	hl,bufer256
		ld	a,#01
		ld	bc,#0000
		call	_bufferUpdate				; забирается буфер
		call	checkUpdate
		ld	a,(strLen)
		ret

printS_00	pop	hl
		inc	hl
		push	hl
		ld	a,(hl)
		cp	#00
		jr	nz,nextLine_00

printS_01	call	prepareNext
		ld	a,(strLen)
		
		pop	hl
		ret

checkUpdate	call	_checkSync				; проверяем необходимость обновления экрана
		call	_printWW
		ret
;---------------------------------------
codeTab		ld	a,(printX)
		srl	a					; /2
		srl	a					; /4
		srl	a					; /8
		cp	#09
		jr	z,codeEnter
		inc	a
		push	hl
		ld	hl,tabTable
		ld	b,0
		ld	c,a
		add	hl,bc
		ld	a,(hl)
		ld	(printX),a
		pop	hl
		inc	hl
		jp	printSLoop
;---------------------------------------
codeDelete	ld	a,(printX)
		cp	#00
		jr	z,codeDelete_00
		dec	a
		ld	(printX),a
codeDelete_00	inc	hl
		jp	printSLoop

;---------------------------------------
codeEnter	inc	hl
		ld	a,(hl)
		cp	#0A					; windows \n\r ?
		jr	nz,nextLine
		inc	hl

nextLine	push	hl

nextLine_00	call	prepareNext
		pop	hl

		jp	printSLoop

prepareNext	ld	hl,bufer256
		ld	a,#00
		call	_bufferUpdate				; забирается буфер

		call	printClear				; очищаем буфер256
		call	checkUpdate

		xor	a
		ld	(printX),a

printScrollEnable
		ld	a,#00					; scroll?
		cp	#00
		ret	z

printScrollCounter
		ld	a,#00
		inc	a
		ld	(printScrollCounter+1),a
		cp	29					; вывод 30 строк
		ret	nz
		xor	a
		ld	(printScrollCounter+1),a

		ld	hl,textScrollMgs
		call	printSLoop

		call	_waitAnyKey
		
		xor	a
		ld	(printX),a
		
		ld	hl,textScrollMgsE
		call	printSLoop
		xor	a
		ld	(printX),a
		ret
;---------------------------------------
codeInk		inc	hl
		ld	a,(hl)
		inc	hl

codeInk_0	cp	16					; 16 ? взять цвет по умолчанию
		jr	nz,codeInk_1
		call	_getFullColor

codeInk_1	and	%00001111
		ld	c,a
		ld	a,(currentColor)
		and	%11110000
		or	c
		ld	(currentColor),a
		jp	printSLoop

codePaper	inc	hl
		ld	a,(hl)
		inc	hl

codePaper_0	cp	16					; 16 ? взять цвет по умолчанию
		jr	nz,codePaper_1
		call	_getFullColor
		and	%11110000
		jr	codePaper_2

codePaper_1	and	%00001111
		sla	a
		sla	a
		sla	a
		sla	a
codePaper_2	ld	c,a
		ld	a,(currentColor)
		and	%00001111
		or	c
		ld	(currentColor),a
		jp	printSLoop

codeInverse	inc	hl
		ld	a,(currentColor)
		and	%00001111
		sla	a
		sla	a
		sla	a
		sla	a
		ld	b,a
		ld	a,(currentColor)
		and	%11110000
		srl	a
		srl	a
		srl	a
		srl	a
		or	b
		ld	(currentColor),a
		jp	printSLoop

codeAt		inc	hl
		ld	a,(hl)
		ld	b,a
		inc	hl
		ld	a,(hl)
		ld	c,a

codeAt_0	ld	a,c
		ld	(printX),a
		ld	(strLen),a
		jp	printSLoop

codeESC		inc	hl
		ld	a,(hl)
codeESC_0	cp	"\\"					; управляющий ESC: BackSlash \
		jp	z,printS
		cp	"t"
		jp	z,codeTab				; управляющий ESC: Tab
		cp	"n"
		jp	z,codeEnter				; управляющий ESC: Enter
		cp	"r"
		jp	z,codeEnter				; управляющий ESC: Enter
		cp	"x"
		jr	z,codeHex				; управляющий ESC: Hex value

		jp	printSLoop+1				; код не опознан = просто напечатать следующий символ

codeHex		inc	hl
		call	getHexNumber
		
		cp	#5c					; "\" — Означает, что следующий за ним символ напечатать без управляющих кодов
		jr	z,codeHexPrint

		cp	#10					; Управляющий код: 16 - ink
		jr	z,codeHexI
		cp	#11					; Управляющий код: 17 - paper
		jr	z,codeHexP

		cp	#16					; Управляющий код: 22 - at x
		jr	z,codeHexA

		inc	hl
		cp	#14					; Управляющий код: 20 - inverse
		jr	z,codeInverse
		jp	printS					; В противном случае просто напечатать код символа

codeHexPrint	inc	hl
		inc	hl
		ld	a,(hl)
		cp	"\\"
		jp	nz,printS				; Ошибочная структура, пропустить символ
		inc	hl
		ld	a,(hl)
		cp	"x"
		jr	nz,codeESC_0				; Ошибочная структура, пропустить символ
		inc	hl
		
		call	getHexNumber
		
		inc	hl
		jp	printS

codeHexI	inc	hl
		inc	hl
		ld	a,(hl)
		cp	"\\"
		jp	nz,printS				; Ошибочная структура, пропустить символ
		inc	hl
		ld	a,(hl)
		cp	"x"
		jr	nz,codeESC_0				; Ошибочная структура, пропустить символ
		inc	hl
		
		call	getHexNumber
		
		inc	hl
		inc	hl
		jp	codeInk_0

codeHexP	inc	hl
		inc	hl
		ld	a,(hl)
		cp	"\\"
		jp	nz,printS				; Ошибочная структура, пропустить символ
		inc	hl
		ld	a,(hl)
		cp	"x"
		jr	nz,codeESC_0				; Ошибочная структура, пропустить символ
		inc	hl
		
		call	getHexNumber
		
		inc	hl
		inc	hl
		jp	codePaper_0

codeHexA	inc	hl
		inc	hl
		call	codeHexA_01
		ld	(codeHexA_00+1),a
		call	codeHexA_01
		ld	b,a
codeHexA_00	ld	c,#00
		jp	codeAt_0

codeHexA_01	ld	a,(hl)
		cp	"\\"
		jp	nz,printS				; Ошибочная структура, пропустить символ
		inc	hl
		ld	a,(hl)
		cp	"x"
		jp	nz,codeESC_0				; Ошибочная структура, пропустить символ
		inc	hl
		
		call	getHexNumber
		
		inc	hl
		inc	hl
		ret

codeSysInk	call	codeSys
		jp	codeInk_0

codeSysPaper	call	codeSys
		jp	codePaper_0

codeSys		inc	hl
		ld	a,(hl)
		inc	hl
		push	hl
		ld	hl,sysColors
		ld	b,#00
		ld	c,a
		add	hl,bc
		ld	a,(hl)
		pop	hl
		ret

;---------------
getHexNumber	push	hl
		ex	hl,de
		call	_hex2int
		ld	a,l
		pop	hl
		ret
;---------------------------------------
printChar	ld	hl,bufer256				; печать символа
		ld	de,(printX)
		add	hl,de
		ld	(hl),a
		
		ld	a,(currentColor)			; печать аттрибутов
		ld	de,128
		add	hl,de
		ld	(hl),a

		ret
;---------------------------------------

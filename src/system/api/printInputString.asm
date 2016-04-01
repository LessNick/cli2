;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #0F printInputString
;---------------------------------------
; Вывести обычную строку в консоль (линия ввода данных 1>)
;  i: HL - адрес строки, заканчивающейся #00
; Управляющие коды в тексте:
;	\x09 - переместить курсок у ближайшей позиции tab (кратной 8?)
;	\x0c - удалить 1 символ слева и переместить курсор на -1 позицию
;	\x0f - установить текущий цвет ink из системного цвета
;	\x10\xNN - установить текущий цвет ink из палитры NN
;	\x11\xNN - установить текущий цвет paper из палитры NN
;	\x12 - установить текущий цвет paper из системного цвета
;	\x14 - инверсия. поменять текущие ink и paper местами
;	\x16\xXX\xYY - установить тукущую позицию печати на XX,YY
;	\xNN - вывести символ кодом NN
;	\x0d - код «enter». X устанавливается в 0, Y увеличивается на 1
;	\x0a - перети на новую строку X без изменений(?), Y увеличивается на 1
;---------------------------------------
_printInputString
		call	printInLine
		jp	printWW

;---------------
printInLine	push	hl
		ld	hl,#0000
		ld	(printEX),hl
		pop	hl
		call	printEStr
		
		ld 	hl,edit256
		ld 	a,#01
		ld 	bc,#0000				; reserved (???)
		call	bufferUpdate
		ret

;---------------
printEStr	xor	a					; Печать в строке ввода
		ld	(eStrLen),a

printEStr_0	ld	a,(hl)
		cp	#00
		jr	z,printEExit

		cp	#09					; Управляющий код: 09 - tab
		jp	z,codeETab
		cp	#0F					; Управляющий код: 15 - system ink код системного цвета
		jp	z,codeESysInk
		cp	#10					; Управляющий код: 16 - ink
		jp	z,codeEInk
		cp	#11					; Управляющий код: 17 - paper
		jp	z,codeEPaper
		cp	#12					; Управляющий код: 18 - system paper код системного цвета
		jp	z,codeESysPaper
		cp	#14					; Управляющий код: 20 - inverse
		jp	z,codeEInverse

		push	hl
		call	printEChar
		ld	a,(printEX)
		inc	a
		cp	80					; Конец буфера edit256
		jr	nz,printEStr_1
		call	printEUp
		xor	a

printEStr_1	ld	(printEX),a

		ld	a,(eStrLen)
		inc	a
		ld	(eStrLen),a

		pop	hl
		inc	hl
		jp	printEStr_0
			
printEUp	push	hl
		ld	hl,edit256
		ld	a,#00
		call	bufferUpdate				; забирается буфер
		call	_editInit

		pop	hl
		ret

printEExit	ld	hl,(scrollOffset)
		inc	h
		ld	(scrollOffset),hl

		ld	a,(eStrLen)
		ret

printEChar	ld	hl,edit256				; печать символа в редактируемой строке
		ld	de,(printEX)

		add	hl,de
		ld	(hl),a
			
		ld	a,(currentColor)			; печать аттрибутов
		ld	de,128
		add	hl,de
		ld	(hl),a
		ret

;---------------
codeETab	ld	a,(printEX)
		srl	a					; /2
		srl	a					; /4
		srl	a					; /8
		cp	#09
		jp	z,printEStr_0
		inc	a
		push	hl
		ld	hl,tabTable
		ld	b,0
		ld	c,a
		add	hl,bc
		ld	a,(hl)
		ld	(printEX),a
		pop	hl
		inc	hl
		jp	printEStr_0

;---------------
codeESysInk	call	codeSys
		jp	codeEInk_0

;---------------
codeEInk	inc	hl
		ld	a,(hl)
		inc	hl

codeEInk_0	cp	16					; 16 ? взять цвет по умолчанию
		jr	nz,codeEInk_1
		call	getFullColor

codeEInk_1	and	%00001111
		ld	c,a
		ld	a,(currentColor)
		and	%11110000
		or	c
		ld	(currentColor),a
		jp	printEStr_0

;---------------
codeEPaper	inc	hl
		ld	a,(hl)
		inc	hl

codeEPaper_0	cp	16					; 16 ? взять цвет по умолчанию
		jr	nz,codeEPaper_1
		call	getFullColor
		and	%11110000
		jr	codeEPaper_2

codeEPaper_1	and	%00001111
		sla	a
		sla	a
		sla	a
		sla	a
codeEPaper_2	ld	c,a
		ld	a,(currentColor)
		and	%00001111
		or	c
		ld	(currentColor),a
		jp	printEStr_0

;---------------
codeESysPaper	call	codeSys
		jp	codeEPaper_0

;---------------
codeEInverse	inc	hl
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
		jp	printEStr_0

;---------------
eStrLen		db	#00
;---------------------------------------

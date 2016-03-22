;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #10 printOkString
;---------------------------------------
; Вывести информационное сообщение (ok) в консоль
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
_printOkString	ld	a,(colorOk)
;---------------
printColorStr	ld	c,a
		ld	a,(currentColor)
		push	af
		and	%11110000
		or	c
		ld	(currentColor),a

		ld	a,b
		cp	#ff
		jr	nz,printColorStr2

		push	hl
		ld	hl,errorMsg
		call	_printString
		pop	hl

printColorStr2	call	_printString
		pop	af
		ld	(currentColor),a
		ld	hl,restoreMsg
		jp	_printString

;---------------------------------------

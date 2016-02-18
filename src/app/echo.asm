;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2015 © breeze/fishbone crew
;---------------------------------------
; echo command
;---------------------------------------
		org	#c000-4

bufferSize	equ	255					; Размер буфера для вывода

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API

appStart	
		db	#7f,"CLA"				; Command Line Application

; 		ex	de,hl					; не надо пропускать пробелы нарушается рисунок ASCII начинающийся с пробелов
; 		ld	a,eatSpaces
; 		call	cliKernel
; 		ex	de,hl

		push	hl					; На входе в HL адрес начала строки с параметрами
		ld	a,printInit
		call	cliKernel

		ld	hl,echoBuffer
		ld	de,echoBuffer+1
		ld	bc,bufferSize-1
		xor	a
		ld	(hl),a
		ldir
		ld	(quoteFlag+1),a
		pop	hl
		ld	de,echoBuffer

echoStr_00	ld	a,(hl)
		cp	#00
		jr	z,echoPrint
		cp	"\""
		jr	nz,echoStr_01
		ld	a,(quoteFlag+1)
		xor	#01
		ld	(quoteFlag+1),a
		jr	echoStr_02

echoStr_01	ld	(de),a
		inc	de
echoStr_02	inc	hl
		jr	echoStr_00

echoPrint	ld	(de),a
		
		ld	hl,echoBuffer
quoteFlag	ld	a,#00
		cp	#01
		jr	nz,quoteOk

		ld	hl,wrongQuoteMsg
		ld	a,printErrorString
		call	cliKernel
		jr	quoteExit

quoteOk		ld	a,printString
		call	cliKernel

		cp	#50					; Если длина строки = 80 символов перенос не нужен
		jr	z,quoteExit

		ld	a,printRestore
		call	cliKernel

quoteExit	ld	a,clearIBuffer				; Очищаем буфер ввода
		jp	cliKernel

wrongQuoteMsg	db	"Error: Unmatched \".",#0d,#00


echoBuffer	ds	eBufferSize, #00

appEnd	nop

		SAVEBIN "install/bin/echo", appStart, appEnd-appStart
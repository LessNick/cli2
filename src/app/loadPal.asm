;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2015 © breeze/fishbone crew
;---------------------------------------
; load palette command
;---------------------------------------
		org	#c000-4

; palBufferSize	equ	516					; 512 + header
palBufferSize	equ	2					; 2*512 = 1024 Размер буфера в блоках по (512кб)

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API
appStart	
		db	#7f,"CLA"				; Command Line Application
								; На входе в HL адрес начала строки с параметрами
		ex	de,hl
		ld	a,eatSpaces
		call	cliKernel
		ex	de,hl

		ld	a,(hl)
		cp	#00
		jp	z,palInfo				; exit: error params

		xor	a
		ld	(isTxtPal+1),a

		ld	de,keyTable
		ld	a,checkCallKeys
		call	cliKernel
		cp	#ff
		jp	z,wrongParams				; exit: error params

		ld	a,(hl)
		cp	#00
		jp	z,noFile				; no file

		ex	de,hl
		ld	a,eatSpaces
		call	cliKernel
		ld	hl,palFileError_1+1
		ld	(hl),de
		ex	de,hl	

; 		ld	de,palBuffer
; 		ld	bc,palBufferSize
; 		ld	a,loadFileLimit
; 		call	cliKernel

		ld	de,palBuffer
		ld	b,palBufferSize
		ld	a,loadFileParts				; Загружаем первую часть в буфер
		call	cliKernel

		cp	#ff
		jp	z,palFileError

		ld	hl,palBuffer
;---------------
		ld	a,(hl)					; проверка сигнатуры
		cp	127
		jr	nz,wrongPal
		inc	hl

		ld	a,(hl)
		cp	"P"
		jr	nz,wrongPal
		inc	hl

		ld	a,(hl)
		cp	"A"
		jr	nz,wrongPal
		inc	hl

		ld	a,(hl)
		cp	"L"
		jr	nz,wrongPal
		inc	hl
;---------------
		ld	a,(hl)					; версия формата
								; TODO: Сделать проверку!!
		inc	hl

;---------------
		ld	a,(hl)					; Тип упаковки данных (#00 - не пакованы)
								; TODO: Сделать проверку!!
		inc	hl

;---------------
		ld	e,(hl)					; Размер палитры
		inc	hl
		ld	d,(hl)
		inc	hl					; TODO: ????
		push	hl
		ld	hl,palSize+1
		ld	(hl),de
		pop	hl

;---------------
		ld	e,(hl)					; Смещение до начала данных
		inc	hl
		ld	d,(hl)
		inc	hl

		add	hl,de

;---------------
isTxtPal	ld	a,#00
		cp	#01
		jr	z,isGfxPal

		ld	a,setTxtPalette
		ld	d,#00					; Номер палитры, куда загружать (0-15)
palSize		ld	bc,#0000
		call	cliKernel

loadPalExit	ld	a,printRestore
		jp	cliKernel

;---------------

isGfxPal	ld	b,#01
		ld	a,setGfxPalette
		jp	cliKernel

setGfxPal	ld	a,getNumberFromParams
		call	cliKernel
		cp	#ff
		jp	z,wrongParams

		ld	a,h
		cp	#00
		jp	nz,wrongParams
		ld	a,l
		cp	#04
		jr	c,dtSetScreen_0
		jp	wrongParams

dtSetScreen_0	ld	a,l
		ld	(isGfxPal+1),a

		ld	a,1
		ld	(isTxtPal+1),a

		ld	a,#fe					; Пропустить следующее значение
		ret

wrongParams	ld	a,printErrParams
		jp	cliKernel

noFile		ld	hl,noFileMsg
		ld	a,printErrorString
		jp	cliKernel

wrongPal	ld	hl,wrongPalMsg
		ld	a,printErrorString
		jp	cliKernel

palFileError	ex	af,af'
		cp	eFileNotFound
		jr	z,palFileError_0
		cp	eFileWrongSize
		ret	nz

		ld	hl,wrongSizeMsg
		ld	a,printErrorString
		jp	cliKernel

palFileError_0	ld	a,printFileNotFound
palFileError_1	ld	hl,#0000
		jp	cliKernel

palInfo		ld	hl,palVersionMsg
		ld	a,printAppNameString
		call	cliKernel

		ld	hl,palCopyRMsg
		ld	a,printCopyrightString
		call	cliKernel

		ld	hl,palUsageMsg
		ld	a,printString
		call	cliKernel

		jp	loadPalExit

;---------------------------------------------
palVersionMsg	db	"Load palette v0.08",#00
palCopyRMsg	db	"2013,2015 ",127," Breeze\\\\Fishbone Crew",#00
		
palUsageMsg	db	#0d,15,5,"Usage: loadpal [switches] filename.pal",#0d
		db	16,16,"  -g n",15,15,"\tgraphics palettes. Load palette for graphics screen N (default 1)"
		db	16,16,#0d,#00

noFileMsg	db	"Error: Incorrect file name.",#0d,#0d,#00
wrongSizeMsg	db	"Error: Wrong file size.",#0d,#0d,#00
wrongPalMsg	db	"Error: Wrong palette file format.",#0d,#0d,#00
wrongParamsMsg	db	"Error: Wrong parametrs.",#0d,#0d,#00

;---------------------------------------------
; Key's table for params
;---------------------------------------------
keyTable	db	"-g"
		db	"*"
		dw	setGfxPal

;--- table end marker ---
		db	#00

palBuffer	ds	palBufferSize,#00

appEnd	nop

		SAVEBIN "install/bin/loadpal", appStart, appEnd-appStart
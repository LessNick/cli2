;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; load font command
;---------------------------------------
		org	#c000-4

fntBufferSize	equ	16					; 16*512 = 8192 Размер буфера в блоках по (512кб)

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
		jp	z,fontInfo				; exit: error params

		ld	de,keyTable
		ld	a,checkCallKeys
		call	cliKernel

		ex	de,hl
		ld	a,eatSpaces
		call	cliKernel
		ld	hl,fontFileError_1+1
		ld	(hl),de
		ex	de,hl

		ld	de,fntBuffer
		ld	b,fntBufferSize
		ld	c,appBank
		ld	a,loadFile				; Загружаем в буфер
		call	cliKernel

		cp	#ff
		jp	z,fontFileError

;---------------
		call	fontVerCopy
;---------------
		ld	hl,fntBuffer
		ld	a,(hl)
		cp	#7f					; Сигнатура #7f + FNT
		jp	nz,wrongFile
		
		inc	hl
		ld	a,(hl)
		cp	"F"
		jp	nz,wrongFile

		inc	hl
		ld	a,(hl)
		cp	"N"
		jp	nz,wrongFile

		inc	hl
		ld	a,(hl)
		cp	"T"
		jp	nz,wrongFile

;---------------
		push	hl
		ld	hl,fntFormatMsg
		call	fntPrint
		pop	hl
;---------------
		inc	hl					; версия формата FNT
		ld	a,(hl)
		push	af
		push	hl
		push	af
		ld	hl,fntVerMsg
		call	fntPrint
		pop	af
		ld	de,fntNumberMsg
		ld	h,#00
		ld	l,a
		ld	a,fourbit2str
		call	cliKernel
		ld	hl,fntNumberMsg
		call	fntPrint
		pop	hl
		pop	af					; TODO: Сделать проверку!!
;---------------
		inc	hl					; Тип упаковки данных (#00 - не пакованы)
		ld	a,(hl)
		push	hl
		push	af
		ld	hl,fntPackMsg
		call	fntPrint
		pop	af
		ld	de,fntNumberMsg
		ld	h,#00
		ld	l,a
		ld	a,fourbit2str
		call	cliKernel
		ld	hl,fntNumberMsg
		call	fntPrint
		pop	hl
								; TODO: Сделать проверку!!
;---------------
		inc	hl					; Тип шрифта
		ld	a,(hl)
		push	hl
		push	af
		ld	hl,fntStyleMsg
		call	fntPrint
		pop	af
		push	af
		and	#0f

		cp	#00					; #x0 - обычный шрифт
		jr	nz,fntSlyle_01
		ld	hl,fntStyleMsgN
		call	fntPrint
		jr	fntSlyle_A

fntSlyle_01	cp	#01					; #x1 - наклонный шрифт (italic)
		jr	nz,fntSlyle_02
		ld	hl,fntStyleMsgB
		call	fntPrint
		jr	fntSlyle_A

fntSlyle_02	cp	#02					; #x2 - жирный шрифт (bold)
		jr	nz,fntSlyle_03
		
		ld	hl,fntStyleMsgI				; #x3 - наклонный + жирный
		call	fntPrint
		jr	fntSlyle_A

fntSlyle_03	ld	hl,fntStyleMsgU				; #?? - неизвестный
		call	fntPrint

fntSlyle_A	pop	af
		and	#80
		cp	#80
		jr	nz,fntSlyle_B

		ld	a,#01					; Не поддерживается !!
		ld	(fontWrongVer+1),a

		ld	hl,fntStyleMsgP				; Пропорциональный шрифт
		jr	fntSlyle_C

fntSlyle_B	ld	hl,fntStyleMsgM				; Моноширный шрифт

fntSlyle_C	call	fntPrint

		pop	hl

;---------------
		inc	hl					; формат данных шрифта:
		ld	a,(hl)
		push	hl
		push	af
		ld	hl,fntTypeMsg
		call	fntPrint
		pop	af

		cp	#01					; #01 - 1 bit (обычный ч/б) шрифт
		jr	nz,fntType_02

		ld	hl,fntType1Msg
		jr	fntType_B

fntType_02	push	af
		ld	a,#01					; Не поддерживается !!
		ld	(fontWrongVer+1),a
		pop	af

		cp	#02					; #02 - 4 bit 16-ти цветный шрифт
		jr	nz,fntType_03

		ld	hl,fntType4Msg
		jr	fntType_B

fntType_03	cp	#03					; #03 - 8 bit 256-ти цветный шрифт
		jr	z,fntType_A

		ld	hl,fntTypeWMsg				; #?? - неизвестный
		jr	fntType_B

fntType_A	ld	hl,fntType8Msg
fntType_B	call	fntPrint

		pop	hl

;---------------
		inc	hl					; ширина шрифта:
		push	hl
		ld	hl,fntWidthMsg
		call	fntPrint
		pop	hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		push	hl
		ex	de,hl

		ld	a,h
		cp	#00
		jr	nz,fntWidthWrong
		ld	a,l
		cp	#08
		jr	z,fntWidthOk

fntWidthWrong	ld	a,#01					; Не поддерживается !!
		ld	(fontWrongVer+1),a

fntWidthOk	ld	de,fntBigNumberMsg
		ld	a,int2str
		call	cliKernel

		ld	hl,fntBigNumberMsg
		call	fntPrint

		pop	hl
;---------------
		inc	hl					; высота шрифта:
		push	hl
		ld	hl,fntHeightMsg
		call	fntPrint
		pop	hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		push	hl
		ex	de,hl

		ld	a,h
		cp	#00
		jr	nz,fntHeightWrong
		ld	a,l
		cp	#08
		jr	z,fntHeightOk

fntHeightWrong	ld	a,#01					; Не поддерживается !!
		ld	(fontWrongVer+1),a

fntHeightOk
		ld	de,fntBigNumberMsg
		ld	a,int2str
		call	cliKernel

		ld	hl,fntBigNumberMsg
		call	fntPrint

		pop	hl
;---------------
		inc	hl					; начало данных bitmap
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		inc	hl
		push	hl
		add	hl,de
		ld	(fontAddrStart+1),hl

;---------------
		pop	hl					; начало данных палитры
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		inc	hl
		push	hl
		add	hl,de
; 		ld	(fontAddrStart+1),hl

;---------------
		pop	hl					; начало данных таблицы ширины
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		inc	hl
		push	hl
		add	hl,de
; 		ld	(fontAddrStart+1),hl

;---------------
		ld	hl,fntNameMsg
		call	fntPrint
		pop	hl

;---------------
		ld	e,(hl)					; начало мета-данных (название шрифта)
		inc	hl
		ld	d,(hl)
		inc	hl
		ex	de,hl
		add	hl,de
		push	hl
		ex	de,hl
		call	fntPrint
		ld	hl,fntEndMsg
		call	fntPrint

;---------------
		ld	hl,fntAuthorMsg
		call	fntPrint
		pop	hl

;---------------
		ld	e,(hl)					; автор шрифта
		inc	hl
		ld	d,(hl)
		inc	hl
		ex	de,hl
		add	hl,de
		push	hl
		ex	de,hl
		call	fntPrint
		ld	hl,fntEndMsg
		call	fntPrint

;---------------
		ld	hl,fntDizMsg
		call	fntPrint
		pop	hl

;---------------
		ld	e,(hl)					; описание шрифта
		inc	hl
		ld	d,(hl)
		inc	hl
		ex	de,hl
		add	hl,de
		push	hl
		ex	de,hl
		call	fntPrint
		ld	hl,fntEndMsg
		call	fntPrint
		pop	hl

;---------------
fontWrongVer	ld	a,#00					; Не загружать, если неверная версия шрифта
		cp	#01
		jr	nz,fontAddrStart
		ld	hl,wrongVerMsg
		call	fontPrintErr
		jr	fntExit

fontAddrStart	ld	hl,fntBuffer
		ld	a,setFont
		call	cliKernel

fntExit		ld	a,printRestore				; Восстанавливаем все цвета и параметры, что бы не было глюков
		jp	cliKernel
;---------------
fontFileError	ex	af,af'
		cp	eFileNotFound
		jr	z,fontFileError_0
		cp	eFileWrongSize
		ret	nz

		ld	hl,wrongSizeMsg
		ld	a,printErrorString
		jp	cliKernel

fontFileError_0	ld	a,printFileNotFound
fontFileError_1	ld	hl,#0000
		jp	cliKernel

wrongParams	ld	a,printErrParams
		jp	cliKernel

noFile		ld	hl,noFileMsg
fontPrintErr	ld	a,printErrorString
		jp	cliKernel

;---------------------------------------------
fontInfo	ld	a,(fntPrint+1)
		cp	#01
		ret	z

		call	fontVerCopy

		ld	hl,fontUsageMsg
		ld	a,printOkString
		jp	cliKernel

fontVerCopy	ld	a,(fntPrint+1)
		cp	#01
		ret	z

		ld	hl,fontVersionMsg
		ld	a,printAppNameString
		call	cliKernel

		ld	hl,fontCopyRMsg
		ld	a,printCopyrightString
		jp	cliKernel
;---------------------------------------------
fntPrint	ld	a,#00
		cp	#01
		ret	z
		ld	a,printString
		jp	cliKernel

setSilentMode	ld	a,#01
		ld	(fntPrint+1),a
		xor	a					; Обязательно должно быть 0!!!
		ret

;---------------------------------------------
wrongFile	ld	hl,wrongFileMsg
		ld	a,printErrorString
		call	cliKernel
		ld	a,#ff					; error
		ret
;---------------------------------------------
fontVersionMsg	db	"Font loader for CLI2 v0.12",#00
fontCopyRMsg	db	"2013,2016 ",127," Breeze\\\\Fishbone Crew",#0d,#00
		
fontUsageMsg	db	"Usage: loadfont [switches] filename.fnt",#0d
		db	16,16,"  -g ",15,15,"\tgraphics mode. load fonts into graphics memory (default console)",#0d
		db	16,16,"  -s ",15,15,"\tsilent mode. additional information is not displayed",#0d
		db	16,16,"  -v ",15,15,"\tversion. show application's version and copyrights",#0d
		db	16,16,"  -h ",15,15,"\thelp. show this info",#0d
		db	16,16,#0d,#00

noFileMsg	db	"Error: Incorrect file name.",#0d,#00
wrongSizeMsg	db	"Error: Wrong file size.",#0d,#00
wrongFileMsg	db	"Error: Incorrect file format.",#0d,#0d,#00
wrongVerMsg	db	#0d,"Error: Unsupported font format. (Supported only b/w 1bit, monospaced, 8x8px )"
		db	#0d,"       If you want load font for graphics mode, use -g key",#0d,#0d,#00

fntFormatMsg	db	" ",249," Font format: FNT detected!",#0d,#00
fntVerMsg	db	" ",249," FNT header version: ",#00
fntPackMsg	db	" ",249," Pack type: ",#00
fntNumberMsg	db	"--",#0d,#00
fntStyleMsg	db	" ",249," Font style: ",#00
fntStyleMsgN	db	"normal ",#00
fntStyleMsgB	db	"bold ",#00
fntStyleMsgI	db	"italic ",#00
fntStyleMsgU	db	"unknown ",#00
fntStyleMsgM	db	"monospaced",#0d,#00
fntStyleMsgP	db	"proportional",#0d,#00
fntTypeMsg	db	" ",249," Font type: ",#00
fntType1Msg	db	"1 bit (b/w font)",#0d,#00
fntType4Msg	db	"4 bit (16 colors font)",#0d,#00
fntType8Msg	db	"8 bit (256 colors font)",#0d,#00
fntTypeWMsg	db	"wrong format",#0d,#00
fntWidthMsg	db	" ",249," Font width: ",#00
fntHeightMsg	db	" ",249," Font height: ",#00
fntBigNumberMsg	db	"----- px",#0d,#00
fntNameMsg	db	" ",249," Font name: ",243,#00
fntAuthorMsg	db	" ",249," Font author: ",243,#00
fntDizMsg	db	" ",249," Font diz: ",243,#00
fntEndMsg	db	242,#0d,#00

;---------------------------------------------
; Key's table for params
;---------------------------------------------
keyTable	db	"-h"
		db	"*"
		dw	fontInfo

		db	"-s"
		db	"*"
		dw	setSilentMode

		db	"-v"
		db	"*"
		dw	fontVerCopy

;--- table end marker ---
		db	#00

;---------------------------------------------
appEnd		nop

		org	#e000
fntBuffer	nop
		
; 		DISPLAY "fontAddrStart",/A,fontAddrStart
; 		DISPLAY "fontWrongVer",/A,fontWrongVer

		SAVEBIN "install/bin/loadfont", appStart, appEnd-appStart

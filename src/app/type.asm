;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2015 © breeze/fishbone crew
;---------------------------------------
; type - show txt file application
;--------------------------------------		
		org	#c000-4

typeBufferSize	equ	#10					; 16*512 = 8192 Размер буфера в блоках по (512кб)

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API

appStart	
		db	#7f,"CLA"				; Command Line Application

		xor	a
		ld	(typeFileCheck+1),a

		ex	de,hl
		ld	a,eatSpaces
		call	cliKernel
		ex	de,hl

		ld	a,(hl)
		cp	#00
		jr	z,typeNoParams				; exit: error params


		ld	de,keyTable
		ld	a,checkCallKeys
		call	cliKernel

typeFileCheck	ld	a,#00
		cp	#01
		ret	z					; просто выход

		call	typeClearBuff

		ex	de,hl
		ld	a,eatSpaces
		call	cliKernel
		ld	hl,typeFileError_1+1
		ld	(hl),de
		ex	de,hl		

		ld	de,typeBuffer
		ld	b,typeBufferSize
		ld	a,loadFileParts
		call	cliKernel
		cp	#ff
		jr	z,typeFileError

		ld	b,#01					; не использовать управляющие коды
		ld	a,printCodeDisable
		call	cliKernel

typeLoop	ld	a,printString
		ld	hl,typeBuffer
		call	cliKernel

		call	typeClearBuff

		ld	a,loadNextPart
		call	cliKernel
		cp	#ff					; конец файла?
		jr	nz,typeLoop
		
		ex	af,af'
		cp	eFileEnd
		jr	nz,typeLoop

		ld	hl,typeBufferEnd			;печать конца
		ld	a,printString
		call	cliKernel

typeExit	ld	b,#00					; восстановить управляющие коды
		ld	a,printCodeDisable
		call	cliKernel

		ld	b,#00					; запретить scroll
		ld	a,printWithScroll
		call	cliKernel

		ld	a,printRestore
		jp	cliKernel

;---------------
typeNoParams	call	typeVer
		jr	typeInfo

typeVer		ld	hl,typeVersionMsg
		ld	a,printAppNameString
		call	cliKernel

		ld	hl,typeCopyRMsg
		ld	a,printCopyrightString
		call	cliKernel

		ld	a,#01
		ld	(typeFileCheck+1),a
		ret

typeInfo	ld	hl,typeUsageMsg
		ld	a,printOkString
		call	cliKernel
		
		ld	a,#01
		ld	(typeFileCheck+1),a
		ret

;---------------
typeFileError	ex	af,af'
		cp	eFileNotFound
		jr	z,typeFileError_0
		cp	eFileWrongSize
		ret	nz

		ld	hl,wrongSizeMsg
		ld	a,printErrorString
		jp	cliKernel

typeFileError_0	ld	a,printFileNotFound
typeFileError_1	ld	hl,#0000
		jp	cliKernel

wrongParams	ld	a,printErrParams
		jp	cliKernel

noFile		ld	hl,noFileMsg
		ld	a,printErrorString
		jp	cliKernel

typeClearBuff	push	hl,de,bc
		ld	hl,typeBuffer
		ld	de,typeBuffer+1
		ld	bc,typeBufferSize*512
		xor	a
		ld	(hl),a
		ldir
		pop	bc,de,hl
		ret
;-------
setScrollEnable	ld	b,#01					; разрешить scroll
		ld	a,printWithScroll
		call	cliKernel
		ret
;-------
typeVersionMsg	db	"Type (Displays the contents of a text file) v0.06",#00
typeCopyRMsg	db	"2013,2015 ",127," Breeze\\\\Fishbone Crew",#0d,#00

typeUsageMsg	db	15,5,"Usage: type [switches] filename.txt",#0d
		db	16,16,"  -s ",15,15,"\tYe! old classic ",243,"scroll?",242," from zx basic. Show limited amount of strings",#0d
		db	16,16,"  -v ",15,15,"\tversion. show application's version and copyrights",#0d
 		db	16,16,"  -h ",15,15,"\thelp. show this info",#0d
		db	16,16,#0d,#00

noFileMsg	db	"Error: Incorrect file name.",#0d,#00
wrongSizeMsg	db	"Error: Wrong file size.",#0d,#00

typeBuffer	ds	typeBufferSize*512,#00
		db	#00,#00
typeBufferEnd	db	#0d,#00
		ds	10, #00

;---------------------------------------------
; Key's table for params
;---------------------------------------------
keyTable	db	"-s"
		db	"*"
		dw	setScrollEnable

		db	"-h"
		db	"*"
		dw	typeInfo

		db	"-v"
		db	"*"
		dw	typeVer
;--- table end marker ---
		db	#00
appEnd	nop

		SAVEBIN "install/bin/type", appStart, appEnd-appStart
;---------------------------------------
; CLi² (Command Line Interface)
; 2016 © breeze/fishbone crew
;---------------------------------------
; cursor command
;---------------------------------------
		org	#c000-4

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API

appStart	
		db	#7f,"CLA"				; Command Line Application
								; На входе в HL адрес начала строки с параметрами
		ld	a,(hl)
		cp	#00
		jp	z,appShowInfo				; exit: error params

		ld	de,keyTable
		ld	a,checkCallKeys
		call	cliKernel

		cp	#ff
		jp	z,wrongParams

		ex	de,hl
		ld	a,eatSpaces
		call	cliKernel
		ex	de,hl

		push	hl
		ld	a,(hl)
		call	lowerCase
		cp	"s"
		jr	nz,testHide
		inc	hl

		ld	a,(hl)
		call	lowerCase
		cp	"h"
		jr	nz,testHide
		inc	hl

		ld	a,(hl)
		call	lowerCase
		cp	"o"
		jr	nz,testHide
		inc	hl

		ld	a,(hl)
		call	lowerCase
		cp	"w"
		jr	nz,testHide
		inc	hl

		ld	a,(hl)
		cp	" "
		jr	z,showOk
		cp	#00
		jr	z,showOk
		pop	hl
		jr	wrongParams

showOk		pop	hl
		jr	showCursor

testHide	pop	hl
		
		ld	a,(hl)
		call	lowerCase
		cp	"h"
		jr	nz,wrongParams
		inc	hl

		ld	a,(hl)
		call	lowerCase
		cp	"i"
		jr	nz,wrongParams
		inc	hl

		ld	a,(hl)
		call	lowerCase
		cp	"d"
		jr	nz,wrongParams
		inc	hl

		ld	a,(hl)
		call	lowerCase
		cp	"e"
		jr	nz,wrongParams
		inc	hl

		ld	a,(hl)
		cp	" "
		jr	z,hideCursor
		cp	#00
		jr	z,hideCursor
		pop	hl
		jr	wrongParams

;---------------
lowerCase	cp	"A"					; Делает символ маленьким
		ret	c
		cp	"Z"+1
		ret	nc
		add	32
		ret
;---------------
setScreen	ld	a,getNumberFromParams
		call	cliKernel
		cp	#ff
		jr	z,wrongParams

		ld	a,h
		cp	#00
		jr	nz,wrongParams

		ld	a,l
		cp	#04
		jr	c,cSetScreen_0
		jp	wrongParams

cSetScreen_0	ld	(showCursor+1),a
		ld	(hideCursor+1),a
		
		ld	a,#fe					; Пропустить следующее значение
		ret
;---------------
showCursor	ld	b,#01
		ld	c,#01
		ld	a,showHideCursor
		call	cliKernel
		xor	a
		ret
;---------------
hideCursor	ld	b,#01
		ld	c,#00
		ld	a,showHideCursor
		call	cliKernel
		xor	a
		ret
;---------------
wrongParams	ld	a,printErrParams
		jp	cliKernel

appExit
		ret
;---------------------------------------------
appShowInfo	call	appVer					; Вывод информации о программе
		call	appHelp
		jp	appExit

appVer		ld	hl,appVersionMsg			
		ld	a,printAppNameString
		call	cliKernel

		ld	hl,appCopyRMsg
		ld	a,printCopyrightString
		call	cliKernel
		ret

appHelp		ld	hl,appUsageMsg
		ld	a,printString
		call	cliKernel
		ret
;---------------
appVersionMsg	db	"Show/Hide mouse Cursor v0.01",#00
appCopyRMsg	db	"2016 ",pCopy," Breeze\\\\Fishbone Crew",#0d,#00

appUsageMsg	db	15,csOk,"Usage: Cursor [switches] show/hide",#0d
		db	16,cRestore,"  -s ",15,csInfo,"\tscreen number. Default is 1",#0d
		db	16,cRestore,#0d,#00
;---------------------------------------------
; Key's table for params
;---------------------------------------------
keyTable
		db	"-s"
		db	"*"
		dw	setScreen

appEnd	nop
; 		DISPLAY "setScreen",/A,setScreen

		SAVEBIN "install/bin/cursor", appStart, appEnd-appStart

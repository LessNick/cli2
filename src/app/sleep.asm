;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
; sleep command
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
		jr	z,appShowInfo				; exit: error params

		ld	de,keyTable
		ld	a,checkCallKeys
		call	cliKernel

		cp	#ff
		jp	z,wrongParams

		ld	a,str2int
		call	cliKernel
		cp	#ff					; exit: wrong params
		jr	z,wrongParams

		ld	a,h
		or	l
		jr	z,unlimitWait

		ld	b,a
sleep_01a	push	bc
		ld	b,50

sleep_01b	halt
		djnz	sleep_01b
		pop	bc
		djnz	sleep_01a

		ret
;---------------
unlimitWait	ld	a,#00
		cp	#01
		jr	nz,unlimitWait_0

		ld	a,printRestore
		call	cliKernel
		jr	unlimitWait_1
		
unlimitWait_0	ld	a,printContinue
		call	cliKernel

unlimitWait_1	ld	a,waitAnyKey
		jp	cliKernel

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
setSilentMode	ld	a,#01
		ld	(unlimitWait+1),a
		xor	a					; Обязательно должно быть 0!!!
		ret
;---------------
appVersionMsg	db	"Sleep v0.02",#00
appCopyRMsg	db	"2013,2014 ",127," Breeze\\\\Fishbone Crew",#0d,#00

appUsageMsg	db	15,5,"Usage: Sleep [switches] seconds",#0d
		db	16,16,"  -s ",15,15,"\tsilent mode. information is not displayed",#0d
		db	16,16,#0d,#00
;---------------------------------------------
; Key's table for params
;---------------------------------------------
keyTable
		db	"-s"
		db	"*"
		dw	setSilentMode
appEnd	nop

		SAVEBIN "install/bin/sleep", appStart, appEnd-appStart

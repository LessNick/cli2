;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
; Test example
;---------------------------------------
		org	#c000-4

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API

appStart	
		db	#7f,"CLA"				; Command Line Application

		ld	a,#00
appLoop		push	af
		ld	(testColor),a
		ex	af,af
		ld	de,testNumber
		ld	a,char2hex
		call	cliKernel
		
		ld	a,(testNumber)
		ld	(testColorN),a
		ld	a,(testNumber+1)
		ld	(testColorN+1),a

		ld	hl,testMsg
		ld	a,printString
		call	cliKernel
		pop	af
		inc	a
		cp	#10
		jr	nz,appLoop
		
		xor	a					; no error, clean exit!
		ret
	
testMsg		db	16,16,"this is test for the long line with number #"
testNumber	db	"00 and ",16
testColor	db	#00,"color #"
testColorN	db	"00",#0d,16,16
		db	#00

appEnd	nop

		SAVEBIN "install/bin/test", appStart, appEnd-appStart
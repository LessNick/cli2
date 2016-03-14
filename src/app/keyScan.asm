;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
; keyboard scancode application
;---------------------------------------
		org	#c000-4

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API
appStart	
		db	#7f,"CLA"				; Command Line Application
								; На входе в HL адрес начала строки с параметрами
		ld	hl,versionMsg
		ld	a,printString
		call	cliKernel

		halt
		ld	a,ps2GetScanCode
		call	cliKernel
		jr	appFirstCall

appLoop		halt

		ld	a,ps2GetScanCode
		call	cliKernel

		ld	a,l
		cp	#00
		jr	nz,appNext
		
appFirstCall	ld	a,d
		or	e
		jr	nz,appNext

		jr	appLoop

appNext		ld	a,l

		cp	#76					; ESC
		jr	nz,appNext_00

		ld	a,(checkEsc)
		cp	#01					; ESC twice = exit
		ret	z

		ld	a,#01
		ld	(checkEsc),a
		jr	appNext_01

appNext_00	cp	#f0
		jr	z,appNext_01
		xor	a
		ld	(checkEsc),a

appNext_01	push	de,hl
		ld	a,l
		ex	af,af'
		ld	de,keyCode1+1
		ld	a,char2hex
		call	cliKernel

		pop	hl
		ld	a,h
		ex	af,af'
		ld	de,keyCode2+1
		ld	a,char2hex
		call	cliKernel

		pop	hl
		push	hl

		ld	a,l
		ex	af,af'
		ld	de,keyCode3+1
		ld	a,char2hex
		call	cliKernel

		pop	hl
		ld	a,h
		ex	af,af'
		ld	de,keyCode4+1
		ld	a,char2hex
		call	cliKernel

		ld	hl,keyCode1
		ld	a,printString
		call	cliKernel

		jr	appLoop

versionMsg	db	16,2,"PS/2 keyboard scancode v0.02",#0d
		db	16,3,"2013,2014 ",127," Breeze\\\\FBn",#0d,#0d
		db	16,16,"Press ",20," any key ",20," for get scan code. Press ",20," ESC ",20," twice for exit.",#0d,#0d
		db	#00

keyCode1	db	"#-- "
keyCode2	db	"#-- "
keyCode3	db	"#-- "
keyCode4	db	"#-- "
		db	#0d,#00

checkEsc	db	#00

appEnd	nop

		SAVEBIN "install/bin/keyscan", appStart, appEnd-appStart

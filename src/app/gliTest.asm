;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
; Test graphics library
;---------------------------------------
		org	#c000-4

		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API
		include "libs/gli.h.asm"			; Список комманд Graphics Library

appStart	
		db	#7f,"CLA"				; Command Line Application

;---------------------------------------
		ld	a,getGliVersion
		call	gfxLibrary

		push	hl
		ld	h,#00

		ld	de,minorMsg
		ld	a,fourbit2str
		call	cliKernel

		pop	hl

		ld	l,h
		ld	h,#00

		ld	de,majorMsg
		ld	a,fourbit2str
		call	cliKernel

		ld	hl,versionMsg
		ld	a,printString
		call	cliKernel
		
		ld	a,printRestore
		jp	cliKernel
	
;---------------------------------------
versionMsg	db	16,16
		db	"Current version of Graphics Library is "
majorMsg	db	"--."
minorMsg	db	"--"
		db	#0d,#00

appEnd	nop

		SAVEBIN "install/bin/glitest", appStart, appEnd-appStart

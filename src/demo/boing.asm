;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
; Amiga Boing (GLi demo)
;---------------------------------------
		org	#c000-4

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API

appStart	
		db	#7f,"CLA"				; Command Line Application

		call	appVer
		call	appRun

		ld	hl,appCallBack
		ld	a,setAppCallBack
		call	cliKernel

appLoop		halt
		ld	a,getKeyWithShift
		call	cliKernel
		
		cp	aEsc
		jp	z,appExit

		jp	appLoop

;---------------------------------------------
appExit		ld	a,editInit
		call	cliKernel

		ld	hl,appExitMsg
		ld	a,printString
		call	cliKernel

		ld	a,printRestore
		jp	cliKernel

;---------------------------------------------
appCallBack
		ret
;---------------------------------------------
appVer		ld	hl,appVersionMsg			
		ld	a,printAppNameString
		call	cliKernel

		ld	hl,appCopyRMsg
		ld	a,printCopyrightString
		jp	cliKernel
		
;---------------------------------------------
appRun		ld	hl,appRunMsg			
		ld	a,printString
		jp	cliKernel
;---------------------------------------------
appVersionMsg	db	"Amiga Boing (GLi demo) v 0.04",#00

appCopyRMsg	db	"2013,2014 ",127," Breeze\\\\Fishbone Crew",#0d,#00

appRunMsg	db	15,6
		db	"Running...",#0d,#0d
		db	16,16
		db	#00

appExitMsg	db	15,5,"Exit.",#0d
		db	16,16
		db	#00
;---------------------------------------------
appEnd	nop

		SAVEBIN "install/demo/boing/boing", appStart, appEnd-appStart

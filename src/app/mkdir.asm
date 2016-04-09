;---------------------------------------
; CLi² (Command Line Interface)
; 2014,2016 © breeze/fishbone crew
;---------------------------------------
; mkdir - create directory
;--------------------------------------		
		org	#c000-4

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API

appStart	
		db	#7f,"CLA"				; Command Line Application

		ld	a,(hl)
		cp	#00
		jr	z,appNoParams				; exit: no params

		ex	de,hl
		ld	a,eatSpaces
		call	cliKernel
		ex	de,hl

		ld	b,#00
		ld	de,dirname
mkLoop		ld	a,(hl)
		ld	(de),a
		inc	hl
		inc	de
		ld	a,(hl)
		cp	#00
		jr	z,checkDirName
		
		inc	b
		ld	a,b
		cp	12
		jr	nz,mkLoop

checkDirName	ld	hl,dirname
		ld	a,checkDirExist
		call	cliKernel
		jr	nz,dirExist

		ld	hl,dirname
		ld	a,checkFileExist
		call	cliKernel
		jr	nz,fileExist

		ld	hl,dirname
		ld	a,createDir
		call	cliKernel
		ret	z

		ld	hl,errorMsg
		ld	a,printString
		call	cliKernel

		ld	hl,dirname
		ld	a,printString
		call	cliKernel

		ld	hl,errorMsg_
		ld	a,printString
		jp	cliKernel

;---------------
fileExist	ld	hl,errorMsg3
		jr	dirExist_

;---------------
dirExist	ld	hl,errorMsg2
dirExist_	ld	a,printString
		call	cliKernel

		ld	hl,dirname
		ld	a,printString
		call	cliKernel

		ld	hl,errorMsg2_
		ld	a,printString
		jp	cliKernel

;---------------
appNoParams	call	appVer
		jr	appInfo

appVer		ld	hl,appVersionMsg
		ld	a,printAppNameString
		call	cliKernel

		ld	hl,appCopyRMsg
		ld	a,printCopyrightString
		call	cliKernel
		ret

appInfo		ld	hl,appUsageMsg
		ld	a,printOkString
		call	cliKernel
		ret

;---------------
dirname		ds	12,0
		db	#00
;---------------
appVersionMsg	db	"MKdir (create directory) v0.02",#00
appCopyRMsg	db	"2014,2016 ",pCopy," Breeze\\\\Fishbone Crew",#0d,#00

appUsageMsg	db	15,csOk,"Usage: mkdir dirname",#0d
		db	16,cRestore,#0d,#00

errorMsg	db	16,cRed,"Error: Can't create directory ",pQuoteOpen,#00
errorMsg_	db	pQuoteClose,16,cRestore,#0d,#00

errorMsg2	db	16,cRed,"Error: Directory ",pQuoteOpen,#00
errorMsg2_	db	pQuoteClose," already exist.", 16,cRestore,#0d,#00

errorMsg3	db	16,cRed,"Error: File ",pQuoteOpen,#00

appEnd	nop
; 		DISPLAY "checkDirName",/A,checkDirName

		SAVEBIN "install/bin/mkdir", appStart, appEnd-appStart

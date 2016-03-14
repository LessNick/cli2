;---------------------------------------
; CLi² (Command Line Interface)
; 2014 © breeze/fishbone crew
;---------------------------------------
; testsave - тестовое приложение для создания файла и записи
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
		jp	z,appNoParams				; exit: no params

		ex	de,hl
		ld	a,eatSpaces
		call	cliKernel
		ex	de,hl

		ld	b,#00
		ld	de,filename
mkLoop		ld	a,(hl)
		ld	(de),a
		inc	hl
		inc	de
		ld	a,(hl)
		cp	#00
		jr	z,checkFileName
		
		inc	b
		ld	a,b
		cp	12
		jr	nz,mkLoop

checkFileName	ld	hl,filename
		ld	a,checkDirExist
		call	cliKernel
		jr	nz,dirExist

		ld	hl,filename
		ld	a,checkFileExist
		call	cliKernel
		jr	nz,fileExist



		ld	hl,filename
		ld	bc,#0010		; младшая часть
		ld	de,#0000		; старшая часть
		ld	a,createFile
		call	cliKernel
		jr	z,writeContent

		ld	hl,errorMsg
		ld	a,printString
		call	cliKernel

		ld	hl,filename
		ld	a,printString
		call	cliKernel

		ld	hl,errorMsg_
		ld	a,printString
		jp	cliKernel

;---------------
writeContent	;ld	hl,fileContent
		;ld	a,			; ???
		;ld	b,#01			; размер в блоках по 512b
		;call	cliKernel		
		ret

;---------------
fileExist	ld	hl,errorMsg3
		jr	dirExist_

;---------------
dirExist	ld	hl,errorMsg2
dirExist_	ld	a,printString
		call	cliKernel

		ld	hl,filename
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
filename	ds	12,0
		db	#00
;---------------
appVersionMsg	db	"Test Save (create file & write content) v0.01",#00
appCopyRMsg	db	"2014 ",127," Breeze\\\\Fishbone Crew",#0d,#00

appUsageMsg	db	15,5,"Usage: testsave filename",#0d
		db	16,16,#0d,#00

errorMsg	db	16,10,"Error: Can't create file ",243,#00
errorMsg_	db	242,16,16,#0d,#00

errorMsg2	db	16,10,"Error: Directory ",243,#00
errorMsg2_	db	242," already exist.", 16,16,#0d,#00

errorMsg3	db	16,10,"Error: File ",243,#00

fileContent	db	"0123456789ABCDEF"
		ds	512,0
appEnd	nop

; 		DISPLAY "checkFileName",/A,checkFileName

		SAVEBIN "install/bin/testsave", appStart, appEnd-appStart

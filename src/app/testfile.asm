;---------------------------------------
; CLi² (Command Line Interface)
; 2014 © breeze/fishbone crew
;---------------------------------------
; testfile - тестовое приложение для проверки наличия файла/директории
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

		push	hl

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

checkFileName	ld	hl,dirMsg
		ld	a,printString
		call	cliKernel

		ld	hl,filename
		ld	a,printString
		call	cliKernel

		pop	hl
		push	hl
		ld	a,checkDirExist
		call	cliKernel

		ld	hl,dirMsg0
		jr	z,check_00
		ld	hl,dirMsg1

check_00	ld	a,printString
		call	cliKernel

		ld	hl,fileMsg
		ld	a,printString
		call	cliKernel

		pop	hl
		ld	a,printString
		call	cliKernel

		ld	hl,filename
		ld	a,checkFileExist
		call	cliKernel
		ld	hl,fileMsg0
		jr	z,check_01
		ld	hl,fileMsg1

check_01	ld	a,printString
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
appVersionMsg	db	"Test File (check is file or dir exist) v0.01",#00
appCopyRMsg	db	"2014 ",127," Breeze\\\\Fishbone Crew",#0d,#00

appUsageMsg	db	15,5,"Usage: testfile filename",#0d
		db	16,16,#0d,#00

dirMsg		db	"Directory ",243,#00
dirMsg0		db	242," not found.", 16,16,#0d,#00
dirMsg1		db	242," already exist.", 16,16,#0d,#00

fileMsg		db	"File ",243,#00
fileMsg0	db	242," not found.", 16,16,#0d,#00
fileMsg1	db	242," already exist.", 16,16,#0d,#00

appEnd	nop

		SAVEBIN "install/bin/testfile", appStart, appEnd-appStart
		
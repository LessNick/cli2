;---------------------------------------
; CLi² (Command Line Interface)
; 2014 © breeze/fishbone crew
;---------------------------------------
; Grab TR-DOS Diks to TRD Image
;---------------------------------------
		org	#c000-4

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API

appStart	
		db	#7f,"CLA"				; Идентификатор приложения CLA (Command Line Application)

		ld	a,(hl)
		cp	#00
		jp	z,appShowInfo				; Выход. Вывод информации о программе

appExit		ret
;---------------------------------------------
diskInfo
		ret
;---------------------------------------------
appShowInfo	call	appVer				; Вывод информации о программе
		call	appHelp
		jp	appExit

appVer		ld	hl,appVersionMsg			
		ld	a,printAppNameString
		call	cliKernel

		ld	hl,appCopyRMsg
		ld	a,printCopyrightString
		call	cliKernel
; 		ld	a,#01					; Просто выйти если файл не задан
; 		ld	(sxgFileCheck+1),a
		ret

appHelp		ld	hl,appUsageMsg
		ld	a,printString
		call	cliKernel
; 		ld	a,#01					; Просто выйти если файл не задан
; 		ld	(sxgFileCheck+1),a
		ret
;---------------------------------------------
appVersionMsg	db	"Dump TR-DOS Disk to TRD Image v 0.01",#00
appCopyRMsg	db	"2014 ",pCopy," Breeze\\\\Fishbone Crew",#0d,#00

appUsageMsg	db	#0d,15,csOk,"Usage: disk2trd [switches] filename.sxg",#0d
		db	16,cRestore,"  -i ",15,csInfo,"\tinfo. Show disk information",#0d
		db	16,cRestore,"  -v ",15,csInfo,"\tversion. show application's version and copyrights",#0d
		db	16,cRestore,"  -h ",15,csInfo,"\thelp. show this info"
		db	16,cRestore,#0d,#00
;---------------------------------------------
; Key's table for params
;---------------------------------------------
keyTable
		db	"-h"
		db	"*"
		dw	appShowInfo

		db	"-v"
		db	"*"
		dw	appVer

		db	"-i"
		db	"*"
		dw	diskInfo

;--- table end marker ---
		db	#00
appEnd	nop

		SAVEBIN "install/bin/disk2trd", appStart, appEnd-appStart

;---------------------------------------
; CLi² (Command Line Interface)
; 2016 © breeze/fishbone crew
;---------------------------------------
; PT3 file loader
;---------------------------------------

		org	#c000-4
		
		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API
appStart
		db	#7f,"CLA"				; Command Line Application
;---------------------------------------------
		xor	a
		ld	(enableAutoPlay+1),a
		ld	(ayPrintStatus+1),a
		ld	(ayFileCheck+1),a

		ld	a,(hl)
		cp	#00
		jp	z,ayShowInfo				; Выход. Вывод информации о программе

		push	hl
		ld	a,disableAyPlay
		call	cliKernel
		ld	a,pt3loopDisable
		call	cliDrivers
		pop	hl

		ex	de,hl
		ld	a,eatSpaces
		call	cliKernel
		ex	de,hl

		ld	de,keyTable
		ld	a,checkCallKeys
		call	cliKernel

		cp	#ff
		jp	z,ayShowInfo				; Выход. Вывод информации о программе

		ld	a,(hl)
		cp	#00
		jp	nz,ayContinue

ayFileCheck	ld	a,#00
		cp	#01
		ret	z
		jp	fileNotSet				; Выход. Не задан файл

ayContinue	ld	(ayFileName+1),hl

		ld	a,(ayPrintStatus+1)
		cp	#01
		jr	z,startLoader
		call	ayLoaderVer

;---------------------------------------------
startLoader	
ayFileName	ld	de,#0000				; Имя файла

		ld	a,eatSpaces
		call	cliKernel
		ex	de,hl
		push	hl
		call	ayPrtFilename
		pop	hl
		ld	de,ayBuffer
		xor	a
		ex	af,af'					; загрузка с сохранением пути
		ld	a,loadFile				; Загружаем файл в буфер
								; На выходе в BC - размер
		call	cliKernel
		cp	#ff					; Если на выходе #ff = ошибка
		jp	z,ayPrtError

		push	bc
		call	ayPrtOk
		pop	bc

		ld	a,uploadAyModule
		ld	hl,ayBuffer
		call	cliKernel

		ld	a,pt3init
		call	cliDrivers

ayType		ld	a,#00
		cp	#01
		jr	nz,ayLoop
	
switchType	ld	a,#00
		push	af

		ld	hl,ayTypeABC
		cp	pt3abc
		jr	z,swt_print

		ld	hl,ayTypeACB
		cp	pt3acb
		jr	z,swt_print

		ld	hl,ayTypeBAC
swt_print	call	ayPrintStatus

		pop	af
		ex	af,af'
		ld	a,pt3setType
		call	cliDrivers

		call	ayPrtOk

ayLoop		ld	a,#00
		cp	#01
		jr	nz,enableAutoPlay

		ld	hl,ayEnableLoop
		call	ayPrintStatus
		
		ld	a,pt3loopEnable
		call	cliDrivers

		call	ayPrtOk

enableAutoPlay	ld	a,#00
		cp	#01
		ret	nz
		
		call	ayPrtPlay
		
		ld	a,enableAyPlay
		call	cliKernel

ayExit		call	ayPrtOk

ayEnd		ld	a,printRestore				; Восстанавливаем все цвета и параметры, что бы не было глюков
		jp	cliKernel

;---------------------------------------------
ayShowInfo	call	ayLoaderVer				; Вывод информации о программе
		call	ayLoaderHelp
		ret

ayLoaderVer	ld	hl,ayVersionMsg			
		ld	a,printAppNameString
		call	cliKernel

		ld	hl,ayCopyRMsg
		ld	a,printCopyrightString
		call	cliKernel
		jr	skipCheckFile

ayLoaderHelp	ld	hl,ayUsageMsg
		ld	a,printString
		call	cliKernel
		jr	skipCheckFile

;---------------
setAbc		ld	a,pt3abc
		ld	(switchType+1),a
		jr	setAy

setAcb		ld	a,pt3acb
		ld	(switchType+1),a
		jr	setAy

setBac		ld	a,pt3bac
		ld	(switchType+1),a

setAy		ld	a,#01
		ld	(ayType+1),a
		ret
;---------------
setLoop		ld	a,#01
		ld	(ayLoop+1),a
		ret

;---------------
ayLoaderPlay	ld	hl,ayTryPlay
		call	ayPrintStatus

		ld	a,pt3init
		call	cliDrivers

		ld	a,enableAyPlay				; Запуск воспроизведения
		call	cliKernel
		
		call	skipCheckFile
		jr	ayExit

;---------------
ayLoaderStop	ld	hl,ayTryStop
		call	ayPrintStatus
		ld	a,disableAyPlay				; Остановка воспроизведения
		call	cliKernel
		call	skipCheckFile
		jr	ayExit

;---------------
ayLoaderCont	ld	hl,ayTryCont
		call	ayPrintStatus
		ld	a,enableAyPlay				; Продолжить воспроизведения
		call	cliKernel
		call	skipCheckFile
		jr	ayExit

;---------------
skipCheckFile	ld	a,#01					; Просто выйти если файл не задан
		ld	(ayFileCheck+1),a
		ret

;---------------------------------------------
ayPrtFilename	ld	de,loadayMsg_03a
		call	ayPrtFilename0

		ld	hl,loadayMsg_03b
		call	ayPrtFilename0
		ld	(de),a

		ld	hl,loadayMsg_03
		jp	ayPrintStatus

ayPrtFilename0	ld	a,(hl)
		cp	#00
		ret	z
		cp	" "
		ret	z
		ld	(de),a
		inc	de
		inc	hl
		jr	ayPrtFilename0

;---------------------------------------------
ayPrtUpload	ld	hl,loadayMsg_04
		jp	ayPrintStatus

;---------------------------------------------
ayPrtPlay	ld	hl,loadayMsg_05
		jr	ayPrintStatus

;---------------------------------------------
ayPrtOk		ld	a,(ayPrintStatus+1)
		cp	#01
		ret	z
		ld	a,printStatusOk
		jp	cliKernel

;---------------------------------------------
ayPrtError	ld	a,(ayPrintStatus+1)
		cp	#01
		ret	z
		ld	a,printStatusError
		call	cliKernel
		jp	ayExit

;---------------------------------------------
ayPrintStatus	ld	a,#00
		cp	#01
		ret	z
		ld	a,printStatusString
		jp	cliKernel

;---------------------------------------------
setAutoPlay	ld	a,#01
		ld	(enableAutoPlay+1),a
		xor	a
		ld	(ayFileCheck+1),a
		ret

setSilentmode	ld	a,#01
		ld	(ayPrintStatus+1),a
		ret

;---------------------------------------------
fileNotSet	ld	hl,noFileMsg
		ld	a,printErrorString
		jp	cliKernel
;---------------------------------------------
ayVersionMsg	db	"ProTracker 3 file loader for AY-3-8910/12 Sound Chip v0.02",#00
ayCopyRMsg	db	"2016 ",127," Breeze\\\\Fishbone Crew",#0d,#00
		
ayUsageMsg	db	15,5,"Usage: loaday [switches] filename.ay",#0d
		db	16,16,"  -a ",15,15,"\tautoplay. allow to automatically play the file after upload",#0d
		db	16,16,"  -l ",15,15,"\tloop. allow to loop play module (default disabled)",#0d
		db	16,16,"  -s ",15,15,"\tsilent mode. additional information is not displayed",#0d
		db	16,16,"  -p ",15,15,"\tplay current pt3 (if already loaded)",#0d
		db	16,16,"  -st ",15,15,"\tstop play.",#0d
		db	16,16,"  -c ",15,15,"\tcontinue play.",#0d
		db	16,16,"  -v ",15,15,"\tversion. show application's version and copyrights",#0d
		db	16,16,"  -h ",15,15,"\thelp. show this info",#0d
		db	16,16,#0d,#00

noFileMsg	db	"Error: Incorrect file name.",#0d,#0d,#00

loadayMsg_01	db	"Try to detect AY Sound Chip...",#00
loadayMsg_03	db	"Try to open pt3 file ",243
loadayMsg_03a	ds	80," "
loadayMsg_03b	db	242,"...",#00
loadayMsg_04	db	"Loading module...",#00
loadayMsg_05	db	"Autoplay start...",#00

ayTryPlay	db	"Try to start playing...",#00
ayTryStop	db	"Try to stop playing...",#00
ayTryCont	db	"Try to continue playing...",#00
ayEnableLoop	db	"Set loop playing...",#00
ayTypeABC	db	"Set ",243,"ABC",242," mode...",#00
ayTypeACB	db	"Set ",243,"ACB",242," mode...",#00
ayTypeBAC	db	"Set ",243,"BAC",242," mode...",#00

;---------------------------------------------
; Key's table for params
;---------------------------------------------
keyTable	db	"-a"
		db	"*"
		dw	setAutoPlay

		db	"-h"
		db	"*"
		dw	ayShowInfo

		db	"-l"
		db	"*"
		dw	setLoop

		db	"-s"
		db	"*"
		dw	setSilentmode

		db	"-v"
		db	"*"
		dw	ayLoaderVer

		db	"-p"
		db	"*"
		dw	ayLoaderPlay

		db	"-st"
		db	"*"
		dw	ayLoaderStop

		db	"-c"
		db	"*"
		dw	ayLoaderCont

		db	"-abc"
		db	"*"
		dw	setAbc

		db	"-acb"
		db	"*"
		dw	setAcb

		db	"-bac"
		db	"*"
		dw	setBac

;--- table end marker ---
		db	#00

;---------------------------------------------
appEnd		nop

ayBuffer	nop

; 		DISPLAY "setLoop",/A,setLoop

		SAVEBIN "install/bin/loadpt3", appStart, appEnd-appStart

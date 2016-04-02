;---------------------------------------
; CLi² (Command Line Interface)
; 2016 © breeze/fishbone crew
;---------------------------------------
; Music file loader
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
		ld	(musPrintStatus+1),a
		ld	(musFileCheck+1),a

		ld	a,(hl)
		cp	#00					; Не заданы параметры
		jp	z,musShowInfo				; Выход. Вывод информации о программе

		ex	de,hl
		ld	a,eatSpaces
		call	cliKernel
		ex	de,hl

		ld	de,keyTable
		ld	a,checkCallKeys
		call	cliKernel

		cp	#ff					; Задан неверный ключ
		jp	z,musShowInfo				; Выход. Вывод информации о программе

		ld	a,(hl)
		cp	#00					; если это не конец строки = продолжаем
		jp	nz,musContinue

musFileCheck	ld	a,#00					; необходимо ли указать имя файла
		cp	#01					; если задан ключ -c(continue) то просто выйти
		ret	z
		jp	fileNotSet				; Выход. Не задан файл

musContinue	ld	(musFileName+1),hl

;---------------------------------------------
; Начало
;---------------------------------------------
		call	musLoaderVer
;---------------
		push	hl

		ld	hl,musTryInit
		call	musPrintStatus

		ld	a,disableAyPlay
		call	cliKernel
		cp	#ff
		push	af
		call	nz,musPrtOk
		pop	af
		call	z,musPrtError

		pop	hl
;---------------


musFileName	ld	de,#0000				; Имя файла

		ld	a,eatSpaces
		call	cliKernel
		ex	de,hl
		
		push	hl
		call	musPrtFilename				; вывод надписи «пытаемся загрузить»
		pop	hl
		
zzz		ld	de,musBuffer
		ld	c,appBank
		xor	a
		ex	af,af'					; загрузка с сохранением пути
		ld	a,loadFile				; Загружаем файл в буфер
								; На выходе в BC - размер
		call	cliKernel
		cp	#ff					; Если на выходе #ff = ошибка
		jp	z,musPrtError

		push	bc
		call	musPrtOk

		ld	hl,musTryDetect				; вывод надписи «пытаемся продетектить»
		call	musPrintStatus
		pop	bc

		ld	a,uploadAyModule
		ld	hl,musBuffer
		call	cliKernel
		
		ld	a,pt3init
		call	cliDrivers

		cp	#ff					; Если на выходе #ff = ошибка
		jp	z,musPrtError

		call	musPrtOk

enableAutoPlay	ld	a,#00
		cp	#01
		ret	nz
		
		call	musPrtPlay
		
		ld	a,enableAyPlay
		call	cliKernel

musExit		call	musPrtOk

musEnd		ld	a,printRestore				; Восстанавливаем все цвета и параметры, что бы не было глюков
		jp	cliKernel

;---------------------------------------------
musShowInfo	call	musLoaderVer				; Вывод информации о программе
		call	musLoaderHelp
		ret

musLoaderVer	ld	a,(musPrintStatus+1)
 		cp	#01
 		ret	z
		ld	hl,musVersionMsg			
		ld	a,printAppNameString
		call	cliKernel

		ld	hl,musCopyRMsg
		ld	a,printCopyrightString
		call	cliKernel
		jr	skipCheckFile

musLoaderHelp	ld	a,(musPrintStatus+1)
 		cp	#01
 		ret	z
 		ld	hl,musUsageMsg
		ld	a,printString
		call	cliKernel
		jr	skipCheckFile
;---------------
musLoaderPlay	ld	hl,musTryPlay
		call	musPrintStatus

		ld	a,pt3init
		call	cliDrivers

		ld	a,enableAyPlay				; Запуск воспроизведения
		call	cliKernel
		
		call	skipCheckFile
		jr	musExit

;---------------
musLoaderStop	ld	hl,musTryStop
		call	musPrintStatus
		ld	a,disableAyPlay				; Остановка воспроизведения
		call	cliKernel
		call	skipCheckFile
		jr	musExit

;---------------
musLoaderCont	ld	hl,musTryCont
		call	musPrintStatus
		ld	a,enableAyPlay				; Продолжить воспроизведения
		call	cliKernel
		call	skipCheckFile
		jr	musExit

;---------------
skipCheckFile	ld	a,#01					; Просто выйти если файл не задан
		ld	(musFileCheck+1),a
		ret

;---------------------------------------------
musPrtFilename	ld	de,loadmusMsg_03a
		call	musPrtFilename0

		ld	hl,loadmusMsg_03b
		call	musPrtFilename0
		ld	(de),a

		ld	hl,loadmusMsg_03
		jp	musPrintStatus

musPrtFilename0	ld	a,(hl)
		cp	#00
		ret	z
		cp	" "
		ret	z
		ld	(de),a
		inc	de
		inc	hl
		jr	musPrtFilename0

;---------------------------------------------
musPrtUpload	ld	hl,loadmusMsg_04
		jp	musPrintStatus

;---------------------------------------------
musPrtPlay	ld	hl,loadmusMsg_05
		jr	musPrintStatus

;---------------------------------------------
musPrtOk	ld	a,(musPrintStatus+1)
		cp	#01
		ret	z
		ld	a,printStatusOk
		jp	cliKernel

;---------------------------------------------
musPrtError	ld	a,(musPrintStatus+1)
		cp	#01
		ret	z
		ld	a,printStatusError
		call	cliKernel
		jp	musEnd

;---------------------------------------------
musPrintStatus	ld	a,#00
		cp	#01
		ret	z
		ld	a,printStatusString
		jp	cliKernel

;---------------------------------------------
setAutoPlay	ld	a,#01
		ld	(enableAutoPlay+1),a
		xor	a
		ld	(musFileCheck+1),a
		ret

setSilentmode	ld	a,#01
		ld	(musPrintStatus+1),a
		ret

;---------------------------------------------
fileNotSet	ld	hl,noFileMsg
		ld	a,printErrorString
		jp	cliKernel
;---------------------------------------------
musVersionMsg	db	"Music loader for AY8910/12, YM2203 & TS Sound Chip v0.06",#00
musCopyRMsg	db	"2016 ",127," Breeze\\\\Fishbone Crew",#0d,#00
		
musUsageMsg	db	15,5,"Usage: loadmus [switches] filename.(pt3|pt2|mtc|tfc|ts)",#0d
		db	16,16,"  -a ",15,15,"\tautoplay. allow to automatically play the file after upload",#0d
		db	16,16,"  -s ",15,15,"\tsilent mode. additional information is not displayed",#0d
		db	16,16,"  -p ",15,15,"\tplay current music (if already loaded)",#0d
		db	16,16,"  -st ",15,15,"\tstop play.",#0d
		db	16,16,"  -c ",15,15,"\tcontinue play.",#0d
		db	16,16,"  -v ",15,15,"\tversion. show application's version and copyrights",#0d
		db	16,16,"  -h ",15,15,"\thelp. show this info",#0d
		db	16,16,#0d,#00

noFileMsg	db	"Error: Incorrect file name.",#0d,#0d,#00

loadmusMsg_03	db	"Try to open file ",243
loadmusMsg_03a	ds	80," "
loadmusMsg_03b	db	242,"...",#00
loadmusMsg_04	db	"Loading module...",#00
loadmusMsg_05	db	"Autoplay start...",#00

musTryInit	db	"Try to initialize sound chip...",#00
musTryDetect	db	"Try to detect supported music format...",#00
musTryPlay	db	"Try to start playing...",#00
musTryStop	db	"Try to stop playing...",#00
musTryCont	db	"Try to continue playing...",#00

;---------------------------------------------
; Key's table for params
;---------------------------------------------
keyTable	db	"-a"
		db	"*"
		dw	setAutoPlay

		db	"-h"
		db	"*"
		dw	musShowInfo

		db	"-s"
		db	"*"
		dw	setSilentmode

		db	"-v"
		db	"*"
		dw	musLoaderVer

		db	"-p"
		db	"*"
		dw	musLoaderPlay

		db	"-st"
		db	"*"
		dw	musLoaderStop

		db	"-c"
		db	"*"
		dw	musLoaderCont

;--- table end marker ---
		db	#00

;---------------------------------------------
appEnd		nop

		align 2						; !!! FIX адреса загрузки кратного 2м !!!

musBuffer	nop

		DISPLAY "zzz",/A,zzz

		SAVEBIN "install/bin/loadmus", appStart, appEnd-appStart

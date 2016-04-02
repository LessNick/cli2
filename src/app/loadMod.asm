;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; Mod file loader
;---------------------------------------

modBufferSize	equ	32					; 32*512 = 16384 Размер буфера в блоках по (512кб)

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
		ld	(modPrintStatus+1),a
		ld	(modFileCheck+1),a

		ld	a,(hl)
		cp	#00
		jp	z,modShowInfo				; Выход. Вывод информации о программе

		ex	de,hl
		ld	a,eatSpaces
		call	cliKernel
		ex	de,hl

		ld	de,keyTable
		ld	a,checkCallKeys
		call	cliKernel

		cp	#ff
		jp	z,modShowInfo				; Выход. Вывод информации о программе

		ld	a,(hl)
		cp	#00
		jp	nz,modContinue

modFileCheck	ld	a,#00
		cp	#01
		ret	z
		jp	fileNotSet				; Выход. Не задан файл

modContinue	ld	(modFileName+1),hl

		ld	a,(modPrintStatus+1)
		cp	#01
		jr	z,startGS
		call	modLoaderVer

;---------------------------------------------
startGS		call	modPrtDetect

		ld	a,gsInit				; Инициализируем (hard reset) General Sound
		call	cliDrivers
		
		ld	a,gsDetect				; ?
		call	cliDrivers

		ld	a,gsStatus				; Проверяем наличие карты
		call	cliDrivers
		cp	#00					; Если на выходе #00 = ошибок нет, карта присутствует
		jp	nz,modPrtError

		call	modPrtOk

; 		call	modPrtUsing

; 		ld	a,getPanelStatus			; Провеяем, не с NGS ли карточки пытаются загрузить мод?
; 		call	cliKernel
; 		cp	#02					; Если на выходе #02 - ошибка
; 		jp	z,modPrtError				; TODO: Сделать буфер больше и грузить сразу весь мод в память!

; 		call	modPrtOk

modFileName	ld	de,#0000				; Имя файла

		ld	a,eatSpaces
		call	cliKernel
		ex	de,hl
		push	hl
		call	modPrtFilename
		pop	hl
		ld	de,modBuffer
		ld	b,modBufferSize
		ld	c,#00
		ld	a,bufferBank
		ex	af,af'
		ld	a,loadFileParts				; Загружаем первую часть в буфер
zzz		call	cliKernel
		cp	#ff					; Если на выходе #ff = ошибка
		jp	z,modPrtError

		call	modPrtOk					
;---------------
		call	modPrtUpload

		ld	a,gsLoadModule				; Загрузка модуля
		call	cliDrivers

		ld	a,gsOpenStream				; Открываем поток
		call	cliDrivers

uploadGsData	ld	hl,modBuffer
		ld	de,modBufferSize*128

uploadGsLoop	ld	a,gsUpload4Bytes			; Загружаем 4 байта данных
		call	cliDrivers
		dec	de
		ld	a,d
		or	e
		jr	nz,uploadGsLoop

;---------------
uploadGsNext	ld	a,loadNextPart				; Загрузить следующую часть в буфер
		call	cliKernel
		cp	#ff					; конец файла?
		jr	nz,uploadGsData

		ex	af,af'
		cp	eFileEnd
		jr	nz,uploadGsData

		ld	a,gsWaitLastByte			; ждем принятия последнего байта
		call	cliDrivers

		ld	a,gsCloseStream				; Закрываем поток
		call	cliDrivers	
;---------------		
		call	modPrtOk

		ld	a,gsResetTrack				; Переустанавливаем номер текущего трека
		call	cliDrivers	

enableAutoPlay	ld	a,#00
		cp	#01
		ret	nz
		
		call	modPrtPlay

		ld	a,gsPlay				; Запуск воспроизведения
		call	cliDrivers

		call	modPrtOk

modExit		ld	a,printRestore				; Восстанавливаем все цвета и параметры, что бы не было глюков
		jp	cliKernel

;---------------------------------------------
modShowInfo	call	modLoaderVer				; Вывод информации о программе
		call	modLoaderHelp
		ret

modLoaderVer	ld	hl,modVersionMsg			
		ld	a,printAppNameString
		call	cliKernel

		ld	hl,modCopyRMsg
		ld	a,printCopyrightString
		call	cliKernel
		jr	skipCheckFile

modLoaderHelp	ld	hl,modUsageMsg
		ld	a,printString
		call	cliKernel
		jr	skipCheckFile

modLoaderPlay	ld	hl,modTryPlay
		call	modPrintStatus
		ld	a,gsPlay				; Запуск воспроизведения
		call	cliDrivers
		call	checkStatus
		jr	modExit

modLoaderStop	ld	hl,modTryStop
		call	modPrintStatus
		ld	a,gsStop				; Остановка воспроизведения
		call	cliDrivers
		call	checkStatus
		jr	modExit

modLoaderCont	ld	hl,modTryCont
		call	modPrintStatus
		ld	a,gsCont				; Продолжить воспроизведение
		call	cliDrivers
		call	checkStatus
		jr	modExit
		
modLoaderReset	ld	hl,modTryReset
		call	modPrintStatus
		ld	a,gsWarmRestart				; Сброс карты
		call	cliDrivers
		call	checkStatus
		jr	modExit

modLoaderColdReset
		ld	hl,modTryColdReset
		call	modPrintStatus
		ld	a,gsColdRestart				; Полный сброс карты
		call	cliDrivers
		call	checkStatus
		jr	modExit

modLoaderFadeOut
		ld	hl,modTryFadeOut
		call	modPrintStatus

		ld	b,#40
fadeOutloop	halt
		push	bc
		ld	a,gsSetMasterVolume
		call	cliDrivers
		pop	bc
		djnz	fadeOutloop
		call	checkStatus
		call	modLoaderStop

skipCheckFile	ld	a,#01					; Просто выйти если файл не задан
		ld	(modFileCheck+1),a
		ret

;---------------------------------------------
checkStatus	ld	a,gsStatus				; Получить статус устройства:
								; o: a = #00 - нет ошибок (GS present)
								;    a = #01-#ff - что-то не так
		call	cliDrivers
		cp	#00
		jr	z,checkStatusOk
		call	modPrtError
		jr	skipCheckFile

checkStatusOk	call	modPrtOk
		jr	skipCheckFile
;---------------------------------------------
; xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;---------------------------------------------
modPrtDetect	ld	hl,loadModMsg_01
		jp	modPrintStatus

;---------------------------------------------
; modPrtUsing	ld	hl,loadModMsg_02
; 		jp	modPrintStatus

;---------------------------------------------
modPrtFilename	ld	de,loadModMsg_03a
		call	modPrtFilename0

		ld	hl,loadModMsg_03b
		call	modPrtFilename0
		ld	(de),a

		ld	hl,loadModMsg_03
		jp	modPrintStatus

modPrtFilename0	ld	a,(hl)
		cp	#00
		ret	z
		cp	" "
		ret	z
		ld	(de),a
		inc	de
		inc	hl
		jr	modPrtFilename0

;---------------------------------------------
modPrtUpload	ld	hl,loadModMsg_04
		jp	modPrintStatus

;---------------------------------------------
modPrtPlay	ld	hl,loadModMsg_05
		jr	modPrintStatus

;---------------------------------------------
modPrtOk	ld	a,(modPrintStatus+1)
		cp	#01
		ret	z
		ld	a,printStatusOk
		jp	cliKernel

;---------------------------------------------
modPrtError	ld	a,(modPrintStatus+1)
		cp	#01
		ret	z
		ld	a,printStatusError
		call	cliKernel
		jp	modExit

;---------------------------------------------
modPrintStatus	ld	a,#00
		cp	#01
		ret	z
		ld	a,printStatusString
		jp	cliKernel

;---------------------------------------------
setAutoPlay	ld	a,#01
		ld	(enableAutoPlay+1),a
		xor	a
		ld	(modFileCheck+1),a
		ret

setSilentMode	ld	a,#01
		ld	(modPrintStatus+1),a
		ret

;---------------------------------------------
fileNotSet	ld	hl,noFileMsg
		ld	a,printErrorString
		jp	cliKernel

;---------------------------------------------
modVersionMsg	db	"MOD file loader for (Neo)GS Card v0.20",#00
modCopyRMsg	db	"2013,2016 ",127," Breeze\\\\Fishbone Crew",#0d,#00
		
modUsageMsg	db	15,5,"Usage: loadmod [switches] filename.mod",#0d
		db	16,16,"  -a ",15,15,"\tautoplay. allow to automatically play the file after upload",#0d
		db	16,16,"  -s ",15,15,"\tsilent mode. additional information is not displayed",#0d
		db	16,16,"  -p ",15,15,"\tplay current mod (if already loaded)",#0d
		db	16,16,"  -st ",15,15,"\tstop play.",#0d
		db	16,16,"  -c ",15,15,"\tcontinue play.",#0d
		db	16,16,"  -fo ",15,15,"\tfadeout volume & stop.",#0d
		db	16,16,"  -r ",15,15,"\treset. warm reset (Neo)GS Card.",#0d
		db	16,16,"  -cr ",15,15,"\tcold reset (Neo)GS Card.",#0d
		db	16,16,"  -v ",15,15,"\tversion. show application's version and copyrights",#0d
		db	16,16,"  -h ",15,15,"\thelp. show this info",#0d
		db	16,16,#0d,#00

noFileMsg	db	"Error: Incorrect file name.",#0d,#0d,#00

loadModMsg_01	db	"Try to detect General Sound (NeoGS)...",#00
; loadModMsg_02	db	"Check NeoGS SD Card is't used...",#00
loadModMsg_03	db	"Try to open MOD file ",243
loadModMsg_03a	ds	80," "
loadModMsg_03b	db	242,"...",#00
loadModMsg_04	db	"Loading module...",#00
loadModMsg_05	db	"Autoplay start...",#00

modTryPlay	db	"Try to start playing...",#00
modTryStop	db	"Try to stop playing...",#00
modTryCont	db	"Try to continue playing...",#00
modTryReset	db	"Try to reset (Neo)GS Card...",#00
modTryColdReset	db	"Try to cold reset (Neo)GS Card...",#00
modTryFadeOut	db	"Try to fadeout volume...",#00

;---------------------------------------------
; Key's table for params
;---------------------------------------------
keyTable	db	"-a"
		db	"*"
		dw	setAutoPlay

		db	"-h"
		db	"*"
		dw	modShowInfo

		db	"-s"
		db	"*"
		dw	setSilentMode

		db	"-v"
		db	"*"
		dw	modLoaderVer

		db	"-p"
		db	"*"
		dw	modLoaderPlay

		db	"-st"
		db	"*"
		dw	modLoaderStop

		db	"-c"
		db	"*"
		dw	modLoaderCont

		db	"-r"
		db	"*"
		dw	modLoaderReset

		db	"-cr"
		db	"*"
		dw	modLoaderColdReset

		db	"-fo"
		db	"*"
		dw	modLoaderFadeOut


;--- table end marker ---
		db	#00

;---------------------------------------------
appEnd		nop

		org	#0000
modBuffer	ds	modBufferSize*512,#00
modBufferEnd	nop

; 		DISPLAY "modBufferEnd",/A,modBufferEnd
		DISPLAY "zzz",/A,zzz

		SAVEBIN "install/bin/loadmod", appStart, appEnd-appStart

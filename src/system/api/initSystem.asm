;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #00 initSystem
;---------------------------------------
; Начальная инициализация системы
;---------------------------------------

_initSystem	xor	a
		ld	(driversLoaded+1),a

		call	_moveScreenInit
		
		call	_initVars

		ld	a,#01
		ld	(disableDrivers+1),a

		call	_switchTxtMode

		call	_clearTxtMemory

		call	_nvRamOpen				; Разрешаем доступ к nvram

		call	_ps2Init				; Инициализация клавиатуры

		call	_printInit

		ld	c,#00					; номер цвета
		ld	a,#01
		call	_clearGfxMemory+1			; Очищаем графическую область 1
		
		ld	c,#00					; номер цвета
		ld	a,#02
		call	_clearGfxMemory+1			; Очищаем графическую область 2

		ld	c,#00					; номер цвета
		ld	a,#03
		call	_clearGfxMemory+1			; Очищаем графическую область 3
		

		call	_cliInitDev				; Подготовка к работе SD-карты
		cp	#ff
		jr	nz,_initSystem_00

		ld	hl,errorDevMsg				; Ошибка инициализации загрузочного устройства
		jr	_initSystem_01

_initSystem_00	call	_loadDrivers				; Загрузить /system/drivers.sys
		cp	#ff
		jr	nz,_initSystem_00a
		
		ld	hl,driversPath
		jr	_initSystem_03

_initSystem_00a	ld	a,#01					; Пометить, что драйвера успешно загружены
		ld	(driversLoaded+1),a

		call	_loadGli				; Загрузить /system/gli.sys
		cp	#ff
		jr	nz,_initSystem_00b
		
		ld	hl,gliPath
		jr	_initSystem_03

_initSystem_00b	
		call	_loadKeyMap				; Загрузить /system/res/keymaps/default.key
		cp	#ff
		jr	nz,_initSystem_00c
		ld	hl,keymapPath
		jr	_initSystem_03

_initSystem_00c	call	_loadCursorsRes				; Загрузить /system/res/cursors/default.cur

		call	scopeBinary				; Собрать список доступных комманд из /bin/*
		cp	#ff
		jr	nz,tryStartUp
		
 		ld	hl,errorBinMgs
_initSystem_01	ld	b,#ff
		call	_printErrorString

_initSystem_03	call	_printBootError
		ld	hl,kernelPanicMgs
		call	_printWarningString
		jp	$

_printBootError	push	hl
		ld	hl,bootErrorMgs
		ld	b,#ff
		call	_printErrorString
		pop	hl
		ld	b,#00
		call	_printErrorString
		ld	hl,bootErrorMgs0
		jp	_printErrorString

;--------------
tryStartUp	call	_reInitSystem

		halt
		ld	de,startUpPath				; запуск скрипта /system/startup.sh
		call	sh
		cp	#ff
		ret	nz
		ex	af,af'
 		cp	eFileNotFound
 		ret	nz
 		
		ld	hl,startUpPath
		jr	_printBootError

;--------------
_initVars	call	storeRam0
		ld	a,varBank				; иницализация переменных
		call	_setRamPage0
		ld	hl,varAddr
		ld	de,varAddr+1
		ld	bc,#3fff
		xor	a
		ld	(hl),a
		ldir
		jp	reStoreRam0
;---------------------------------------

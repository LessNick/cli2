;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
_cliApi		cp	#00
		jp	z,_initSystem				; #00
		dec	a
		jp	z,_reInitSystem				; #01
		dec	a
		jp	z,_getCliVersion			; #02
		dec	a
		jp	z,_exitSystem				; #03
		dec	a
		jp	z,_clearTxtMemory			; #04
		dec	a
		jp	z,_clearGfxMemory			; #05
		dec	a
		jp	z,_switchTxtMode			; #06

		dec	a
		jp	z,_switchGfxMode			; #07
		dec	a
		jp	z,_setGfxColorMode			; #08
		dec	a
		jp	z,_setGfxResolution			; #09

		dec	a
		jp	z,_setScreenOffsetX			; #0A
		dec	a
		jp	z,_setScreenOffsetY			; #0B

		dec	a
		jp	z,_printInit				; #0C
		dec	a
		jp	z,_editInit				; #0D
		dec	a
		jp	z,_printString				; #0E
		dec	a
		jp	z,_printInputString			; #0F
		dec	a
		jp	z,_printOkString			; #10

		dec	a
		jp	z,_printErrorString			; #11
		dec	a
		jp	z,_printAppNameString			; #12
		dec	a
		jp	z,_printCopyrightString			; #13
		dec	a
		jp	z,_printInfoString			; #14
		
		dec	a
		jp	z,_printStatusString			; #15
		dec	a
		jp	z,_printStatusOk			; #16
		dec	a
		jp	z,_printStatusError			; #17

		dec	a
		jp	z,_printErrParams			; #18
		dec	a
		jp	z,_printFileNotFound			; #19
		dec	a
		jp	z,_printFileTooBig			; #1A
		dec	a
		jp	z,_printRestore				; #1B
		
		dec	a
		jp	z,_printContinue			; #1C	
		dec	a
		jp	z,_printInputYN				; #1D
		dec	a
		jp	z,_printInputRIA			; #1E
		
		dec	a
		jp	z,_printCodeDisable			; #1F
		dec	a
		jp	z,_printWithScroll			; #20

		dec	a
		jp	z,_clearIBuffer				; #21
		dec	a
		jp	z,_checkCallKeys			; #22
		dec	a
		jp	z,_loadFile				; #23
		dec	a
		jp	z,_loadFileLimit			; #24
		dec	a
		jp	z,_loadFileParts			; #25
		dec	a
		jp	z,_loadNextPart				; #26

		dec	a
		jp	z,_saveFile				; #27
		dec	a
		jp	z,_saveFileParts			; #28
		dec	a
		jp	z,_saveNextPart				; #29
		dec	a
		jp	z,_createFile				; #2A
		dec	a
		jp	z,_createDir				; #2B

		dec	a
		jp	z,_deleteFileDir			; #2C
		dec	a
		jp	z,_renameFileDir			; #2D

		dec	a
		jp	z,_checkFileExist			; #2E
		dec	a
		jp	z,_checkDirExist			; #2F

		dec	a
		jp	z,_getTxtPalette			; #30
		dec	a
		jp	z,_getGfxPalette			; #31

		dec	a
		jp	z,_setTxtPalette			; #32
		dec	a
		jp	z,_setGfxPalette			; #33
		dec	a
		jp	z,_setFont				; #34
		dec	a
		jp	z,_str2int				; #35
		dec	a
		jp	z,_int2str				; #36
		dec	a
		jp	z,_char2str				; #37
		dec	a
		jp	z,_char2hex-1				; #38
		dec	a
		jp	z,_fourbit2str				; #39
		dec	a
		jp	z,_mult16x8-1				; #3A
		dec	a
		jp	z,_divide16_16				; #3B

		dec	a
		jp	z,_parseLine				; #3C
		dec	a
		jp	z,_getPanelStatus			; #3D
		dec	a
		jp	z,_eatSpaces				; #3E
		dec	a
		jp	z,_setAppCallBack			; #3F
		dec	a
		jp	z,_setRamPage0-1			; #40
		dec	a
		jp	z,_restoreWcBank			; #41

		dec	a
		jp	z,_moveScreenInit			; #42
		dec	a
		jp	z,_moveScreenUp				; #43
		dec	a
		jp	z,_moveScreenDown			; #44
		dec	a
		jp	z,_moveScreenLeft			; #45
		dec	a
		jp	z,_moveScreenRight			; #46

		dec	a
		jp	z,_getNumberFromParams			; #47
		dec	a
		jp	z,_getHexFromParams			; #48
		dec	a
		jp	z,_getHexPairFromParams			; #49

		dec	a
		jp	z,_nvRamOpen				; #4A
		dec	a
		jp	z,_nvRamClose				; #4B

		dec	a
		jp	z,_nvRamGetData				; #4C
		dec	a
		jp	z,_nvRamSetData				; #4D

		dec	a
		jp	z,_ps2Init				; #4E
		dec	a
		jp	z,_ps2ResetKeyboard			; #4F
		dec	a
		jp	z,_ps2GetScanCode			; #50

		dec	a
		jp	z,_getKeyWithShift			; #51

		dec	a
		jp	z,_waitAnyKey				; #52

		dec	a
; 		jp	z,_enableRes				; #53			; Разрешить вызов обработчика резидентов
		jp	z,_reserved
		dec	a
; 		jp	z,_disableRes				; #54			; Запретить вызов обработчика резидентов
		jp	z,_reserved

		dec	a
		jp	z,_enableNvram				; #55
		dec	a
		jp	z,_disableNvram				; #56

		dec	a
		jp	z,_getLocale				; #57

		dec	a
		jp	z,_setMouseCursor			; #58

		dec	a
		jp	z,_enableAyPlay				; #59

		dec	a
		jp	z,_disableAyPlay			; #5A

		dec	a
		jp	z,_uploadAyModule			; #5B

_reserved	ret

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
_initSystem	xor	a
		ld	(_driversLoaded+1),a
		call	_ps2Init

		call	_moveScreenInit
		
		call	_initVars

		ld	a,#01
		ld	(disableDrivers+1),a
		call	_switchTxtMode

		call	_clearTxtMemory

		call	_nvRamOpen				; Разрешаем доступ к nvram

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
		ld	(_driversLoaded+1),a

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

; 		call	_loadSysRes				; Загрузить /system/res.sys
; 		cp	#ff
; 		jr	nz,_initSystem_00c
; 		ld	hl,resPath
; 		jr	_initSystem_03

; _initSystem_00c	
; 		ld	a,initResidents				; инициализация системы резидентов
; 		call	_resApi

_initSystem_00c	call	_loadCursorsRes				; Загрузить /system/res/cursors/default.cur
; 		cp	#ff
; 		jr	nz,_initSystem_00c
; 		call	_printBootError
; 		jr	$

; _initSystem_00c	call	_prepareCursor				; Установить спрайт для курсоса

		call	_scopeBinary				; Собрать список доступных комманд из /bin/*
		cp	#ff
		jr	nz,_tryStartUp
		
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
_tryStartUp	call	_reInitSystem

		halt
		ld	de,startUpPath				; запуск скрипта /system/startup.sh
		call	_sh
		cp	#ff
		ret	nz
		ex	af,af'
 		cp	eFileNotFound
 		ret	nz
 		
		ld	hl,startUpPath
		jr	_printBootError

_reInitSystem	call	_switchTxtMode
		call	_clearIBuffer
		call	_printInit
		call	_editInit
		halt
		call	_setInterrupt
		xor	a
		ld	(disableDrivers+1),a
		ret

;---------------------------------------
_getCliVersion	ld	hl,(cliVersion)
		ret
;---------------------------------------
_initVars	ld	a,varBank				; иницализация переменных
		call	_setRamPage0
		ld	hl,varAddr
		ld	de,varAddr+1
		ld	bc,#3fff
		xor	a
		ld	(hl),a
		ldir
		jp	_restoreWcBank

;---------------------------------------

_switchTxtMode	xor	a
		ld	(currentScreen),a

		ld	a,#01					; #01 - 1й видео буфер (16 страниц)
		call	_setVideoBuffer

		ld	a,(pTxtScreen)				; переключаем разрешайку на 320x240 TXT
		call	_switchGfxOn

		ld	a,palBank
		call	switchMemBank

		ld	hl,palAddr
		call	_setPal

		call	setAppBank

		jp	_restoreBorder

;-------------------
_switchGfxMode	ld	a,c
		ld	(_switchGfxEnd_3+1),a
		ld	a,b			;3 2 1
		dec	a			;2 1 0
		jp	z,_switchGfxMode1	
		dec	a			;1 0
		jp	z,_switchGfxMode2
		dec	a			;0
		jp	z,_switchGfxMode3

		ret						; error ?

;-------------------
_switchGfxMode3	ld	a,(pGfxScreen3)				; переключаем разрешайку
		ld	(_switchGfxEnd_1+1),a
		
		ld	a,gPalBank3
		ld	(_switchGfxEnd_2+1),a

		ld	hl,gPalAddr3

		jr	_switchGfxEnd
;-------------------
_switchGfxMode2	ld	a,(pGfxScreen2)				; переключаем разрешайку
		ld	(_switchGfxEnd_1+1),a
		
		ld	a,gPalBank2
		ld	(_switchGfxEnd_2+1),a

		ld	hl,gPalAddr2

		jr	_switchGfxEnd
;-------------------

_switchGfxMode1	ld	a,(pGfxScreen)				; переключаем разрешайку
		ld	(_switchGfxEnd_1+1),a
		
		ld	a,gPalBank1
		ld	(_switchGfxEnd_2+1),a

		ld	hl,gPalAddr1
;---------		
_switchGfxEnd	push	hl
		ld	a,b
		ld	(currentScreen),a
		inc	a
		call	_setVideoBuffer

_switchGfxEnd_1	ld	a,#00
		call	_switchGfxOn

_switchGfxEnd_2	ld	a,#00
		call	switchMemBank
		pop	hl

_switchGfxEnd_3	ld	a,#00
		cp	#01
		call	nz,_setPal

		jp	setAppBank

_switchGfxOn	;halt						; !!!! ПРЕРЫВАНИЕ !!!! НИКАКИХ ХАЛЬТОВ !!!
		call	_setVideoMode
		jp	moveScreenUpdate			; обновляем смещения
;---------------------------------------
_setGfxColorMode
		ex	af,af'					; на входе в A = цветовой режим: %00-ZX, %01-16c, %10-256c, %11 - txt
		and	%00000011
		ld	c,a
		ld	a,b
		dec	a
		jr	z,_setGCM_1
		dec	a
		jr	z,_setGCM_2
		dec	a
		jr	z,_setGCM_3
		ret

_setGCM_1	ld	a,(pGfxScreen)
		and	%11000000
		or	c
		ld	(pGfxScreen),a
		ret

_setGCM_2	ld	a,(pGfxScreen2)
		and	%11000000
		or	c
		ld	(pGfxScreen2),a
		ret

_setGCM_3	ld	a,(pGfxScreen3)
		and	%11000000
		or	c
		ld	(pGfxScreen3),a
		ret

;---------------
_setGfxResolution 
		ex	af,af'
		rrca
		rrca
		and	%11000000
		ld	c,a
		
		ld	a,b
		dec	a
		jr	z,_setGR_1
		dec	a
		jr	z,_setGR_2
		dec	a
		jr	z,_setGR_3

_setGR_1	ld	a,(pGfxScreen)
		and	%00000011
		or	c
		ld	(pGfxScreen),a
		ret

_setGR_2	ld	a,(pGfxScreen2)
		and	%00000011
		or	c
		ld	(pGfxScreen2),a
		ret

_setGR_3	ld	a,(pGfxScreen3)
		and	%00000011
		or	c
		ld	(pGfxScreen3),a
		ret
;---------------------------------------
_getFullColor	ld	a,(colorPaper)
		sla	a
		sla	a
		sla	a
		sla	a
		ld	c,a
		ld	a,(colorInk)
		or	c
		ret

;---------------------------------------
_clearTxtMemory	ld	a,#00					; Включаем страницу с текстовым режимом
		call	switchMemBank

		ld	hl,#c000+128				; блок атрибутов
		ld	de,#c001+128

		call	_getFullColor
		call	_clearBlock

		ld	hl,#c000				; блок символов
		ld	de,#c001
		ld	a," "
		call	_clearBlock

;---------------
_restoreBorder	ld	a,(colorBorder)
_setBorder	ld	bc,tsBorder
		out	(c),a
		ret

;---------------------------------------
_borderIndicate	halt
		call	_setBorder
		halt
		call	_restoreBorder
		ret
;---------------------------------------

_clearBlock	ld	b,64
_clearLoop	push	bc,de,hl
		ld	bc,127
		ld	(hl),a
		ldir
		pop	hl,de,bc
		inc	h
		inc	d
		djnz	_clearLoop
		ret

;---------------------------------------
_clearGfxMemory	ld	a,b					; #10 1й
		cp	#00
		ret	z
		cp	#04
		ret	nc

		sla	a
		sla	a
		sla	a
		sla	a

		push 	af

		ld	hl,pTxtScreen
		ld	d,#00
		ld	e,b
		add	hl,de
		ld	a,(hl)
		and	%00000011
		cp	%00000001				; если режим 16ц
		jr	nz,_clearGfxMemory2
		ld	a,c
		sla	a
		sla	a
		sla	a
		sla	a
		or	c
		ld	c,a		

_clearGfxMemory2		
		ld	h,c
		ld	l,c

		pop	af

		push	af
		call	switchMemBank

		ld	(#c000),hl				; заливаем цветом первые 2 пикселя

		call	setAppBank

		ld	a,#ff
		call	_callDma				; ожидаем готовности DMA

		pop	af
								
		ld	b,a					; ld	bc,#1010
		ld	c,a

		ld	a,32*8-1
		ld	(_gfxClsK+1),a
		ld	a,255
		ld	(_gfxClsS+1),a

		call	_gfxClsDma

		ld	a,32*8-2
		ld	(_gfxClsK+1),a
		ld	a,255
		ld	(_gfxClsS+1),a
		call	_gfxClsDma2

		ld	a,0
		ld	(_gfxClsK+1),a
		ld	a,254
		ld	(_gfxClsS+1),a
		jr	_gfxClsDma2			
;-----------							; ld	bc,#1111
_gfxClsDma	ld	hl,0					; BHL - Source
		ld	de,2					; CDE - Destination
		ld	a,#00					; Инициализация источника(Source) и приёмника(Destination)
		call	_callDma

_gfxClsDma2	ld	a,#05					; выставление DMA_T
_gfxClsK	ld	b,32*8-1				; B - кол-во бёрстов
		call	_callDma
		
		ld	a,#06					; выставление DMA_N
_gfxClsS	ld	b,255					; B - размер бёрста
		call	_callDma

		ld	a,#fe					; запуск с ожиданием завершения (o:NZ - DMA занята)
		jp	_callDma

;---------------------------------------
_setInterrupt	halt
		di
		ld	hl,_cliInt
		ld	(_WCINT),hl
		ei
		ret

;---------------------------------------
_storeWcInt	halt
		ld	hl,(_WCINT)
		ld	(_wcIntAddr+1),hl
		ret

_restoreWCInt	halt
		ld	hl,(_wcIntAddr+1)
		ld	(_WCINT),hl
		ret

;---------------------------------------
_cliInt		push	hl,de,bc,af				;======================================================================================================
		exx
		ex	af,af'
		push	hl,de,bc,af

		ld	hl,(intCounter)
		inc	hl
		ld	(intCounter),hl

disableKeyboard	ld	a,#00
 		cp	#01
 		jr	z,skipKeyboard

		call	_ps2PrepareScanCode

		call	storeAltStatus				; Сохраняем значение клавиши ALT
		call	storeCtrlStatus				; Сохраняем значение клавиши CTRL

		call	_checkKeyCtrlL
 		call	nz,_actionCtrlKey

 		call	_checkKeyAltL
 		call	nz,_actionAltKey

 		call	_actionInsOver

skipKeyboard	call	updateDrivers
		call	_updateCursor

		ld	a,(currentScreen)
		cp	#00
;  		jr	nz,skipMouseSelect
		push	af
		call	z,_checkMouseClicks
		pop	af
		call	nz,_resetMouseClicks

; disableResident ld	a,#00
;  		cp	#01
;  		jr	z,skipResident

; 		ld	a,callResidentMain
; 		call	_resApi

; skipResident

; skipMouseSelect

enableAy	ld	a,#00
		cp	#00
		jr	z,skipAy
		
		ld	a,pt3play
		call	cliDrivers

skipAy
		pop	af,bc,de,hl		
		exx
		ex	af,af'
		pop	af,bc,de,hl
		ei
		ret

_wcIntAddr	jp	#0000

;---------------------------------------
_enableAyPlay	halt
		ld	a,#01
		ld	(enableAy+1),a
		ret
;---------------------------------------
_disableAyPlay	halt
		xor	a
		ld	(enableAy+1),a
		ld	a,pt3mute
		call	cliDrivers
		ret
;---------------------------------------
_uploadAyModule	ld	a,ayBank
		push	bc
		call	_setRamPage0
		pop	bc
		ld	de,#0000
		ldir
		jp	_restoreWcBank
;---------------------------------------
_checkMouseClicks
		ld	a,getMouseButtons
		call	cliDrivers

		bit	0,a					; левая кнопка
		jp	z,_cmc_02				; отпустили?

_cmc_01		ld	a,#00
		cp	#01					; уже нажата и держится
		jp	z,_cmc_03

		ld	a,#01
		ld	(_cmc_01+1),a				; устанавливаем флаг, что уже нажали и держат
		
		ld	hl,(mouseSelectB)
		ld	a,h
		or	l
		jr	z,_cmc_01Skip				; Выделений нет - пропуск

		call	_openCacheBank				; Банка с выделенным текстом
		
		call	_removeOldSel				; убираем старое выделение

_cmc_01Skip	ld	a,mCursorSelect
		call	_setCursorPhase

		call	_getMouseTxtPos
		ld	(_cmc_03+1),hl
		ld	(mouseSelectB),hl			; Сохраняем начало выделения

_cmc_01a	call	_openCacheBank
		call	_invertMousePos

		xor	a
		ld	de,(_cmc_03+1)				; предыдущее значение

		call	_fillMouseClicks

		ld	(_cmc_03+1),hl
		ld	(mouseSelectE),hl			; Сохраняем конец выделения

_cmc_01b	ld	a,#00
		ld	(_PAGE3),a				; Восстанавливаем банку для WildCommander
		ld	bc,tsRAMPage3
		out	(c),a

		ret

_openCacheBank	ld	a,(_PAGE3)				; Сохряняем какая была до этого открыта страница
		ld	(_cmc_01b+1),a

		ld	a,#62					; Включаем страницу кеш текста
		ld	bc,tsRAMPage3
		out	(c),a
		ret

;---------------
_removeOldSel	ld	de,(mouseSelectE)
		ex	de,hl
		call	_invertMousePos				; начальный курсор
		ex	de,hl
_removeOldSel2	ld	hl,(mouseSelectB)
		ld	a,h
		cp	d
		jr	nz,_removeOldSel3
		ld	a,l
		cp	e
		jr	z,_fillMouseClicks
_removeOldSel3	call	_invertMousePos				; конечный курсор
; 		jr	_fillMouseClicks			; всё что между ними
;----		
_fillMouseClicks
		push	hl
		sbc	hl,de
		jr	z,_cmc_01end				; равны = выход
		jp	m,right2left
		pop	hl
		push	hl
		
_cmc_01loop1	dec	hl
		ld	a,l
		cp	e
		jr	z,_cmc_01end
		call	_invertMousePos
		jr	_cmc_01loop1

right2left	pop	hl
		push	hl
		
_cmc_01loop2	inc	hl
		ld	a,l
		cp	e
		jr	z,_cmc_01end
		call	_invertMousePos
		jr	_cmc_01loop2

_cmc_01end	pop	hl
		ret
;----		

;---------------
_resetMouseClicks
_cmc_02		ld	a,(_cmc_01+1)
		cp	#00
		ret	z					; уже отпустили (не нажимали)

		xor	a
		ld	(_cmc_01+1),a

		ld	a,mCursorDefault
		call	_setCursorPhase
		ret
;---------------
_cmc_03		ld	de,#0000				; нажали и держат
		push	de
		call	_getMouseTxtPos
; 		push	hl
; 		call	_openCacheBank
; 		call	_removeOldSel2				; очищаем всё что было выделено
; 		pop	hl
		pop	de
; 		ld	a,h
; 		cp	d
; 		jr	nz,_cmc_01a
		ld	h,d					; не зависимо от новой позиции Y
		ld	a,l
		cp	e
		ret	z
		jp	_cmc_01a	

;---------------
_getMouseTxtPos	ld	a,getMouseX				; HL
		call	cliDrivers
		
		ld	de,#0004
		call	_divide16_16				; bc
		push	bc

		ld	a,getMouseY				; HL
		call	cliDrivers
		ld	de,#0008
		call	_divide16_16				; bc

		ld	hl,#c000
		ld	b,c
		ld	c,#00
		add	hl,bc
		pop	bc

 		add	hl,bc					; адрес курсора
 		ret

;---------------
_invertMousePos	push	hl,de
		ld	de,(_scrollOffset)
; 		ld	a,d
; 		cp	#00
; 		jr	z,_impSkip
		ld	a,d
		cp	#1e					; уже отображено 30 строк?
		jr	c,_impSkip
		
		xor	a
		ld	bc,#1d00				;30-1
	
		ex	de,hl
		sbc	hl,bc
		ex	de,hl
		
		add	hl,de

_impSkip	ld	bc,#80					; HL - аддр
		add	hl,bc
		ld	a,(hl)
		and	%11110000
		srl	a
		srl	a
		srl	a
		srl	a
		ld	c,a
		ld	a,(hl)
		and	%00001111
		sla	a
		sla	a
		sla	a
		sla	a
		or	c
		ld	(hl),a
		pop	de,hl
		ret

;---------------------------------------
_setMouseCursor	ex	af,af'					; in A' - тип курсора (на самом деле номер фазы)	
;---------------------------------------
_setCursorPhase	push	hl,de

		push	af					; in A - номер фазы

		ld	a,(cursorSFile+1)
		and	%00000111
		ld	h,#00
		ld	l,a
		pop	af
		call	_mult16x8				; in: hl * a
 								; out:hl,low de,high
		ld	a,l

		push	af
		and	%00000011
		rrca
		rrca
		ld	c,a
		ld	a,(cursorSBitmapX)
		and	%00111111
		or	c
		ld	(cursorSBitmapX),a
		pop	af

		and	%00111100
		srl	a
		srl	a
		ld	c,a

		ld	a,(cursorSBitmapY)
		and	%11110000
		or	c
		ld	(cursorSBitmapY),a

		pop	de,hl
		ret

;---------------------------------------
_loadCursorsRes	ld	hl,cursorsPath
		ld	de,bufferAddr
		push	de
		call	_loadFile

		pop	hl
		ld	a,(hl)
		cp	#7f
		ret	nz					; не верный формат файла
		
		inc	hl
		ld	a,(hl)
		cp	"C"
		ret	nz					; не верный формат файла
		
		inc	hl
		ld	a,(hl)
		cp	"U"
		ret	nz					; не верный формат файла
		
		inc	hl
		ld	a,(hl)
		cp	"R"
		ret	nz					; не верный формат файла

		inc	hl
		ld	a,(hl)					; ширина курсора
		srl	a
		ld	(lcr_width+1),a
		
		ld	b,#00
		ld	c,a
		ld	de,256


		ex	hl,de
		sbc	hl,bc
		ex	hl,de

		ld	(lcr_skip+1),de

		ld	a,(cursorSFileX+1)
		and	%11111000
		srl	c
		srl	c
		or	c
		ld	(cursorSFileX+1),a

		inc	hl
		ld	a,(hl)					; высота курсора

		ld	d,#00
		ld	e,a

		ld	c,a
		ld	a,(cursorSFile+1)
		and	%11111000
		srl	c
		srl	c
		or	c
		ld	(cursorSFile+1),a

		inc	hl
		ld	a,(hl)					; количество фаз

		push	hl
		ex	hl,de

		call	_mult16x8				; in: hl * a
								; out:hl,low de,high
		ld	(lcr_height+1),hl

		ld	a,(_PAGE3)
		ld	(lcr_page+1),a

		ld	a,sprBank				; Включаем страницу для спрайтов с #0000
		call	_setRamPage3

		pop	hl
		
		inc	hl

		ld	de,#C000
lcr_height	ld	bc,16
prepareLoop	push	bc
lcr_width	ld	bc,8
		ldir
		ex	de,hl
lcr_skip	ld	bc,248
		add	hl,bc
		ex	de,hl
		pop	bc
		dec	bc
		ld	a,b
		or	c
		jr	nz,prepareLoop

		ld	bc,tsSGPage				; Указываем страницу для спрайтов
		ld	a,sprBank
		add	a,#20
		out	(c),a

lcr_page	ld	a,#00
		ld	(_PAGE3),a				; Восстанавливаем банку для WildCommander
		ld	bc,tsRAMPage3
		out	(c),a

;---------------
_updateCursor	ld	a,getMouseX
		call	_driversApi
		ex	de,hl
		ld	a,getMouseY
		call	_driversApi

_updateCursor2	ld	a,e
		ld	(cursorSFileX),a
		ld	a,d
		and	%00000001
		or	%00100010
		ld	(cursorSFileX+1),a

		ld	a,l
		ld	(cursorSFile),a
		ld	a,h
		and	%00000001
		or	%00100010
		ld	(cursorSFile+1),a

		ld	bc,tsFMAddr
		ld 	a,%00010000				; Разрешить приём данных (?) Bit 4 - FM_EN установлен
		out	(c),a

		ld	hl,cursorSFile
		ld 	de,#0000+512				; Память с палитрой замапливается на адрес #0000
		ld	bc,6
		ldir
;---------------
		ld	bc,tsFMAddr
		xor	a					; Запретить, Bit 4 - FM_EN сброшен
		out	(c),a

		ld	bc,tsConfig				; Включаем отображение спрайта
			  ;76543210
		ld	a,%10000000				; bit 7 - S_EN Sprite Layers Enable
		out	(c),a

		ret

;---------------------------------------
_actionInsOver	call	_getKeyWithShiftT
		cp	aInsert
		ret	nz
		ld	a,(keyInsOver)
		xor	#01
		ld	(keyInsOver),a
		cp	#00
		jr	z,_aInsMode
		ld	a,"_"
		ld	(cursorType),a
		ret

_aInsMode	ld	a,"|"
		ld	(cursorType),a

		ret
;---------------------------------------
_actionCtrlKey	call	_checkKeyShiftL
		call	nz,switchLayout

		ret

;---------------------------------------
_actionAltKey
		call	_getKeyWithShiftT			; Опрашиваем клавиши, но не снимаем флаг, что данные забрали!
		cp	aF5
		jp	c,_actionAltKey2
		jp	restoreAltStatus			; Если нет ни одно комбинации, то восстанавливаем значение клавиши ALT
		
_actionAltKey2	cp	aF1
		jr	nc,_setVideo
		jp	restoreAltStatus			; Если нет ни одно комбинации, то восстанавливаем значение клавиши ALT


;---------------------------------------
switchLayout	ld	a,(keyLayoutSwitch)
		xor	#01
		ld	(keyLayoutSwitch),a
		ret

;---------------------------------------
_setVideo	sub	aF1
		push	af
		cp	#00
		jr	z,_setVideoT
		ld	b,a
		call	_switchGfxMode

_setVideoN	call	scanCodeReady				; снимаем флаг нажатия клавиши
		pop	af
		ld	hl,(callBackApp)
		jp	(hl)

_setVideoT	call	_switchTxtMode
		jr	_setVideoN
;---------------------------------------
_exitSystem	call	_restoreWCInt
		call	_restoreWC
		xor	a	 				; просто выход
		ret

;---------------------------------------
_setPal		ld	bc,tsFMAddr
		ld 	a,%00010000				; Разрешить приём данных для палитры (?) Bit 4 - FM_EN установлен
		out	(c),a

		ld 	de,#0000				; Память с палитрой замапливается на адрес #0000
		ld	bc,512
		ldir

		ld 	bc,tsFMAddr			
		xor	a					; Запретить, Bit 4 - FM_EN сброшен
		out	(c),a

		ld	bc,tsPalSel
		xor	a
		out	(c),a					; Выбрать 0ю группу и 16 палитр (если выбран режим 16ц)
		
		ret

;---------------------------------------
_printStatusString
		push	hl
		ld	a,(colorOk)
		ld	hl,iAsteriskMsg
		call	_printColorStr
		pop	hl
		ld	a,(colorHelp)
		call	_printColorStr
		jp	checkUpdate

_printStatusOk	ld	a,68					; 11 позиций до правой границы экрна
		ld	(printX),a
		ld	hl,iOpenBracketMsg
		call	_printString
		ld	a,(colorOk)
		ld	hl,iOkMsg
		call	_printColorStr
		ld	hl,iCloseBracketMsg
		jp	_printString

_printStatusError
		ld	a,68					; 11 позиций до правой границы экрна
		ld	(printX),a
		ld	hl,iOpenBracketMsg
		call	_printString
		ld	a,(colorError)
		ld	hl,iErrorMsg
		call	_printColorStr
		ld	hl,iCloseBracketMsg
		jp	_printString

_printInfoString
		ld	a,(colorInfo)
		jr	_printColorStr

_printAppNameString
		ld	a,(colorAppName)
		call	_printColorStr
		ld	hl,returnMsg
		jp	_printString

_printCopyrightString
		ld	a,(colorCopyright)
		call	_printColorStr
		ld	hl,returnMsg
		jp	_printString

_printUnknownCmd
		ld	hl,unknownCmdMsg
		ld	b,#ff
		jp	_printErrorString

_printOkString	ld	a,(colorOk)
		jr	_printColorStr

_printWarningString
		ld	a,(colorWarning)
		jr	_printColorStr

_printFileTooBig
		ld	hl,errorFileTooBig
		ld	b,#ff
		jr	_printErrorString

_printFileNotFound
		push	hl
		ld	hl,fileNotFoundMsg
		ld	b,#ff
		call	_printErrorString
		pop	hl
		ld	b,#00
		call	_printErrorString
		ld	hl,fileNotFoundMsg0
		jr	_printErrorString

_printErrNun	ld	hl,errorNunMsg
		jr	_printEP

_printErrLimits	ld	hl,errorLimitMsg
		jr	_printEP

_printErrParams	ld	hl,errorParamsMsg
_printEP	ld	b,#ff
_printErrorString
		ld	a,(colorError)

_printColorStr	ld	c,a
		ld	a,(currentColor)
		push	af
		and	%11110000
		or	c
		ld	(currentColor),a

		ld	a,b
		cp	#ff
		jr	nz,_printColorStr2

		push	hl
		ld	hl,errorMsg
		call	_printString
		pop	hl

_printColorStr2	call	_printString
		pop	af
		ld	(currentColor),a
		ld	hl,restoreMsg
		jp	_printString

_printRestore	ld	hl,restoreMsg
		call	_printString

_printReturn	ld	hl,returnMsg
		jp	_printString

;---------------------------------------
_printContinue	halt
		ld	hl,continueMgs
		jp	_printString

;---------------------------------------
_printInputYN	halt
		call	_printWarningString

		ld	hl,returnMsg
		call	_printString

inputYNLoop	halt
		call	_getKey
		cp	"y"
		ret	z
		cp	"n"
		ret	z
		jr	inputYNLoop

;---------------------------------------
_printInputRIA	halt
		call	_printErrorString
		
		ld	hl,returnMsg
		call	_printString

inputRIALoop	halt
		call	_getKey
		cp	"r"
		ret	z
		cp	"i"
		ret	z
		cp	"a"
		ret	z
		jr	inputRIALoop

;---------------------------------------
_storePath	push	hl,de,bc,af
		ld	hl,pathBString
		ld	de,pathBString+1
		ld	bc,pathStrSize
		xor	a
		ld	(hl),a
		ldir

		ld	de,pathBString
storePathCall	ld	hl,pathString
storeLoop	ld	a,(hl)
		cp	#00
		jr	z,storePathExit
		cp	#0d
		jr	z,storePathExit
		ld	(de),a
		inc	hl
		inc	de
		jr	storeLoop

storePathExit	pop	af,bc,de,hl
		ret

_restorePath	ld	de,pathBString
_restorePath_1	push	af
		ex	af,af'
		push	af
		call	_changeDir
		pop	af
		ex	af,af'
		pop	af
		ret
;---------------------------------------
_clearBuffer	ld	hl,bufferAddr
		ld	de,bufferAddr+1
		ld	bc,#1fff
		xor	a
		ld	(hl),a
		ldir
		ret

;---------------------------------------
_cliInitDev	call	_initPath

		ld	a,(bootDevide)
		ld	b,a					; загрузочное устройство
		call	_openStream
		ret	z					; если устройство найдено

		ld	a,"?"
		ld	(pathString),a

		ld	a,#ff					; error
		ret
;---------------------------------------
_checkIsPath	push	hl
		xor	a
		ld	(needCd+1),a
		ld	(pathCd+1),hl

cipLoop		ld	a,(hl)					; цикл: проверка всей строки на наличие /
		cp	#00
		jr	z,needCd
		
		cp	"/"
		jr	nz,cipNext
		ld	a,#01
		ld	(needCd+1),a	
		ld	(pathCd+1),hl
cipNext		inc	hl
		jr	cipLoop

needCd		ld	a,#00					; need cd?
		cp	#00
		jr	z,cipExit

pathCd		ld	hl,#0000
		xor	a
		ld	(hl),a

; 		push	hl
; 		call	_storePath
; 		pop	hl

		pop	de
		ld	a,(de)
		cp	#00					; root ?
		jr	nz,pathCd_00
		ld	de,rootPath
		
pathCd_00	push	hl
		call	_changeDir
		pop	hl

		ld	a,"/"
		ld	(hl),a
		inc	hl
		ret

cipExit		;call	_storePath
		pop	hl
		xor	a
		ex	af,af'
		xor	a
		ret

;---------------------------------------
_storeHomePath	push	hl,de,bc

		ld	hl,pathHomeString
		ld	de,pathHomeString+1
		ld	bc,pathStrSize
		xor	a
		ld	(hl),a
		ldir

		ld	hl,pathString				; store current path to home app path
		ld	de,pathHomeString
		
storeHomeLoop	ld	a,(hl)
		cp	#00
		jr	z,storeHomeExit
		cp	#0d
		jr	z,storeHomeExit
		ld	(de),a
		inc	hl
		inc	de
		jr	storeHomeLoop

storeHomeExit	pop	bc,de,hl
		ret

_restoreHomePath
		push	hl,de,bc
; 		ld	hl,pathHomeString			; restore current path from home app path
; 		ld	de,pathString
; 		ld	bc,pathStrSize
; 		ldir
 		ld	de,pathHomeString
 		call	_restorePath_1
;  		call	_changeDir
		pop	bc,de,hl
		ret

; _restorePath	push	af
; 		ex	af,af'
; 		push	af
; 		ld	de,pathBString
; 		call	_changeDir
; 		pop	af
; 		ex	af,af'
; 		pop	af
; 		ret


;---------------------------------------
_initCallBack	ld	hl,callBackRet				; инициализирует callBack при переключении ALT+F1/F2/F3/F4
_setAppCallBack	ld	(callBackApp),hl
		ret

;---------------------------------------
_storeFileLen	ld	(fileLength),hl
		ld	(fileLength+2),de
		ret

;---------------------------------------
_checkCallKeys	push	hl
		ex	de,hl					; hl - адрес таблицы ключей
								; de - адрес строки с ключами
		xor	a					; сброс флагов
		ld	a,(de)
		cp	"-"
		jr	nz,exitNoKeys
checkCallLoop	push	hl
		call	_parser
		ld	de,(storeAddr)
		pop	hl
		cp	#fe					; Пропустить следующее значение
		jr	nz,checkCallSkip

checkCallLoop2	inc	de
		ld	a,(de)
		cp	#00
		jr	z,checkCallSkip2
		cp	" "
		jr	nz,checkCallLoop2
		call	_eatSpaces
		jr	checkCallSkip2

checkCallSkip	cp	#ff
		jr	z,errorCallExit

checkCallSkip2	ld	a,(de)
		cp	"-"
		jr	z,checkCallLoop

checkCallOk	pop	af
		ex	de,hl
		ret

errorCallExit	ex	hl,de
		ld	a,#ff

exitNoKeys	pop	hl
		ret

;---------------------------------------
_loadFileLimit	ld	a,#01					; bc - лимит
		ld	(checkLimit+1),a
		ld	a,b
		ld	(checkLimit_01+1),a
		ld	a,c
		ld	(checkLimit_02+1),a
		jr	_loadFile0

;---------------
_loadFile	xor	a
		ld	(checkLimit+1),a
		ex	af,af'
		cp	#01
		jr	z,loadFile_00				; загрузка файла без восстановления пути

_loadFile0	call	_storePath				; загрузка файла с восстановлением пути
		call	loadFile_00
		push	bc
		call	_restorePath
		pop	bc
		ret

; _loadFileHere	xor	a					; загрузка файла без восстановления пути
; 		ld	(checkLimit+1),a

loadFile_00	push	de					; de - aдрес загрузки
		call	_checkIsPath				; hl - адрес строки с именем файла
							
		ld	a,flagFile				; file
		call	_prepareEntry
			
		call	_eSearch
		jr	z,loadFileFNF				
		
		call	_storeFileLen
		ld	a,d
		or	e
		jr	nz,loadFileTooBig
		
		pop	bc
		push	bc					; в BC адрес загрузки
		
		push	hl
		add	hl,bc
		jr	c,loadFileTooBig			; если вылетаем за границу адресного пространства (>#ffff)

		pop	hl					; hl - размер файла?
		ld	(loadFileSize+1),hl

checkLimit	ld	a,#00
		cp	#00
		jr	z,loadFile_01

		ld	a,h
checkLimit_01	cp	#00
		jr	nz,loadWrongSize

		ld	a,l
checkLimit_02	cp	#00
		jr	nz,loadWrongSize		

loadFile_01	call	_setFileBegin
		call	_prepareSize
		ld	a,b
		cp	#00
		jr	nz,loadFileTooBig
		ld	b,c

		pop	hl
		call	_load512bytes

		xor	a
loadFileSize	ld	bc,#0000				; на выходе в BC - размер файла
		ret

loadWrongSize	pop	hl
		ld	a,eFileWrongSize
		ex	af,af'
		jr	loadFileError

loadFileTooBig	pop	hl
		call	_printFileTooBig
		ld	a,eFileTooBig
		ex	af,af'
		jr	loadFileError

loadFileFNF	pop	de
		ld	a,eFileNotFound
		ex	af,af'

loadFileError	call	_restorePath
		ld	a,#ff					; exit with error
		ret

;---------------
_loadFileParts	ld	a,b
		ld	(loadFileCheck+1),a			; b - размер одной загружаемой части в блоках (по 512б)
		ld	(loadFileAddr+1),de			; de - aдрес загрузки
		call	_storePath
		call	_checkIsPath				; hl - адрес строки с именем файла
							
		ld	a,flagFile				; file
		call	_prepareEntry
			
		call	_eSearch
		jr	z,loadFileFNF+1				; +1 не нужно восстанавливать pop de			
		
		call	_storeFileLen

		call	_setFileBegin
		call	_prepareSize
		ld	(loadFileBlocks),bc

_loadNextPart	call	_restoreWcBank
		ld	hl,(loadFileBlocks)
		ld	a,h
		or	l
		jr	nz,loadFileCheck
		ld	a,eFileEnd
		ex	af,af'
		ld	a,#ff
		ret

loadFileCheck	ld	c,#00
		ld	b,#00
		sbc	hl,bc
		jr	c,loadFileEnd
		ld	(loadFileBlocks),hl

		ld	b,c
loadFileAddr	ld	hl,#0000

; 		call	_disableRes
		call	_load512bytes
; 		call	_enableRes

		xor	a
		ret

loadFileEnd	ld	de,(loadFileBlocks)
		ld	b,e
		xor	a
		ld	(loadFileBlocks),a
		ld	(loadFileBlocks+1),a
		call	loadFileAddr
		call	_restorePath
		xor	a
		ret

;---------------------------------------
_saveFile
_saveFileParts
_saveNextPart

_deleteFileDir

_renameFileDir

_getTxtPalette
		ret

_createFile	ld	a,flagFile
		call	_prepareSaveEntry

		ld	hl,entryForSearch
		ld	a,_MKFILE
  		jp	wcKernel

_createDir	ld	a,_MKDIR
  		jp	wcKernel

_checkFileExist	ld	a,flagFile				; file
		jr	_checkDirExist_

_checkDirExist	ld	a,flagDir				; directory
_checkDirExist_	call	_prepareEntry
		jp	_eSearch

;---------------------------------------
_setTxtPalette	xor	a
		ld	(setPalScr+1),a
								; На входе:
								;	в HL адрес начала палитры
								;	в D номер блока один из 16-ти
								;	в BC размер загружаемой палитры
; 		ld	de,#0000				
; 		ld	bc,512
		sla	d					; * 2 (512)
		xor	a
		ld	e,a
		ldir

		ld	a,palBank				; Включаем страницу для сохранения текстовой палитры
		call	switchMemBank

		ld 	de,palAddr
		jr	storePalette

;---------------
_setGfxPalette	push	bc
		call	toBuff0000

		ld	a,gPalBank1				; Включаем страницу для сохранения графической палитры
		call	switchMemBank
		pop	bc

		call	getPalAddr

storePalette	push	de
		call	fromBuff0000
		pop	hl

setPalScr	ld	c,#00
		ld	a,(currentScreen)
		cp	c
 		call	z,_setPal

setAppBank	ld	a,appBank				; Включаем страницу приложений
		jp	switchMemBank

toBuff0000	ld	de,#0000				; На входе в HL адрес начала палитры
		ld	bc,512
		ldir
		ret

fromBuff0000	ld	hl,#0000
		ld	bc,512
		ldir
		ret

getPalAddr	ld 	de,gPalAddr1	
		ld	a,b					; номер графического экрана
		ld	(setPalScr+1),a
		dec	a
		ret	z					; 1й
		ld 	de,gPalAddr2
		dec	a
		ret	z					; 2й
		ld 	de,gPalAddr3
		ret						; 3й

;---------------
_getGfxPalette	push	hl,bc

		ld	a,gPalBank1				; Включаем страницу для сохранения графической палитры
		call	switchMemBank

		pop	bc

		call	getPalAddr
		ex	hl,de
		call	toBuff0000

		call	setAppBank

		pop	de
		jp	fromBuff0000

;---------------------------------------
_setFont	ld	de,#0000				; Сохраняем копию шрифта в #0000
		ld	bc,2048
		ldir
		ld	a,txtFontBank				; Включаем страницу с нашим фонтом
		call	switchMemBank
		
		ld	hl,#0000				; Копируем шрифт из #0000
		ld	de,txtFontAddr
		ld	bc,2048
		ldir
		jp	setAppBank

;---------------------------------------
_gliApi		push	af
		
		ld	a,gliBank
		call	switchMemBank

		pop	af

		call	gliAddr

		push	af
		call	setAppBank
		pop	af

		ret

;---------------------------------------
; _resApi		push	af

; 		ld	a,resBank
; 		call	switchMemBank
; 		pop	af

; 		call	resAddr

; 		push	af
; 		call	restoreMemBank
; 		pop	af
; 		ret

;---------------------------------------
; _loadSysRes	ld	hl,resPath
; 		ld	a,resBank				; Указываем страницу для загрузки  res.sys с #c000
; 		jr	loadDmaPath

;---------------------------------------
_loadKeyMap	ld	hl,keymapPath
		ld	a,keymapBank				; Указываем страницу для загрузки  default.key с #c000
		jr	loadDmaPath

;---------------------------------------
_loadGli	ld	hl,gliPath
		ld	a,gliBank				; Указываем страницу для загрузки  gli.sys с #c000
		jr	loadDmaPath

;---------------------------------------
_loadDrivers	ld	hl,driversPath
		ld	a,driversBank				; Указываем страницу для загрузки drivers.sys с #c000

loadDmaPath	push	af
		ld	a,(_PAGE3)
		ld	(restorePage3+1),a
		pop	af
		add	32
		ld	(_PAGE3),a

		ld	de,#c000
		call	_loadFile

		push	af					; Load status
restorePage3	ld	a,#00
		ld	(_PAGE3),a
		pop	af
		ret

;---------------------------------------
; _enableRes	push 	af
; 		xor	a					; Разрешить вызов обработчика резидентов
; 		jr	_disableRes1
; _disableRes	push	af
; 		ld	a,#01					; Запретить вызов обработчика резидентов
; _disableRes1	ld	(disableResident+1),a
; 		pop	af
; 		ret
;---------------------------------------
_enableNvram	push 	af
 		call	_nvRamOpen
		xor	a					; Разрешить вызов обработчика клавиатуры
		ld	(disableKeyboard+1),a
 		pop	af
		ret

_disableNvram	push	af
		ld	a,#01					; Запретить вызов обработчика клавиатуры
		ld	(disableKeyboard+1),a
		call	_nvRamClose
		pop	af
		ret
;---------------------------------------
_driversApi	di
		push	af,bc
		ld	a,#01
		ld	(disableDrivers+1),a
; 		call	_disableRes

		ld	a,(_PAGE3)				; Сохряняем какая была до этого открыта страница
		ld	(da_page+1),a

		ld	a,driversBank				; Включаем страницу для drivers.sys с #0000
		call	_setRamPage3
		pop	bc,af

		call	driversAddr

		push	af
da_page		ld	a,#00
		ld	(_PAGE3),a				; Восстанавливаем банку для WildCommander
		ld	bc,tsRAMPage3
		out	(c),a
		
		xor	a
		ld	(disableDrivers+1),a
; 		call	_enableRes
		pop	af
		ei	
		ret

;---------------------------------------
_restoreWcBank	ld	a,(_PAGE0)				; Восстанавливаем банку для WildCommander
		ld	bc,tsRAMPage0
		out	(c),a
		ret
;---------------------------------------
updateDrivers
disableDrivers	ld	a,#00
		cp	#01
		ret	z

		ld	a,(_PAGE3)				; Сохряняем какая была до этого открыта страница
		ld	(ud_page+1),a

		ld	a,driversBank
		call	_setRamPage3				; Включаем страницу для drivers.sys с #с000

		ld	a,mouseUpdate
		call	driversAddr

ud_page		ld	a,#00
		ld	(_PAGE3),a				; Восстанавливаем банку для WildCommander
		ld	bc,tsRAMPage3
		out	(c),a
		ret
		
;---------------------------------------
_getPanelStatus	ld	ix,(storeIx)				; Получить состояние активной панели Wild Commander'a
		ld	a,(ix+29)
		ret

;---------------------------------------
_printInputString
		call	_printInLine
		jp	_printWW
;---------------------------------------
		ex	af,af'
_setRamPage0	ld	bc,tsRAMPage0
_setRamPage0_	add	32
		out	(c),a
		ret

_setRamPage3	ld	bc,tsRAMPage3
 		jr	_setRamPage0_
;---------------------------------------
_moveScreenInit	push	hl
		ld	hl,#0000
		ld	(mXoffset1),hl
		ld	(mYoffset1),hl
		ld	(mXoffset2),hl
		ld	(mYoffset2),hl
		ld	(mXoffset3),hl
		ld	(mYoffset3),hl
		pop	hl
		ret

_moveScreenUp	call	getCurScrYToHL
		cp	#00
		ret	z					; текстовый режим не скроллим!	
		call	getHLfromAddr
		ex	af,af'
		ld	b,#00
		ld	c,a
		add	hl,bc
		call	setHLToCurScrY
		jr	moveScreenUpdate

_moveScreenDown	call	getCurScrYToHL
		cp	#00
		ret	z					; текстовый режим не скроллим!
		call	getHLfromAddr
		ex	af,af'
		ld	b,#00
		ld	c,a
		sbc	hl,bc
		call	setHLToCurScrY
		jr	moveScreenUpdate

_moveScreenLeft	call	getCurScrXToHL
		cp	#00
		ret	z					; текстовый режим не скроллим!
		call	getHLfromAddr
		ex	af,af'
		ld	b,#00
		ld	c,a
		sbc	hl,bc
		call	setHLToCurScrX
		jr	moveScreenUpdate

_moveScreenRight
		call	getCurScrXToHL
		cp	#00
		ret	z					; текстовый режим не скроллим!
		call	getHLfromAddr
		ex	af,af'
		ld	b,#00
		ld	c,a
		add	hl,bc
		call	setHLToCurScrX

moveScreenUpdate
		call	getCurScrXToHL
		call	getHLfromAddr
		call	setGXoff
		call	getCurScrYToHL
		call	getHLfromAddr
		jr	setGYoff

;---------------
setGXoff	ld	a,l
		ld	bc,tsGXoffsL
		out	(c),a
		ld	a,h
		ld	bc,tsGXoffsH
		out	(c),a

; 		ld	a,_GXoff
; 		call	wcKernel			; !!!!! FIX !!!!
		ret

;---------------
setGYoff	ld	a,l
		ld	bc,tsGYoffsL
		out	(c),a
		ld	a,h
		ld	bc,tsGYoffsH
		out	(c),a

; 		ld	a,_GYoff
; 		call	wcKernel			; !!!!! FIX !!!!
		ret
;---------------
getCurScrXToHL	ld	a,(currentScreen)
getCurScrXToHL_	cp	#00
		ld	hl,mXoffset0
		ret	z
getCurScrXToHL0	ld	hl,mXoffset1
		cp	#01
		ret	z
		ld	hl,mXoffset2
		cp	#02
		ret	z
		ld	hl,mXoffset3
		ret

;---------------
getCurScrYToHL	ld	a,(currentScreen)
getCurScrYToHL_	cp	#00
		ld	hl,mYoffset0
		ret	z
getCurScrYToHL0	ld	hl,mYoffset1
		cp	#01
		ret	z
		ld	hl,mYoffset2
		cp	#02
		ret	z
		ld	hl,mYoffset3
		ret

;---------------
setHLToCurScrX	ex	de,hl				; de значение
		call	getCurScrXToHL			; в hl аддр
setDEToAddrHL	ld	(hl),e
		inc	hl
		ld	(hl),d
		ret
;---------------
setHLToCurScrY	ex	de,hl				; de значение
		call	getCurScrYToHL			; в hl аддр
		jr	setDEToAddrHL
;---------------
getHLfromAddr	ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		ret
;---------------------------------------
_setScreenOffsetX
		ex	de,hl
		ld	a,b				; у нас свой скрин
		call	getCurScrXToHL_
		jr	setDEToAddrHL
;---------------------------------------
_setScreenOffsetY
		ex	de,hl
		ld	a,b				; у нас свой скрин
		call	getCurScrYToHL_
		jr	setDEToAddrHL

;---------------------------------------
_getNumberFromParams
		call	_eatSpaces
		ex	hl,de
		call	_str2int
		ret

;---------------------------------------
_getHexFromParams
		call	_eatSpaces
		ld	a,(de)
		cp	"#"
		jr	nz,getHexError
		inc	de
		call	_hex2int
		ret

;---------------------------------------
_getHexPairFromParams
		call	_eatSpaces
		ld	a,(de)
		cp	"#"
		jr	nz,getHexError
		inc	de
		call	_hex2int
		cp	#ff
		ret	z
		ld	a,(de)
		cp	","
		jr	nz,getHexError
		inc	de
		ld	a,(de)
		cp	"#"
		jr	nz,getHexError
		jr	getHexSecond

getHexError	ld	a,#ff
		ret

getHexSecond	inc	de
		ld	b,l
		call	_hex2int
		cp	#ff
		ret	z
		ld	h,b
		ret

;---------------------------------------
_nvRamOpen	ld	a,#80
		ld	bc,peNvRamAccess
		out	(c),a
		ret

_nvRamClose	xor	a
		ld	bc,peNvRamAccess
		out	(c),a
		ret

;---------------------------------------
_nvRamGetData	ex	af,af'
		ld	bc,peNvRamLocation
		out	(c),a
_nvRamGetData0	ld	bc,peNvRamData
		in	a,(c)
		ret

;---------------------------------------
_nvRamSetData	ex	af,af'
; 		push	af
		ld	bc,peNvRamLocation
		out	(c),a
		ld	bc,peNvRamData
		ld	a,l
		out	(c),a
		ret

;---------------------------------------
_getKey		xor	a				; сбрасываем учёш клавиши shift
		ld	(checkShiftKey),a
		call	_getKeyWithShift
		push	af
		ld	a,#01				; восстанавливаем учёш клавиши shift
		ld	(checkShiftKey),a
		pop	af
		ret

;---------------------------------------
_getKeyWithShiftT
		call	_ps2GetScanCodeT		; Получить сканкод, но не удалять!
		jr	_getKeyWithShiftN	
;---------------------------------------
_getKeyWithShift
		call	_ps2GetScanCode			; Получить сканкод
		
_getKeyWithShiftN
		cp	#ff				; Выход если ничего не нажато
		jp	z,returnEmptyAscii

		ld	a,l
		cp	#00				; Выход если пусто
		jr	z,returnEmptyAscii		

		cp	#f0				; Если #f0 — клавишу отпустили = выход
		jp	z,getAsciiCode_02

		cp	#e0				; Если не #e0 значит обычная клавиша 
		jr	nz,getAsciiCode

 		ld	l,h				; иначе расширенный код
 		ld	h,#00
 		
 		ld	a,l
 		cp	#f0
		jp	z,getAsciiCode_02

 		cp	#4a
 		jr	nz,gkE0_00
 		
 		ld	a,"/"
 		or	a				; данные получены
		ret

gkE0_00		cp	#68
 		jr	c,returnEmptyAscii
 		ld	de,keyMap_E0-#68
 		push	af
		ld	a,keymapBank
		call	_setRamPage0
		pop	af
 		jr	getAsciiCode_0C
;---------------
getAsciiCode	push	af
		ld	a,keymapBank
		call	_setRamPage0
		pop	af
		push	hl

		ld	a,(keyLayoutSwitch)		; Проверить активную раскладку
		cp	#00				; 0 - EN, 1 - RU
		jr	z,gAC_EN

gAC_RU		ld	a,(checkShiftKey)
		cp	#00
		jr	z,getAsciiCode_0B
		call	_checkKeyShift			; Проверить нажат ли shift
		jr	z,getAsciiCode_0B		; Если нет, то таблица keyMap_1A
		
		ld	de,keyMap_1B			; в противном случае keyMap_1B
		jr	getAsciiCode_0A+3

getAsciiCode_0B	ld	de,keyMap_1A
		jr	getAsciiCode_0A+3

gAC_EN		ld	a,(checkShiftKey)
		cp	#00
		jr	z,getAsciiCode_0A
		call	_checkKeyShift			; Проверить нажат ли shift
		jr	z,getAsciiCode_0A		; Если нет, то таблица keyMap_0A
		
		ld	de,keyMap_0B			; в противном случае keyMap_0B
		jr	getAsciiCode_0A+3

getAsciiCode_0A	ld	de,keyMap_0A
		
		pop	hl

getAsciiCode_0C	add	hl,de
		ld	a,(hl)

		push	af
		cp	#00
		jr	z,getAsciiCode_01
		pop	af
		or	a					; NZ - данные получены
		jr	getAsciiExit

getAsciiCode_01	pop	af
getAsciiCode_02	
returnEmptyAscii
		xor	a					; Z - данных нет - выход
		or	a
		
getAsciiExit	push	af
		call	_restoreWcBank
		pop	af
		ret
;---------------------------------------
_checkSync	ld	hl,(intCounter)
		ld	a,h
		or	l
		ret	z				; Z - ещё не было обновлений - выход
		ld	hl,#0000
		ld	(intCounter),hl
		ld	a,1				; NZ - обновление было
		or	a
		ret
;---------------------------------------
storeAltStatus	ld	hl,keyStatus + #11
		ld	a,(hl)
		ld	hl,altStatusB
		ld	(hl),a
		ret

restoreAltStatus
		ld	hl,altStatusB
		ld	a,(hl)
		ld	hl,keyStatus + #11
		ld	(hl),a
		ret

;---------------------------------------
storeCtrlStatus	ld	hl,keyStatus + #14
		ld	a,(hl)
		ld	hl,ctrlStatusB
		ld	(hl),a
		ret

restoreCtrlStatus
		ld	hl,ctrlStatusB
		ld	a,(hl)
		ld	hl,keyStatus + #14
		ld	(hl),a
		ret

;---------------------------------------
checkKey	ld	a,(hl)
		or	a
		ret

;---------------------------------------
_checkKeyCtrlL	ld	hl,keyStatus + #14	
		jr	checkKey

;---------------------------------------
_checkKeyCtrlR	ld	hl,keyStatusE0 + #14	
		jr	checkKey

;---------------------------------------
_checkKeyAltL	ld	hl,keyStatus + #11	
		jr	checkKey

;---------------------------------------
_checkKeyAltR	ld	hl,keyStatusE0 + #11	
		jr	checkKey

;---------------------------------------
_checkKeyUp	ld	hl,keyStatusE0 + #75	
		jr	checkKey

;---------------------------------------
_checkKeyDown	ld	hl,keyStatusE0 + #72	
		jr	checkKey

;---------------------------------------
_checkKeyLeft	ld	hl,keyStatusE0 + #6B	
		jr	checkKey

;---------------------------------------
_checkKeyRight	ld	hl,keyStatusE0 + #74	
		jr	checkKey

;---------------------------------------
_checkKeyShift	call	_checkKeyShiftL
		jr	z,_checkKeyShiftR
		ret
;---------------------------------------
_checkKeyShiftL	ld	hl,keyStatus + #12
		jr	checkKey

;---------------------------------------
_checkKeyShiftR	ld	hl,keyStatus + #59
		jr	checkKey

;---------------------------------------
_waitAnyKey	halt
		call	_getKeyWithShift			; Опрашиваем клавиатуру

		cp	#00					; Если ничего не нажали
		jp	z,_waitAnyKey
		ret
;---------------------------------------
switchMemBank	call	storeMemBank
		jp	_setVideoPage

;---------------
storeMemBank	push	af
		ld	a,(_PAGE3)
		sub	#20
		ld	(storeBank+1),a
		pop	af
		ret
;---------------
restoreMemBank	push	af
storeBank	ld	a,#00
		call	_setVideoPage
		pop	af
		ret
;---------------------------------------
_getLocale	ld	hl,sysLocale
		ld	a,(hl)
		inc	hl
		ld	l,(hl)
		ld	h,a
		ret

;---------------------------------------















;---------------------------------------
_setVideoPage	ex	af,af'
		ld	a,_MNGCVPL
		jp	wcKernel

;---------------------------------------                        
_setVideoBuffer	;push	af					; #00 - 0й текстовый                             #10
		;ex	af,af'					; #01 - 1й графичекский видео буфер (16 страниц) #20
		;ld	a,_MNGV_PL				; #02 - 2й графичекский видео буфер (16 страниц) #30
		;call	wcKernel				; #03 - 3й графичекский видео буфер (16 страниц) #40
		;pop	af
		
		inc	a					; !!! FIX !!!
		sla 	a
		sla 	a
		sla 	a
		sla 	a
		ld	bc,tsVpage
		out	(c),a
		ret

;---------------------------------------
_setVideoMode	
		ld	bc,tsVConfig				; Временный fix из-за отключенных прерываний WC
		out	(c),a
		
		push	af
_driversLoaded	ld	a,#00
		cp	#00
		jr	nz,_slm
		pop	af
		ret

_slm		pop	af
;---------------
_setLimitMouse	push	af					; На входе в A - параметры для граф режима (_setVideoMode) 
		and	%00000011
		cp	%00000011
		jr	nz,_svm_00

		pop	af

		ld	hl,319					; перерасчитанное TXT->GFX разрешение
		ld	de,239
		jr	_svm

_svm_00		pop	af
		and	%11000000

		cp	%00000000				; %00 - 256x192
		jr	nz,_svm_01
		ld	hl,255
		ld	de,191
		jr	_svm

_svm_01		cp	%01000000				; %01 - 320x200
		jr	nz,_svm_10
		ld	hl,319
		ld	de,199
		jr	_svm

_svm_10		cp	%10000000				; %10 - 320x240
		jr	nz,_svm_11
		ld	hl,319
		ld	de,239
		jr	_svm

_svm_11		cp	%11000000				; %11 - 360x288
		ret	nz

		ld	hl,359
		ld	de,287
_svm 		ld	a,mouseInit
		call	cliDrivers

		ld	hl,#0000
		ld	de,#0000
		jp	_updateCursor2

; 		ex	af,af'					; включение видео режима (разрешение+тип)
; 								; i:A' - видео режим
; 								;   [7-6]: %00 - 256x192
; 								;          %01 - 320x200
; 								;          %10 - 320x240
; 								;          %11 - 360x288
; 								;   [5-2]: %0000
; 								;   [1-0]: %00 - ZX
; 								;          %01 - 16c
; 								;          %10 - 256c
; 								;          %11 - txt
; 		ld	a,_GVmod
; 		jp	wcKernel				; !!! FIX !!!

;---------------------------------------
_callDma	ex	af,af'
		ld	a,_DMAPL
		jp	wcKernel

;---------------------------------------
_restoreWC	ld	a,#00				; Восстановление видеорежима для WC (#00 - основной экран (тхт))
		ex	af,af'
		ld	a,_MNGV_PL
		jp	wcKernel

;---------------------------------------
_openStream	ld	d,#00				; окрываем поток с устройством (#00 = инициализация, #ff = сброс в root)
		ld	a,_STREAM
		jp	wcKernel

;---------------------------------------
_load512bytes	
; 		call	_disableRes
		ld	a,1
		call	_setCursorPhase
		ld	a,_LOAD512
		call	wcKernel
		push	af
		xor	a
		call	_setCursorPhase
		pop	af
		ret
; 		jp	_enableRes

;---------------------------------------
_setFileBegin	ld	a,_GFILE
		jp	wcKernel

;---------------------------------------
_setDirBegin	ld	a,_GDIR
		jp	wcKernel

;---------------------------------------
_pathToRoot	ld	d,#ff				; окрываем поток с устройством (#00 = инициализация, #ff = сброс в root)
		ld	bc,#ffff			; устройство (#ffff = не создавать заново, использовать текущий поток)
		ld	a,_STREAM
		jp	wcKernel

;---------------------------------------
_searchEntry	ld	a,_FENTRY
		jp	wcKernel

; ;---------------------------------------

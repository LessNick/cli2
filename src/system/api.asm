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
		jp	z,_reserved				; #03		!!! RESERVED !!!
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
		jp	z,_reserved				; #3D		!!! RESERVED !!!
		dec	a
		jp	z,_eatSpaces				; #3E
		dec	a
		jp	z,_setAppCallBack			; #3F
		dec	a
		jp	z,_setRamPage0Ext			; #40
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
		jp	z,_reserved				; #53		!!! RESERVED !!!
		dec	a

		jp	z,_reserved				; #54		!!! RESERVED !!!

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

		dec	a
		jp	z,_setPalNow				; #5C

		dec	a
		jp	z,_showHideCursor			; #5D

_reserved	ret

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		include "api/initSystem.asm"			; ID: #00
		include "api/reInitSystem.asm"			; ID: #01
		include "api/getCliVersion.asm"			; ID: #02
								; ID: #03 - reserved
		include "api/clearTxtMemory.asm"		; ID: #04
		include "api/clearGfxMemory.asm"		; ID: #05
		include "api/switchTxtMode.asm"			; ID: #06
		include "api/switchGfxMode.asm"			; ID: #07
		include "api/setGfxColorMode.asm"		; ID: #08
		include "api/setGfxResolution.asm"		; ID: #09
		include "api/setScreenOffsetX.asm"		; ID: #0A
		include "api/setScreenOffsetY.asm"		; ID: #0B
		include "api/printInit.asm"			; ID: #0C
		include "api/editInit.asm"			; ID: #0D
		include "api/printString.asm"			; ID: #0E
		include "api/printInputString.asm"		; ID: #0F
		include "api/printOkString.asm"			; ID: #10
		include "api/printErrorString.asm"		; ID: #11
		include "api/printAppNameString.asm"		; ID: #12
		include "api/printCopyrightString.asm"		; ID: #13
		include "api/printInfoString.asm"		; ID: #14
		include "api/printStatusString.asm"		; ID: #15
		include "api/printStatusOk.asm"			; ID: #16
		include "api/printStatusError.asm"		; ID: #17
		include "api/printErrParams.asm"		; ID: #18
		include "api/printFileNotFound.asm"		; ID: #19
		include "api/printFileTooBig.asm"		; ID: #1A
		include "api/printRestore.asm"			; ID: #1B
		include "api/printContinue.asm"			; ID: #1C
		include "api/printInputYN.asm"			; ID: #1D
		include "api/printInputRIA.asm"			; ID: #1E
		include "api/printCodeDisable.asm"		; ID: #1F
		include "api/printWithScroll.asm"		; ID: #20
		include "api/clearIBuffer.asm"			; ID: #21
		include "api/checkCallKeys.asm"			; ID: #22
		include "api/loadFile.asm"			; ID: #23
		include "api/loadFileLimit.asm"			; ID: #24
		include "api/loadFileParts.asm"			; ID: #25
		include "api/loadNextPart.asm"			; ID: #26
		include "api/saveFile.asm"			; ID: #27
		include "api/saveFileParts.asm"			; ID: #28
		include "api/saveNextPart.asm"			; ID: #29
		include "api/createFile.asm"			; ID: #2A
		include "api/createDir.asm"			; ID: #2B
		include "api/deleteFileDir.asm"			; ID: #2C
		include "api/renameFileDir.asm"			; ID: #2D
		include "api/checkFileExist.asm"		; ID: #2E
		include "api/checkDirExist.asm"			; ID: #2F
		include "api/getTxtPalette.asm"			; ID: #30
		include "api/getGfxPalette.asm"			; ID: #31
		include "api/setTxtPalette.asm"			; ID: #32
		include "api/setGfxPalette.asm"			; ID: #33
		include "api/setFont.asm"			; ID: #34
		include "api/str2int.asm"			; ID: #35
		include "api/int2str.asm"			; ID: #36, ID: #37, ID: #39
		include "api/char2hex.asm"			; ID: #38
		include "api/mult16x8.asm"			; ID: #3A
		include "api/divide16_16.asm"			; ID: #3B
		include "api/parseLine.asm"			; ID: #3C
								; ID: #3D - reserved
		include "api/eatSpaces.asm"			; ID: #3E
		include "api/setAppCallBack.asm"		; ID: #3F
		include "api/setRamPage0Ext.asm"			; ID: #40
		include "api/restoreWcBank.asm"			; ID: #41
		include "api/moveScreenInit.asm"		; ID: #42
		include "api/moveScreenUp.asm"			; ID: #43
		include "api/moveScreenDown.asm"		; ID: #44
		include "api/moveScreenLeft.asm"		; ID: #45
		include "api/moveScreenRight.asm"		; ID: #46
		include "api/getNumberFromParams.asm"		; ID: #47
		include "api/getHexFromParams.asm"		; ID: #48
		include "api/getHexPairFromParams.asm"		; ID: #49
		include "api/nvRamOpen.asm"			; ID: #4A
		include "api/nvRamClose.asm"			; ID: #4B
		include "api/nvRamGetData.asm"			; ID: #4C
		include "api/nvRamSetData.asm"			; ID: #4D
		include "api/ps2Init.asm"			; ID: #4E
		include "api/ps2ResetKeyboard.asm"		; ID: #4F
		include "api/ps2GetScanCode.asm"		; ID: #50
		include "api/getKeyWithShift.asm"		; ID: #51
		include "api/waitAnyKey.asm"			; ID: #52
								; ID: #53 - reserved
								; ID: #54 - reserved
		include "api/enableNvram.asm"			; ID: #55
		include "api/disableNvram.asm"			; ID: #56
		include "api/getLocale.asm"			; ID: #57
		include "api/setMouseCursor.asm"		; ID: #58
		include "api/enableAyPlay.asm"			; ID: #59
		include "api/disableAyPlay.asm"			; ID: #5A
		include "api/uploadAyModule.asm"		; ID: #5B
		include "api/setPalNow.asm"			; ID: #5C
		include "api/showHideCursor.asm"		; ID: #5D


;---------------------------------------
storeRam0	push	af
		ld	a,(_PAGE0)				; Сохряняем какая была до этого открыта страница
		ld	(rsr0+1),a
		pop	af
		ret

;---------------
reStoreRam0	push	bc,af
rsr0		ld	a,#00
		ld	(_PAGE0),a				; Восстанавливаем банку
		ld	bc,tsRAMPage0
;---------------
setRam		out	(c),a
		pop	bc,af
		ret

;---------------------------------------
storeRam3	push	af
		ld	a,(_PAGE3)				; Сохряняем какая была до этого открыта страница
		ld	(rsr3+1),a
		pop	af
		ret

;---------------
setRamPage3	add	32
		ld	(_PAGE3),a
setRamPage33	ld	bc,tsRAMPage3
		out	(c),a
		ret
;---------------
reStoreRam3	push	af,bc
rsr3		ld	a,#00
		ld	(_PAGE3),a				; Восстанавливаем банку
		ld	bc,tsRAMPage3
		jr	setRam
;---------------------------------------
_borderIndicate	halt
		call	setBorder
		halt
		call	restoreBorder
		ret

;---------------------------------------
_setInterrupt	halt
		di
		ld	hl,_cliInt
		ld	(_WCINT),hl
		ei
		ret

;---------------------------------------
_cliInt		push	hl,de,bc,af				;======================================================================================================
		exx
		ex	af,af'
		push	hl,de,bc,af

		ld	hl,(intCounter)
		inc	hl
		ld	(intCounter),hl

		ld	a,(rsr0+1)
		ld	(restore0+1),a
		ld	a,(rsr3+1)
		ld	(restore3+1),a

		ld	a,(_PAGE0)
		ld	(restoreP0+1),a
		ld	a,(_PAGE3)
		ld	(restoreP3+1),a

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

skipKeyboard	
		call	updateDrivers
		call	updateCursor

		ld	a,(currentScreen)
		cp	#00
		push	af
		call	z,_checkMouseClicks
		pop	af
		call	nz,_resetMouseClicks

enableAy	ld	a,#00
		cp	#00
		jr	z,skipAy
		
		ld	a,pt3play
		call	cliDrivers

skipAy

restore0	ld	a,#00
		ld	(rsr0+1),a
restore3	ld	a,#00
		ld	(rsr3+1),a

restoreP0	ld	a,#00
		ld	(_PAGE0),a
		call	_setRamPage00

restoreP3	ld	a,#00
		ld	(_PAGE3),a
		call	setRamPage33

		pop	af,bc,de,hl		
		exx
		ex	af,af'
		pop	af,bc,de,hl
		ei
		ret

_wcIntAddr	jp	#0000

;---------------------------------------
_checkMouseClicks
		ld	hl,enableCursors
		ld	a,(hl)
		bit	0,a
		ret	z

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
		call	setCursorPhase

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

		jp	reStoreRam3

_openCacheBank	call	storeRam3				; Сохряняем какая была до этого открыта страница

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
			
;---------------
_fillMouseClicks						; всё что между крайними точками
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
		call	setCursorPhase
		ret
;---------------
_cmc_03		ld	de,#0000				; нажали и держат
		push	de
		call	_getMouseTxtPos
		pop	de
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

		call	storeRam3

		ld	a,sprBank				; Включаем страницу для спрайтов с #0000
		call	setRamPage3

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

		call	reStoreRam3				; Восстанавливаем банку которая была до вызова
		jp	updateCursor

;---------------------------------------
_actionInsOver	call	getKeyWithShiftT
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
		call	getKeyWithShiftT			; Опрашиваем клавиши, но не снимаем флаг, что данные забрали!
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
_printUnknownCmd
		ld	hl,unknownCmdMsg
		ld	b,#ff
		jp	_printErrorString

;---------------------------------------
_printWarningString
		ld	a,(colorWarning)
		jp	printColorStr

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
		call	openStream
		ret	z					; если устройство найдено

		ld	a,"?"
		ld	(pathString),a

		ld	a,#ff					; error
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
 		ld	de,pathHomeString
 		call	restorePath_1
		pop	bc,de,hl
		ret

;---------------------------------------
_initCallBack	ld	hl,callBackRet				; инициализирует callBack при переключении ALT+F1/F2/F3/F4
		jp	_setAppCallBack

;---------------------------------------
_gliApi		call	storeRam3

		push	af
		ld	a,gliBank
		call	setRamPage3
		pop	af

		call	gliAddr

		jp	reStoreRam3

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

loadDmaPath	call	storeRam3
		call	setRamPage3

		ld	de,#c000
		call	_loadFile
		jp	reStoreRam3

;---------------------------------------
_driversApi	di
		push	af,bc
		ld	a,#01
		ld	(disableDrivers+1),a

		call	storeRam3				; Сохряняем какая была до этого открыта страница

		ld	a,driversBank				; Включаем страницу для drivers.sys с #0000
		call	setRamPage3
		pop	bc,af

		call	driversAddr

		push	af
		call	reStoreRam3				; Восстанавливаем банку установленную до вызова

		xor	a
		ld	(disableDrivers+1),a
		pop	af
		ei	
		ret

;---------------------------------------
updateDrivers
disableDrivers	ld	a,#00
		cp	#01
		ret	z

		call	storeRam3

		ld	a,driversBank
		call	setRamPage3				; Включаем страницу для drivers.sys с #с000

		ld	a,mouseUpdate
		call	driversAddr

		jp	reStoreRam3				; Восстанавливаем банку установленную до вызова
		
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


























;---------------------------------------
callDma		ex	af,af'
		ld	a,_DMAPL
		jp	wcKernel

;---------------------------------------
openStream	ld	d,#00				; окрываем поток с устройством (#00 = инициализация, #ff = сброс в root)
		ld	a,_STREAM
		jp	wcKernel

;---------------------------------------
load512bytes	ld	a,1
		call	setCursorPhase
		ld	a,_LOAD512
		call	wcKernel
		push	af
		xor	a
		call	setCursorPhase
		pop	af
		ret

;---------------------------------------
setDirBegin	ld	a,_GDIR
		jp	wcKernel

;---------------------------------------
pathToRoot	ld	d,#ff				; окрываем поток с устройством (#00 = инициализация, #ff = сброс в root)
		ld	bc,#ffff			; устройство (#ffff = не создавать заново, использовать текущий поток)
		ld	a,_STREAM
		jp	wcKernel

;---------------------------------------

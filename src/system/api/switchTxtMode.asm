;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #06 switchTxtMode
;---------------------------------------
; Переключиться на текстовый экран (Screen 0)
;---------------------------------------
_switchTxtMode	xor	a
		ld	(currentScreen),a

		ld	a,#01					; #01 - 1й видео буфер (16 страниц)
		call	setVideoBuffer

		ld	a,(pTxtScreen)				; переключаем разрешайку на 320x240 TXT
		call	switchGfxOn

		call	storeRam3

		ld	a,palBank
		call	setRamPage3

		ld	hl,palAddr
		call	_setPalNow

		call	reStoreRam3

		jp	restoreBorder

;---------------------------------------
; #00 - 0й текстовый                            		#10
; #01 - 1й графичекский видео буфер (16 страниц)		#20
; #02 - 2й графичекский видео буфер (16 страниц)		#30
; #03 - 3й графичекский видео буфер (16 страниц)		#40
		
setVideoBuffer	inc	a					; !!! FIX !!!
		sla 	a
		sla 	a
		sla 	a
		sla 	a
		ld	bc,tsVpage
		out	(c),a
		ret

;---------------------------------------
switchGfxOn	call	setVideoMode				; !!!! ПРЕРЫВАНИЕ !!!! НИКАКИХ ХАЛЬТОВ !!!
		jp	moveScreenUpdate			; обновляем смещения

;---------------------------------------


;---------------------------------------
setVideoMode	ld	bc,tsVConfig				; Временный fix из-за отключенных прерываний WC
		out	(c),a
		
		push	af
driversLoaded	ld	a,#00
		cp	#00
		jr	nz,slm
		pop	af
		ret

slm		pop	af

;---------------
;setLimitMouse
;---------------
		push	af					; На входе в A - параметры для граф режима (setVideoMode) 
		and	%00000011
		cp	%00000011
		jr	nz,svm_00

		pop	af

		ld	hl,319					; перерасчитанное TXT->GFX разрешение
		ld	de,239
		jr	svm

svm_00		pop	af
		and	%11000000

		cp	%00000000				; %00 - 256x192
		jr	nz,svm_01
		ld	hl,255
		ld	de,191
		jr	svm

svm_01		cp	%01000000				; %01 - 320x200
		jr	nz,svm_10
		ld	hl,319
		ld	de,199
		jr	svm

svm_10		cp	%10000000				; %10 - 320x240
		jr	nz,svm_11
		ld	hl,319
		ld	de,239
		jr	svm

svm_11		cp	%11000000				; %11 - 360x288
		ret	nz

		ld	hl,359
		ld	de,287
svm 		ld	a,mouseInit
		call	cliDrivers

		ld	hl,#0000
		ld	de,#0000
		jp	updateCursor2

;---------------------------------------
updateCursor	ld	a,getMouseX
		call	_driversApi
		ex	de,hl
		ld	a,getMouseY
		call	_driversApi

updateCursor2	ld	a,e
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

		call	storeRam0
		ld	a,#ff
		call	_setRamPage0

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

		jp	reStoreRam0
;---------------------------------------


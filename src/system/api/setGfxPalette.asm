;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #33 setGfxPalette
;---------------------------------------
; Установить палитру для графического режима
; i: HL - адрес 512-ти байтов палитры
;    B - номер графического экрана (1,2,3)
;---------------------------------------
_setGfxPalette	push	bc

		call	storeRam0
		ld	a,#ff
		call	_setRamPage0

		call	toBuff0000

		call	storeRam3
		ld	a,gPalBank1				; Включаем страницу для сохранения графической палитры
; 		call	switchMemBank
; 		call	_setVideoPage
		call	setRamPage3

		pop	bc

		call	getPalAddr

storePalette	push	de
		call	fromBuff0000
		pop	hl

		call	reStoreRam0

setPalScr	ld	c,#00
		ld	a,(currentScreen)
		cp	c
 		call	z,_setPalNow

; setAppBank	ld	a,appBank				; Включаем страницу приложений
; 		jp	switchMemBank
		jp	reStoreRam3

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
		ret
;---------------------------------------

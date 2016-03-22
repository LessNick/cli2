;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #31 getGfxPalette
;---------------------------------------
_getGfxPalette	push	hl,bc

		call	storeRam0
		ld	a,#ff
		call	_setRamPage0

		call	storeRam3

		ld	a,gPalBank1				; Включаем страницу для сохранения графической палитры
		call	setRamPage3

		pop	bc

		call	getPalAddr
		ex	hl,de
		call	toBuff0000

		call	reStoreRam3

		pop	de
		call	fromBuff0000

		jp	reStoreRam0
;---------------------------------------

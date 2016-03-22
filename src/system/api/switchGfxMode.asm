;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #07 switchGfxMode
;---------------------------------------
; Переключиться на графический экран
; i:B - номер графического экрана (1/2/3)
;   C - запретить ли загрузку палитры: #00 - нет
;				       #01 - да
;---------------------------------------
_switchGfxMode	ld	a,c
		ld	(_switchGfxEnd_3+1),a
		ld	a,b					;3 2 1
		dec	a					;2 1 0
		jp	z,_switchGfxMode1	
		dec	a					;1 0
		jp	z,_switchGfxMode2
		dec	a					;0
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
		call	setVideoBuffer

_switchGfxEnd_1	ld	a,#00
		call	switchGfxOn

_switchGfxEnd_2	ld	a,#00
		call	storeRam3
		call	setRamPage3
		pop	hl

_switchGfxEnd_3	ld	a,#00
		cp	#01
		call	nz,_setPalNow

		jp	reStoreRam3
;---------------------------------------

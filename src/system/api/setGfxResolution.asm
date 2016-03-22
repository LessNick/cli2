;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #09 setGfxResolution
;---------------------------------------
; Установить разрешение для графического экрана
; i:A' - разрешение экрана:
;	   %00 - 256x192
;          %01 - 320x200
;          %10 - 320x240
;          %11 - 360x288
;   B - номер графического экрана (1/2/3)
;---------------------------------------
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

;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #08 setGfxColorMode
;---------------------------------------
; Установить цветовой режим (zx/16c/256c) для графического экрана
; i:A' - цветовой режим:
;	   %00 - ZX
;          %01 - 16c
;          %10 - 256c
;          %11 - txt
;   B - номер графического экрана (1/2/3)
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
;---------------------------------------

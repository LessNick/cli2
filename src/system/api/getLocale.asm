;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #57 getLocale
;---------------------------------------
; получить текущую системную локаль (ASCII)
; o: H = "E" R P J
;    L = "N" U L P
;---------------------------------------
_getLocale	ld	hl,sysLocale
		ld	a,(hl)
		inc	hl
		ld	l,(hl)
		ld	h,a
		ret
;---------------------------------------

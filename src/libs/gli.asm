;---------------------------------------
; CLi² (Command Line Interface) Graphics Library
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
; GLi — Graphics Library
;---------------------------------------------
		org	#c000

sGLi		cp	#00
		jp	z,_initGli
		dec	a
		jp	z,_reInitGli
		dec	a
		jp	z,_getGliVersion

		ret
;---------------------------------------
_initGli	ret

_reInitGli	ret

_getGliVersion	ld	hl,(gliVersion)
		ret

;---------------------------------------
gliVersion	dw	#000A				; v 0.10

eGLi	nop

	SAVEBIN "install/system/gli.sys", sGLi, eGLi-sGLi

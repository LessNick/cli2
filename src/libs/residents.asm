;---------------------------------------
; CLi² (Command Line Interface)
; 2014 © breeze/fishbone crew
;---------------------------------------------
; Resident progrgams
;---------------------------------------------
		org	#c000

sRes		cp	#00
		jp	z,_initRes
		dec	a
		jp	z,_reInitRes
		dec	a
		jp	z,_getResVersion

		ret
;---------------------------------------
_initRes	
		ret

_reInitRes	
		ret

_getResVersion	ld	hl,(resVersion)
		ret

;---------------------------------------
resVersion	dw	#0001				; v 0.01

eGLi	nop

	SAVEBIN "install/system/res.sys", sRes, eRes-sRes
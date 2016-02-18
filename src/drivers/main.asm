;---------------------------------------
; CLi² (Command Line Interface) Drivers
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
		org	#c000

sCliDrivers	cp	#00
		jp	z,_initDrivers			; #00
		dec	a
		jp	z,_reInitDrivers		; #01
		dec	a
		jp	z,_getDrvVersion		; #02
;---------------------------------------
; Kempstone Mouse driver
;---------------------------------------
		dec	a
		jp	z,_mouseInit			; #03
		dec	a
		jp	z,_mouseUpdate			; #04
		dec	a
		jp	z,_getMouseX			; #05
		dec	a
		jp	z,_getMouseY			; #06
		dec	a
		jp	z,_getMouseDeltaX		; #07
		dec	a
		jp	z,_getMouseDeltaY		; #08
		dec	a
		jp	z,_getMouseRawX			; #09
		dec	a
		jp	z,_getMouseRawY			; #0A
		dec	a
		jp	z,_getMouseWheel		; #0B
		dec	a
		jp	z,_getMouseButtons		; #0C
; 		dec	a
; 		jp	z,				; #0D
; 		dec	a
; 		jp	z,				; #0E
; 		dec	a
; 		jp	z,				; #0F

		sbc	#03				; reserved (3 команды)

;---------------------------------------
; NeoGS (General Sound) driver
;---------------------------------------
		dec	a
		jp	z,_gsInit			; #10
		dec	a
		jp	z,_gsStatus			; #11
		dec	a
		jp	z,_gsDetect			; #12
		dec	a
		jp	z,_gsUpload4Bytes		; #13
		dec	a
		jp	z,_gsWaitLastByte		; #14
		dec	a
		jp	z,_gsSendCmd			; #15
		dec	a
		jp	z,_gsSendWaitCmd		; #16
		dec	a
		jp	z,_gsPlay			; #17
		dec	a
		jp	z,_gsStop			; #18
		dec	a
		jp	z,_gsCont			; #19
		dec	a
		jp	z,_gsResetFlags			; #1A
		dec	a
		jp	z,_gsWarmRestart		; #1B
		dec	a
		jp	z,_gsColdRestart		; #1C
		dec	a
		jp	z,_gsGetRAMPages		; #1D
		dec	a
		jp	z,_gsLoadModule			; #1E
		dec	a
		jp	z,_gsOpenStream			; #1F
		dec	a
		jp	z,_gsCloseStream		; #20
		dec	a
		jp	z,_gsResetTrack			; #21
		dec	a
		jp	z,_gsGetMasterVolume		; #22
		dec	a
		jp	z,_gsSetMasterVolume		; #23
		dec	a
		jp	z,_gsGetFXMasterVolume		; #24
		dec	a
		jp	z,_gsSetFXMasterVolume		; #25
;---------------------------------------
		ret

_initDrivers	ret

_reInitDrivers	ret

_getDrvVersion	ld	hl,(drvVersion)
		ret

		include	"mouse.asm"
		include	"neogs.asm"

drvVersion	dw	#0002				; v 0.02

eCliDrivers	nop

	SAVEBIN "install/system/drivers.sys", sCliDrivers, eCliDrivers-sCliDrivers
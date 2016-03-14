;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
; NeoGS (General Sound) driver
;---------------------------------------
cReset		equ	#80			; команда reset
cGetRAMPages	equ	#23			; Получить число страниц в GS. (В базовой версии 3 страницы)

pReset		equ	#33			; порт resrt
pDataInReg	equ	#b3			; порт регистра вывода (GS->Data)
pDataOutReg 	equ	#b3			; порт регистра данных (Data->GS)

pCmdReg		equ	#bb			; порт регистр команд для GS
pStatusReg	equ	#bb			; порт регистра состояния. Биты:
						;  7й — Data bit, флаг данных
						;  6,5,4,3,2,1й — Не используются
						;  0й — Command bit, флаг команд 

tReset		equ	1000			; подбор
						; время ожидания инициализации карты после reset (1/48.888) секунды
						; 32/48.888 = ~0.654 секунды
						
;---------------------------------------
_gsUpload4Bytes	ld	c,pStatusReg

		call	_gsUploadLoop
		call	_gsUploadLoop
		call	_gsUploadLoop
		
_gsUploadLoop	in	b,(c)
		jp	p,_gsUploadReady
		
		in	b,(c)
		jp	m,_gsUploadLoop

_gsUploadReady	ld	a,(hl)
		out	(pDataOutReg),a
		inc	hl
		ret

;---------------------------------------
_gsWaitLastByte	ld	c,pStatusReg
_gsWaitLastLoop	in	b,(c)
		jp	m,_gsWaitLastLoop
		ret

;---------------------------------------
_gsInit		ld	a,cReset
		out	(pReset),a
		ld	bc,tReset
_gsInit_0	push	bc
		ld	b,255
		djnz	$
		pop	bc
		dec	bc
		ld	a,b
		or	c
		ret	z
		jr	_gsInit_0

;---------------------------------------
_gsDetect	in	a,(pDataInReg)
		ld	b,#00
		ld	c,a
stab		in	a,(pDataInReg)
		cp	c
		jr	nz,wse
		djnz	stab

		ld	a,cGetRAMPages
		out	(pCmdReg),a
		ld	bc,#0f00
dik		dec	bc
		ld	a,b
		or	c
		jr	z,wse
		in	a,(pStatusReg)		
		rrca
		jr	c,dik
		in	a,(pDataInReg)
		cp	#03
		jr	c,wse

		ld	a,#01
		out	(pDataOutReg),a
		ld	a,#6a
		call	_gsSendWaitCmd

		xor	a
		out	(pDataOutReg),a
		ld	a,#6b
		call	_gsSendWaitCmd
		
		xor	a
wze		ld	(gsStatusData),a
		push	af
		ld	a,#f3
		call	_gsSendCmd

		pop	af
		ret

wse		ld	a,#01
		or	a
		jr	wze

;---------------------------------------
_gsSendCmd	out	(pCmdReg),a
		ret

_gsSendWaitCmd	out	(pCmdReg),a
gswc		in	a,(pStatusReg)
		rrca
		jr	c,gswc
		ret
;-------
gwc		in	a,(pStatusReg)
		rrca
		ret

;-------
getdat		in	a,(pStatusReg)
		rlca
		jr	nc,getdat
		in	a,(pDataInReg)
		ret
;-------
_gsPlay		ld	a,#31
		jr	_gsSendCmd

;-------
_gsStop		ld	a,#32
		jr	_gsSendCmd

;-------
_gsCont		ld	a,#33
		jr	_gsSendCmd

;-------
_gsStatus	ld	a,(gsStatusData)
		ret

;-------
_gsResetFlags	xor	a
		jp	_gsSendWaitCmd

;-------
_gsWarmRestart	ld	a,#f3
		jp	_gsSendWaitCmd

;-------
_gsColdRestart	ld	a,#f4
		jp	_gsSendWaitCmd

;-------
_gsGetRAMPages	ld	a,#23
		jp	_gsSendWaitCmd

;-------
_gsLoadModule	ld	a,#30
		jp	_gsSendWaitCmd

;-------
_gsOpenStream	ld	a,#d1
		jp	_gsSendWaitCmd
		
;-------
_gsCloseStream	ld	a,#d2
		jp	_gsSendWaitCmd

;-------
_gsResetTrack	in	a,(pDataInReg)
		out	(pDataOutReg),a
		ret
;-------
_gsGetMasterVolume
		ret

_gsSetMasterVolume
		ld	a,b
		out	(pDataOutReg),a
		ld	a,#2a
		jp	_gsSendCmd			; bb

_gsGetFXMasterVolume
		ret

_gsSetFXMasterVolume
		ld	a,b
		out	(pDataOutReg),a
		ld	a,#2b
		jp	_gsSendCmd
;-------

gsStatusData	db	#FF

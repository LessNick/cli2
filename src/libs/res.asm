;---------------------------------------
; CLi² (Command Line Interface)
; 2014,2016 © breeze/fishbone crew
;---------------------------------------------
; Resident programms
;---------------------------------------------
		org	#c000

resSize		equ	16					; доступное количество резидентов

sRes		cp	#00
		jp	z,_initResidents			; #00
		dec	a
		jp	z,_reInitResidents			; #01
		dec	a
		jp	z,_getVerResidents			; #02
		
		dec	a
		jp	z,_getResidents				; #03

		dec	a
		jp	z,_loadResident				; #04
		dec	a
		jp	z,_deleteResident			; #05
		
		dec	a
		jp	z,_callResidentMain			; #06
		dec	a
		jp	z,_sentToResident			; #07
		dec	a
		jp	z,_getFromResident			; #08

		dec	a
		jp	z,_sleepAllResidents			; #09
		dec	a
		jp	z,_wakeupAllResidents			; #0A

resNop		ret

;---------------------------------------
_initResidents	ld	hl,resIntAddrList
		ld	a,#cd					; call
		ld	de,resNop				; выход без операции

		ld	b,resSize
_initResLoop0	ld	(hl),a
		inc	hl
		ld	(hl),e
		inc	hl
		ld	(hl),d
		inc	hl
		djnz	_initResLoop0
		ld	a,201
		ld	(hl),a

		ld	de,resNamesList
		ld	b,resSize
_initResLoop1	push	bc
		ld	hl,resEmpty
		push	hl
		ld	bc,8
		ldir
		pop	hl
		pop	bc
		djnz	_initResLoop1

		ld	a,enableRes
		jp	cliKernel

;---------------
_reInitResidents	
		ret

;---------------
_getResidents
		ret

;---------------
_loadResident	call	_disableRes
		ld	a,(hl)
		cp	#00
		jr	nz,_loadResident00
		call	_printErrParams
		jr	_loadResidentExit

_loadResident00	ex	de,hl
		call	_eatSpaces
		ex	de,hl

		push	hl
		ld	a,flagFile			; file
		call	_prepareEntry
			
		call	_eSearch
		pop	hl
		jr	nz,_loadResident01
		
		call	_printFileNotFound
		jr	_loadResidentExit
		
_loadResident01	call	_storeFileLen

		call	_setFileBegin
		call	_prepareSize
		ld	a,b
		cp	#00
		jp	z,_loadResident02
		call	_printFileTooBig
		jr	_loadResidentExit

_loadResident02	ld	b,c
		ld	hl,resStarAddr
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a
		push	hl
		call	_load512bytes
		pop	hl

;---------------
		ld	a,(hl)
		cp	#7f					; Сигнатура #7f + RES
		jp	nz,wrongFile
		
		inc	hl
		ld	a,(hl)
		cp	"R"
		jp	nz,wrongFile

		inc	hl
		ld	a,(hl)
		cp	"E"
		jp	nz,wrongFile

		inc	hl
		ld	a,(hl)
		cp	"S"
		jp	nz,wrongFile


		xor	a
		
_loadResidentExit
		jp	_enableRes

;---------------
wrongFile	ld	a,#ff
		jr	_loadResidentExit
;---------------
_deleteResident
		ret

;---------------

_callResidentMain
		; TODO: Сделать нормальный вызов!!

		jp	resIntAddrList

;---------------		
_sentToResident
		ret

;---------------
_getFromResident
		ret

;---------------
_getVerResidents
		ld	hl,(resVersion)
		ret

;---------------
_sleepAllResidents
		ret

;---------------
_wakeupAllResidents
		ret

;---------------------------------------
resVersion	dw	#0001					; v 0.01
			;01234567
resEmpty	db	"Empty   "
resStarAddr	dw	resApp					; следующий свободный адрес для резидента

;---------------
eRes	nop



resIntAddrList	ds	resSize*3,#00				; список адресов резидентов + #cd
		ret

resNamesList	ds	resSize*8,#00				; список названий резидентов
		ret
		
resApp		nop						; начала загрузки резидентов

	SAVEBIN "install/system/res.sys", sRes, eRes-sRes
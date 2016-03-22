;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; run - run application
;---------------------------------------
_run		ld	(appParams+1),hl	
		ex	de,hl
		ld	a,(hl)
		cp	#00
		jp	z,_printErrParams

		call	_storeHomePath
		call	checkIsPath
		
		ex	af,af'
		cp	#00
		call	z,exeApp

		jp	_initCallBack			; Вернуть (восстановить) адрес callBack на Ret
; 		call	_restoreWcBank
; 		ret
;---------------
exeApp		push	hl
		ld	a,flagFile			; file
		call	prepareEntry
			
		call	eSearch
		pop	hl
		jp	z,_printFileNotFound
		call	storeFileLen

		call	setFileBegin
		call	prepareSize
		ld	a,b
		cp	#00
		jp	nz,_printFileTooBig
		ld	b,c
;---------------
loadApp		ld	a,appBank
; 		call	switchMemBank+3
; 		call	storeMemBank
		call	setRamPage3
		
		ld	hl,appAddr-4
		push	hl
		call	load512bytes

		pop	hl

		ld	a,(hl)
		cp	127
		jr	nz,wrongApp
		inc	hl

		ld	a,(hl)
		cp	"C"
		jr	nz,wrongApp
		inc	hl

		ld	a,(hl)
		cp	"L"
		jr	nz,wrongApp
		inc	hl

		ld	a,(hl)
		cp	"A"
		jr	nz,wrongApp

appParams	ld	hl,#0000
		call	_restoreHomePath
		jp	appAddr
		
wrongApp	ld	a,#ff				; не верный формат приложения - выход
		ret

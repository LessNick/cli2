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
; 		call	_storePath
		
		call	_checkIsPath
		
		ex	af,af'
		cp	#00
		call	z,exeApp

		call	_initCallBack			; Вернуть (восстановить) адрес callBack на Ret
		call	_restoreWcBank
		ret
;---------------
exeApp		push	hl
		ld	a,flagFile			; file
		call	_prepareEntry
			
		call	_eSearch
		pop	hl
		jp	z,_printFileNotFound
		call	_storeFileLen

		call	_setFileBegin
		call	_prepareSize
		ld	a,b
		cp	#00
		jp	nz,_printFileTooBig
		ld	b,c
;---------------
loadApp		ld	a,appBank
; 		call	switchMemBank
		call	switchMemBank+3
		call	storeMemBank

; 		ld	a,disableRes
; 		call	resApi
		
		ld	hl,appAddr-4
		push	hl
		call	_load512bytes

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
; 		push	hl
		call	_restoreHomePath
; 		call	_restorePath
; 		call	_pathWorkDir
; 		pop	hl
		jp	appAddr
		
wrongApp	ld	a,#ff				; не верный формат приложения - выход
		ret

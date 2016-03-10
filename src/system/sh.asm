;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
; sh command
;---------------------------------------
_sh		ex	de,hl					; hl params
		ld	a,(hl)
		cp	#00
		jp	z,_printErrParams			; exit: error params
		call	shClear

		push	hl
 		call	storeShPath

		ld	de,scriptAddr
		ld	a,#01					; загрузка без восстановления пути
		ex	af,af'
		call	_loadFile

		pop	hl
		cp	#ff
 		jr	z,shExitErr
;---------------
		ld	hl,scriptAddr

shExt_Loop	ld	de,iBuffer
		push	hl,de
		ld	hl,iBuffer
 		inc	de
 		ld	bc,iBufferSize-1
 		xor	a
 		ld	(hl),a
  		ldir
  		pop	de,hl

		ld	bc,#0000
shStr_Loop	ld	a,(hl)
		cp	#00					; end file ?
		jr	z,shExt_00
		cp	#0d					; end string?
		jr	z,shExt_00a
		ld	(de),a
		inc	hl
		inc	de
		inc	bc
		jr	shStr_Loop

shExt_00	ld	a,b
		or	c
		jr	z,shExitOk
		jr	shExt_01a

shExt_00a	inc	hl
		ld	a,(hl)
		cp	#0a
		jr	nz,shExt_01
		inc	hl

shExt_01	ld	a,b
		or	c
		jr	z,shExt_Loop				; пропустить пустую строку

shExt_01a	xor	a					; сброс флагов
		ld	de,iBuffer
		
		ld	a,(de)
		cp	#00
		jr	z,shExitOk

shExt_02	push	hl
		
		ld	de,iBuffer
		call	_parseLine

		cp	#ff					; комманда не распознана
		call	z,_printUnknownCmd

		ld	a,scriptBank
		call	switchMemBank

		pop	hl
		jr	shExt_Loop
;--------------
shExitErr	call	_printFileNotFound			; выводим сообщение, что файл скрипта не найден!
shExitOk	call	restoreShPath

shClear		push	hl
		ld	a,scriptBank
		call	switchMemBank
		
		ld	hl,scriptAddr
		ld	de,scriptAddr+1
		ld	bc,#3fff
		xor	a
		ld	(hl),a
		ldir
		pop	hl
		
		xor	a					; не сообщаем ни о каких ошибках!
		ret

;---------------
storeShPath	push	hl,de,bc,af
		ld	hl,pathShString
		ld	de,pathShString+1
		ld	bc,pathStrSize-1
		xor	a
		ld	(hl),a
		ldir

		ld	de,pathShString
		ld	hl,pathString
storeShLoop	ld	a,(hl)
		cp	#00
		jr	z,storeShExit
		cp	#0d
		jr	z,storeShExit
		ld	(de),a
		inc	hl
		inc	de
		jr	storeShLoop

storeShExit	pop	af,bc,de,hl
		ret

;---------------
restoreShPath	ex	af,af'
		push	af
		ld	de,pathShString
		call	_changeDir
		pop	af
		ex	af,af'
		ret
;---------------

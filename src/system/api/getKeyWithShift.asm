;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #51 getKeyWithShift
;---------------------------------------
getKeyWithShiftT
		call	ps2GetScanCodeT			; Получить сканкод, но не удалять!
		jr	gkws

;---------------------------------------
; Получить ASCII код нажатой клавиши:
; o: A - ASCII код нажатой клавиши (включая спецклавиши из constants.asm)
;---------------------------------------
_getKeyWithShift
		call	_ps2GetScanCode			; Получить сканкод
		
gkws		cp	#ff				; Выход если ничего не нажато
		jp	z,returnEmptyAscii

		ld	a,l
		cp	#00				; Выход если пусто
		jr	z,returnEmptyAscii		

		cp	#f0				; Если #f0 — клавишу отпустили = выход
		jp	z,getAsciiCode_02

		cp	#e0				; Если не #e0 значит обычная клавиша 
		jr	nz,getAsciiCode

		ld	l,h				; иначе расширенный код
		ld	h,#00
		
		ld	a,l
		cp	#f0
		jp	z,getAsciiCode_02

		cp	#4a
		jr	nz,gkE0_00
		
		ld	a,"/"
		or	a				; данные получены
		ret

gkE0_00		cp	#68
		jr	c,returnEmptyAscii
		ld	de,keyMap_E0-#68
		push	af
		
		call	storeRam3

		ld	a,keymapBank
		call	setRamPage3
		pop	af
		jr	getAsciiCode_0C

;---------------
getAsciiCode	push	af
		
		call	storeRam3

		ld	a,keymapBank
		call	setRamPage3
		pop	af
		push	hl

		ld	a,(keyLayoutSwitch)		; Проверить активную раскладку
		cp	#00				; 0 - EN, 1 - RU
		jr	z,gAC_EN

gAC_RU		ld	a,(checkShiftKey)
		cp	#00
		jr	z,getAsciiCode_0B
		call	_checkKeyShift			; Проверить нажат ли shift
		jr	z,getAsciiCode_0B		; Если нет, то таблица keyMap_1A
		
		ld	de,keyMap_1B			; в противном случае keyMap_1B
		jr	getAsciiCode_0A+3

getAsciiCode_0B	ld	de,keyMap_1A
		jr	getAsciiCode_0A+3

gAC_EN		ld	a,(checkShiftKey)
		cp	#00
		jr	z,getAsciiCode_0A
		call	_checkKeyShift			; Проверить нажат ли shift
		jr	z,getAsciiCode_0A		; Если нет, то таблица keyMap_0A
		
		ld	de,keyMap_0B			; в противном случае keyMap_0B
		jr	getAsciiCode_0A+3

getAsciiCode_0A	ld	de,keyMap_0A
		
		pop	hl

getAsciiCode_0C	add	hl,de
		ld	a,(hl)

		push	af
		cp	#00
		jr	z,getAsciiCode_01
		pop	af
		or	a					; NZ - данные получены
		jr	getAsciiExit

getAsciiCode_01	pop	af
getAsciiCode_02	
returnEmptyAscii
		xor	a					; Z - данных нет - выход
		or	a
		
getAsciiExit	push	af
		call	reStoreRam3

		pop	af
		ret
;---------------------------------------

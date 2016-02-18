;---------------------------------------------
; PS/2 Keyboard driver
;---------------------------------------------
_ps2Init	call	_ps2SelectNvram
		xor	a
		ld	(ps2Status),a
_ps2Init_00	ld	(ps2RepeatMode),a
		ld	a,(ps2RepeatDefaut)
		add	a,a
		ld	(ps2RepeatCounter),a

		jp	_ps2ResetAll

;---------------------------------------

_ps2SelectNvram	ld	a,#f0					; отсылаем #02 -> #f0 (включить режим чтение ps/2)
		ld	bc,peNvRamLocation
		out	(c),a
		ld	a,#02
		ld	bc,peNvRamData
		out	(c),a
		ret
		
;---------------------------------------
_ps2PrepareScanCode
		call	ps2SetKeyStatus
		ld	a,(ps2Status)				; Вызывается каждое прерывание
		
		cp	#04					; Данные подготовлены и ожидают, что их заберут
		ret	z

		cp	#00					; Если статус ≠ #00, то продолжаем обработку
		jr	nz,ps2Status01

;---------------
ps2Status00	ld	a,(ps2RepeatMode)
		cp	#01
		jp	z,checkRepeatMode			; Если включен режим автоповтора, то проверяем статус готовности

;---------------
		call	ps2ReadOneCode				; Читаем 0й скан код
		cp	#00
		jr	nz,ps2Status00B				

ps2Status00A	ld	a,(ps2RepeatMode)			; Если скан код = #00, то проверяем режим автоповтора
		cp	#01
		jr	z,ps2Status00H

		ret
			
ps2Status00B	ld	(ps2ScanCode),a
		
		cp	#f0					; Если скан код #f0 (клавишу отпустили), отключить режим автоповтора
		jr	z,ps2Status00D

		cp	#e0					; Если скан код = #e0, установить статус #01 и выйти
		jr	nz,ps2Status00E

ps2Status00C	ld	a,#01
		ld	(ps2Status),a
		ret

ps2Status00D	call	ps2RepeatDisable
		jr	ps2Status00C

ps2Status00E	xor	a					; В противном случае выставить последующие коды 1,2,3 как #00
		ld	(ps2ScanCode+1),a

ps2Status00F	xor	a
		ld	(ps2ScanCode+2),a

ps2Status00G	xor	a
		ld	(ps2ScanCode+3),a

ps2Status00H	call	ps2RepeatEnable				; Включить режим автоповтора
		
ps2Status00I	ld	a,#04					; Установить статус данные готовы — можно забирать
		ld	(ps2Status),a

		ret
;---------------
ps2Status01	cp	#01					; Если статус ≠ #01, то продолжаем обработку
		jr	nz,ps2Status02

		call	ps2ReadOneCode				; Читаем 1й скан код
		cp	#00					; Данные не готовы — выход
		ret	z

		ld	(ps2ScanCode+1),a

		cp	#f0
		jr	nz,ps2Status01A		

		call	ps2RepeatDisable

		ld	a,#02
		ld	(ps2Status),a

		ret

ps2Status01A	ld	a,(ps2ScanCode)
		cp	#f0
		jr	nz,ps2Status00F

		xor	a
		ld	(ps2ScanCode+2),a
		ld	(ps2ScanCode+3),a

		jr	ps2Status00I

;---------------
ps2Status02	cp	#02					; Если статус ≠ #02, то заканчиваем обработку
		ret	nz					; в противном случае — выход

		call	ps2ReadOneCode				; Читаем 2й скан код
		cp	#00					; Данные не готовы — выход
		ret	z

		ld	(ps2ScanCode+2),a

		ld	a,(ps2ScanCode+1)
		cp	#f0
		jr	nz,ps2Status00G

		xor	a
		ld	(ps2ScanCode+3),a

		jr	ps2Status00I
;---------------
checkRepeatMode	call	ps2ReadOneCode
		cp	#00					; Если новый код ≠ #00, то останавливаем повтор
		jp	nz,ps2Status00B

		ld	a,(ps2RepeatCounter)
		cp	#00					; Если задержка повтора нажатой клавиши = #00 выставляем режим #04
		jr	nz,decRepeatMode

		ld	a,(ps2RepeatDefaut)
		ld	(ps2RepeatCounter),a

		jr	ps2Status00I


decRepeatMode	dec	a
		ld	(ps2RepeatCounter),a
		ret

;---------------
ps2ReadOneCode	ld	a,#f0
 		jp	_nvRamGetData+1				; читаем скан-код

;---------------
ps2RepeatEnable	ld	a,#01
		jp	_ps2Init_00

ps2RepeatDisable push	af
		xor	a
		call	_ps2Init_00
		pop	af
		ret

;---------------
_ps2GetScanCodeT						; Забрать данные, но не снимать флаг!
		ld	a,(ps2Status)
		cp	#04
		jr	nz,_ps2NoScanCode
		jr	_ps2YepScanCode

_ps2GetScanCode	ld	a,(ps2Status)
		cp	#04
		jr	z,scanCodeReady				; Если #04, данные готовы — можно забирать
_ps2NoScanCode	ld	hl,#0000
		ld	de,#0000
		ld	a,#ff					; A=#FF Ошибка.Данные не готовы
		ret

scanCodeReady	xor	a
 		ld	(ps2Status),a				; данные забраны, можно подготовить следующие

_ps2YepScanCode	ld	hl,(ps2ScanCode)
 		ld	de,(ps2ScanCode+2)
 		ret

;---------------	
_ps2ResetKeyboard
		ld	a,#0c
		call	_nvRamGetData
		and	%00000010				; 1-й бит сохраняем статус Caps Lock
		or	%00000001				; 0-й бит cброс буфера клавиатуры
_ps2ResKbd	ex	af,af'
		ld	a,#0c
		call	_nvRamSetData
		ret

_ps2ResetAll	ld	a,%00000001				; 0-й бит cброс буфера клавиатуры
		jr	_ps2ResKbd
;---------------
ps2SetKeyStatus	ld	hl,(ps2ScanCode)				
 		ld	de,(ps2ScanCode+2)
 		ld	a,h					; скан код пустой — выход
 		or	l
 		ret	z

 		ld	a,l
 		cp	#e0
 		jr	nz,setKeyStatus00

 		ld	l,h
 		ld	h,e

 		ld	de,keyStatusE0
 		jr	setKeyStatus01

setKeyStatus00	ld	de,keyStatus
setKeyStatus01	ld	a,l					; скан код (#11 - alt)
		cp	#f0					; если #f0 значит отпустили
		jr	nz,setKeyStatus03
		ld	l,h
		ld	h,#00
		xor	a
		jr	setKeyStatus04

setKeyStatus03	ld	a,#01
setKeyStatus04	add	hl,de
 		ld	(hl),a

		ret
;---------------

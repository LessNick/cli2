;---------------------------------------------
; PS/2 Keyboard driver
;---------------------------------------------



		
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


;---------------	



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

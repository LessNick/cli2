;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #50 ps2GetScanCode
;---------------------------------------
; Получить Raw ScanCode согласно таблице сканкодов
; o: HL,DE — четыре скан кода
;    A - флаг статуса:
;	#ff - данные не готовы (при этом HL,DE = #00 00 00 00)

;---------------------------------------
_ps2GetScanCode	ld	a,(ps2Status)
		cp	#04
		jr	z,scanCodeReady				; Если #04, данные готовы — можно забирать

noScanCode	ld	hl,#0000
		ld	de,#0000
		ld	a,#ff					; A=#FF Ошибка.Данные не готовы
		ret

scanCodeReady	xor	a
 		ld	(ps2Status),a				; данные забраны, можно подготовить следующие

readScanCode	ld	hl,(ps2ScanCode)
 		ld	de,(ps2ScanCode+2)
 		ret

;---------------
ps2GetScanCodeT	ld	a,(ps2Status)				; Забрать данные, но не снимать флаг!
		cp	#04
		jr	nz,noScanCode
		jr	readScanCode
;---------------------------------------

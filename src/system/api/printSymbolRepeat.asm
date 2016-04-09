;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #3D printSymbolRepeat
;---------------------------------------
; Вывести один символ до тех пор пока позиция X не будет равна заданному числу
; i: A' - код символа ASCII
;    C  - позиция X до которой повторять символ
;---------------------------------------
_printSymbolRepeat
		ex	af,af'
		dec	c
psrLoop		push	af
		call	printChar

		ld	a,(printX)
		cp	c
		jr	nc,psrExit
		inc	a
		cp	80					; Конец буфера256
		jr	z,psrExit
		ld	(printX),a

		ld	a,(strLen)
		inc	a
		ld	(strLen),a
		pop	af
		jr	psrLoop

psrExit		pop	af
		ret

;---------------------------------------

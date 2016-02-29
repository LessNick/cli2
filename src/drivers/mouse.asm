;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; Kempstone Mouse driver
;---------------------------------------
mBPort		equ	#fadf			; D0: левая кнопка (0=нажата)
						; D1: правая кнопка (0=нажата)
						; D2: средняя кнопка (0=нажата)
						; D3: зарезервировано под ещё одну кнопку (0=нажата)
						; D4-D7: координата колёсика
mXPort		equ	#fbdf			; X-координата (растёт слева направо)
mYPort		equ	#ffdf			; Y-координата (растёт снизу вверх)
;---------------------------------------
_mouseInit	ld	(mouseIsRight+1),hl
		ld	(mouseIsDown+1),de
		ld	hl,mouseRawDataX
		ld	de,mouseRawDataX+1
		ld	bc,mouse_B-mouseRawDataX
		xor	a
		ld	(hl),a
		ldir
		ret
;---------------------------------------
_mouseUpdate	call	mouseButtons
		call	mouseDriver
		ret
;---------------------------------------
_getMouseX	ld	hl,(mouse_X)
		ret
;---------------------------------------
_getMouseY	ld	hl,(mouse_Y)
		ret
;---------------------------------------
_getMouseW	ld	hl,(mouse_W)
		ret
;---------------------------------------
_getMouseDeltaX	ld	hl,(mouseDeltaX)
		ret
;---------------------------------------
_getMouseDeltaY	ld	hl,(mouseDeltaY)
		ret
;---------------------------------------
_getMouseDeltaW	ld	hl,(mouseDeltaW)
		ret
;---------------------------------------
_getMouseRawX	ld	hl,(mouseRawDataX)
		ld	h,#00
		ret
;---------------------------------------
_getMouseRawY	ld	hl,(mouseRawDataX)
		ld	l,h
		ld	h,#00
		ret
;---------------------------------------
_getMouseRawW	ld	hl,(mouseRawDataW)
		ld	h,#00
		ret	
;---------------------------------------
_getMouseButtons
		ld	a,(mouse_B)
		ret
;---------------------------------------
_resetMouseWheel
		ld	hl,#0000
		jp	mouseWStore

;---------------------------------------
mouseButtons	ld	bc,mBPort		; порт кнопок
		in	a,(c)			; читаем значение		
		cpl				; инвертируем значение
		
		push	af
		and	%11110000
		ld	(mouseNewW+1),a
		pop	af

		and	%00001111
		ld	(mouse_B),a
		
		ret

		ds	1000,0
;---------------------------------------
mouseDriver	ld	de,(mouseRawDataX)	; последние координаты 8bit (в e=X, d=Y)

mouseGetX	ld	h,#00			; изначально положительное значение

		ld	bc,mXPort		; порт координат X
		in	a,(c)			; читаем значение
		ld	(mouseRawDataX),a	; cохраняем Raw значение из порта X
		
		sub	e			; вычитаем последний сохранёный Raw X
		jr	z,mouseGetY		; если 0, перемещения не было переходим к получению данных Y	
		jp	p,mouseGetXPlus		; если положительное значение сохраняем дельту X
		ld	h,#ff			; в противном случает изменяем знак с + на -

mouseGetXPlus	ld	l,a
		ld	(mouseDeltaX),hl
		ld	bc,(mouse_X)		; предыдущие координаты X 16bit
;---------------
; Thx 4 psndcj
;  bc - coords
;  hl - delta
		ld	a,h
		add	hl,bc
		rla
		jr	c,mouseIsLeft

mouseIsRight	ld	bc,360
		and	a
		sbc	hl,bc
		jr	c,$+2+3
		ld	hl,0
		add	hl,bc
		jr	mouseXStore

mouseIsLeft	bit	7,h
		jr	z,$+2+3
		ld	hl,0
;---------------
mouseXStore	ld	(mouse_X),hl		; сохраняем новые значения

;---------------
mouseGetY	ld	h,#00			; изначально положительное значение

		ld	bc,mYPort		; порт координат Y
		in	a,(c)			; читаем значение
		ld	(mouseRawDataY),a	; cохраняем Raw значение из порта Y
		
		sub	d			; вычитаем последний сохранёный Raw Y
		jr	z,mouseGetW		; если 0, перемещения не было переходим к получению данных Wheel	

		neg				; меняем положение Y Up<->Down

		jp	p,mouseGetYPlus		; если положительное значение сохраняем дельту Y
		ld	h,#ff			; в противном случает изменяем знак с + на -

mouseGetYPlus	ld	l,a
		ld	(mouseDeltaY),hl
		ld	bc,(mouse_Y)		; предыдущие координаты Y 16bit
;---------------
; Thx 4 psndcj
;  bc - coords
;  hl - delta
		ld	a,h
		add	hl,bc
		rla
		jr	c,mouseIsUp

mouseIsDown	ld	bc,288
		and	a
		sbc	hl,bc
		jr	c,$+2+3
		ld	hl,0
		add	hl,bc
		jr	mouseYStore

mouseIsUp	bit	7,h
		jr	z,$+2+3
		ld	hl,0
;---------------
mouseYStore	ld	(mouse_Y),hl		; сохраняем новые значения





;---------------
mouseGetW	ld	de,(mouseRawDataW)	; последнее положение 8bit (в e=W, d=0)

		ld	h,#00			; знак: изначально положительное значение

mouseNewW	ld	a,#00			
		ld	(mouseRawDataW),a	; cохраняем Raw значение Wheel
		
		cp	e
		ret	z			; a==e? перемещения не было - выход

		sub	e			; вычитаем последний сохранёный Raw W

		jp	m,mouseGetWMinus
 		jp	nc,mouseGetWPlus

		jp	p,mouseGetWPlus		; если положительное значение сохраняем дельту W

mouseGetWMinus	ld	h,#ff			; в противном случает изменяем знак с + на -

mouseGetWPlus	ld	l,a
		ld	(mouseDeltaW),hl
		ld	bc,(mouse_W)		; предыдущее значение W 16bit

;---------------
; Thx 4 psndcj
;  bc - coords
;  hl - delta
		ld	a,h
		add	hl,bc
		rla
		jr	c,wheelIsUp

wheelIsDown	ld	bc,288*16		; 288
		and	a
		sbc	hl,bc
		jr	c,$+2+3
		ld	hl,0
		add	hl,bc
		jr	mouseWStore

wheelIsUp	bit	7,h
		jr	z,$+2+3
		ld	hl,0
;---------------
mouseWStore	ld	(mouse_W),hl		; сохраняем новые значения
		ret
;---------------------------------------

mouseRawDataX	db	#00			; cохранённое Raw значение из порта X
mouseRawDataY	db	#00			; cохранённое Raw значение из порта Y
mouseRawDataW	db	#00			; cохранённое Raw значение колёсика
		db	#00

mouseDeltaX	dw	#0000			; дельта смещения X ±127 (16bit)
mouseDeltaY	dw	#0000			; дельта смещения Y ±127 (16bit)
mouseDeltaW	dw	#0000			; дельта смещения Whell ±7 (16bit)

mouse_X		dw	#0000			; текущая координата X
mouse_Y		dw	#0000			; текущая координата Y
mouse_W		dw	#0000			; текущая значение W

mouse_B		db	#00			; текущее состяние кнопок

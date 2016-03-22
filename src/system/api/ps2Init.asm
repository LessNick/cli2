;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #4E ps2Init
;---------------------------------------
; Инициализация драйвера клавиатуры
;---------------------------------------
_ps2Init	call	ps2SelectNvram
		xor	a
		ld	(ps2Status),a
_ps2Init_00	ld	(ps2RepeatMode),a
		ld	a,(ps2RepeatDefaut)
		add	a,a
		ld	(ps2RepeatCounter),a

		ld	a,%00000001				; 0-й бит cброс буфера клавиатуры
		jr	_ps2ResKbd

;---------------------------------------
ps2SelectNvram	ld	a,#f0					; отсылаем #02 -> #f0 (включить режим чтение ps/2)
		ld	bc,peNvRamLocation
		out	(c),a
		ld	a,#02
		ld	bc,peNvRamData
		out	(c),a
		ret
;---------------------------------------

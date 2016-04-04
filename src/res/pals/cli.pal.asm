;---------------------------------------
; CLi² (Command Line Interface) text mode palette
; 2013,2016 © breeze/fishbone crew
;---------------------------------------

		MODULE	cli_pal

		org	#C000
sPal
		db	#7f,"PAL"				; #7f+"PAL" - 4 байта сигнатура, что это формат файла PAL

		db	#01					; 1 байт версия формата
		db	#00					; 1 байт тип упаковки данных:
								;		#00 - данные не пакованы

		dw	ePal-bPal				; 2 байта размер палитры
		dw	bPal-taPal				; 2 байта смещение от текущего адреса до начала данных палитры

taPal								; Зарезервировано для дальнейшего разширения

		include "default.asm"

		SAVEBIN "install/system/res/pals/default.pal", sPal, ePal-sPal

		ENDMODULE

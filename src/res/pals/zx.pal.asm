;---------------------------------------
; CLi² (Command Line Interface) text mode palette
; 2013,2016 © breeze/fishbone crew
;---------------------------------------

		MODULE	zx_pal

		org	#C000
sPal
		db	#7f,"PAL"				; #7f+"PAL" - 4 байта сигнатура, что это формат файла PAL

		db	#01					; 1 байт версия формата
		db	#00					; 1 байт тип упаковки данных:
								;		#00 - данные не пакованы

		dw	ePal-bPal				; 2 байта размер палитры
		dw	bPal-taPal				; 2 байта смещение от текущего адреса до начала данных палитры

taPal								; Зарезервировано для дальнейшего разширения
		
bPal		dw	#0000,#0010,#4000,#4010
		dw	#0200,#0210,#4200,#4210
		dw	#0000,#0018,#6000,#6018
		dw	#0300,#0318,#6300,#6318
ePal

		SAVEBIN "install/system/res/pals/zx.pal", sPal, ePal-sPal

		ENDMODULE

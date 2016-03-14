;---------------------------------------
; CLi² (Command Line Interface) text mode palette
; 2013,2015 © breeze/fishbone crew
;---------------------------------------

		org	#C000
sPal1
		db	#7f,"PAL"				; #7f+"PAL" - 4 байта сигнатура, что это формат файла PAL

		db	#01					; 1 байт версия формата
		db	#00					; 1 байт тип упаковки данных:
								;		#00 - данные не пакованы

		dw	ePal1-bPal1				; 2 байта размер палитры
		dw	bPal1-taPal1				; 2 байта смещение от текущего адреса до начала данных палитры

taPal1								; Зарезервировано для дальнейшего разширения

		;         rR   gG   bB
		;         RRrrrGGgggBBbbb
bPal1		dw	%0000000000000000		; 0.black
		dw	%0000000000010000		; 1.navy 
		dw	%0110000100010000		; 2.amiga pink
		dw	%0110001000011000		; 3.light violet
		dw	%0000001000000000		; 4.green
		dw	%0000000100010000		; 5.dark teal
		dw	%0110000100000000		; 6.orange
		dw	%0110001000010000		; 7.light beige
		;         rR   gG   bB
		;         RRrrrGGgggBBbbb
		dw	%0100001000010000		; 8.silver
		dw	%0000000000011000		; 9.blue
		dw	%0110000000000000		;10.red			A
		dw	%0110000100001000		;11.dark pink		B
		dw	%0000001100000000		;12.lime		C
		dw	%0000001000011000		;13.teal		D
		dw	%0110001100010000		;14.light yellow	E
		dw	%0110001100011000		;15.white		F
ePal1

	SAVEBIN "install/system/res/pals/default.pal", sPal1, ePal1-sPal1

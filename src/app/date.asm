;---------------------------------------
; CLi² (Command Line Interface)
; 2016 © breeze/fishbone crew
;---------------------------------------
; Date & Time
;---------------------------------------
		org	#c000-4

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API

appStart	
		db	#7f,"CLA"				; Command Line Application

		ld	a,getCurrentDate
		call	cliKernel

		push	hl
		push	de
		ld	a,c
		ex	af,af'
		ld	a,getDayNameByNumber
		ld	de,dateMsg				; название дня недели
		call	cliKernel		

		pop	de
		ld	a,d
		push	de
		ex	af,af'
		ld	a,getMonthNameByNumber
		ld	de,dateMsg+4				; название месяца
		call	cliKernel

		pop	de

		ld	h,#00
		ld	l,e
		ld	de,dateTmp
		ld	a,char2str
		call	cliKernel

		ld	hl,dateTmp+1
		ld	de,dateMsg+8				; число
		ld	bc,2
		ldir

		pop	hl
		ld	de,dateTmp
		ld	a,int2str
		call	cliKernel

		ld	hl,dateTmp+1
		ld	de,dateMsg+20				; год
		ld	bc,4
		ldir

;---------------

		ld	a,getCurrentTime
		call	cliKernel

		push	hl

		ld	h,#00
		ld	l,c
		ld	de,dateTmp
		ld	a,char2str
		call	cliKernel

		ld	hl,dateTmp+1
		ld	de,dateMsg+17				; секунды
		ld	bc,2
		ldir

		pop	hl
		push	hl

		ld	l,h
		ld	h,#00
		ld	de,dateTmp
		ld	a,char2str
		call	cliKernel

		ld	hl,dateTmp+1
		ld	de,dateMsg+11				; часы
		ld	bc,2
		ldir

		pop	hl

		ld	h,#00
		ld	de,dateTmp
		ld	a,char2str
		call	cliKernel

		ld	hl,dateTmp+1
		ld	de,dateMsg+14				; минуты
		ld	bc,2
		ldir

		ld	hl,dateMsg
		ld	a,printString
		call	cliKernel
			
		xor	a					; no error, clean exit!
		ret

			;01234
dateTmp		db	"     "

			;Fri Apr  1 21:24:26 2016
dateMsg		db	"             :  :       ",#0d,#00

appEnd	nop

		SAVEBIN "install/bin/date", appStart, appEnd-appStart

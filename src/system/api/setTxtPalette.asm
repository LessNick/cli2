;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #32 setTxtPalette
;---------------------------------------
; Установить палитру для текстового режима
; i: HL - адрес начала данных палитры
;    D - номер одиной из 16-ти палитр в которую начинать загрузку (0,1,2,3… 15)
;	 Если палтира больше 16-ти цветов, то D должно быть = 0
;    BC - размер палитры в байтах (=512 адресует всю палитру)
;---------------------------------------
_setTxtPalette	
; 		xor	a
; 		ld	(setPalScr+1),a
; 								; На входе:
; 								;	в HL адрес начала палитры
; 								;	в D номер блока один из 16-ти
; 								;	в BC размер загружаемой палитры
; 		sla	d					; * 2 (512)
; 		xor	a
; 		ld	e,a
; 		ldir

; 		call	storeRam3

; 		ld	a,palBank				; Включаем страницу для сохранения текстовой палитры
; ; 		call	switchMemBank
; 		call	setRamPage3

; 		ld 	de,palAddr
; 		jr	storePalette
;---------------------------------------
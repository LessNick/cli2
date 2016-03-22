;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #4C nvRamGetData
;---------------------------------------
; Прочитать данные из ячейки nvRam
; i: A' - номер ячейки
; o: A - значение
;---------------------------------------
_nvRamGetData	ex	af,af'
		ld	bc,peNvRamLocation
		out	(c),a
_nvRamGetData0	ld	bc,peNvRamData
		in	a,(c)
		ret
;---------------------------------------

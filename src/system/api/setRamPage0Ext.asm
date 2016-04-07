;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #40 setRamPage0Ext
;---------------------------------------
; Включить указанную банку по адресу #0000
; i: A' - номер банка
;---------------------------------------
_setRamPage0Ext	ex	af,af'
_setRamPage0	ld	(cPage0),a
_setRamPage00	ld	bc,tsRAMPage0
		out	(c),a
		ret
;---------------------------------------

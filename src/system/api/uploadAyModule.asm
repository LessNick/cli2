;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #5B uploadAyModule
;---------------------------------------
; Установить (скопировать) модуль в ayBank
; i: HL - адрес откуда будут копирваться данные.
;         адрес должен быть не меньше #4000.
;    BC - размер модуля
;---------------------------------------
_uploadAyModule	call	storeRam0
		ld	a,ayBank
		push	bc
		call	_setRamPage0
		pop	bc
		ld	de,#0000
		ldir

		jp	reStoreRam0
;---------------------------------------

;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #30 getTxtPalette
;---------------------------------------
; Получить палитру для текстового режима
; i: HL - адрес начала, куда будут
;	  сохранены 512 байт данных
;---------------------------------------
_getTxtPalette	push	hl

		call	storeRam3

		ld	a,palBank				; Включаем страницу для чтения текстовой палитры
		call	setRamPage3

		call	storeRam0				; Включаем страницу для временного хранения текстовой палитры
		ld	a,#ff
		call	_setRamPage0

		ld	hl,palAddr
		call	toBuff0000

		call	reStoreRam3				; Восстанавливаем что было

		pop	de

		call	fromBuff0000

		jp	reStoreRam0				; Восстанавливаем что было

;---------------------------------------

;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #34 setFont
;---------------------------------------
; Установить шрифт для текстового режима
; i: HL - адрес 2048-ти байтов шрифта
;---------------------------------------
_setFont	call	storeRam0
		ld	a,#ff
		call	_setRamPage0

		call	storeRam3

		ld	de,#0000				; Сохраняем копию шрифта в #0000
		ld	bc,2048
		ldir
		ld	a,txtFontBank				; Включаем страницу с нашим фонтом
; 		call	switchMemBank
		call	setRamPage3
		
		ld	hl,#0000				; Копируем шрифт из #0000
		ld	de,txtFontAddr
		ld	bc,2048
		ldir

		call	reStoreRam0
		jp	reStoreRam3
;---------------------------------------

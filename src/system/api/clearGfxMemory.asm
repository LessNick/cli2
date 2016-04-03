;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #05 clearGfxMemory
;---------------------------------------
; Очистить всю память выделенную для графического режима
; i:B - номер графического экрана (1/2/3)
;   C - номер цвета очистки
;---------------------------------------
_clearGfxMemory	ld	a,b					; #10 1й
		ld	b,a					; сохрняем копию в B, если вызов был на адрес +1

		cp	#00
		ret	z
		
		cp	#04
		ret	nc

		sla	a
		sla	a
		sla	a
		sla	a

		push 	af

		ld	hl,pTxtScreen
		ld	d,#00
		ld	e,b
		add	hl,de
		ld	a,(hl)
		and	%00000011
		cp	%00000001				; если режим 16ц
		jr	nz,_cgm_skip
		ld	a,c
		sla	a
		sla	a
		sla	a
		sla	a
		or	c
		ld	c,a		

_cgm_skip	ld	h,c
		ld	l,c

		pop	af

		push	af
		call	storeRam3

		add	a,#20					; +#20 адресация
		call	setRamPage3

		ld	(#c000),hl				; заливаем цветом первые 2 пикселя

		call	reStoreRam3

		ld	a,#ff
		call	callDma					; ожидаем готовности DMA

		pop	af
								
		ld	b,a					; ld	bc,#1010
		ld	c,a

		ld	a,32*8-1
		ld	(gfxClsK+1),a
		ld	a,255
		ld	(gfxClsS+1),a

		call	gfxClsDma

		ld	a,32*8-2
		ld	(gfxClsK+1),a
		ld	a,255
		ld	(gfxClsS+1),a
		call	gfxClsDma2

		ld	a,0
		ld	(gfxClsK+1),a
		ld	a,254
		ld	(gfxClsS+1),a
		jr	gfxClsDma2			

;-----------							; ld	bc,#1111
gfxClsDma	ld	hl,0					; BHL - Source
		ld	de,2					; CDE - Destination
		ld	a,#00					; Инициализация источника(Source) и приёмника(Destination)
		call	callDma

gfxClsDma2	ld	a,#05					; выставление DMA_T
gfxClsK		ld	b,32*8-1				; B - кол-во бёрстов
		call	callDma
		
		ld	a,#06					; выставление DMA_N
gfxClsS		ld	b,255					; B - размер бёрста
		call	callDma

		ld	a,#fe					; запуск с ожиданием завершения (o:NZ - DMA занята)
		jp	callDma
;---------------------------------------
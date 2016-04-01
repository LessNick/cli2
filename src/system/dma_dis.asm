;---------------------------------------
; CLi² (Command Line Interface) DMA from WC
; 2016 © breeze/fishbone crew
;---------------------------------------
; Code by Budder^MGN
; DisAssembled by Me
;---------------------------------------
; работа с DMA
; i: A - тип операции:
; 	#00 - инит S и D (BHL - Source, CDE - Destination)
; 	#01 - инит S (BHL)
; 	#02 - инит D (CDE)
; 	#03 - инит S с пагой из окна (HL, B - 0-3 [номер окна])
; 	#04 - инит D с пагой из окна (HL, B - 0-3 [номер окна])
; 	#05 - выставление DMA_T (B - кол-во бёрстов)
; 	#06 - выставление DMA_N (B - размер бёрста)
;
; 	#FD - запуск без ожидания завершения (o:NZ - DMA занята)
; 	#FE - запуск с ожиданием завершения (o:NZ - DMA занята)
; 	#FF - ожидание готовности дма
;
; 	в функциях #00-#02 формат B/C следующий:
; 		[7]:%1 - выбор страницы из блока выделенного плагину (0-5)
; 		    %0 - выбор страницы из видео буферов (0-31)
;		[6-0]:номер страницы
;---------------------------------------
DMAPL
callDma		
		cp	#FF
		jr	z,waitDmaReady		; #FF - ожидание готовности дма	
		cp	#FE
		jr	z,runWithWait		; #FE - запуск с ожиданием завершения
		cp	#FD
		jr	z,runWithoutWait 	; #FD - запуск без ожидания завершения 
		or	a
		jr	z,initSrcAndDst		; #00 - инит S и D (BHL - Source, CDE - Destination)
		dec	a
		jp	z,initSource		; #01 - инит S (BHL)
		dec	a
		jp	z,initDest		; #02 - инит D (CDE)
		dec	a
		jp	z,initSrcWithPage	; #03 - инит S с пагой из окна (HL, B - 0-3 [номер окна])
		dec	a
		jp	z,initDstWithPage	; #04 - инит D с пагой из окна (HL, B - 0-3 [номер окна])
		dec	a
		jp	z,setDmaT		; #05 - выставление DMA_T (B - кол-во бёрстов)
		dec	a
		jp	z,setDmaN		; #06 - выставление DMA_N (B - размер бёрста)
		ret
;---------------
waitDmaReady	ld	bc,tsDMActr		;_27AF	; tsDMActr
wdrLoop		in	f,(c)
		jp	m,wdrLoop		;
		xor	a
		ret
;---------------
runWithWait	call	runWithoutWait		;
		ret	nz
		jr	waitDmaReady		;
;---------------
runWithoutWait	call	_6E66			;
		ret	nz
		ld	bc,tsDMActr		;_27AF	; tsDMActr
		ld	a,#01
		out	(c),a
		xor	a
		ret
;---------------
_6E66		ld	bc,tsDMActr		;_27AF	; tsDMActr
		in	f,(c)
		jp	m,_6E70			;
		xor	a
		ret
;---------------
_6E70		ld	a,#01
		or	a
		ret
;---------------
initSrcAndDst	push	bc
		call	initSource		;
		pop	bc
		jr	initDest		;
;---------------
initSource	ld	a,b
		call	_6F06			;
		ld	bc,tsDMAsAddrL		;_1AAF	; tsDMAsAddrL
		out	(c),l
		ld	b,#1B
		out	(c),h
		ld	b,#1C
		out	(c),a
		ret
;---------------
_6E92		ld	bc,tsDMAsAddrL		;_1AAF	; tsDMAsAddrL
		out	(c),l
		ld	b,#1B
		out	(c),h
		ld	b,#1C
		out	(c),a
		ret
;---------------
initDest	ld	a,c
		call	_6F06			;
_6EA4		ld	bc,tsDMAdAddrL		;_1DAF	; tsDMAdAddrL
		out	(c),e
		ld	b,#1E
		out	(c),d
		ld	b,#1F
		out	(c),a
		ret
;---------------
initSrcWithPage	call	_6F1A			;
		jr	_6E92			;
;---------------
initDstWithPage	call	_6F1A			;
		jr	_6EA4			;
;---------------
setDmaT		ld	a,b
		ld	bc,tsDMAnum		;_28AF	; tsDMAnum
		out	(c),a
		ret
;---------------
setDmaN		ld	a,b
		ld	bc,tsDMAlen		;_26AF	; tsDMAlen
		out	(c),a
		ret
;---------------
_6F06		bit	7,a
		jr	nz,_6F0F		;
		and	#3F
		add	a,#20
		ret
;---------------
_6F0F		and	#0F
		add	a,#61
; 		exx
; 		ld	hl,_7F0E		;
; 		add	a,(hl)
; 		exx
		ret
;---------------
_6F1A		ld	a,b
		and	#03
		exx
		ld	h,#60
		ld	l,a
		ld	a,(hl)
		exx
		ret
;---------------
; _7F0E		db	#00			; PPFR

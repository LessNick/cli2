;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #62 long2str
;---------------------------------------
; long2str перевод long (4 байта) в текст (десятичное число)
; (C) BUDDER/MGN
;--------------------------------------------------------------
; Преобразовать 32-битное число в строку с десятичным значением
; i: DE(старшая часть),HL(младшая часть) - значение (32-бит), DE' - адрес начала строки (длинной 10 символов)
; 
;--------------------------------------------------------------
_long2str	ld	bc,#ca00
		ld	(pbstl+1),bc
		ld	bc,#3b9a
		ld	(pbsth+1),bc
		call	delit4p
		exx
		ld	(de),a
		inc	de
		exx

		ld	bc,#e100
		ld	(pbstl+1),bc
		ld	bc,#05f5
		ld	(pbsth+1),bc
		call	delit4p
		exx
		ld	(de),a
		inc	de
		exx

		ld	bc,#9680
		ld	(pbstl+1),bc
		ld	bc,#0098
		ld	(pbsth+1),bc
		call	delit4p
		exx
		ld	(de),a
		inc	de
		exx

		ld	bc,#4240
		ld	(pbstl+1),bc
		ld	bc,#000f
		ld	(pbsth+1),bc
		call	delit4p
		exx
		ld	(de),a
		inc	de
		exx

		ld	bc,#86a0
		ld	(pbstl+1),bc
		ld	bc,#0001
		ld	(pbsth+1),bc
		call	delit4p
		exx
		ld	(de),a
		inc de
		exx

;---------------
deczon2		ld	bc,10000
		ld	(pbstl+1),bc
		ld	bc,0
		ld	(pbsth+1),bc
		call	delit4p
		push	hl
		exx
		ld	(de),a
		inc de
		pop hl

decz2		ld	bc,1000
		call	delit
		ld	(de),a
		inc	de

decz1		ld	bc,100
		call	delit
		ld	(de),a
		inc de

decz		ld	c,10
		call	delit
		ld	(de),a
		inc	de
		ld	c,1
		call	delit
		ld	(de),a
		inc	de
		ret

;---------------
delit4p		ld	ix,0-1
naze		or	a
pbsth		ld	bc,0
		inc	ix
		ex	de,hl
		sbc	hl,bc
		jr	c,nd

pbstl		ld	bc,0
		ex	de,hl
		sbc	hl,bc
		jr	nc,pbsth

		dec	de
		ld	a,d
		inc	a
		jr	nz,naze

		ld	a,e
		inc	a
		jr	nz,naze
		inc	de

		add	hl,bc
		ex	de,hl
		ld	bc,(pbsth+1)
nd		add	hl,bc
		ex	de,hl
		push	ix
		pop	bc
		ld	a,c
		add	a,#30
		ret
;---------------------------------------

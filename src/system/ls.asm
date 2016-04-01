;---------------------------------------
; CLi² (Command Line Interface)
; 2016 © breeze/fishbone crew
;---------------------------------------------
; ls - show directory content
;---------------------------------------------
_ls		ex	de,hl
		
		ld	a,(hl)
		cp	#00
		jr	z,lsShow

		push	hl
		call	storePath
		pop	de
		call	_changeDir
		
		cp	#ff
		jr	nz,lsShow
		
		ld	hl,dirNotFoundMsg
		ld	b,#ff
		call	_printErrorString
		xor	a

		jp	restorePath

lsShow		ld	de,lsBuffer
		ld	a,fGetNextEntryDir
		call	fatDriver
		jp	z,_printRestore					; Конец директории
		
		ld	hl,lsBuffer+12					; флаги файла
		call	lsGetColor
		call	setInk	

		ld	hl,lsBuffer+13					; Начало имени
		call	_printString

		ld	a,(printX)

		cp	40+1						; Ширина 1 колонки
		jr	nc,lsMore2
		
		ld	a,40
		ld	(printX),a
		jr	lsShow

lsMore2		call	_printRestore
		jr	lsShow


lsNextLine	call	_printRestore
		jr	lsShow
;---------------
lsGetColor	bit	4,(hl)
		jr	z,lsColor_1
		ld	a,(colorDir)					; если 1, то каталог
		ret

lsColor_1	bit	0,(hl)
		jr	z,lsColor_2					; если 1, то файл только для чтения
		ld	a,(colorRO)
		ret

lsColor_2	bit	1,(hl)
		jr	z,lsColor_3					; если 1, то файл скрытый
		ld	a,(colorHidden)
		ret

lsColor_3	bit	2,(hl)
		jr	z,lsColor_4					; если 1, то файл системный
		ld	a,(colorSystem)
		ret

lsColor_4	bit	5,(hl)
		jr	z,lsColor_5					; если 1, то файл архивный
		ld	a,(colorArch)
		ret

lsColor_5	ld	a,(colorFile)					; в противном случает - обычный файл
		ret

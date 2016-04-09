;---------------------------------------
; CLi² (Command Line Interface)
; 2016 © breeze/fishbone crew
;---------------------------------------------
; ll - show directory list
;---------------------------------------------
ll		ex	de,hl
		
		ld	a,(hl)
		cp	#00
		jr	z,llShow

		push	hl
		call	storePath
		pop	de
		call	changeDir
		
		cp	#ff
		jr	nz,ll0
		
		ld	hl,dirNotFoundMsg
		ld	b,#ff
		call	_printErrorString
		xor	a
		jp	restorePath

ll0		call	llShow
		jp	restorePath

llShow		ld	a,fSetDir
		call	fatDriver

llLoop		xor	a
		ld	(llIsDir+1),a

		ld	de,lsBuffer
		ld	a,fGetNextEntryDir
		call	fatDriver
		ret	z						; Конец директории
		
		ld	hl,lsBuffer+12					; флаги файла
		call	lsGetColor
		call	setInk

		ld	hl,lsBuffer+12					; флаги файла
		call	llBitAttr

		ld	hl,llAttrStr
		call	_printString

llIsDir		ld	a,#00
		cp	#00
		jr	z,llIsFile

		ld	hl,llDir
		call	_printString
		jr	llNext

llIsFile	ld	hl,(lsBuffer+4)					; младшая часть
		ld	de,(lsBuffer+6)					; старшая часть
		exx
		ld	de,llSize
		exx
		call	_long2str

		ld	hl,llSize					; заменяем начальные 0 на пробелы
llSpace		ld	a,(hl)
		cp	"0"
		jr	nz,llSkip
		ld	a," "
		ld	(hl),a
		inc	hl
		jr	llSpace


llSkip		ld	hl,llSize
		call	_printString


llNext		ld	hl,lsBuffer+8
		call	llCalcDate

		ld	hl,llDate
		call	_printString

		ld	hl,lsBuffer+13					; Начало имени
		call	_printString

		call	_printRestore

		jr	llLoop

;---------------
llBitAttr	ld	a,"-"
		ld	(llAttrStr+0),a
		ld	(llAttrStr+1),a
		ld	(llAttrStr+2),a
		ld	(llAttrStr+3),a
		ld	(llAttrStr+4),a
		ld	(llAttrStr+5),a

llBitAttr_0	bit	0,(hl)
		jr	z,llBitAttr_1					; если 1, то файл только для чтения
		ld	a,"r"
		ld	(llAttrStr+7-2),a

llBitAttr_1	bit	1,(hl)
		jr	z,llBitAttr_2					
		ld	a,"h"						; если 1, то файл скрытый
		ld	(llAttrStr+6-2),a

llBitAttr_2	bit	2,(hl)
		jr	z,llBitAttr_3					; если 1, то файл системный
		ld	a,"s"
		ld	(llAttrStr+5-2),a

llBitAttr_3	bit	3,(hl)
		jr	z,llBitAttr_4					; если 1, то запись это ID тома
		ld	a,"t"
		ld	(llAttrStr+4-2),a

llBitAttr_4	bit	4,(hl)
		jr	z,llBitAttr_5
		ld	a,"d"						; если 1, то каталог
		ld	(llAttrStr+3-2),a
		ld	a,#01
		ld	(llIsDir+1),a

llBitAttr_5	bit	5,(hl)
		ret	z						; если 1, то файл архивный
		ld	a,"a"
		ld	(llAttrStr+2-2),a
		ret

;---------------
llCalcDate	push	hl
		ld	a,(hl)
		and	%11100000
		rlc	a
		rlc	a
		rlc	a
		ld	c,a
		inc	hl
		ld	a,(hl)
		and	%00000001
		sla	a
		sla	a
		sla	a
		or	c
		ld	de,llDate	
		call	_getMonthNameByNumber
		pop	hl

		push	hl
		ld	a,(hl)
		and	%00011111
		ld	h,0
		ld	l,a
		ld	de,llTmpNum
		call	_char2str

		ld	hl,llTmpNum+1
		ld	de,llDate+4
		ld	bc,2
		ldir
		pop	hl

		inc	hl
		ld	(llShowTime+1),hl
		ld	a,(hl)
		and	%11111110
		srl	a
		ld	b,0
		ld	c,a
		ld	hl,1980						; 1980 + offset
		add	hl,bc

		push	hl
		call	_getCurrentDate
		pop	de
		ex	de,hl

		ld	a,h
		cp	d
		jr	nz,llShowYear

		ld	a,l
		cp	e
		jr	nz,llShowYear

llShowTime	ld	hl,#0000		
		inc	hl
		ld	a,(hl)
		and	%11100000					; минуты часть 1
		rlca
		rlca
		rlca
		ld	c,a
		inc	hl
		push	hl
		ld	a,(hl)
		and	%00000111					; минуты часть 2
		sla	a
		sla	a
		sla	a
		or	c
		ld	h,0
		ld	l,a
		ld	de,llTmpNum
		call	_char2str

		ld	hl,llTmpNum+1
		ld	de,llDate+10
		ld	bc,2
		ldir

		pop	hl
		ld	a,(hl)
		and	%11111000					; часы
		srl	a
		srl	a
		srl	a
		
		ld	h,0
		ld	l,a
		ld	de,llTmpNum
		call	_char2str

		ld	hl,llTmpNum+1
		ld	de,llDate+7
		ld	bc,2
		ldir
		
		ld	a,":"
		ld	(llDate+9),a
		ret

llShowYear	ld	a," "
		ld	(llDate+7),a

		ld	de,llTmpNum
		call	_int2str

		ld	hl,llTmpNum+1
		ld	de,llDate+8
		ld	bc,4
		ldir
		ret
;---------------
                        ;01234
llTmpNum	db	"     "

llAttrStr	db	"------ ",#00

	 ; #FFFF,#FFFF = 4294967295
llSize		db	"---------- ",#00
llDir		db	"<DIR>      ",#00
			;Mar 28 16:39
llDate		db	"             ",#00
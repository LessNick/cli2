;---------------------------------------
; CLi² (Command Line Interface) SexyBoot
; 2016 © breeze/fishbone crew
;---------------------------------------
; I'm sexy and I boot it!
;---------------------------------------
	DEVICE	ZXSPECTRUM128

CORE		equ	#2002
DEV_INI		equ	CORE+3
HDD		equ	CORE+9
LOAD512		equ	CORE+21
DOS_SWP		equ	CORE+27
FENTRY		equ	CORE+78
NXTETY		equ	CORE+87
SETDIR		equ	CORE+93
SETROOT		equ	CORE+96

_WCINT		equ	#5BFF

		org	#6000
sSexyBoot	
_PAGE0		jp	startBoot		; #6000 номер страницы подключенной с адреса #0000-#3fff
_PAGE1		equ	_PAGE0+1		; #6001 номер страницы подключенной с адреса #4000-#7fff
_PAGE2		equ	_PAGE0+2		; #6002 номер страницы подключенной с адреса #8000-#dfff
_PAGE3		db	#00			; #6003 номер страницы подключенной с адреса #c000-#ffff
		db	#00			; #6004
		db	#00			; #6005
						; #6006
wcKernel	push	af,bc
		ld	a,(_PAGE0)
		ld	(wke+1),a
		ld	a,#0f
		call	setMemBank0
		ld	(_PAGE0),a
		pop	bc,af

		cp	#39
		jr	z,_STREAM
		cp	#30
		jr	z,_LOAD512
		cp	#3F
		jr	z,_GDIR
		cp	#49
		jr	z,_MKDIR
		cp	#48
		jr	z,_MKFILE
		cp	#3B
		jr	z,_FENTRY
		cp	#3E
		jr	z,_GFILE

wcKernelExit	push	af,bc
wke		ld	a,#00
		call	setMemBank0
		ld	(_PAGE0),a
		pop	bc,af
		ret
;---------------
_STREAM		ld	a,d	
		cp	#ff
		jr	nz,noCmd
		ld	a,b
		cp	#ff
		jr	nz,noCmd
		ld	a,c
		cp	#ff
		jr	nz,noCmd
		call	SETROOT
noCmd		xor	a
		jr	wcKernelExit
;---------------
_LOAD512	ld	a,h
		cp	#c0
		jr	c,_l0000
		ld	de,#c000
		sbc	hl,de	
		ld	a,(_PAGE3)
_loadOk		ld	c,a
		call	LOAD512
		jr	wcKernelExit

_l0000		cp	#40
		jr	nc,_noLoad
		ld	a,(wke+1)
		jr	_loadOk

_noLoad		ld	a,#ff			; нельзя грузить #0000 > < #c000
		jr	wcKernelExit

;---------------
_GDIR		call	SETDIR
		jr	wcKernelExit
;---------------
_MKDIR		call	CORE+60
		jr	wcKernelExit
;---------------
_MKFILE		call	CORE+57
		jr	wcKernelExit
;---------------
_FENTRY		call	FENTRY
		jr	wcKernelExit
;---------------
_GFILE
		jr	wcKernelExit
;---------------

; tmpIntPos	equ	#feff
tsMemConfig	equ	#21af
tsRAMPage0	equ	#10af
tsRAMPage2	equ	#12af
tsRAMPage3	equ	#13af
tsVpage		equ	#01af
tsVConfig	equ	#00af
borderPort	equ	#0faf
FMAddr		equ	#15af

defaultColor	equ	%01011111

palBank		equ	#03
palAddr		equ	#f800

gPalBank1	equ	#03
gPalAddr1	equ	#fe00

startBoot	ld	sp,#5ffe
; 		jr	$
		xor	a
		ld	(sSexyBoot),a
		ld	(sSexyBoot+1),a
		ld	(sSexyBoot+2),a
		out	(254),a


		call	txtModeInit

		call	storePalette

		ld	a,#00					; Включаем страницу с текстовым режимом
		call	setMemBank3

		call	clearTxtScreen				; Очищаем текстовую область

		ld	a,#24-32				; ???
		call	setMemBank3

		ld	a,#01					; #01 - 1й видео буфер (16 страниц)
		call	setVideoBuffer

		ld	a,%10000011				; переключаем разрешайку на 320x240 TXT
		call	setVideoMode

		ld	hl,sBootMsg
		ld	de,#c000
		ld	bc,eBootMsg-sBootMsg
		ldir						; Выводим надпись


		ld	hl,tmpInt
		ld	(_WCINT),hl

		ld	hl,#C9FB
		ld	(_WCINT+2),hl

		di
		ld	a,#5b
		ld	i,a
		im	2
		ei

		ld	bc,tsMemConfig
		ld	a,%00001110			; [3]: Установить в #0000 страницу ОЗУ(1) или ПЗУ(0)
							; [2]: Разрешить(0) / Запретить(1) выбор банки
							; [1]: Разрешить(1) / Запретить(0) запись с #0000
		out	(c),a

		ld	a,#0f
		call	setMemBank0

		ld	hl,sDriver
		ld	de,CORE
		ld	bc,eDriver-sDriver
		ldir

		call	DOS_SWP				; DEPACK Driver

; 		xor	a				; !!! Убирает дурацкое обрезание аттрибутов файла !!!
; 		ld	(#20FC+0),a
; 		ld	(#20FC+1),a
; 		ld	(#20FC+2),a
; 		ld	(#20FC+3),a
		ld	hl,sDrvPatch
		ld	de,#20e6
		ld	bc,eDrvPatch-sDrvPatch
		ldir

		call	DEV_INI
		jp	nz,devNotFound
		call	HDD
		jp	nz,fatNotFound
		
; 		jp	testPart

		call	SETROOT				; SET ROOT DIR
		
		ld	hl,systemDir
		call	FENTRY
		jr	z,pathNotFound

		call	SETDIR

		ld	hl,kernelName			; ищем файл
		call	FENTRY
		jr	z,pathNotFound

		ld	a,#61				; ???
		call	setMemBank2

		ld	c,#61				; Банка 2 (#8000)
		ld	(_PAGE2),a
		ld	hl,#8000
; 		ld	b,32				; Тупо грузим 32 блока по 512б = 16384
		ld	b,40				; Тупо грузим 40 блоков по 512б = 20480 (#c000-#7000)
		call	LOAD512

		ld	a,#F1				; ???
		ld	(_PAGE0),a
		call	setMemBank0

		ld	a,#62-32			; ???
		call	setMemBank3

		ld	hl,#8000
		ld	de,#7000
; 		ld	bc,#4000
		ld	bc,#5000
		ldir

		ld	a,#24-32			; ???
		call	setMemBank3

		jp	#7000

tmpInt		ei
		ret
;---------------
; testPart	jr	$
		
; 		call	SETROOT

; 		ld	hl,systemDir
; 		call	FENTRY
; 		jr	z,pathNotFound
; 		call	SETDIR
		
; 		ld	de,#8000
; 		call	readDir

; 		call	SETROOT

; 		ld	de,#9000
; 		call	readDir

; 		jr	$

;---------------
; readDir		call	NXTETY
; 		ret	z
; 		ld	a,d
; 		cp	#c0
; 		ret	nc
; 		jr	readDir
;---------------

; VYGREB  LD DE,#8000
; VYG     CALL NXTETY:RET Z
;         LD A,D:CP #C0:RET NC
;         JR VYG

sDrvPatch
		ld	c,#08
		sbc	hl,bc
		ldi
		ldi
		dec	l
		dec	l
		dec	l
		dec	l
		ldi
		ldi
		ld	c,#08
		sbc	hl,bc
		res	4,l
		call	#2268
		ex	af,af'
eDrvPatch

;---------------
setMemBank0	ld	bc,tsRAMPage0
		out	(c),a
		ret

setMemBank2	ld	bc,tsRAMPage2
		out	(c),a
		ret

setMemBank3	add	32
		ld	bc,tsRAMPage3
		out	(c),a
		ld	(_PAGE3),a
		ret
;---------------------------------------
; Device not found (SD Card NOT ready!)
;---------------------------------------
devNotFound	ld	a,#01
stopErr		out	(254),a
		halt
		jr	$

;---------------------------------------
; FAT32 NOT FOUND
;---------------------------------------
fatNotFound	ld	a,#02
		jr	stopErr

;---------------------------------------
; PATH NOT FOUND
;---------------------------------------
pathNotFound	ld	a,#03
		jr	stopErr
;---------------------------------------




;---------------------------------------
;---------------------------------------
; #00 - 0й текстовый                            		#10
; #01 - 1й графичекский видео буфер (16 страниц)		#20
; #02 - 2й графичекский видео буфер (16 страниц)		#30
; #03 - 3й графичекский видео буфер (16 страниц)		#40
		
setVideoBuffer	inc	a					; !!! FIX !!!
		sla 	a
		sla 	a
		sla 	a
		sla 	a
		ld	bc,tsVpage
		out	(c),a
		ret
;---------------------------------------
setVideoMode	ld	bc,tsVConfig
		out	(c),a
		ret
;---------------------------------------
clearTxtScreen	ld	hl,#c000+128				; блок атрибутов
		ld	de,#c001+128
		ld	a,defaultColor
		call	clearTxt

		ld	hl,#c000				; блок символов
		ld	de,#c001
		ld	a," "
		call	clearTxt

		ld	a,defaultColor
		and	%11110000
		srl	a
		srl	a
		srl	a
		srl	a

		ld	bc,borderPort
		out	(c),a
		ret

clearTxt	ld	b,64
clearLoop	push	bc,de,hl
		ld	bc,127
		ld	(hl),a
		ldir
		pop	hl,de,bc
		inc	h
		inc	d
		djnz	clearLoop
		ret

;---------------------------------------
txtModeInit	ld	a,#01					; Включаем страницу с нашим фонтом
; 		call	setVideoPage
		call	setMemBank3
		
		ld	hl,defaultFont				; Загружаем шрифт
		ld	de,#c000
		ld	bc,2048
		ldir

		ld	hl,defaultPal
		ld	bc,FMAddr
		ld 	a,%00010000				; Разрешить приём данных для палитры (?) Bit 4 - FM_EN установлен
		out	(c),a

		ld 	de,#0000				; Память с палитрой замапливается на адрес #0000
		call	dupPal

		ld 	bc,FMAddr			
		xor	a					; Запретить, Bit 4 - FM_EN сброшен
		out	(c),a
		ret

dupPal		ld	b,#00
		ld	a,16
palLoop		push	hl
		ld	c,32
		ldir
		dec 	a
		pop	hl
		jr 	nz,palLoop
		ret

;---------------------------------------
storePalette	ld	a,palBank				; Включаем страницу для сохранения текстовой палитры
		call	setMemBank3

		ld 	de,palAddr
		call	dupPal

		ld	a,gPalBank1				; Включаем страницу для сохранения графической палитры
		call	setMemBank3

		ld 	de,gPalAddr1
		call	dupPal
		ret
;---------------------------------------
systemDir	db	#10
		db	"SYSTEM",0

kernelName	db 	#00				; #00 - file, #10 - DIR
		db	"kernel.sys",0
;---------------------------------------
defaultPal	
		;         rR   gG   bB
		;         RRrrrGGgggBBbbb
		DUP	16
		dw	%0000000000000000		; 0.black
		dw	%0000000000010000		; 1.navy 
		dw	%0110000100010000		; 2.amiga pink
		dw	%0110001000011000		; 3.light violet
		dw	%0000001000000000		; 4.green
		dw	%0000000100010000		; 5.dark teal
		dw	%0110000100000000		; 6.orange
		dw	%0110001000010000		; 7.light beige
		;         rR   gG   bB
		;         RRrrrGGgggBBbbb
		dw	%0100001000010000		; 8.silver
		dw	%0000000000011000		; 9.blue
		dw	%0110000000000000		;10.red
		dw	%0110000100001000		;11.dark pink
		dw	%0000001100000000		;12.lime
		dw	%0000001000011000		;13.teal
		dw	%0110001100010000		;14.light yellow
		dw	%0110001100011000		;15.white
		EDUP

defaultFont	incbin	"..\rc\fonts\8x8\default.bin"

;---------------------------------------
sBootMsg	db	"[CLi",#FD,"] Try to boot /system/kernel.sys..."
eBootMsg
;---------------------------------------


sDriver		incbin "..\rc\bin\WDFCVBI2.COD"
eDriver		nop
eSexyBoot	nop
	
	DISPLAY "-------------------------------------"
	DISPLAY "start boot",/A,startBoot
	DISPLAY "boot size",/A,eSexyBoot-sSexyBoot
	DISPLAY "boot end",/A,eSexyBoot
	DISPLAY "-------------------------------------"

	SAVEHOB "install/boot.$c", "BOOT.C", sSexyBoot, eSexyBoot-sSexyBoot

;---------------------------------------
; CLi² (Command Line Interface) SexyBoot
; 2016 © breeze/fishbone crew
;---------------------------------------
; I'm sexy and I boot it!
;---------------------------------------
	DEVICE	ZXSPECTRUM128

		include	"../system/tsconf.h.asm"
		include	"../system/fat.h.asm"
		include	"../system/constants.asm"

defaultColor	equ	%01011111

		org	#6000

sSexyBoot	ld	sp,#5ffe
		xor	a
		out	(254),a

		call	txtModeInit

		call	storePalette
		
		ld	a,vPageTXT0+#20				; Включаем страницу с текстовым режимом
		call	setMemBank3

		call	clearTxtScreen				; Очищаем текстовую область

		ld	a,vPageTXT0+#20
		call	setMemBank3

		ld	a,vPageTXT0				; #00 - 0й видео буфер (TXT: 16 страниц)
		call	setVideoBuffer

		ld	a,%10000011				; переключаем разрешайку на 320x240 TXT
		call	setVideoMode

		ld	hl,sBootMsg
		ld	de,#c000
		ld	bc,eBootMsg-sBootMsg
		ldir						; Выводим надпись

		ld	hl,tmpInt
		ld	(kernelInt),hl

		ld	hl,#C9FB
		ld	(kernelInt+2),hl

		di
		ld	a,#5b
		ld	i,a
		im	2
		ei

		ld	bc,tsMemConfig
		ld	a,%00001110				; [3]: Установить в #0000 страницу ОЗУ(1) или ПЗУ(0)
								; [2]: Разрешить(0) / Запретить(1) выбор банки
								; [1]: Разрешить(1) / Запретить(0) запись с #0000
		out	(c),a

		ld	a,fPageDrv				; раположение FAT драйвера
		call	setMemBank0

		ld	hl,sDriver
		ld	de,fStart
		ld	bc,eDriver-sDriver
		ldir

		call	fStart+fDriverUnpack			; DEPACK Driver

		ld	hl,sDrvPatch				; !!! Патч драйверов (v2) Коши. Убирает обрезание аттрибутов и правит дату файла !!!
		ld	de,#20e6
		ld	bc,eDrvPatch-sDrvPatch
		ldir

		call	fStart+fDeviceInit
		jp	nz,devNotFound
		
		call	fStart+fFatInit
		jp	nz,fatNotFound
		
		call	fStart+fSetRoot				; SET ROOT DIR
		

		ld	hl,systemDir
		call	fStart+fFentry
		jp	z,pathNotFound

		call	fStart+fSetDir

		ld	hl,kernelName				; ищем файл
		call	fStart+fFentry
		jr	z,pathNotFound

		ld	(sbCopySize+1),hl

		ld	c,h					; размер файла
		ld	a,l
		cp	#00
		jr	z,sbSkip
		inc	c
sbSkip		ld	a,c
		srl	a					; /2 512б блоки
		ld	(sbKernelSize+1),a

		ld	a,kernelBank
		call	setMemBank2

		ld	c,kernelBank				; Банка 2 (#8000)
		ld	hl,#8000
sbKernelSize	ld	b,#00					; размер kernel для загрузки в блоках по 512б
		call	fStart+fLoad512

		ld	a,#F1					; ???
		call	setMemBank0

		ld	a,kernelBank+1
		call	setMemBank3

		ld	hl,#8000
		ld	de,kernelAddr
sbCopySize	ld	bc,#0000
		ldir

		ld	a,#24				; ???
		call	setMemBank3

		jp	#7000

tmpInt		ei
		ret

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

setMemBank3	ld	bc,tsRAMPage3
		out	(c),a
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
; #00 - 0й текстовый						#00 + #20 = #20
; #01 - 1й графичекский видео буфер (16 страниц)		#10 + #20 = #30
; #02 - 2й графичекский видео буфер (16 страниц)		#20 + #20 = #40
; #03 - 3й графичекский видео буфер (16 страниц)		#30 + #20 = #50
		
setVideoBuffer	sla 	a
		sla 	a
		sla 	a
		sla 	a
		add	a,#20
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

		ld	bc,tsBorder
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
txtModeInit	ld	a,vPageTXT0+#21				; Включаем страницу с нашим фонтом
		call	setMemBank3
		
		ld	hl,defaultFont				; Загружаем шрифт
		ld	de,#c000
		ld	bc,2048
		ldir

		ld	hl,defaultPal
		ld	bc,tsFMAddr
		ld 	a,%00010000				; Разрешить приём данных для палитры (?) Bit 4 - FM_EN установлен
		out	(c),a

		ld 	de,#0000				; Память с палитрой замапливается на адрес #0000
		call	dupPal

		ld 	bc,tsFMAddr			
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
defaultPal	include "..\res\pals\default.asm"
defaultFont	incbin	"..\rc\fonts\8x8\default.bin"

;---------------------------------------
sBootMsg	db	"[CLi",#FD,"] Try to boot /system/kernel.sys..."
eBootMsg
;---------------------------------------


sDriver		incbin "..\rc\bin\WDFCVBI2.COD"
eDriver		nop
eSexyBoot	nop
	
	DISPLAY "-------------------------------------"
	DISPLAY "boot size",/A,eSexyBoot-sSexyBoot
	DISPLAY "boot end",/A,eSexyBoot
	DISPLAY "-------------------------------------"

	SAVEHOB "install/boot.$c", "BOOT.C", sSexyBoot, eSexyBoot-sSexyBoot

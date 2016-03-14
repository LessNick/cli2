;---------------------------------------
; CLi² Loader
;---------------------------------------
		org	#6200
		DISP	#8000

FMAddr		equ	#15af					; FMaps Addr (?)
defaultColor	equ	%01011111
;flagFile	equ	#00					; flag:#00 - file
;flagDir		equ	#10					;      #10 - dir

		include "..\system\constants.asm"

;---------------------------------------
; TS-Labs Configuration's small header API
borderPort	equ	#0faf					; Border's Port

;---------------------------------------
; WildCommander's small header API 
;wcKernel	equ	#6006					; WildCommander API

_MNGC_PL	equ	#00					; включение страницы на #C000 (из выделенного блока)
								; нумерация совпадает с использующейся в +36
								; i:A' - номер страницы (от 0)
								;   #FF - страница с фонтом (1го текстового экрана)
								;   #FE - первый текстовый экран (в нём панели)

_LOAD512	equ	#30					; потоковая загрузка файла
								; i:HL - Address
								;   B - Blocks (512b)
								; o:HL - New Value

_STREAM		equ	#39					; работа с потоками
								; i:D - номер потока (0/1)
								;   B - устройство: 0-SD(ZC)
								;	1-Nemo IDE Master
								;	2-Nemo IDE Slave
								;   C - раздел (не учитывается)
								;   BC=#FFFF: включает поток из D (не возвращает флагов)
								;	      иначе создает/пересоздает поток.
								; o:NZ - устройство или раздел не найдены
								;   Z - можно начинать работать с потоком

_FENTRY		equ	#3b					; поиск файла/каталога в активной директории
								; i:HL - flag(1),name(1-12),#00
								; 		 flag:#00 - file
								;		      #10 - dir
								;		 name:"NAME.TXT","DIR"...
								; o: Z - entry not found
								;    NZ - CALL GFILE/GDIR for activating file/dir
								;    [DE,HL] - file length

_GFILE		equ	#3e					; выставить указатель на начало найденного файла
								; (вызывается после FENTRY!)

_GDIR		equ	#3f					; сделать найденный каталог активным
								; (вызывается после FENTRY!)

_MNGV_PL	equ	#40					; включение видео страницы
								; i:A' - номер видео страницы
								;   #00 - основной экран (тхт)
								;   >паллитра выставляется автоматом
								;   >как и все режимы и смещения
								;   #01 - 1й видео буфер (16 страниц)
								;   #02 - 2й видео буфер (16 страниц)

_MNGCVPL	equ	#41					; включение страницы из видео буферов
								; i:A' - номер страницы
								;   #00-#0F - страницы из 1го видео буфера
								;   #10-#1F - страницы из 2го видео буфера

_GVmod		equ	#42					; включение видео режима (разрешение+тип)
								; i:A' - видео режим
								;   [7-6]: %00 - 256x192
								;          %01 - 320x200
								;          %10 - 320x240
								;          %11 - 360x288
								;   [5-2]: %0000
								;   [1-0]: %00 - ZX
								;          %01 - 16c
								;          %10 - 256c
								;          %11 - txt

;---------------------------------------
pluginStart	push	hl,de,bc,af,ix
		call	txtModeInit

		call	storePalette

		ld	a,#00					; Включаем страницу с текстовым режимом
		call	setVideoPage

		call	clearTxtScreen				; Очищаем текстовую область


		ld	a,#01					; #01 - 1й видео буфер (16 страниц)
		call	setVideoBuffer

		ld	a,%10000011				; переключаем разрешайку на 320x240 TXT
		call	setVideoMode

		ld	hl,sBootMsg
		ld	de,#c000
		ld	bc,eBootMsg-sBootMsg
		ldir						; Выводим надпись

		call	pathToRoot				; Сбрасывает текущий путь в начало

		ld	hl,systemPath
		call	searchEntry
		jr	z,pathNotFound				; Ошибка: отсутствует директория system

		call	setDirBegin				; 

		ld	hl,kernelFile
		call	searchEntry
		jr	z,kernelNotFound			; Ошибка: отсутствует файл kernel.sys

		call	setFileBegin				; [DE,HL] - file length

		ld	a,#04					; Включаем страницу для загрузки ядра
		call	setVideoPage

		ld	hl,#c000
		ld	b,32					; Тупо грузим 32 блока по 512б = 16384
		call	load512bytes

		ld	a,#00					; Включаем страницу с текстовым режимом
		call	setVideoPage

		ld	hl,sStartingMsg
		ld	de,#c100
		ld	bc,eStartingMsg-sStartingMsg
		ldir						; Выводим надпись

		ld	a,#04
		call	setVideoPage

		ld	hl,sRunKernel
		ld	de,#0000
		ld	bc,eRunKernel-sRunKernel
		ldir

		ld	hl,#c000
		ld	de,#8000
		ld	bc,#4000
		jp	#0000

pathNotFound	ld	hl,sWrongPathMsg
		ld	de,#c100
		ld	bc,eWrongPathMsg-sWrongPathMsg
		ldir						; Выводим надпись
		jp	$

kernelNotFound	ld	hl,sWrongKernelMsg
		ld	de,#c100
		ld	bc,eWrongKernelMsg-sWrongKernelMsg
		ldir						; Выводим надпись
		jp	$

;---------------------------------------
setVideoBuffer	ex	af,af'					; #01 - 1й видео буфер (16 страниц)
		ld	a,_MNGV_PL				; #02 - 2й видео буфер (16 страниц)
		jp	wcKernel

;---------------
setVideoMode	ex	af,af'
		ld	a,_GVmod
		jp	wcKernel

;---------------
setVideoPage	ex	af,af'					; #00-#0F - страницы из 1го видео буфера
		ld	a,_MNGCVPL				; #10-#1F - страницы из 2го видео буфера
		jp	wcKernel

;---------------
setRamPage	ex	af,af'					; A' - номер страницы (от 0)
		ld	a,_MNGC_PL				; #FE - первый текстовый экран (в нём панели)
		jp	wcKernel				; #FF - страница с фонтом (1го текстового экрана)

;---------------
pathToRoot	ld	d,#ff					; окрываем поток с устройством (#00 = инициализация, #ff = сброс в root)
		ld	bc,#ffff				; устройство (#ffff = не создавать заново, использовать текущий поток)
		ld	a,_STREAM
		jp	wcKernel

;---------------
searchEntry	ld	a,_FENTRY
		jp	wcKernel

;---------------
setFileBegin	ld	a,_GFILE
		jp	wcKernel
;---------------
setDirBegin	ld	a,_GDIR
		jp	wcKernel

;---------------
load512bytes	ld	a,_LOAD512
		jp	wcKernel

;---------------
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

;---------------
txtModeInit	ld	a,#ff					; Включаем страницу со страндартным фонтом WC
		call	setRamPage
					
		ld	hl,#c000				; Сохраняем копию шрифта в #0000
		ld	de,#0000
		ld	bc,2048
		ldir
		
		ld	a,#01					; Включаем страницу с нашим фонтом
		call	setVideoPage
		
		ld	hl,#0000				; Клонируем шрифт из #0000
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

;---------------
storePalette	ld	a,palBank				; Включаем страницу для сохранения текстовой палитры
		call	setVideoPage

		ld 	de,palAddr
		call	dupPal

		ld	a,gPalBank1				; Включаем страницу для сохранения графической палитры
		call	setVideoPage

		ld 	de,gPalAddr1
		call	dupPal
		ret

;---------------
sRunKernel	ldir
		pop	ix,af,bc,de,hl
		jp	#8000
eRunKernel
;---------------------------------------
sBootMsg	db	"[CLi",#FD,"] Try to boot /system/kernel.sys..."
eBootMsg

sWrongPathMsg	db	"Error: System path not found!"
eWrongPathMsg

sWrongKernelMsg	db	"Error: kernel.sys not found!"
eWrongKernelMsg

sStartingMsg	db	"Kernel is loaded. Starting..."
eStartingMsg

lastPost	dw	#0000

systemPath	db	flagDir, "system",#00
kernelFile	db	flagFile,"kernel.sys",#00

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
;---------------------------------------
pluginEnd
		ENT

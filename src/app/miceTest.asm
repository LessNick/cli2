;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
; micetest - application for test kempstone mouse
;---------------------------------------
		org	#c000-4

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API

		include "system/tsconf.h.asm"			; Временно
		include "system/wc.h.asm"			; Временно
appStart	
		db	#7f,"CLA"				; Command Line Application

		call	miceTestVer
		call	miceTestRun

		ld	hl,miceCallBack
		ld	a,setAppCallBack
		call	cliKernel

		ld	hl,319					; Ширина и высота в пикселях (для текстового режима)
		ld	de,239					; на 1 меньше (320x240)
		ld	a,mouseInit
		call	cliDrivers

		call	prepareCursor

miceLoop	halt
		call	updateCursor

		ld	a,getKeyWithShift
		call	cliKernel

		cp	aEsc
		jp	z,miceStop

		call	setTracker

		call	setMicePos

		ld 	hl,micePosMsg
		ld	a,printInputString
		call	cliKernel

		jp	miceLoop

;---------------------------------------------
prepareCursor	ld	bc,tsRAMPage0				; Подключаем страницу sprBank адреса #0000
		ld	a,sprBank
		out	(c),a

		ld	hl,#0000
		ld	de,#0001
		ld	bc,#3fff
		xor	a
		ld	(hl),a
		ldir

		ld	hl,miceCursor
		ld	de,#0000
		ld	b,11
prepareLoop	push	bc
		ld	bc,6
		ldir
		ex	de,hl
		ld	bc,250
		add	hl,bc
		ex	de,hl
		pop	bc
		djnz	prepareLoop

		ld	bc,tsSGPage				; Указываем страницу для спрайтов
		ld	a,sprBank
		out	(c),a

		ld	bc,tsRAMPage0				; Подключаем страницу sprBank адреса #0000
		ld	a,(_PAGE0)				; Восстанавливаем банку для WildCommander
		out	(c),a

updateCursor	ld	bc,tsFMAddr
		ld 	a,%00010000				; Разрешить приём данных (?) Bit 4 - FM_EN установлен
		out	(c),a

		ld	hl,cursorSFile
		ld 	de,#0000+512				; Память с палитрой замапливается на адрес #0000
		ld	bc,6
		ldir

		ld	bc,tsFMAddr
		xor	a					; Запретить, Bit 4 - FM_EN сброшен
		out	(c),a

		ld	bc,tsConfig				; Включаем отображение спрайта
			  ;76543210
		ld	a,%10000000				; bit 7 - S_EN Sprite Layers Enable
		out	(c),a

		ret

;---------------------------------------------
setMicePos	ld	a,getMouseDeltaX
		call	cliDrivers

		ld	b,"+"
		ld	c,"-"

		bit	7,h
		ld	a,b
		ld	(rawXMsg-1),a
		jr	z,micePlusXSkip
		ld	a,c

		ld	(rawXMsg-1),a
		ld	h,#00
		ld	a,255
		sub	l
		and	%01111111
		ld	l,a

micePlusXSkip	ld	de,rawXMsg
		ld	a,char2str
		call	cliKernel
;---------------
		ld	a,getMouseRawX
		call	cliDrivers
		
		ld	de,rawXMsg+4
		ld	a,char2str
		call	cliKernel
;---------------
		ld	a,getMouseDeltaY
		call	cliDrivers

		ld	b,"+"
		ld	c,"-"

		bit	7,h
		ld	a,b
		ld	(rawYMsg-1),a
		jr	z,micePlusYSkip
		ld	a,c

		ld	(rawYMsg-1),a
		ld	h,#00
		ld	a,255
		sub	l
		and	%01111111
		ld	l,a

micePlusYSkip	ld	de,rawYMsg
		ld	a,char2str
		call	cliKernel
;---------------
		ld	a,getMouseRawY
		call	cliDrivers
		
		ld	de,rawYMsg+4
		ld	a,char2str
		call	cliKernel
;---------------
		ld	a,getMouseWheel
		call	cliDrivers

		ld	de,posWheelMsg
		ld	a,fourbit2str
		call	cliKernel
;---------------
		ld	a,getMouseButtons
		call	cliDrivers
		push	af

		ld	b,15
		ld	c,16
		and	%00000001
		cp	%00000001
		ld	a,b
		jr	nz,miceLSet
		ld	a,c
miceLSet	ld	(leftButtonMsg),a

		pop	af
		push	af
		and	%00000010
		cp	%00000010
		ld	a,b
		jr	nz,miceRSet
		ld	a,c
miceRSet	ld	(rightButtonMsg),a

		pop	af
		and	%00000100
		cp	%00000100
		ld	a,b
		jr	nz,miceMSet
		ld	a,c
miceMSet	ld	(middleButtonMsg),a
;---------------
		ld	a,getMouseX
		call	cliDrivers
		
		ld	a,l
		ld	(cursorSFileX),a
		ld	a,h
		and	%00000001
		or	%00100010
		ld	(cursorSFileX+1),a

		ld	de,posXMsg
		ld	a,int2str
		call	cliKernel
;---------------		
		ld	a,getMouseY
		call	cliDrivers

		ld	a,l
		ld	(cursorSFile),a
		ld	a,h
		and	%00000001
		or	%00100010
		ld	(cursorSFile+1),a

		ld	de,posYMsg
		ld	a,int2str
		jp	cliKernel

;---------------------------------------------
setTracker	ld	hl,(timeCount)
		inc	hl
		ld	(timeCount),hl
		ld	de,timeCountMsg
		ld	a,int2str
		jp	cliKernel

;---------------------------------------------
miceCallBack	cp	#00					; активирован текстовый режим?
		jr	nz,miceCallGfx
		ld	hl,319					; да
		ld	de,239
		jr	miceCallUpdate

miceCallGfx	ld	hl,359					; нет, графический
		ld	de,287

miceCallUpdate	ld	a,mouseInit
		call	cliDrivers
		jp	updateCursor

;---------------------------------------------
miceStop	ld	a,editInit
		call	cliKernel

		ld	hl,miceExitMsg
		ld	a,printString
		call	cliKernel

		ld	bc,tsConfig				; Выключаем отображение спрайта
			  ;76543210
		ld	a,%00000000				; bit 7 - S_EN Sprite Layers Enable
		out	(c),a

		ld	a,printRestore
		jp	cliKernel
;---------------------------------------------
miceTestRun	ld	hl,miceRunMsg			
		ld	a,printString
		jp	cliKernel

;---------------------------------------------
miceTestVer	ld	hl,miceVersionMsg			
		ld	a,printAppNameString
		call	cliKernel

		ld	hl,miceCopyRMsg
		ld	a,printCopyrightString
		jp	cliKernel
		
;---------------------------------------------
miceVersionMsg	db	"Kempstone mouse test v0.12",#00
miceCopyRMsg	db	"2013,2014 ",127," Breeze\\\\Fishbone Crew",#0d,#00

miceRunMsg	db	15,6
		db	"(\\\\/)",#0d
		db	" \\\\/\\\\",#0d
		db	" /__)",#0d
		db	"   (_  Move your mouse...",#0d,#0d
		db	16,16
		db	#00

miceExitMsg	db	15,5,"Exit.",#0d
		db	16,16
		db	#00

micePosMsg	db	15,5,"Raw: X=",16,16,"+"
rawXMsg		db	"---[---]"

		db	15,17,", ",15,5,"Y=",16,16,"+"
rawYMsg		db	"---[---]"

		db	15,17,", ",15,5,"wheel=",16,16
posWheelMsg	db	"--"

		db	15,17," | "
		db	15
leftButtonMsg	db	15,"L"
		db	15
middleButtonMsg	db	15,"M"
		db	15
rightButtonMsg	db	15,"B"

		db	15,17," | ",15,5,"Pos: X=",16,16
posXMsg		db	"-----"

		db	15,17,", ",15,5,"Y=",16,16
posYMsg		db	"-----"
		
		db	15,17," | ",15,5,"T=",16,16
timeCountMsg	db	"-----"
		db	#00
;---------------------------------------------
timeCount	dw	#0000
;---------------------------------------------
cursorSFile	db	#00			; Y0-7     | 8 bit младшие даные Y координаты (0-255px)
			;FLAR S Y8
		db	%00100010		; Y8       | 0й бит - старшие данные Y координаты (256px >)
						; YS       | 1,2,3 бит - высота в блоках по 8 px
						; RESERVED | 4й бит - зарезервирован
						; ACT      | 5й бит - спрайт активен (показывается)
						; LEAP     | 6й бит - указывает, что данный спрайт последний в текущем слое. (для перехода по слоям)
						; YF       | 7й бит - указывает, что данный спрайт нужно отобразить зеркально по вертикали
		
cursorSFileX	db	#00			; X0-7     | 8 bit младшие даные X координаты (0-255px)
			;F  R S X8
		db	%00000010		; X8       | 0й бит - старшие данные X координаты (256px >)
						; XS       | 1,2,3 бит - ширина в блоках по 8 px
						; RESERVED | 4й бит - зарезервирован
						; -        | 5,6й бит - не используются
						; XF       | 7й бит - указывает, что данный спрайт нужно отобразить зеркально по горизонтали
			;TNUM
		db	%00000000		; TNUM	   | Номер тайла для левого верхнего угла.
						;          | 0,1,2,3,4,5й бит - Х координата в битмап
			;SPALTNUM		;          | 6,7й бит +
; 		db	%00010000		; TNUM     | 0,1,2,3 бит - Y координата в битмап
		db	%00000000		; TNUM     | 0,1,2,3 бит - Y координата в битмап
						; SPAL     | 4,5,6,7й биты номер палитры (?)
;---------------------------------------------
miceCursor	db	#be,#00,#00,#00,#00,#00
		db	#1b,#ee,#00,#00,#00,#00
		db	#01,#bb,#ee,#00,#00,#00
		db	#01,#bb,#bb,#ee,#00,#00
		db	#00,#1b,#bb,#bb,#ee,#00
		db	#00,#1b,#bb,#bb,#bb,#00
		db	#00,#01,#bb,#be,#00,#00
		db	#00,#01,#bb,#1b,#e0,#00
		db	#00,#00,#1b,#01,#be,#00
		db	#00,#00,#1b,#00,#1b,#e0
		db	#00,#00,#00,#00,#01,#b0
		db	#00,#00,#00,#00,#00,#00
 		db	#00,#00,#00,#00,#00,#00
 		db	#00,#00,#00,#00,#00,#00
 		db	#00,#00,#00,#00,#00,#00
 		db	#00,#00,#00,#00,#00,#00

appEnd	nop

		SAVEBIN "install/bin/micetest", appStart, appEnd-appStart
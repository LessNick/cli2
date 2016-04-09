;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; micetest - application for test kempstone mouse
;---------------------------------------
		org	#c000-4

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API

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

miceLoop	halt
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
		ld	a,getMouseDeltaW
		call	cliDrivers

		ld	b,"+"
		ld	c,"-"

		bit	7,h
		ld	a,b
		ld	(rawWMsg-1),a
		jr	z,micePlusWSkip
		ld	a,c

		ld	(rawWMsg-1),a
		ld	h,#00
		ld	a,255
		sub	l
		and	%01111111
		ld	l,a

micePlusWSkip	ld	de,rawWMsg
		ld	a,char2str
		call	cliKernel
;---------------		
		ld	a,getMouseRawW
		call	cliDrivers
		
		ld	de,rawWMsg+4
		ld	a,char2str
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
		push	af
		and	%00000100
		cp	%00000100
		ld	a,b
		jr	nz,miceMSet
		ld	a,c
miceMSet	ld	(middleButtonMsg),a
		pop	af
		
		bit	0,a
		jr	z,cursorType_2
		ld	a,1
		jr	newCursorSet

cursorType_2	bit	1,a
		jr	z,cursorType_3
		ld	a,2
		jr	newCursorSet

cursorType_3	bit	2,a
		jr	z,cursorType_0
		ld	a,3
		jr	newCursorSet

cursorType_0	xor	a
newCursorSet	ex	af,af'
		ld	a,setMouseCursor
		call	cliKernel
;---------------
		ld	a,getMouseX
		call	cliDrivers

		ld	de,posXMsg
		ld	a,int2str
		call	cliKernel
;---------------		
		ld	a,getMouseY
		call	cliDrivers

		ld	de,posYMsg
		ld	a,int2str
		call	cliKernel

;---------------		
		ld	a,getMouseW
		call	cliDrivers

		ld	de,posWMsg
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
miceCallBack	ret						; Обработчик CallBack при переключении экранов ALT+F1/F4

;---------------------------------------------
miceStop	ld	a,editInit
		call	cliKernel

		ld	hl,micePosMsg
		ld	a,printString
		call	cliKernel

		ld	hl,miceExitMsg
		ld	a,printString
		call	cliKernel

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
miceVersionMsg	db	"Kempstone mouse test v0.16",#00
miceCopyRMsg	db	"2013,2016 ",pCopy," Breeze\\\\Fishbone Crew",#0d,#00

miceRunMsg	db	15,csHelp
		db	"(\\\\/)",#0d
		db	" \\\\/\\\\",#0d
		db	" /__)",#0d
		db	"   (_  Click, Scroll & Move your mouse...",#0d,#0d
		db	16,cLemonCream
		db	psTL
		ds	13,psMH
		db	" Raw Data "
		ds	14,psMH
		db	psTR
		db	16,cLightPurplePink
		db	psTL
		ds	10,psMH
		db	" Real Data "
		ds	10,psMH
		db	#bf
		db	16,cOrangeDawn,psTL
		db	"Timer"
		db	psTR,#0d
		db	16,cRestore
		db	#00

miceExitMsg	db	#0d,#0d,15,csOk,"Exit.",#0d
		db	16,cRestore
		db	#00

micePosMsg	db	15,csOk," X=",16,cRestore,"+"
rawXMsg		db	"---[---]"

		db	15,csFrames,", ",15,5,"Y=",16,cRestore,"+"
rawYMsg		db	"---[---]"

		db	15,csFrames,", ",15,5,"W=",16,cRestore,"+"
rawWMsg		db	"---[---]"

		db	15,csInfo,"  ["
		db	15
leftButtonMsg	db	15,"L"
		db	15
middleButtonMsg	db	15,"M"
		db	15
rightButtonMsg	db	15,"B"

		db	15,15,"] ",15,5,"X=",16,cRestore
posXMsg		db	"-----"

		db	15,csFrames,", ",15,5,"Y=",16,cRestore
posYMsg		db	"-----"

		db	15,csFrames,", ",15,5,"W=",16,cRestore
posWMsg		db	"-----"
		
		db	15,csFrames,"  ",16,cRestore
timeCountMsg	db	"-----"
		db	#00
;---------------------------------------------
timeCount	dw	#0000
;---------------------------------------------
appEnd	nop

		SAVEBIN "install/bin/micetest", appStart, appEnd-appStart

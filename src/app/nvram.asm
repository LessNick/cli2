;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
; nvram - info & tool application
;---------------------------------------
		org	#c000-4

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API

appStart	
		db	#7f,"CLA"				; Command Line Application
		
		xor	a
		ld	(nvramPos),a

		ld	a,(hl)
		cp	#00
		jr	z,nvramShowInfo				; exit: error params

		ex	de,hl
		ld	a,eatSpaces
		call	cliKernel
		ex	de,hl

		ld	a,disableNvram
		call	cliKernel

		ld	de,keyTable
		ld	a,checkCallKeys
		call	cliKernel

		push	af
		ld	a,enableNvram
		call	cliKernel
		pop	af
		
		cp	#ff
		jp	z,nvramShowInfo				; Выход. Вывод информации о программе

nvramExit	ld	a,printRestore
		jp	cliKernel
;---------------------------------------------
nvramShowInfo	call	nvramVer				; Вывод информации о программе
		call	nvramHelp
		jp	nvramExit

nvramVer	ld	hl,nvramVersionMsg			
		ld	a,printAppNameString
		call	cliKernel

		ld	hl,nvramCopyRMsg
		ld	a,printCopyrightString
		call	cliKernel
		ret

nvramHelp	ld	hl,nvramUsageMsg
		ld	a,printString
		call	cliKernel
		ret

;---------------
nvramShowDump	ld	hl,nvramLine
		ld	a,printString
		call	cliKernel

		ld	hl,nvramHeader
		ld	a,printString
		call	cliKernel

		ld	hl,nvramLine
		ld	a,printString
		call	cliKernel

		ld	a,nvRamOpen
		call	cliKernel

		ld	a,#00
nvramShowLoop	push	af

		ld	h,#00
		ld	l,a
		ld	a,16
		ex	af,af'
		ld	a,mult16x8
		call	cliKernel
		
		ld	a,l
		ex	af,af'
		ld	de,nvramAddr
		ld	a,char2hex
		call	cliKernel

		xor	a
		ld	(nvramStrPos),a

		ld	b,16
nvramShowLoop2	push	bc
		ld	a,(nvramPos)
		ex	af,af'
		ld	a,nvRamGetData
		call	cliKernel
		
		push	af

		ld	hl,nvramDump
		ld	a,(nvramStrPos)
		ld	b,a
		add	a,a
		add	a,b
		ld	e,a
		ld	d,#00
		add	hl,de
		ex	de,hl
		
		pop	af
		push	af
		ex	af,af'
		ld	a,char2hex
		call	cliKernel
;---------------
		ld	hl,nvramAscii+6
		ld	a,(nvramStrPos)
		add	a,a
		add	a,a
		add	a,a
		ld	e,a
		ld	d,#00
		add	hl,de
		ex	de,hl
		pop	af
		ex	af,af'
		ld	a,char2hex
		call	cliKernel

		ld	a,(nvramPos)
		inc	a
		ld	(nvramPos),a
		ld	a,(nvramStrPos)
		inc	a
		ld	(nvramStrPos),a
		pop	bc
		djnz	nvramShowLoop2

		ld	hl,nvramData
		ld	a,printString
		call	cliKernel
		pop	af
		inc	a
		cp	#10
		jr	nz,nvramShowLoop

		ld	hl,nvramLine
		ld	a,printString
		call	cliKernel

		ld	a,ps2Init
		call	cliKernel

		ld	a,nvRamClose
		call	cliKernel

		jp	nvramExit

;---------------
nvramClear	ld	a,printInputYN
		ld	hl,nvramClearMsg
		call	cliKernel
		cp	"y"
		jr	z,nvramClearYes

		ld	a,printErrorString
		ld	hl,abortedMsg
		jp	cliKernel

nvramClearYes	ld	a,nvRamOpen
		call	cliKernel

		xor	a
nvramClearLoop	push	af
		ex	af,af'
		ld	l,#00
		ld	a,nvRamSetData
		call	cliKernel
		pop	af
		inc	a
		cp	#f0
		jr	nz,nvramClearLoop
		
		ld	a,nvRamClose
		call	cliKernel

		ld	a,printOkString
		ld	hl,cleanedMsg
		jp	cliKernel

;---------------
nvramGet	ld	a,getHexFromParams
		call	cliKernel
		cp	#ff
		jr	z,wrongParams

		push	de

		ld	a,l

		push	af
		ld	a,nvRamOpen
		call	cliKernel
		pop	af
		ex	af,af'
		ld	a,nvRamGetData
		call	cliKernel

		ex	af,af'
		ld	de,nvramGetMsg+1
		ld	a,char2hex
		call	cliKernel

		ld	hl,nvramGetMsg
		ld	a,printString
		call	cliKernel

		ld	a,nvRamClose
		call	cliKernel

		pop	de
		
		ld	a,#fe					; Пропустить следующее значение
		ret

;---------------
nvramSet	ld	a,getHexPairFromParams
		call	cliKernel
		cp	#ff
		jr	z,wrongParams
		push	de					; h - cell , l - value
		push	hl
		ld	a,nvRamOpen
		call	cliKernel
		pop	hl
		ld	a,h
		ex	af,af'
		ld	a,nvRamSetData
		call	cliKernel
		ld	a,nvRamClose
		call	cliKernel
		pop	de
		ld	a,#fe					; Пропустить следующее значение
		ret

;---------------------------------------------
wrongParams	ld	hl,wrongParamsMsg
		ld	a,printErrorString
		jp	cliKernel

;---------------------------------------------
nvramVersionMsg	db	"NVRAM (CMOS) Info & tool v0.04",#00
nvramCopyRMsg	db	"2013,2015 ",pCopy," Breeze\\\\Fishbone Crew",#00
		
nvramUsageMsg	db	#0d,15,csOk,"Usage: nvram switches",#0d
		db	16,cRestore,"  -d ",15,csInfo,"\t\tdump. show nvram dump",#0d
		db	16,cRestore,"  -g #nn",15,csInfo,"\tget value. read value from nvram's cell at #nn (hex)",#0d
		db	16,cRestore,"  -s #nn,#vv ",15,csInfo,"\tset value. write value #vv (hex) to nvram's cell at #nn(hex)",#0d
		db	16,cRestore,"  -c ",15,csInfo,"\t\tclear. set all values of nvram to #00",#0d
		db	16,cRestore,"  -v ",15,csInfo,"\t\tversion. show application's version and copyrights",#0d
		db	16,cRestore,"  -h ",15,csInfo,"\t\thelp. show this info"
		db	16,cRestore,#0d,#00

nvramHeader	db	#0d,15,5," Addr ",15,csFrames,"|",15,csOk,"  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F ",15,csFrames,"|",15,csOk," 0123456789ABCDEF",#00
nvramLine	db	15,csFrames,#0d,"---------------------------------------------------------------------------",#00

nvramData	db	#0d,16,16," 00"
nvramAddr	db	"00 ",15,csFrames,"| ",16,cRestore
nvramDump	db	"00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ",15,csFrames,"| ",16,cRestore
nvramAscii	dup	16
		db	"\\x5c\\x20"
		edup
		db	#00

nvramGetMsg	db	"#--",#0d,#00

wrongParamsMsg	db	"Error: Wrong parametrs.",#0d,#00

nvramClearMsg	db	"Clear all values of nvram, are you sure? (y/n)",#0d,#00

abortedMsg	db	"Aborted.",#0d,#00
cleanedMsg	db	"Successfully cleaned.",#0d,#00

;---------------------------------------------
; Key's table for params
;---------------------------------------------
keyTable	db	"-g"
		db	"*"
		dw	nvramGet

		db	"-d"
		db	"*"
		dw	nvramShowDump

		db	"-h"
		db	"*"
		dw	nvramShowInfo

		db	"-c"
		db	"*"
		dw	nvramClear

		db	"-s"
		db	"*"
		dw	nvramSet

		db	"-v"
		db	"*"
		dw	nvramVer

;--- table end marker ---
		db	#00

;---------------------------------------------
nvramPos	db	#00
nvramStrPos	db	#00

appEnd	nop
; 		DISPLAY "nvramGet",/A,nvramGet

		SAVEBIN "install/bin/nvram", appStart, appEnd-appStart

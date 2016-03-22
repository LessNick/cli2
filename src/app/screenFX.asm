;---------------------------------------
; CLi² (Command Line Interface)
; 2014,2016 © breeze/fishbone crew
;---------------------------------------
; screenFX - сборник эффектов для работы с экранами
;--------------------------------------		
		org	#c000-4

		include "system/tsconf.h.asm"			; Список комманд TSCONF API

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API

appStart	
		db	#7f,"CLA"				; Command Line Application

		ld	a,(hl)
		cp	#00
		jp	z,appNoParams				; exit: no params

		ex	de,hl
		ld	a,eatSpaces
		call	cliKernel
		ex	de,hl

		ld	de,keyTable
		ld	a,checkCallKeys
		call	cliKernel

		cp	#ff
		jp	z,appNoParams				; Выход. Вывод информации о программе

appCheck	ld	a,#00
		cp	#01
		ret	z
		jp	appNoParams				; Не заданы команды. Вывод информации о программе

;---------------
fxSetScreen	ld	a,getNumberFromParams
		call	cliKernel
		cp	#ff
		jp	z,wrongParams

		ld	a,h
		cp	#00
		jp	nz,wrongParams
		
		ld	a,l
		cp	#04
		jr	c,fxSetScreen_0
		jp	wrongParams

fxSetScreen_0	ld	a,l
		ld	(fxScr_00+1),a
		ld	(vmMode+1),a

		ld	a,#fe					; Пропустить следующее значение
		ret
;---------------

fxFadeIn	call	preparePal
		ld	hl,emptyBuffer
		ld	de,emptyBuffer+1
		ld	bc,511
		xor	a
		ld	(hl),a
		ldir
		
		ld	hl,emptyBuffer
		ld	a,setPalNow
		call	cliKernel

		ld	a,24
		ld	(currentInColor),a

fxfiLoop	ld	b,2					; задержка
fxfiWait	halt
 		djnz	$-1

		call	incPal	
		ld	hl,emptyBuffer
		ld	a,setPalNow
		call	cliKernel

		ld	a,(currentInColor)
		dec	a
		ld	(currentInColor),a
		cp	#ff					; 25 цветов
		jr	nz,fxfiLoop

;---------------
fxCmdExit	ld	a,#01
		ld	(appCheck+1),a
		xor	a					; Обязательно должно быть 0!!!
		ret

;---------------
fxFadeOut	call	preparePal
		ld	hl,palBuffer
		ld	a,setPalNow
		call	cliKernel
		
		ld	b,25					; 25 цветов
fxfoLoop	push	bc
		call	decPal

		ld	b,2					; задержка
fxfoWait	halt
		djnz	$-1

		ld	hl,palBuffer
		ld	a,setPalNow
		call	cliKernel
		pop	bc
		djnz	fxfoLoop

		jr	fxCmdExit

;---------------
preparePal	ld	hl,palBuffer				; буфер куда прочитать палитру
fxScr_00	ld	b,#01					; номер экрана для которого надо прочитать палитру
		ld	a,getGfxPalette
		call	cliKernel
		
		halt
vmMode		ld	b,#01
		ld	c,#01					; не включать палитру
		ld	a,switchGfxMode
		jp	cliKernel

;---------------
decPal		ld	hl,palBuffer
		ld	b,0					;512/2 = 256
		
decLoop		ld	a,(hl)					; B
		; RRrrrGGgggBBbbb
		and	%00011111				; взяли Blue
		cp	#00
		jr	z,decSkip_00				; если уже 0 - ничего
		dec	a					; уменьшили на 1
decSkip_00	ld	e,a					; сохранили Blue в E
		ld	a,(hl)					; G2
		; RRrrrGGgggBBbbb
		and	%11100000				; взяли Green младшую часть
		rlc	a
		rlc	a
		rlc	a					; сместили по кругу 3 бита 3 раза 2,1,0й
		ld	d,a					; сохранили Green младшую часть в D
		inc	hl
		ld	a,(hl)					; G1
			; RRrrrGGgggBBbbb
		and	%00000011				; взяли Green старшую часть
		sla	a
		sla	a
		sla	a					; сместили 2 бита 3 раза влево залив нулями 2,1,0й
		or	d					; полное Green
		cp	#00					
		jr	z,decSkip_01				; если уже 0 - ничего
		dec	a					; уменьшили на 1
decSkip_01	ld	c,a					; сохранили полное Green в C
		ld	a,(hl)					; взяли Red
			; RRrrrGGgggBBbbb
		and	%01111100
		srl	a
		srl	a					; сместили 2 бита вправо залив нулями 6,5й
		cp	#00					
		jr	z,decSkip_02				; если уже 0 - ничего
		dec	a					; уменьшили на 1
decSkip_02	sla	a
		sla	a					; сместили 2 бита влево залив нулями 1,0й
		ld	(hl),a					; сохранили по адресу в (HL)
		ld	a,c					
		;	    GGggg
		and	%00011000				; взяли старшую часть Green
		srl	a
		srl	a
		srl	a					; сместили 2 бита 3 раза вправо залив нулями
		or	(hl)					; объединили с Red
		ld	(hl),a					; сохранили Red + старшую часть Green

		ld	a,c					
		;	    GGggg
		and	%00000111				; взяли младшую часть Green
		rrc	a
		rrc	a
		rrc	a					; сместили по кругу 3 бита 3 раза 2,1,0й
		or	e					; объединили с Blue
		push	hl
		dec	hl
		ld	(hl),a					; сохранили младшую часть Green + Blue
		pop	hl
		inc	hl
		djnz	decLoop
		ret

;---------------
incPal		ld	hl,emptyBuffer
		ld	b,0					;512/2 = 256
		
incLoop		push	hl
		inc	h
		inc	h
		ld	a,(hl)
		and	%00011111				; взяли оригинальное значение Blue
		ld	(checkBlue+1),a
		ld	a,(hl)
		and	%11100000				; взяли оригинальное значение Green младшую часть
		rlc	a
		rlc	a
		rlc	a
		ld	(checkGreen_0+1),a
		pop	hl

		ld	a,(hl)					; B
		; RRrrrGGgggBBbbb
		and	%00011111				; взяли Blue
		push	af
		ld	a,(currentInColor)
checkBlue	cp	24
		jr	nc,incSkip_00				; если уже 24 - ничего
		pop	af
		inc	a					; уменьшили на 1
		jr	incSkip_00+1
incSkip_00	pop	af
		ld	e,a					; сохранили Blue в E
		ld	a,(hl)					; G2
		; RRrrrGGgggBBbbb
		and	%11100000				; взяли Green младшую часть
		rlc	a
		rlc	a
		rlc	a					; сместили по кругу 3 бита 3 раза 2,1,0й
		ld	d,a					; сохранили Green младшую часть в D
		inc	hl

		push	hl
		inc	h
		inc	h
		ld	a,(hl)
		and	%00000011				; взяли оригинальное значение Green старшую часть
		sla	a
		sla	a
		sla	a
checkGreen_0	or	#00
		ld	(checkGreen+1),a
		pop	hl

		ld	a,(hl)					; G1
			; RRrrrGGgggBBbbb
		and	%00000011				; взяли Green старшую часть
		sla	a
		sla	a
		sla	a					; сместили 2 бита 3 раза влево залив нулями 2,1,0й
		or	d
		push	af
		ld	a,(currentInColor)					; полное Green
checkGreen	cp	24					
		jr	nc,incSkip_01				; если уже 24 - ничего
		pop	af
		inc	a
		jr	incSkip_01+1

incSkip_01	pop	af
		ld	c,a					; сохранили полное Green в C

		push	hl
		inc	h
		inc	h
		ld	a,(hl)
		and	%01111100				; взяли оригинальное значение Red
		srl	a
		srl	a
		ld	(checkRed+1),a
		pop	hl

		ld	a,(hl)					; взяли Red
			; RRrrrGGgggBBbbb
		and	%01111100
		srl	a
		srl	a					; сместили 2 бита вправо залив нулями 6,5й
		
		push	af
		ld	a,(currentInColor)
checkRed	cp	24					
		jr	nc,incSkip_02				; если уже 24 - ничего
		pop	af
		inc	a
		jr	incSkip_02+1

incSkip_02	pop	af
		sla	a
		sla	a					; сместили 2 бита влево залив нулями 1,0й
		ld	(hl),a					; сохранили по адресу в (HL)
		ld	a,c					
		;	    GGggg
		and	%00011000				; взяли старшую часть Green
		srl	a
		srl	a
		srl	a					; сместили 2 бита 3 раза вправо залив нулями
		or	(hl)					; объединили с Red
		ld	(hl),a					; сохранили Red + старшую часть Green

		ld	a,c					
		;	    GGggg
		and	%00000111				; взяли младшую часть Green
		rrc	a
		rrc	a
		rrc	a					; сместили по кругу 3 бита 3 раза 2,1,0й
		or	e					; объединили с Blue
		push	hl
		dec	hl
		ld	(hl),a					; сохранили младшую часть Green + Blue
		pop	hl
		inc	hl
		dec	b
		ld	a,b
		cp	#00
		jp	nz,incLoop
		ret

;---------------
appNoParams	call	appVer
		jr	appInfo

appVer		ld	hl,appVersionMsg
		ld	a,printAppNameString
		call	cliKernel

		ld	hl,appCopyRMsg
		ld	a,printCopyrightString
		call	cliKernel
		ret

appInfo		ld	hl,appUsageMsg
		ld	a,printOkString
		call	cliKernel
		ret
;---------------------------------------------
wrongParams	ld	hl,wrongParamsMsg
		ld	a,printErrorString
		call	cliKernel
		ret
;---------------
appVersionMsg	db	"ScreenFX (some screen effects) v0.04",#00
appCopyRMsg	db	"2014,2016 ",127," Breeze\\\\Fishbone Crew",#0d,#00

appUsageMsg	db	15,5,"Usage: screenfx switches",#0d
		db	16,16,"  -s n",15,15,"\tscreen number. set work screen (default 1)",#0d
		db	16,16,"  -fi ",15,15,"\tswitch to current screen and show it with fade in effect",#0d
		db	16,16,"  -fo ",15,15,"\tswitch to current screen and hide it with fade out effect"
		db	16,16,#0d,#00

wrongParamsMsg	db	"Error: Wrong parametrs.",#0d,#0d,#00

currentInColor	db	#00
;---------------------------------------------
; Key's table for params
;---------------------------------------------
keyTable
		db	"-s"
		db	"*"
		dw	fxSetScreen

		db	"-fi"
		db	"*"
		dw	fxFadeIn

		db	"-fo"
		db	"*"
		dw	fxFadeOut

;--- table end marker ---
		db	#00

;---------------------------------------------
appEnd	nop
		org	#f000
emptyBuffer	ds	512,#00

		org	#f200
palBuffer	ds	512,#00

; 		DISPLAY "decPal",/A,decPal

		SAVEBIN "install/bin/screenfx", appStart, appEnd-appStart
		
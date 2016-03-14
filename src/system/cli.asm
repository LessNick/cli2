;---------------------------------------
; CLi² (Command Line Interface) main code
; 2013,2016 © breeze/fishbone crew
;---------------------------------------

coldStart	jp	_coldStart				; #8000: Первая точка входа
cliApi		jp	_cliApi					; #8003: Точка входа для вызова функций API
driversApi	jp	_driversApi				; #8006: Точка входа для вызова функций драйверов
gliApi		jp	_gliApi					; #8009: Точка входа для вызова функций графической библиотеки

_coldStart	ld	(storeIx),ix				; Сохраняем значение IX для WildCommander
		call	_storeWcInt				; Сохраняем INT WildCommander'а

		halt
startSwith	ld	a,#00					; Проверка при первом старте (холодном) необходимо загрузить недостающие компоненты
		cp	#01
		jr	z,warmStart

		ld	a,initSystem				; Начальная инициализация системы и загрузка всех компонентов
		call	_cliApi

		ld	a,#01					; Все компоненты успешно загружены и последующий вызов не требуется
		ld	(startSwith+1),a

		jr	contStart

warmStart	ld	a,reInitSystem
		call	_cliApi

contStart	ld	hl,promptMsg				; приглашение 1>
		call	_printEStr

;---------------------------------------		
mainLoop	halt						; Главный цикл (опрос клавиатуры)
		call	_showCursor

		ld 	hl,edit256
		ld 	a,#01
		ld 	bc,#0000				; reserved
		call	_bufferUpdate

		call	_printWW

		call	checkMouseWheel
		call	checkMouseClick

 		call	_checkKeyAltL
 		jp	nz,altMode

		call	_getKeyWithShift

		cp	aCurLeft
		jp	z,leftKey

		cp	aCurRight
		jp	z,rightKey

		cp	aCurUp
		jp	z,upKey

		cp	aCurDown
		jp	z,downKey

		cp	aHome
		jp	z,maxLeftKey

		cp	aEnd
		jp	z,maxRightKey

		cp	aBackspace
		jp	z,backSpaceKey
		
		cp	aEnter
		jp	z,enterKey

		cp	aF1
		jr	c,mainLoopSkip
		cp	aF1+11				; F1…F11
		jp	c,checkFkeys
		

mainLoopSkip	cp	#20				; если код клавиши НЕ меньше #20 то в печать
		call	nc,_printKey
		jr	mainLoop

;---------------------------------------
checkMouseClick	ld	a,getMouseButtons
		call	cliDrivers

		bit	2,a					; средняя кнопка
		jp	z,_cmc_00				; отпустили?

		ld	a,#01
		ld	(_cmc_00+1),a
		ret

_cmc_00		ld	a,#00
		cp	#00
		ret	z
		
		xor	a					; 1? нажали и отпустили
		ld	(_cmc_00+1),a

		ld	hl,(mouseSelectB)
		ld	a,h
		or	l
		ret	z

		xor	a
		ld	de,(mouseSelectE)
		ex	de,hl
		sbc	hl,de
		inc	hl					;
		ex	de,hl					; hl - начало
								; de - длина
		call	_openCacheBank
_cmc_00a	ld	a,(hl)
		push	hl,de
		call	_printKey
		pop	de,hl
		inc	hl
		dec	de
		ld	a,d
		or	e
		jr	nz,_cmc_00a
		
 		jp	_cmc_01b				; закрываем банку

;---------------------------------------
checkMouseWheel	ld	a,getMouseW
		call	cliDrivers

		srl	h
		rr	l
		srl	h
		rr	l
		srl	h
		rr	l
		srl	h
		rr	l
		
		ld	(cmw_end+1),hl

		ld	de,(cliWheelPos)
		
		sbc	hl,de
		ret	z
		jr	nc,cmw_down_loop

		xor	a			; сброс флагов
		ld	hl,(cliWheelPos)
		ld	de,(cmw_end+1)
		sbc	hl,de

		push	hl
		pop	bc

cmw_up_loop	push	bc
		ld	a,#01
		call	PR_POZ
		pop	bc
		dec	bc
		ld	a,b
		or	c
		jr	z,cmw_end
		jr	cmw_up_loop

cmw_down_loop	push	hl
		pop	bc

		push	bc
		ld	a,#02
		call	PR_POZ
		pop	bc
		dec	bc
		ld	a,b
		or	c
		jr	z,cmw_end		
		jr	cmw_down_loop

cmw_end		ld	hl,#0000
		ld	(cliWheelPos),hl
		ret

;---------------------------------------
checkFkeys	sub	aF1
		ld	hl,fKeysSize
		call	_mult16x8
		ld	bc,fKeys
		add	hl,bc
		
setFkeyLoop	ld	a,(hl)
		cp	#00
		jp	z,mainLoop
		cp	#0a
		jp	z,enterKey
		cp	#0d
		jp	z,enterKey
		push	hl
		call	_printKey
		pop	hl
		inc	hl
		jr	setFkeyLoop
;---------------------------------------
altMode		call	_getKeyWithShift

		cp	aCurUp
		jp	z,scrollUp

		cp	aCurDown
		jp	z,scrollDown

		cp	aPageUp
		jp	z,scrollPageUp
		
		cp	aPageDown
		jp	z,scrollPageDown

 		jp	mainLoop

;---------------------------------------
scrollUp	ld	a,#01
		call	PR_POZ
		jp	mainLoop

;---------------------------------------
scrollDown	ld	a,#02
		call	PR_POZ
		jp	mainLoop

;---------------------------------------
scrollPageUp	ld	b,30
scrollPageUpL	ld	a,#01
		call	PR_POZ
		djnz	scrollPageUpL
		jp	mainLoop

;---------------------------------------
scrollPageDown	ld	b,30
scrollPageDownL	ld	a,#02
		call	PR_POZ
		djnz	scrollPageDownL
		jp	mainLoop

;---------------------------------------
upKey		ld	a,(hCount)
		cp	#00
		jp	z,mainLoop

		ld	a,(historyPos)
		cp	#00
		jr	nz,upKey_00
		ld	c,a
		ld	a,(hCount)
		dec	a
		add	a,c
		jr	upKey_00a

upKey_00	dec	a

upKey_00a	push	af
		ld	hl,iBufferSize				;hl * a
		call	_mult16x8
		push	hl
		pop	bc
		ld	hl,cliHistory
		add	hl,bc

		pop	af
		ld	(historyPos),a

upKey_01	ld	de,iBuffer
		ld	bc,iBufferSize
		ldir

		call	_editInit
			
		ld	hl,promptMsg
		call	_printEStr

		ld	hl,iBuffer
		call	_printEStr

		ld	(iBufferPos),a
; 		ret
		jp	mainLoop

;---------------------------------------
downKey		ld	a,(hCount)
		cp	#00
		jp	z,mainLoop

		ld	a,(historyPos)
		cp	historySize
		jr	c,dnKey_00
		xor	a
		jr	dnKey_00a

dnKey_00	dec	a
		cp	#ff
		jr	nz,dnKey_00a

		xor	a

dnKey_00a	ld	hl,iBufferSize				;hl * a
		call	_mult16x8
		push	hl
		pop	bc
		ld	hl,cliHistory
		add	hl,bc

		ld	a,(hCount)
		inc	a
		ld	c,a
		ld	a,(historyPos)
		inc	a
		cp	c
		jr	c,dnKey_00b
		ld	a,1
dnKey_00b	ld	(historyPos),a

		jr	upKey_01

;---------------------------------------
maxLeftKey	ld	a,(iBufferPos)
		cp	#00
		jp	z,mainLoop
		
		call	leftKeyTest
		jp	maxLeftKey

;---------------
leftKey		ld	a,(iBufferPos)
		cp	#00
		jp	z,mainLoop
		
		call	leftKeyTest
		jp	mainLoop

leftKeyTest	dec	a
		ld	hl,iBuffer
		ld	b,0
		ld	c,a
		add	hl,bc
		push	af
		ld	a,(storeKey)
		ld	b,a
		ld	a,(hl)
		ld	(storeKey),a
		ld	a,b
		cp	#00
		jr	nz,leftKey_01
		ld	a," "
leftKey_01	call	printEChar
		pop 	af
		ld	(iBufferPos),a
		ld	a,(printEX)
		dec	a
		ld	(printEX),a
		ret

;---------------------------------------
maxRightKey	call	rightKeyTest
		cp	#00
		jp	z,mainLoop
		jr	maxRightKey

;---------------
rightKey	call	rightKeyTest
		jp	mainLoop

rightKeyTest	ld	a,(iBufferPos)
		inc	a
		ld	hl,iBuffer
		ld	b,0
		ld	c,a
		add	hl,bc
		push	af
		push	hl
		dec	hl
		ld	a,(hl)
		cp	#00
		jr	z,rightStop

		pop	hl
		ld	a,(storeKey)
		ld	b,a
		ld	a,(hl)
		ld	(storeKey),a
		ld	a,b
		cp	#00
		jr	nz,rightKey_01
		ld	a," "
rightKey_01	call	printEChar
		pop 	af
rightKey_02	ld	(iBufferPos),a
		ld	a,(printEX)
		inc	a
		ld	(printEX),a
		ret

rightStop	pop	hl
		pop	af
		xor	a
		ret
;---------------
resetWheel	push	hl
		ld	hl,#0000				; сброс прокрутки мышом
		ld	(cliWheelPos),hl
		ld	a,resetMouseWheel
		call	cliDrivers
		pop	hl
		ret
;---------------------------------------
enterKey	call	resetWheel

		call	_getFullColor
		ld	(currentColor),a
		ld	a,(storeKey)
		call	printEChar
		call	printEUp

		ld	a,(iBuffer)
		cp	#00					; simple enter
		jr	z,_enterReady

		call	putHistory

		ld	de,iBuffer
		ld	bc,#0001				; номер текущей строки в SH скрипте (в данном случае всегда 1)
		call	_parseLine

_enterReady	ld	hl,promptMsg
		call	_printEStr
		call	_clearIBuffer
		jp	mainLoop

_clearIBuffer	ld	hl,iBuffer
		ld	de,iBuffer+1
		ld	bc,iBufferSize-1
		xor	a
		ld	(hl),a
		ldir
		ld	(iBufferPos),a
 		ret

putHistory	ld	a,(hCount)
		cp	historySize
		jr	c,ph_00

		ld	hl,cliHistory+iBufferSize
		ld	de,cliHistory
		ld	bc,(historySize-1)*iBufferSize
		ldir

		dec	a

ph_00		ld	hl,iBufferSize				;hl * a
		call	_mult16x8
		push	hl
		pop 	bc
		ld	hl,cliHistory
		add	hl,bc
		ex	de,hl
		ld	hl,iBuffer
		ld	bc,iBufferSize
		ldir

		ld	a,(hCount)
		inc	a
		cp	historySize+1
		jr	nc,ph_01
		ld	(hCount),a

ph_01		ld	a,(hCount)
		ld	(historyPos),a
 		ret

;---------------------------------------
backSpaceKey	ld	a,(iBufferPos)
		cp	#00					; уже удалено до самого конца
		jr	z,backSpaceEnd

		ld	hl,iBuffer-1
		ld	b,#00
		ld	c,a
		add	hl,bc
		ld	(hl),b

		dec	a
		ld	(iBufferPos),a

		ld	a," "
		call	printEChar

		ld	a,(printEX)
		dec	a
		cp	#ff					; Начало строки буфера edit256
		jr	nz,putEX

		ld	a,79
putEX		ld	(printEX),a
		
		ld	a,(iBufferPos)
		cp	#00
		jp	nz,mainLoop
		ld	a," "
		call	printEChar
		jp	mainLoop

backSpaceEnd	call	buffOverload+1
		jp	mainLoop
;---------------------------------------

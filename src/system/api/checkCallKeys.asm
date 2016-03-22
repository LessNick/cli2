;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #22 checkCallKeys
;---------------------------------------
; Выполнить подпрограммы по таблице согласно заданным ключам
;  i: HL - адрес строки с ключами
;     DE - адрес таблицы ключей и подпрограмм
;  o: A = #ff - неправильный (отсутсвующий в таблице) ключ
;---------------------------------------
_checkCallKeys	push	hl
		ex	de,hl					; hl - адрес таблицы ключей
								; de - адрес строки с ключами
		xor	a					; сброс флагов
		ld	a,(de)
		cp	"-"
		jr	nz,exitNoKeys
checkCallLoop	push	hl
		call	parser
		ld	de,(storeAddr)
		pop	hl
		cp	#fe					; Пропустить следующее значение
		jr	nz,checkCallSkip

checkCallLoop2	inc	de
		ld	a,(de)
		cp	#00
		jr	z,checkCallSkip2
		cp	" "
		jr	nz,checkCallLoop2
		call	_eatSpaces
		jr	checkCallSkip2

checkCallSkip	cp	#ff
		jr	z,errorCallExit

checkCallSkip2	ld	a,(de)
		cp	"-"
		jr	z,checkCallLoop

checkCallOk	pop	af
		ex	de,hl
		ret

errorCallExit	ex	hl,de
		ld	a,#ff

exitNoKeys	pop	hl
		ret
;---------------------------------------

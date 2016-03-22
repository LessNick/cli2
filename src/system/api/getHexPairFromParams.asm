;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #49 getHexPairFromParams
;---------------------------------------
; Получить пару чисел (шеснадцатиричных) через запятую (#A1,#B2) из строки параметров
; i: DE - адрес начала строки
; o: H - первое значение (число), L - второе
;    DE - адрес продолжения строки
;     A = #ff - ошибка (не число)
;---------------------------------------
_getHexPairFromParams
		call	_eatSpaces
		ld	a,(de)
		cp	"#"
		jr	nz,getHexError
		inc	de
		call	_hex2int
		cp	#ff
		ret	z
		ld	a,(de)
		cp	","
		jr	nz,getHexError
		inc	de
		ld	a,(de)
		cp	"#"
		jr	nz,getHexError
		jr	getHexSecond

getHexError	ld	a,#ff
		ret

getHexSecond	inc	de
		ld	b,l
		call	_hex2int
		cp	#ff
		ret	z
		ld	h,b
		ret
;---------------------------------------

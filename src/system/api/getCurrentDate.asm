;---------------------------------------
; CLi² (Command Line Interface) API
; 2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #63 getCurrentDate
;---------------------------------------
; Получить текущую дату
; o:HL - год
;    D - месяц
;    E - день
;    C - день недели
;---------------------------------------
_getCurrentDate	ld	a,#0b					; включить режим BIN данных
		ld	l,#04
		call	_nvRamSetData+1				; устанавливаем данные

		ld	a,#09					; регистр года (смещение относительно 2000)
 		call	_nvRamGetData+1				; читаем данные	
 		ld	hl,2000
 		ld	b,0
 		ld	c,a
 		add	hl,bc

 		ld	a,#08					; регистр месяца
 		call	_nvRamGetData+1				; читаем данные
 		ld	d,a

 		ld	a,#07					; регистр дня месяца
 		call	_nvRamGetData+1				; читаем данные
 		ld	e,a

 		ld	a,#06					; регистр дня недели
 		call	_nvRamGetData+1				; читаем данные
 		ld	c,a
 		ret
;---------------------------------------

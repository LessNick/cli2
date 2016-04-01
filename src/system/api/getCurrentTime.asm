;---------------------------------------
; CLi² (Command Line Interface) API
; 2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #64 getCurrentTime
;---------------------------------------
; Получить текущее время
; o:H - часы
;   L - минуты
;   С - секунды
;---------------------------------------
_getCurrentTime	ld	a,#0b					; включить режим BIN данных
		ld	l,#04
		call	_nvRamSetData+1
		
		ld	a,#04					; регистр часов
 		call	_nvRamGetData+1				; читаем данные
 		ld	h,a

 		ld	a,#02					; регистр минут
 		call	_nvRamGetData+1				; читаем данные
 		ld	l,a

 		ld	a,#00					; регистр секунд
 		call	_nvRamGetData+1				; читаем данные
 		ld	c,a
 		ret
;---------------------------------------

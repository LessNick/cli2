;---------------------------------------
; CLi² (Command Line Interface) FAT from WC
; 2016 © breeze/fishbone crew
;---------------------------------------
; Code by Budder^MGN
; DisAssembled by Me
;---------------------------------------
; работа с потоками
; i:D - номер потока (0/1)
;   B - устройство: 0-SD(ZC)
;	1-Nemo IDE Master
;	2-Nemo IDE Slave
;   C - раздел (не учитывается)
;   BC=#FFFF: включает поток из D (не возвращает флагов)
;	      иначе создает/пересоздает поток.
; o:NZ - устройство или раздел не найдены
;   Z - можно начинать работать с потоком
;---------------------------------------
_STREAM
_6CF3		call	_6D5C			;
		call	_6FB4
		ld	a,(_6000)		; PG0
		ld	(_600B),a		; FEP
		jp	_6D6D
;---------------
_6D5C		push	af
		push	bc
		ld	a,(_6000)		; PG0
		ld	(_600C),a		; XPP
		ld	a,(_600B)		; FEP
		call	_69A4
		pop	bc
		pop	af
		ret
;---------------

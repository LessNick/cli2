;---------------------------------------
; CLi² (Command Line Interface) API
; 2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #66 getDayNameByNumber
;---------------------------------------
; Получить 3-х буквенное назавание дня недели по номеру
; i: A' - номер дня (1-7)
;    DE - адрес строки куда сохранить 3 символа
;---------------------------------------
		ex	af,af'
_getDayNameByNumber
		dec	a
		ld	c,a
		sla	a					; * 2
		add	a,c					; * 3 ?
		ld	hl,dayNames
		ld	b,0
		ld	c,a
		add	hl,bc

		ld	b,3
gdnbnLoop	ld	a,(hl)
		ld	(de),a
		inc	hl
		inc	de
		djnz	gdnbnLoop
		ret
;---------------------------------------

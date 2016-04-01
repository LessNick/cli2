;---------------------------------------
; CLi² (Command Line Interface) API
; 2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #65 getMonthNameByNumber
;---------------------------------------
; Получить 3-х буквенное назавание месяца по номеру
; i: A' - номер месяца (1-12)
;    DE - адрес строки куда сохранить 3 символа
;---------------------------------------
		ex	af,af'
_getMonthNameByNumber
		dec	a
		ld	c,a
		sla	a					; * 2
		add	a,c					; * 3 ?
		ld	hl,monthNames
		ld	b,0
		ld	c,a
		add	hl,bc

		ld	b,3
gmnbnLoop	ld	a,(hl)
		ld	(de),a
		inc	hl
		inc	de
		djnz	gmnbnLoop
		ret
;---------------------------------------

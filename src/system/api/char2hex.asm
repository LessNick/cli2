;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #38 char2hex
;---------------------------------------
; Преобразовать 8-битное число в строку с шестнадцатиричным значением
; i: A' - значение (8-бит), DE - адрес начала строки
;---------------------------------------
		ex	af,af'
_char2hex	push 	af
		and 	#f0
		rra 
		rra 
		rra 
		rra 
		
		ld 	hl,hexLetters
		ld 	b,0
		ld 	c,a
		add 	hl,bc
		
		ld 	a,(hl)
		ld 	(de),a
		inc	de
		
		pop 	af
		and 	#0f
		
		ld 	hl,hexLetters
		ld 	b,0
		ld 	c,a
		add 	hl,bc
		
		ld 	a,(hl)
		ld 	(de),a
		ret

hexLetters	db	"0123456789ABCDEF"
;---------------------------------------

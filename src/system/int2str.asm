;---------------------------------------
; CLi² (Command Line Interface) System Messages
; 2013,2014 © breeze/fishbone crew
;--------------------------------------------------------------
; int2str перевод int в текст (десятичное число)
; (C) BUDDER/MGN - 2011.12.26
; char2str перевод char(8bit) в текст (десятичное число)
; Added by breeze
;--------------------------------------------------------------
; i:[HL] - int16, EXX DE - String addres
; o:Decimal string(5)
_int2str	ld	bc,10000
		call	delit
		ld	(de),a
		inc	de

		ld	bc,1000
		call	delit
		ld	(de),a
		inc	de

; i:[HL] - int8, EXX DE - String addres
; o:Decimal string(3)
_char2str	ld	bc,100
		call	delit
		ld	(de),a
		inc	de

; i:[HL] - int4, EXX DE - String addres
; o:Decimal string(3)
_fourbit2str	ld	bc,10
		call	delit
		ld	(de),a
		inc	de
		
		ld	bc,1
		call	delit
		ld	(de),a
		ret

delit		ld	a,#ff
		or	a
dlit		inc	a
		sbc	hl,bc
		jp	nc,dlit
		add	hl,bc
		add	a,#30
		ret

;--------------------------------------------------------------
; int2str перевод char в текст (шестнадцатиричное число)
; 2013,2014 © breeze/fishbone crew
;--------------------------------------------------------------
;in: de,str addr | "--"
;    a,int8 (#00…#FF)
;out: #0A (10)
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

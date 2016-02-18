;---------------------------------------
; CLi² (Command Line Interface) hex to int converter
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
; in: de,str addr | "0A"
;out: h=0,l=byte     | #0a (10)
;     a=0 - ok, a=#ff - wrong hex

_hex2int	ld	a,(de)
		call	ascii2Number
		sla	a
		sla	a
		sla	a
		sla	a
		and	%11110000
		ld	c,a
		inc	de
		ld	a,(de)
		inc	de
		call	ascii2Number
		and	%00001111
		or	c
		ld	h,#00
		ld	l,a
		xor	a
		ret

ascii2Number	cp	"0"
		jr	c,wrongHex
		cp	"9"+1
		jr	nc,ascii2Number_00
		sub	#30					; 0 - 9
		ret

ascii2Number_00	cp	"A"
		jr	c,wrongHex
		cp	"F"+1
		jr	nc,ascii2Number_01
		sub	55					; A = 10
		ret

ascii2Number_01	cp	"a"
		jr	c,wrongHex
		cp	"f"+1
		jr	nc,wrongHex
		sub	87					; a = 10
		ret

wrongHex	ld	a,#ff					; error
		ld	hl,#0000
		ret

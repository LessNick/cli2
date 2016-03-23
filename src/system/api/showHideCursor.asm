;---------------------------------------
; CLi² (Command Line Interface) API
; 2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #5D showHideCursor
;---------------------------------------
; Разрешить/Запретить отображение курсора мыши на экране
; i:B - номер графического экрана (1,2,3-GFX)
;   C - #00 скрыть, #01 отображать
;---------------------------------------
_showHideCursor	ld	a,b
		cp	#00
		jr	z,_shcSkip
		cp	#03+1
		ret	nc

		ld	a,#FE
_shcLoop	rlca
		sla	c
		djnz	_shcLoop

		ld	b,a

_shcNext	ld	hl,enableCursors
		ld	a,(hl)
		and	b			; выбираем всё кроме 1
		or	c			
		ld	(hl),a

		ret

_shcSkip	ld	b,#FE
		jr	_shcNext
;---------------------------------------

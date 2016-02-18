;---------------------------------------
; CLi² (Command Line Interface)
; 2014 © breeze/fishbone crew
;---------------------------------------
; TR-DOS Floppy driver
;---------------------------------------









































; ; переменные бейсика

; bSysRegCopy	equ	#5d16				; 23830 - копия системного регистра

; ;---------------

; ; точки входа в TR-DOS

; dCallTrDos	equ	#3d2f				; 15663

; dRegTrack	equ	#1e3a				; 7738 - регистр дорожки
; dRegSystem	equ	#1ff3				; 8179 - системный регистр
; dSendToPort	equ	#2a53				; 10835 - запись в любой порт
; dSetRegVG93	equ	#2fc3				; 12227 - заносит в регистр команд ВГ93 число из аккумулятора
; dCmd		equ	#3f33				; 16179 - подрограмма
; dWaitInrRqDrq	equ	#3fca				; 16330 - ожидание intrq или drq
; dWaitCmd	equ	#3fe5				; 16357 - ожидание выполнения команды (используется при позиционировании)

; ;---------------

; _loadSectors	call	_resetDrive
; 		jp	load

; ;---------------
; _resetDrive	ld	a,(currentDrive)
; 		ld	(sysRegisterCopy),a
; 		ld	a,#08
; 		call	dos5
; 		ret

; ;---------------------------------------------
; ; dos1
; regTrack	push	hl
; 		ld	hl,dRegTrack
; 		jr	callTrDos

; ;---------------
; dos2		push	hl
; 		ld	hl,dRegSystem
; 		jr	callTrDos

; ;---------------
; dos3		push	hl,bc
; 		ld	c,#7f
; 		jr	dos9

; ;---------------
; dos4		push	hl
; 		ld	hl,dSetRegVG93
; 		jr	callTrDos
; ;---------------

; dos5		call	dos4
; ;---------------
; dos6		push	hl
; 		ld	hl,dWaitCmd
; 		jr	callTrDos

; ;---------------
; dos7		push	hl
; 		ld	hl,dCmd
; 		jr	callTrDos

; ;---------------
; dos8		push	de
; 		xor	a
; 		call	regTrack
; 		ld	a,9
; 		call	nsec
; 		ld	d,1
; 		call	dos7
; 		pop	de
; 		ld	a,d
; 		srl	a
; 		call	regTrack
; 		ld	a,b
; 		ret

; ;---------------
; nsec		push	hl,bc
; 		ld	c,#5f
; 		inc	a

; dos9		ld	hl,dos10
; 		push	hl
; 		ld	hl,dSendToPort
; 		push	hl
; 		jp	callTrDos_0

; dos10		pop	bc,hl
; 		ret

; dosa		push	hl
; 		ld	hl,dWaitInrRqDrq

; ;---------------
; callTrDos	ex	(sp),hl
; callTrDos_0	; TODO: сделать включение ПЗУ TR-DOS
; 		call	dCallTrDos
; 		; TODO: сделать включение как было
; 		ret
; ;---------------------------------------------
; currentDrive	db	#00				; A=#00, B=#01, C=#02, D=#03




































; set_drv		ld	a,(ix+0)
; 		ld	(#5d16),a
; 		ret					;ld (save4+1),a

; load_s		call	reset
; 		ld	l,(ix+0)
; 		ld	h,(ix+1)
; 		ld	b,(ix+2)
; 		ld	e,(ix+3)
; 		ld	d,(ix+4)
; 		ld	a,(ix+5)
; 		ld	(#5b8d),a
; 		jp	load

; save_s		call	reset
; 		ld	l,(ix+0)
; 		ld	h,(ix+1)
; 		ld	b,(ix+2)
; 		ld	e,(ix+3)
; 		ld	d,(ix+4)
; 		ld	a,(ix+5)
; 		ld	(#5b8d),a
; 		jp	save

; load_f		call	reset
; 		ld	(exit+1),sp
; 		ld	a,(ix+8)
; 		ld	(#5b8d),a

; 		ld	l,(ix+0)			;name
; 		ld	h,(ix+1)

; 		ld	e,(ix+2)			;add load
; 		ld	d,(ix+3)

; 		call	loader

; exit		ld	sp,0
; 		ld	iy,23610
; 		exx
; 		ld	hl,10072
; 		exx
; 		ret

; ;------------------------------------
; loader		push	de,hl
; 		ld	l,(ix+4)			;addr load cat
; 		ld	h,(ix+5)

; 		ld	(catu+1),hl
; 		ld	(catu_2+1),hl
; 		ld	(search+1),hl
; 		ld	a,#08
; 		add	a,h
; 		ld	h,a
; 		ld	(catu1+1),hl

; 		ld	l,(ix+6)			;mesto grp
; 		ld	h,(ix+7)
; 		push	hl
; 		call	reset
; catu_2		ld	hl,#c000			;add cat load
; 		ld	de,0				;add cat sec/trk (grp)
; 		ld	b,#08				;len
; 		call	load
; 		pop	hl
; 		call	search
; 		ld	hl,(trakz+1)			;gde

; 		ld	(grp+1),hl
; 		call	reset
; catu		ld	hl,#c000			;add cat load
; grp		ld	de,0				;add cat sec/trk (grp)
; 		ld	b,#08				;len
; 		call	load
; catu1		ld	hl,0
; 		ld	de,#0900
; 		ld	b,1
; 		call	load

; 		pop	hl
; 		call	search
; 		pop	hl				;adres

; trakz		ld	de,0				;gde?
; lenz		ld	b,1				;dlina
; 		call	load
; 		ld	a,0
; 		ld	(#5b3f),a
; 		ret
; ;-----------------------------------------------

; search		ld	de,#c000			;cat hl-mask
; 		ld	a,(de)
; again		ld	b,a
; 		ld	a,(hl)
; 		cp	b
; 		jp	z,cont1
; cont3		push	hl
; 		ex	de,hl
; 		ld	de,16
; 		add	hl,de
; 		ex	de,hl
; 		pop	hl
; 		ld	a,(de)
; 		cp	#01
; 		jp	z,again
; 		cp	#00
; 		jp	z,nother			;file not found
; 		jp	again

; nother		call	f_n_f
; 		jp	exit

; nother2		call	d_i_f
; 		jp	exit

; cont1		ld	(cont2+1),hl
; 		ex	de,hl
; 		ld	(cont22+1),hl
; 		ex	de,hl
; 		inc	hl
; 		inc	de
; 		ld	a,(hl)
; 		ld	b,a
; 		ld	a,(de)
; 		cp	b
; 		jp	nz,cont2
; 		inc	hl
; 		inc	de
; 		ld	a,(hl)
; 		ld	b,a
; 		ld	a,(de)
; 		cp	b
; 		jp	nz,cont2
; 		inc	hl
; 		inc	de
; 		ld	a,(hl)
; 		ld	b,a
; 		ld	a,(de)
; 		cp	b
; 		jp	nz,cont2
; 		inc	hl
; 		inc	de
; 		ld	a,(hl)
; 		ld	b,a
; 		ld	a,(de)
; 		cp	b
; 		jp	nz,cont2
; 		inc	hl
; 		inc	de
; 		ld	a,(hl)
; 		ld	b,a
; 		ld	a,(de)
; 		cp	b
; 		jp	nz,cont2
; 		inc	hl
; 		inc	de
; 		ld	a,(hl)
; 		ld	b,a
; 		ld	a,(de)
; 		cp	b
; 		jp	nz,cont2
; 		inc	hl
; 		inc	de
; 		ld	a,(hl)
; 		ld	b,a
; 		ld	a,(de)
; 		cp	b
; 		jp	nz,cont2

; 		inc	hl
; 		inc	de
; 		ld	a,(hl)
; 		ld	b,a
; 		ld	a,(de)
; 		cp	b
; 		jp	nz,cont2

; 		inc	hl
; 		inc	de
; 		ld	a,(hl)
; 		ld	b,a
; 		ld	a,(de)
; 		cp	b
; 		jp	nz,cont2

; 		inc	hl
; 		inc	de
; 		ld	a,(hl)
; 		ld	b,a
; 		ld	a,(de)
; 		cp	b
; 		jp	nz,cont2


; 		ex	de,hl
; 		ld	de,3
; 		add	hl,de				;dl
; 		ld	a,(hl)
; 		ld	(lenz+1),a
; 		inc	hl
; 		ld	a,(hl)
; 		ld	(trakz+1),a
; 		inc	hl
; 		ld	a,(hl)
; 		ld	(trakz+2),a
; 		ret



; cont2		ld	hl,0
; cont22		ld	de,0
; 		jp	cont3
; ;-^^^^-----------------------^-^^^^^--------
; save_f		call	reset
; 		ld	(exit+1),sp
; 		ld	a,(ix+9)
; 		ld	(#5b8d),a

; 		ld	l,(ix+0)			;name
; 		ld	h,(ix+1)

; 		ld	e,(ix+2)			;add load
; 		ld	d,(ix+3)

; 		call	saver

; 		jp	exit

; ;------------------------------------
; saver
; 		ld	a,(ix+4)
; 		ld	(s_dl+1),a
; 		ld	(s_dl2+1),a
; 		ld	(lenz2+1),a
; 		push	hl,de
; 		ld	l,(ix+5)
; 		ld	h,(ix+6)
; 		ld	(catu2+1),hl
; 		ld	(catu22+1),hl
; 		ld	(search2+1),hl
; 		ld	a,#08
; 		add	a,h
; 		ld	h,a
; 		ld	(catu11+1),hl
; 		ld	(catu111+1),hl

; 		ld	(zz1+2),a
; 		ld	(zz2+2),a
; 		ld	(zz3+2),a
; 		ld	(control+2),a
; 		ld	(zz4+2),a
; 		ld	(dale1+2),a
; 		ld	(zz5+2),a
; 		ld	(zz6+2),a
; 		ld	(zz7+2),a

; 		ld	l,(ix+7)
; 		ld	h,(ix+8)
; 		ld	(grp2+1),hl
; 		ld	(grp22+1),hl

; 		call	reset

; catu2		ld	hl,#c000			;kat
; grp2		ld	de,0				;grp
; 		ld	b,#08
; 		call	load

; catu11		ld	hl,0				;kat
; 		ld	de,#0008			;grp
; 		ld	b,#01
; 		call	load

; 		call	control

; 		pop	hl				;adres

; trakz2		ld	de,0				;gde?
; 		ex	de,hl
; 		ld	(ai2+1),hl
; 		ex	de,hl
; lenz2		ld	b,1				;dlina
; 		ld	a,b
; 		ld	(ai1+1),a
; 		call	save
; 		ex	de,hl
; zz1		ld	(#c8e1),hl

; 		pop	hl				;name

; 		call	search2
; zz2		ld	a,(#c8e4)
; 		inc	a
; zz3		ld	(#c8e4),a

; catu22		ld	hl,#c000
; grp22		ld	de,0
; 		ld	b,#09
; 		call	save

; catu111		ld	hl,0
; 		ld	de,#0008
; 		ld	b,#01
; 		call	save


; 		ret

; control		ld	a,(#c8e6)
; 		cp	0
; 		jp	nz,dale1
; zz4		ld	a,(#c8e5)
; 		ld	b,a
; s_dl		ld	a,0
; 		cp	b
; 		jp	c,nother2			;disk fool
; dale1		ld	a,(#c8e1)
; 		ld	(trakz2+1),a
; zz5		ld	a,(#c8e2)
; 		ld	(trakz2+2),a

; zz6		ld	hl,(#c8e5)
; 		ld	d,0
; s_dl2		ld	e,0
; 		sbc	hl,de
; zz7		ld	(#c8e5),hl			;free
; 		ret

; search2		ld	de,#c000
; 		ld	b,0
; zjzj		ld	a,(de)
; 		cp	#00
; 		jp	z,oka
; 		inc	b
; 		ld	a,b
; 		cp	128
; 		jp	z,nother2			;dir fool
; 		push	hl
; 		ld	hl,#10
; 		add	hl,de
; 		ex	de,hl
; 		pop	hl
; 		jp	zjzj
; oka		ld	b,11
; 		ex	de,hl
; nznz		ld	a,(de)
; 		ld	(hl),a
; 		inc	hl
; 		inc	de
; 		djnz	nznz
; 		inc	hl
; ai1		ld	a,0
; 		ld	(hl),a
; 		inc	hl
; 		ld	(hl),a
; 		inc	hl
; ai2		ld	de,0
; 		ld	(hl),e
; 		inc	hl
; 		ld	(hl),d
; 		ret


; ;-^^^^-^^-^-^-^-^-^-^-^^^^^^-^-^-^-^^^^^^-------^-
; reset		di
; 		ld	a,(#5d16)
; 		and	3
; 		ld	(load4+1),a
; 		ld	(save4+1),a
; 		ld	a,#08
; 		call	dos5
; 		ret
; ;;)))))))))))))))))))))))))))))))))))))))))))))
; load		ld	(tztz+1),hl
; 		push	de,bc,af
; 		ld	hl,load_
; 		ld	de,#5b8f
; 		ld	bc,l_end-load_
; 		ldir
; 		ld	hl,lo5
; 		ld	de,#5cb6
; 		ld	bc,l_end2-lo5
; 		ldir
; 		pop	af,bc,de
; 		push	af
; 		ld	a,(#5b8d)
; 		ld	(bababa+1),a
; 		pop		af
; 		ld	hl,#5b8f
; 		push	hl
; tztz		ld	hl,0

; 		jp	kick


; load_
; ;			phase			#5b8f

; 		di
; 		ld	c,#0b
; load2		ld	a,d
; 		srl	a
; 		call	dos3
; 		ld	a,#18
; 		call	dos5
; 		ld	a,d
; 		srl	a
; 		call	dos1
; load3		push	hl
; 		push	bc
; 		ld	a,#2c
; 		bit	0,d
; 		jr	nz,load4
; 		ld	a,#3c
; load4		or	0				;drive 0=a 1=b 2=c 3=d
; 		call	dos2
; 		ld	a,e
; 		call	nsec
; 		ld	a,#80
; 		call	dos4
; 		ld	bc,#007f
; 		call	dos6
; 		call	dos8
; 		pop	bc
; 		pop	hl
; 		or	a
; 		jp	z,load5
; 		ld	(flg+1),a
; 		ld	a,c
; 		and	#03
; 		jr	nz,load1
; 		ld	a,#0c
; 		call	dos5
; load1		dec	c
; 		jr	nz,load2
; flg		ld	a,0				;w a - error
; 		push	hl
; 		call	rip??
; 		ld	hl,load
; 		ld	(wdv1+1),hl
; 		ld	hl,load5
; 		ld	(wdv2+1),hl
; 		pop	af,hl
; 		jp	r_i_a
; 		nop

; rip??
; 		ld	a,#11
; 		ld	(bababa+1),a
; 		call	kick
; 		ret

; kick		push	bc,af
; 		ld	bc,32765
; bababa		ld	a,#11
; 		out	(c),a
; 		pop	af,bc
; 		ret					;jp	load
; ;			unphase	
; l_end
; lo5
; ;			phase	#5cb6
; load5		push	af
; 		ld	a,(#5b8d)
; 		ld	(bababa+1),a
; 		call	kick
; 		pop	af
; 		inc	h
; 		ld	c,#0b
; 		inc	e
; 		bit	4,e
; 		jr	z,load6
; 		ld	e,0
; 		inc	d
; 		bit	0,d
; 		jr	nz,load6
; 		ld	a,#58
; 		call	dos5
; load6		dec	b
; 		jp	nz,load3
; 		ld	a,#11
; 		ld	(bababa+1),a
; 		call	kick
; 		ret

; ;			unphase	
; l_end2

; save		ld	(qweq+1),hl
; 		push	de,bc,af
; 		ld	hl,save_
; 		ld	de,#5b8f
; 		ld	bc,s_end-save_
; 		ldir
; 		ld	hl,sa5
; 		ld	de,#5cb6
; 		ld	bc,s_end2-sa5
; 		ldir
; 		pop	af,bc,de
; 		push	af
; 		ld	a,(#5b8d)
; 		ld	(bababa+1),a
; 		pop	af
; 		ld	hl,#5b8f
; 		push	hl
; qweq		ld	hl,0
; 		jp	kick

; save_
; ;			phase			#5b8f

; 		di
; 		ld	c,#0b
; save2		ld	a,d
; 		srl	a
; 		call	dos3
; 		ld	a,#18
; 		call	dos5
; 		ld	a,d
; 		srl	a
; 		call	dos1
; save3		push	hl
; 		push	bc
; 		ld	a,#2c
; 		bit	0,d
; 		jr	nz,save4
; 		ld	a,#3c
; save4		or	0				;drive 0=a 1=b 2=c 3=d
; 		call	dos2
; 		ld	a,e
; 		call	nsec
; 		ld	a,#a0
; 		call	dos4
; 		ld	bc,#007f
; 		call	dosa
; 		call	dos8
; 		pop	bc
; 		pop	hl
; 		or	a
; 		jp	z,save5
; 		ld	(qsc+1),a
; 		ld	a,c
; 		and	#03
; 		jr	nz,save1
; 		ld	a,#0c
; 		call	dos5
; save1		dec	c
; 		jr	nz,save2
; qsc		ld	a,0				;error
; 		push	hl,af
; 		call	rip??
; 		ld	hl,save
; 		ld	(wdv1+1),hl
; 		ld	hl,save5
; 		ld	(wdv2+1),hl
; 		pop	af,hl
; 		jp	r_i_a

; ;			unphase	
; s_end
; sa5
; ;			phase	#5cb6

; save5		push	af
; 		ld	a,(#5b8d)
; 		ld	(bababa+1),a
; 		call	kick
; 		pop		af
; 		inc	h
; 		ld	c,#0b
; 		inc	e
; 		bit	4,e
; 		jr	z,save6
; 		ld	e,0
; 		inc	d
; 		bit	0,d
; 		jr	nz,save6
; 		ld	a,#58
; 		call	dos5
; save6		dec	b
; 		jp	nz,save3
; 		ld	a,#11
; 		ld	(bababa+1),a
; 		call	kick
; 		ret

; ;			unphase	

; s_end2

; doz_b
; ;			phase			23872

; dos2		push	hl
; 		ld	hl,#1ff3
; 		jr	dos0

; dos3		push	hl,bc
; 		ld	c,#7f
; 		jr	dos9

; nsec		push	hl,bc
; 		ld	c,#5f
; 		inc	a
; dos9		ld	hl,dos10
; 		push	hl
; 		ld	hl,#2a53
; 		push	hl
; 		jp	#3d2f

; dos10		pop	bc,hl
; 		ret

; dos1		push	hl
; 		ld	hl,#1e3a
; 		jr	dos0

; dos4		push	hl
; 		ld	hl,#2fc3
; 		jr	dos0

; dos5		call	dos4
; dos6		push	hl
; 		ld	hl,#3fe5
; dos0		ex	(sp),hl
; 		jp	#3d2f

; dos7		push	hl
; 		ld	hl,#3f33
; 		jr	dos0

; dosa		push	hl
; 		ld	hl,#3fca
; 		jr	dos0

; dos8		push	de
; 		xor	a
; 		call	dos1
; 		ld	a,9
; 		call	nsec
; 		ld	d,1
; 		call	dos7
; 		pop	de
; 		ld	a,d
; 		srl	a
; 		call	dos1
; 		ld	a,b
; 		ret

; ;			unphase	

; doz_e		nop

; ;------------------------------------
; r_i_a		push	hl,de,bc,af
; 		ld	hl,fz1
; 		ld	(thm1+1),hl
; 		ld	(thm2+1),hl
; 		ld	(thm3+1),hl

; 		ld	a,(fl_scr)
; 		cp	1
; 		jp	z,jpia

; 		ld	hl,xar
; 		ld	(thm1+1),hl
; 		ld	(thm2+1),hl
; 		ld	(thm3+1),hl
; 		jp	jpia2

; jpia		ld	hl,fz0
; 		call	upz

; jpia2		ld	ix,data1
; 		call	window

; 		ld	ix,data2_
; 		call	e_pic

; 		ld	ix,data3_
; 		call	bigprt

; 		ld	ix,data4
; 		call	button

; 		ld	ix,data5_
; 		call	button

; 		ld	ix,data44
; 		call	button

; 		ld	ix,data55
; 		call	button

; azaza		ld	hl,(exitzz+1)
; 		push	hl
; 		xor		a
; 		ld	(exitzz),a
; 		ld	(exitzz+1),a
; 		ld	(exitzz+2),a
; 		ld	ix,data_t
; 		call	strel
; 		push	af
; 		ld	a,#31
; 		ld	(exitzz),a
; 		pop		af
; 		pop		hl
; 		ld	(exitzz+1),hl
; 		cp	0
; 		jp	z,zrog1
; 		cp	1
; 		jp	z,zrog2
; 		cp	2
; 		jp	z,zrog3
; 		jp	zrog4

; data1		db	5,3,20,16,40,15,56,2
; 		dw	mess1,mess2

; mess1		db	31,0,14,"minisoft doors system",#ff
; mess2		db	"...",15,#ff

; data2_		db	0,0,1

; data3_		db	3,1
; 		dw	mes3
; mes3		db	"disk error",#ff

; data4		db	1,5,7,5
; 		dw	txt1
; clik1		db	0,2
; txt1		db	"retry",#ff

; data5_		db	10,5,7,5
; 		dw	txt2
; clik2		db	0,2
; txt2		db	"abort",#ff

; data44		db	1,8,8,6
; 		dw	txt11
; clik3		db	0,2
; txt11		db	"ignore",#ff

; data55		db	11,8,6,4
; 		dw	txt22
; clik4		db	0,2
; txt22		db	"infa",#ff

; data_t		db	#80
; 		dw	ablas
; 		db	0

; ablas		db	#5f,#11,#38,#30
; 		dw	strel_
; 		db	#aa
; 		db	#21

; 		db	#5f,#11,#80,#30
; 		dw	strel_
; 		db	#aa
; 		db	#21

; 		db	#77,#11,#38,#38
; 		dw	strel_
; 		db	#aa
; 		db	#21

; 		db	#77,#11,#88,#28
; 		dw	strel_
; 		db	#aa
; 		db	#21

; 		db	#00,#00,0,0,0,0




; zrog1							;retry
; 		ld	ix,data4
; 		call	cheka
; thm1		ld	hl,fz1
; 		call	upz
; 		pop		af,bc,de,hl
; wdv1		jp	load

; zrog2							;abort
; 		ld	ix,data5_
; 		call	cheka
; thm3		ld	hl,fz1
; 		call	upz
; 		jp	exitzz

; zrog3							;ignore
; 		ld	ix,data44
; 		call	cheka
; thm2		ld	hl,fz1
; 		call	upz
; 		pop		af,bc,de,hl
; wdv2		jp	load5

; zrog4
; 		ld	ix,data55
; 		call	cheka
; 		jp	azaza

; cheka		ld	a,1
; 		ld	(ix+6),a
; 		call	button
; 		call	opros
; 		ld	(zuuu+1),a
; 		ld	b,5
; 		call	tyte
; uuuu1		call	opros
; 		cp	0
; 		jp	z,uuuu2
; zuuu		cp	0
; 		jp	z,uuuu1
; uuuu2		xor		a
; 		ld	(ix+6),a
; 		call	button
; 		ret

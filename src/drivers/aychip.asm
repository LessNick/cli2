;---------------------------------------
; CLi² (Command Line Interface)
; 2016 © breeze/fishbone crew
;---------------------------------------
; Ay Chip driver (player)
;---------------------------------------
_pt3init	call	storeRam0
		ld	a,ayBank
		call	_setRamPage0
		ld	hl,#0000
		call	UNI.Init
		jp	reStoreRam0
		
;---------------------------------------
_pt3play	call	storeRam0
		ld	a,ayBank
		call	_setRamPage0
		call	UNI.Play
		jp	reStoreRam0

;---------------------------------------
_pt3mute	ld	a,(enableAy+1)
		cp	#00
		ret	z
		jp	UNI.Mute

;---------------------------------------
_pt3loopEnable	
; 		ld	a,(START)
; 		and	%00000110
; 		ld	(START),a
		ret

;---------------------------------------
_pt3loopDisable	
; 		ld	a,(START)
; 		and	%00000110
; 		or	%00000001
; 		ld	(START),a
		ret

;---------------------------------------
_pt3setType	
; 		ex	af,af'
; 		sla	a
; 		ld	c,a
; 		ld	a,(START)
; 		and	%00000001
; 		or	c
; 		ld	(START),a
		ret

;---------------------------------------

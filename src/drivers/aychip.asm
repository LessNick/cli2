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
		push	af
		call	reStoreRam0
		pop	af
		ret
		
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
		ret

;---------------------------------------
_pt3loopDisable	
		ret

;---------------------------------------
_pt3setType	
		ret

;---------------------------------------

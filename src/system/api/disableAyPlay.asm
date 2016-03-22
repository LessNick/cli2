;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #5A disableAyPlay
;---------------------------------------
; Запретить воспроизведение AY. При этом вызывается драйвер - pt3mute
;---------------------------------------
_disableAyPlay	halt
		xor	a
		ld	(enableAy+1),a
		ld	a,pt3mute
		call	cliDrivers
		ret
;---------------------------------------

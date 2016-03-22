;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #41 restoreWcBank
;---------------------------------------
; Включить банку WildCommander'а по адресу #0000
;---------------------------------------
_restoreWcBank	ld	a,(_PAGE0)				; Восстанавливаем банку для WildCommander
		ld	bc,tsRAMPage0
		out	(c),a
		ret
;---------------------------------------

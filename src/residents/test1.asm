;---------------------------------------
; CLi² (Command Line Interface)
; 2014,2016 © breeze/fishbone crew
;---------------------------------------
; Test Resident 1
;---------------------------------------
		org	#c000-(resInstall-resStart)

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API
;---------------
resStart	
		db	#7f,"RES"				; Идентификатор приложения RES (Resident)
		db	"test1  "				; Название резидента 8 символов
		dw	resInstall				; адрес вызова при установке
		dw	resUninstall				; адрес вызова при удалении
		dw	resSleep				; адрес вызова при запрете резидентов
		dw	resWakeup				; адрес вызова при разрешении резидентов
		dw	resInt					; адрес вызова по прерыванию
		dw	resGet					; адрес вызова получить данные от резидента
		dw	resSet					; адрес вызова передать данные резиденту
;---------------
resInstall
		ret

;---------------
resUninstall
		ret

;---------------
resSleep
		ret
;---------------
resWakeup
		ret		
;---------------		
resInt		ld	bc,#0faf				; TS Border
		ld	hl,#6003
		ld	a,(hl)
		out	(c),a
		ret

;---------------		
resGet
		ret

;---------------		
resSet
		ret

;---------------		
resEnd	nop

		SAVEBIN "install/system/resident/test1.res", resStart, resEnd-resStart

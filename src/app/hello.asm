;---------------------------------------
; CLi² (Command Line Interface)
; 2014 © breeze/fishbone crew
;---------------------------------------
; Hello World Example
;---------------------------------------
		org	#c000-4

		include "system/constants.asm"			; Константы
		include "system/api.h.asm"			; Список комманд CLi² API
		include "system/errorcodes.asm"			; коды ошибок
		include "drivers/drivers.h.asm"			; Список комманд Drivers API

appStart	
		db	#7f,"CLA"				; Идентификатор приложения CLA (Command Line Application)

		call	appVer					; Выводим версию приложения и авторские права
		
		ld	hl,appQuetionMsg			; Выводим сообщение с вопросом 1
		call	appPrint

		ld	hl,appQuetionMsg_			; Выводим строку (y/n)
		ld	a,printInputYN
		call	cliKernel
		
		cp	"y"					; Если нажали "y" (или Y), то выводим сообщение и продолжаем
		jr	z,appCont

		ld	hl,appNoMsg				; Если нажали "n" (или N), то выводим сообщение и выходим
appLast		call	appPrint
		jp	appExit

appCont		ld	hl,appYesMsg
		call	appPrint

		ld	hl,appQuetionMsg2			; Выводим сообщение с вопросом 2
		call	appPrint

		ld	hl,appQuetionMsg2_			; Выводим строку (r/i/a)
		ld	a,printInputRIA
		call	cliKernel

		ld	hl,appRetryMsg
		cp	"r"					; Если нажали R
		jr	z,appCont2
		ld	hl,appIgnoreMsg
		cp	"i"					; Если нажали I
		jr	z,appCont2
		
		ld	hl,appAbortMsg
		jr	appLast

appCont2	call	appPrint

		call	appRun					; Выводим строку, что приложение работает

		ld	hl,appCallBack				; Данная функция вызывается при переключении экранов (ALT+F1…F4)
		ld	a,setAppCallBack
		call	cliKernel

appLoop		halt
		ld	a,getKeyWithShift			; Опрашиваем клавиатуру
		call	cliKernel

		cp	aEsc					; Если нажали ESC — выход из приложения
		jp	z,appExit

		jp	appLoop					; Иначе цикл

;---------------------------------------------
		; Убираем за собой «мусор»
appExit		ld	a,editInit				; Переинициализируем строку ввода
		call	cliKernel				

		ld	hl,appExitMsg				; Выводим строку, что приложение завершило работу
		ld	a,printString
		call	cliKernel

		ld	a,printRestore				; Восстанавливаем все цвета и параметры, что бы не было глюков
		jp	cliKernel

;---------------------------------------------
appCallBack							; При вызове данной функции сюда в аккумуляторе передаётся номер
								; активного экрана (ALT+F1 = 0, ALT+F2 = 1, итд)
		
		ld	h,0					; Преобразуем число (4bit 0-16) в строку
		ld	l,a
		ld	de,appInfoMsgN
		ld	a,fourbit2str
		call	cliKernel

		ld	hl,appInfoMsg				; Выводим сообщение, что экран был переключен
		jp	appPrint
;---------------------------------------------
appVer		ld	hl,appVersionMsg			; Выводим версию приложения	
		ld	a,printAppNameString			; Немного модифицированная процедура печати, специально для AppName
		call	cliKernel

		ld	hl,appCopyRMsg				; Выводим информацию об авторских правах
		ld	a,printCopyrightString			; Немного модифицированная процедура печати, специально для Copyright
		jp	cliKernel
		
;---------------------------------------------
appRun		ld	hl,appRunMsg				; Выводим приложение завершило работу
appPrint	ld	a,printString				; Обычная печать строки
		jp	cliKernel
;---------------------------------------------
appVersionMsg	db	"Hello World Application v 0.01",#00

appCopyRMsg	db	"2014 ",127," Breeze\\\\Fishbone Crew",#0d,#00

appQuetionMsg	db	15,6
		db	"This is first test question:",#0d
		db	16,16
		db	#00

appQuetionMsg_	db	"Continue run application (Yes/No)?",#00

appQuetionMsg2	db	15,6,#0d
		db	"This is second test question:",#0d
		db	16,16
		db	#00
		
appQuetionMsg2_	db	"Application error (Retry/Ignore/Abort)?",#00

appRunMsg	db	15,6,#0d
		db	"Press ALT+F1...F4 to change screen. Press Esc to exit.",#0d,#0d
		db	"Running...",#0d,#0d
		db	16,16
		db	#00

appYesMsg	db	"Selected: Yes. Continue.",#0d
		db	#00

appNoMsg	db	"Selected: No. Aborting.",#0d
		db	#00

appRetryMsg	db	"Selected: Retry. Continue.",#0d
		db	#00

appIgnoreMsg	db	"Selected: Ignore. Continue.",#0d
		db	#00

appAbortMsg	db	"Selected: Abort. Aborting.",#0d
		db	#00

appExitMsg	db	15,5,"Exit.",#0d
		db	16,16
		db	#00

appInfoMsg	db	15,7,"Screen changed to "
appInfoMsgN	db	"   "
		db	#0d,#00
;---------------------------------------------
appEnd	nop

		SAVEBIN "install/bin/hello", appStart, appEnd-appStart

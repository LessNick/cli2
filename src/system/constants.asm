;---------------------------------------
; CLi² (Command Line Interface) constants
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
wcKernel	equ	#6006				; WildCommander API

txtFontBank	equ	#01				; Банка и
txtFontAddr	equ	#c000				; Адрес для хранения шрифта текстового режима

scopeBinBank	equ	#03				; Банка и
scopeBinAddr	equ	#c000				; Адрес для хранения списка доступных команд из /bin

palBank		equ	#03				; Банка и
palAddr		equ	#f800				; Адрес для хранения палитры для текстового режима

gPalAddr0	equ	#f800				; Адрес для хранения «нулевой» палитры

gPalBank1	equ	#03				; Банка и
gPalAddr1	equ	#fe00				; Адрес для хранения палитры для графического режима 1


gPalBank2	equ	#03				; Банка и
gPalAddr2	equ	#fc00				; Адрес для хранения палитры для графического режима 2

gPalBank3	equ	#03				; Банка и
gPalAddr3	equ	#fa00				; Адрес для хранения палитры для графического режима 2

appBank		equ	#04				; Банка и
appAddr		equ	#c000				; Адрес для загрузки приложений

scriptBank	equ	#05				; Банка и
scriptAddr	equ	#c000				; Адрес для загрузки sh-скриптов

driversBank	equ	#06				; Банка и
driversAddr	equ	#c000				; Адрес для загрузки drivers.sys

gliBank		equ	#07				; Банка и
gliAddr		equ	#c000				; Адрес для загрузки gli.sys

; resBank		equ	#08				; Банка и
; resAddr		equ	#c000				; Адрес для загрузки res.sys

sprBank		equ	#09				; Банка и
sprAddr		equ	#c000				; Адрес для загрузки спрайтов

iBufferSize	equ	255				; размер буфера строки [?]
eBufferSize	equ	iBufferSize			; размер буфера редактируемой строки

historySize	equ	10				; Размер истории (в строках) для введённых комманд

pathStrSize	equ	255				; Размер буфера для сохранения пути (?)

bufferAddr	equ	#0000				; Адрес буфера для временной подгрузки данных

flagFile	equ	#00				; flag:#00 - file
flagDir		equ	#10				;      #10 - dir

deviceSDZC	equ	#00				; SD-Card Z-Controller (SDZC)
deviceNemoM	equ	#01				; Nemo IDE Master
deviceNemoS	equ	#02				; Nemo IDE Slave

;-------------------------------------------------------------------------------------
;		equ	#01				; псевдо-коды ASCII для маппинга расширенных клавиш
aInsert		equ	#02
aDelete		equ	#03
aHome		equ	#04
aEnd		equ	#05
aPageUp		equ	#06
aPageDown	equ	#07
aCurLeft	equ	#08
aCurRight	equ	#09
aCurDown	equ	#0a
aCurUp		equ	#0b	
;		equ	#0c
aEnter		equ	#0d
aBackspace	equ	#0e
aTab		equ	#0f
aEsc		equ	#10
aF1		equ	#11
aF2		equ	#12
aF3		equ	#13
aF4		equ	#14
aF5		equ	#15
aF6		equ	#16
aF7		equ	#17
aF8		equ	#18
aF9		equ	#19
aF10		equ	#1a
aF11		equ	#1b

;-------------------------------------------------------------------------------------
							; Курсоры мыши:
mCursorDefault	equ	#00				;    по умолчанию
mCursorClock	equ	#01				;    часы
mCursorSelect	equ	#02				;    выделение
mCursorHand	equ	#03				;    рука
mCursorEmpty	equ	#04				;    пустой

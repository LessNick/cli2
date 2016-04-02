;---------------------------------------
; CLi² (Command Line Interface) constants
; 2013,2016 © breeze/fishbone crew
;---------------------------------------

lsBuffer	equ	#4000				; Буфер чтения дискриптора файла. 512 байт
edit256		equ	#be00				; Буфер строки ввода 128 байт текст + 128 байт цвет
bufer256	equ	#bf00				; Буфер строки печати 128 байт текст + 128 байт цвет

; wcKernel	equ	#6006				; WildCommander API

txtFontBank	equ	#01+#20				; Банка и
txtFontAddr	equ	#c000				; Адрес для хранения шрифта текстового режима

scopeBinBank	equ	#03+#20				; Банка и
scopeBinAddr	equ	#c000				; Адрес для хранения списка доступных команд из /bin

palBank		equ	#03+#20				; Банка и
palAddr		equ	#f800				; Адрес для хранения палитры для текстового режима

gPalBank1	equ	#03+#20				; Банка и
gPalAddr1	equ	#fe00				; Адрес для хранения палитры для графического режима 1

gPalBank2	equ	#03+#20				; Банка и
gPalAddr2	equ	#fc00				; Адрес для хранения палитры для графического режима 2

gPalBank3	equ	#03+#20				; Банка и
gPalAddr3	equ	#fa00				; Адрес для хранения палитры для графического режима 2

appBank		equ	#04+#20				; Банка и
appAddr		equ	#c000				; Адрес для загрузки приложений

scriptBank	equ	#05+#20				; Банка и
scriptAddr	equ	#c000				; Адрес для загрузки sh-скриптов

driversBank	equ	#06+#20				; Банка и
driversAddr	equ	#c000				; Адрес для загрузки drivers.sys

gliBank		equ	#07+#20				; Банка и
gliAddr		equ	#c000				; Адрес для загрузки gli.sys

ayBank		equ	#08+#20				; Банка и
ayAddr		equ	#c000				; Адрес для загрузки модулей для AY

sprBank		equ	#09+#20				; Банка и
sprAddr		equ	#c000				; Адрес для загрузки спрайтов

varBank		equ	#0A+#20				; Банка и
varAddr		equ	#0000				; Адрес для переменных

keymapBank	equ	#0B+#20				; Банка и
keymapAddr	equ	#0000				; Адрес для раскладки клавиатуры

fontBank	equ	30 ;#0a				; 2 Банки (16c) или 4 Банки (256c) и
fontAddr	equ	#c000				; Адрес для загрузки графического шрифта

iBufferSize	equ	255				; размер буфера строки [?]
eBufferSize	equ	iBufferSize			; размер буфера редактируемой строки

historySize	equ	10				; Размер истории (в строках) для введённых комманд

pathStrSize	equ	255				; Размер буфера для сохранения пути (?)

bufferBank	equ	#F1;-32				; Банка и
bufferAddr	equ	#0000				; Адрес буфера для временной подгрузки данных

flagFile	equ	#00				; flag:#00 - file
flagDir		equ	#10				;      #10 - dir

; deviceSDZC	equ	#00				; SD-Card Z-Controller (SDZC)
; deviceNemoM	equ	#01				; Nemo IDE Master
; deviceNemoS	equ	#02				; Nemo IDE Slave

;-------------------------------------------------------------------------------------
		include "ascii_keys.h.asm"		; псевдо-коды ASCII для маппинга расширенных клавиш
;-------------------------------------------------------------------------------------
							; Курсоры мыши:
mCursorDefault	equ	#00				;    по умолчанию
mCursorClock	equ	#01				;    часы
mCursorSelect	equ	#02				;    выделение
mCursorHand	equ	#03				;    рука
mCursorEmpty	equ	#04				;    пустой

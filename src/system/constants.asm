;---------------------------------------
; CLi² (Command Line Interface) constants
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; Здесь только EQU ! Никаких db !!
;---------------------------------------
;---------------------------------------
; (16) Define палитры (default.pal) цветов CLi²
;---------------------------------------
cBlack			equ	0			; Чёрный
cNavy			equ	1			; Морской (тёмно-синий)
cAmigaPink		equ	2			; Розовый (как в MagicWB на Amiga)
cLightViolet		equ	3			; Светло-фиолетовый
cDarkGreen		equ	4			; Тёмно-Зелёный
cCobaltBlue		equ	5			; Кобальт синий
cOrange			equ	6			; Оранжевый
cLightPurplePink	equ	7			; Светлый пурпурно-розовый
cWhiteAluminum		equ	8			; Бело-алюминиевый
cBlue			equ	9			; Синий
cRed			equ	10			; Красный
cOrangeDawn		equ	11			; Оранжевая заря
cGreen			equ	12			; Зелёный
cFrostySky		equ	13			; Морозное небо
cLemonCream		equ	14			; Лимонно-кремовый
cWhite			equ	15			; Белый

cRestore		equ	16			; Восстановить цвет по умолчанию

;---------------------------------------
; (15) Define палитры ситтемных цветов CLi²
;---------------------------------------
csInk			equ	0			; 0й - основной цвет чернил
sPaper			equ	1			; 1й - основной цвет бумаги
csBorder		equ	2			; 2й - основной цвет бордера
csError			equ	3			; 3й - цвет сообщения об ошибке
csWarning		equ	4			; 4й - цвет сообщения предупреждения
csOk			equ	5			; 5й - цвет сообщения об успехе
csHelp			equ	6			; 6й - цвет сообщения подсказки
csDir			equ	7			; 7й - цвет аттрибута - директория
csFile			equ	8			; 8й - цвет аттрибута - файл
csRO			equ	9			; 9й - цвет аттрибута - только для чтения
csHidden		equ	10			;10й - цвет аттрибута - скрытый
csSystem		equ	11			;11й - цвет аттрибута - системный
csArch			equ	12			;12й - цвет аттрибута - архивный
csAppName		equ	13			;13й - цвет вывода названия приложения
csCopyright		equ	14			;14й - цвет вывода информации о владельце (©)
csInfo			equ	15			;15й - цвет инфомационного сообщения
csDefault		equ	16			;16й - цвет по умолчанию
csFrames		equ	17			;17й - цвет рамки

;---------------------------------------
; Define некоторых символов печати
;---------------------------------------
pUp			equ	#18			; ↑ знак
pDown			equ	#19			; ↓ знак
pRight			equ	#1A			; → знак
pLeft			equ	#1B			; ← знак

pCopy			equ	#7F			; © знак copyright

psTL			equ	#DA			; ┌ тонкая рамка вверх-лево
psT			equ	#C2			; ┬ тонкая рамка вверх
psTR			equ	#BF			; ┐ тонкая рамка вверх-право
psML			equ	#C3			; ├ тонкая рамка середина-лево
psM			equ	#C5			; ┼ тонкая рамка середина
psMH			equ	#C4			; ─ тонкая рамка середина горизонтальная
psMV			equ	#B3			; │ тонкая рамка середина вертикальная
psMR			equ	#B4			; ┤ тонкая рамка середина-право
psBL			equ	#C0			; └ тонкая рамка низ-лево
psB			equ	#C1			; ┴ тонкая рамка низ
psBR			equ	#D9			; ┘ тонкая рамка низ-право

pdTL			equ	#C9			; ╔ двойная рамка вверх-лево
pdT			equ	#CB			; ╦ двойная рамка вверх
pdTR			equ	#BB			; ╗ двойная рамка вверх-право
pdML			equ	#CC			; ╠ двойная рамка середина-лево
pdM			equ	#CE			; ╬ двойная рамка середина
pdMH			equ	#CD			; ═ двойная рамка середина горизонтальная
pdMV			equ	#BA			; ║ двойная рамка середина вертикальная
pdMR			equ	#B9			; ╣ двойная рамка середина-право
pdBL			equ	#C8			; ╚ двойная рамка низ-лево
pdB			equ	#CA			; ╩ двойная рамка низ
pdBR			equ	#BC			; ╝ двойная рамка низ-право

pQuoteOpen		equ	#F3			; « ёлочки
pQuoteClose		equ	#F2			; » ёлочки
pEllipsis		equ	#FE			; … троеточие

pSquared		equ	#FD			; ² степень
pNumber			equ	#FC			; № знак номер
pDegree			equ	#F8			; ° знак градус

pMarker			equ	#F9			; Маркер (жирная точка посредине)


;---------------------------------------
statusPos		equ	68			; позиция X где будет выведен статус [  OK  ] или [ ERROR ]
							; 11 позиций до правой границы экрна
;---------------------------------------

lsBuffer		equ	#4000			; Буфер чтения дискриптора файла. 512 байт

edit256			equ	#4200			; Буфер строки ввода 128 байт текст + 128 байт цвет
bufer256		equ	#4300			; Буфер строки печати 128 байт текст + 128 байт цвет

cPage0			equ	#4400			; Номер включенной (текущей) страницы с адреса #0000
cPage1			equ	#4401			; Номер включенной (текущей) страницы с адреса #4000
cPage2			equ	#4402			; Номер включенной (текущей) страницы с адреса #8000
cPage3			equ	#4403			; Номер включенной (текущей) страницы с адреса #C000

kernelStack		equ	#44fe			; Адрес размещения Стека системы (#5ffe)

kernelInt		equ	#44ff			; Адрес размещения вектора INT системы (#5bff)

kernelStart		equ	#4600			; Адрес размещения ядра системы
cliKernel		equ	kernelStart+#03		; Адрес входа для вызова функций API

;---------------------------------------
vPageTXT0		equ	#00			; #00 * 16 + #20 = #20 Банка начала видеопамяти, текстовый экран 0 (16 банок)
vPageGFX1		equ	#01			; #01 * 16 + #20 = #30 Банка начала видеопамяти, графический экран 1 (16 банок)
vPageGFX2		equ	#02			; #02 * 16 + #20 = #40 Банка начала видеопамяти, графический экран 2 (16 банок)
vPageGFX3		equ	#03			; #03 * 16 + #20 = #50 Банка начала видеопамяти, графический экран 3 (16 банок)

fPageDrv		equ	#0f			; Банка, где распологается fatDriver

video0Bank		equ	#00+#20			; Банка и
video0Addr		equ	#c000			; Адрес начала видеопамяти текстового режима

txtFontBank		equ	video0Bank+#01		; Банка и
txtFontAddr		equ	#c000			; Адрес для хранения шрифта текстового режима

video1Bank		equ	#10+#20			; Банка и
video1Addr		equ	#c000			; Адрес начала видеопамяти графического режима 1

video2Bank		equ	#20+#20			; Банка и
video2Addr		equ	#c000			; Адрес начала видеопамяти графического режима 2

video3Bank		equ	#30+#20			; Банка и
video3Addr		equ	#c000			; Адрес начала видеопамяти графического режима 3

scopeBinBank		equ	#03+#20			; Банка и
scopeBinAddr		equ	#c000			; Адрес для хранения списка доступных команд из /bin

palBank			equ	#03+#20			; Банка и
palAddr			equ	#f800			; Адрес для хранения палитры для текстового режима

gPalBank1		equ	#03+#20			; Банка и
gPalAddr1		equ	#fe00			; Адрес для хранения палитры для графического режима 1

gPalBank2		equ	#03+#20			; Банка и
gPalAddr2		equ	#fc00			; Адрес для хранения палитры для графического режима 2

gPalBank3		equ	#03+#20			; Банка и
gPalAddr3		equ	#fa00			; Адрес для хранения палитры для графического режима 2

appBank			equ	#04+#20			; Банка и
appAddr			equ	#c000			; Адрес для загрузки приложений

scriptBank		equ	#05+#20			; Банка и
scriptAddr		equ	#c000			; Адрес для загрузки sh-скриптов

driversBank		equ	#06+#20			; Банка и
driversAddr		equ	#c000			; Адрес для загрузки drivers.sys

gliBank			equ	#07+#20			; Банка и
gliAddr			equ	#c000			; Адрес для загрузки gli.sys

ayBank			equ	#08+#20			; Банка и
ayAddr			equ	#c000			; Адрес для загрузки модулей для AY

sprBank			equ	#09+#20			; Банка и
sprAddr			equ	#c000			; Адрес для загрузки спрайтов

varBank			equ	#0A+#20			; Банка и
varAddr			equ	#0000			; Адрес для переменных

keymapBank		equ	#0B+#20			; Банка и
keymapAddr		equ	#0000			; Адрес для раскладки клавиатуры

fontBank		equ	30 ;#0a			; 2 Банки (16c) или 4 Банки (256c) и
fontAddr		equ	#c000			; Адрес для загрузки графического шрифта

kernelBank		equ	#61			; Банка и
kernelAddr		equ	kernelStart		; Адрес для загрузки ядра сиситемы (kernel.sys)

bufferBank		equ	#F1;-32			; Банка и
bufferAddr		equ	#0000			; Адрес буфера для временной подгрузки данных

;---------------------------------------

iBufferSize		equ	255			; размер буфера строки [?]
eBufferSize		equ	iBufferSize		; размер буфера редактируемой строки

historySize		equ	10			; Размер истории (в строках) для введённых комманд

pathStrSize		equ	255			; Размер буфера для сохранения пути (?)


flagFile		equ	#00			; flag:#00 - file
flagDir			equ	#10			;      #10 - dir

;-------------------------------------------------------------------------------------
		include "ascii_keys.h.asm"		; псевдо-коды ASCII для маппинга расширенных клавиш
;-------------------------------------------------------------------------------------
							; Курсоры мыши:
mCursorDefault		equ	#00			;    по умолчанию
mCursorClock		equ	#01			;    часы
mCursorSelect		equ	#02			;    выделение
mCursorHand		equ	#03			;    рука
mCursorEmpty		equ	#04			;    пустой

;-------------------------------------------------------------------------------------
keyMap_E0		equ	#C000			; Позиция в Keymap для расширенных клавиш
keyMap_0A		equ	#C018			; Позиция в Keymap для обычных клавиш
keyMap_0B		equ	#C0A0			; Позиция в Keymap для клавиш + shift
keyMap_0C		equ	#C128			; Позиция в Keymap для клавиш + alt gr
keyMap_1A		equ	#C1B0			; Позиция в Keymap обычных клавиш (русская раскладка)
keyMap_1B		equ	#C238			; Позиция в Keymap для клавиш (русская раскладка) + shift
keyMap_1C		equ	#C2C0			; Позиция в Keymap для клавиш (русская раскладка) + alt gr
;-------------------------------------------------------------------------------------

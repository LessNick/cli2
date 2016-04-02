;---------------------------------------
; CLi² (Command Line Interface) parameters
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
storeIx		db	#00					; Значение IX для WildCommander
loadFileBlocks	dw	#0000					; Размер загружаемого файла в блоках

mXoffset0	dw	#0000					; Смещение графического экрана 0 по горизонтали
mYoffset0	dw	#0000					; Смещение графического экрана 0 по веритикали
mXoffset1	dw	#0000					; Смещение графического экрана 1 по горизонтали
mYoffset1	dw	#0000					; Смещение графического экрана 1 по веритикали
mXoffset2	dw	#0000					; Смещение графического экрана 2 по горизонтали
mYoffset2	dw	#0000					; Смещение графического экрана 2 по веритикали
mXoffset3	dw	#0000					; Смещение графического экрана 3 по горизонтали
mYoffset3	dw	#0000					; Смещение графического экрана 3 по веритикали

; bootDevide	db	deviceSDZC				; С чего загрузились (SD-карта)

currentScreen	db	#00					; Активный экран (0 - txt, 1,2,3 - gfx)
cliVersion	dw	#0012					; v 0.18

; 0=black, 1=navy, 2=amiga pink, 3=light violet, 4=green, 5=dark teal, 6=orange,  7=light beige, 
; 8=silver, 9=blue, 10=red, 11=dark pink, 12=lime, 13=teal, 14=light yellow, 15=white 

sysColors							; Системные цвета, доступны при печати через код 15(#0F)
;---------------------------------------
colorInk	db	15					; 0й - основной цвет чернил
colorPaper	db	5					; 1й - основной цвет бумаги
colorBorder	db	5					; 2й - основной цвет бордера

colorError	db	10					; 3й - цвет сообщения об ошибке
colorWarning	db	6					; 4й - цвет сообщения предупреждения
colorOk		db	12					; 5й - цвет сообщения об успехе

colorHelp	db	13					; 6й - цвет сообщения подсказки

colorDir	db	15					; 7й - цвет аттрибута - директория
colorFile	db	8					; 8й - цвет аттрибута - файл
colorRO		db	1					; 9й - цвет аттрибута - только для чтения
colorHidden	db	13					;10й - цвет аттрибута - скрытый
colorSystem	db	2					;11й - цвет аттрибута - системный
colorArch	db	3					;12й - цвет аттрибута - архивный

colorAppName	db	2					;13й - цвет вывода названия приложения
colorCopyright	db	3					;14й - цвет вывода информации о владельце (©)

colorInfo	db	8					;15й - цвет инфомационного сообщения

colorDefault	db	15					;16й - цвет по умолчанию

colorFrames	db	14					;17й - цвет рамки
;---------------------------------------

currentColor	db	#00					; текущий цвет для печати в текстовом режиме (paper|ink)

intCounter	dw	#0000					; счётчик количества прошедших прерываний

;			  |-----%00 - 256x192
;			  |	%01 - 320x200
;			  |	%10 - 320x240
;			  |	%11 - 360x288
;			  |
;			  |     |------ %00 - ZX
;			  |     |	%01 - 16c
;			  |	|	%10 - 256c
;			  |	|	%11 - txt
;			 \/    \/
;                        xx    xx
pTxtScreen	db	%10000011				; разрешие экрана 320x240x16 TXT
pGfxScreen	db	%11000010				; разрешие экрана 360x288x256 GFX
pGfxScreen2	db	%11000010				; разрешие экрана 360x288x256 GFX
pGfxScreen3	db	%11000010				; разрешие экрана 360x288x256 GFX

callBackApp	dw	callBackRet
callBackRet	db	201					; RET

printX		dw	#0000					; позиция X для печати в буфере256
strLen		db	#00

tabSize		equ	#08					; tab size
tabTable	db	tabSize*0, tabSize*1, tabSize*2, tabSize*3, tabSize*4
		db	tabSize*5, tabSize*6, tabSize*7, tabSize*8, tabSize*9

curAnimPos	db	#00
curAnim		db	14,15					; timeout,color
		db	5,8					; timeout,color
		db	7,5					; timeout,color
		db	5,8					; timeout,color
		db	#00

cursorType	db	"_"

iBufferPos	db	#00					; ??? Позиция в строке ввода 1>
iBuffer		ds	iBufferSize,#00				; ??? Размер буфера строки ввода
rBufferSize	equ	iBufferSize
rBuffer		ds	rBufferSize,#00				; Размер буфера строки для замены с переменными
rBufferNumber	db	"-----",#00				; Буфера для преобразования int2str

fileLength	dw	#0000,#0000
storeKey	db	#00					; временное сохрание символа под курсором

rootSearch	db	flagDir,".",#00
rootPath	db	"/",#00
binPath		db	"/bin",#00

keymapPath	db	"/system/res/keymaps/default.key",#00
cursorsPath	db	"/system/res/cursors/default.cur",#00
gliPath		db	"/system/gli.sys",#00
driversPath	db	"/system/drivers.sys",#00
startUpPath	db	"/system/startup.sh",#00
cdBinPath	db	"/bin/"
cibPath		db	"     "
cibFile		ds	8,0
		db	#00

nameEmpty	db	"             "

fileOneLine	db	16,15,"             "
		db	16,15,"             "
		db	16,15,"             "
		db	16,15,"             "
		db	16,15,"             "
		db	16,15,"             "
		db	#0d,#00					; end

helpOneLine	db	"          "
		db	"          "
		db	"          "
		db	"          "
		db	"          "
		db	"          "
		db	"          "
		db	"          "
		db	#00					; end

lsPathCount	db	#00					; path counter

pathStrPos	dw	#0000
pathString	ds	pathStrSize,#00
		db	#00

pathBString	ds	pathStrSize,#00
		db	#00

pathHomeString	ds	pathStrSize,#00
		db	#00

pathShString	ds	pathStrSize,#00
		db	#00

entryForSearch	ds	255,#00

hCount		db	#00
historyPos	db	#00
cliHistory	DUP	historySize
		ds	iBufferSize, #00
		EDUP

ps2Status	db	#00
ps2RepeatDefaut	db	#03
ps2RepeatCounter db	#00
ps2RepeatMode	db	#00
ps2ScanCode	db	#00,#00,#00,#00				; текущий скан-код ps/2 клавиатуры (обновляется 1 код за прерывание)

keyStatus	ds	131, #00	
altStatusB	db	#00					; для сохранения статуса клавиши ALT
ctrlStatusB	db	#00					; для сохранения статуса клавиши CTRL
checkShiftKey	db	#01					; проверять нажата ли клаша шифт

keyInsOver	db	#01					; переключение режима ввода строки Insert (#00) / Overwrite (#01)

keyStatusE0	ds	125, #00

keyLayoutSwitch	db	#00					; переключение раскладки 0 - EN, 1 - RU

keyMap_E0	equ	#C000
keyMap_0A	equ	#C018
keyMap_0B	equ	#C0A0
keyMap_1A	equ	#C128
keyMap_1B	equ	#C1B0

fKeysSize	equ	16					; Количество байт отведённых под 1 команду

fKeys		db	"help\n"				; F1
		ds	11,#00
		
		db	"ls\n"					; F2
		ds	13,#00
		
		db	"type "					; F3
		ds	11,#00
		
		db	"edit "					; F4
		ds	11,#00
		db	"cd "					; F5
		ds	13,#00
		db	"rename "				; F6
		ds	9,#00
		db	"mkdir "				; F7
		ds	10,#00
		db	"delete "				; F8
		ds	9,#00
		db	"find "					; F9
		ds	11,#00
		db	"sh "					; F10
		ds	13,#00
		db	"pwd\n"					; F11
		ds	12,#00

sysLocale	db	"EN"					; System Locale:
								; EN - English
								; RU - Russian
								; PL - Polish
								; DE - German
								; FR - French
								; etc

;---------------------------------------------
cursorSFile	db	#00					; Y0-7     | 8 bit младшие даные Y координаты (0-255px)
			;FLAR S Y8
		db	%00100010				; Y8       | 0й бит - старшие данные Y координаты (256px >)
								; YS       | 1,2,3 бит - высота в блоках по 8 px
								; RESERVED | 4й бит - зарезервирован
								; ACT      | 5й бит - спрайт активен (показывается)
								; LEAP     | 6й бит - указывает, что данный спрайт последний в текущем слое. (для перехода по слоям)
								; YF       | 7й бит - указывает, что данный спрайт нужно отобразить зеркально по вертикали
		
cursorSFileX	db	#00					; X0-7     | 8 bit младшие даные X координаты (0-255px)
			;F  R S X8
		db	%00000010				; X8       | 0й бит - старшие данные X координаты (256px >)
								; XS       | 1,2,3 бит - ширина в блоках по 8 px
								; RESERVED | 4й бит - зарезервирован
								; -        | 5,6й бит - не используются
								; XF       | 7й бит - указывает, что данный спрайт нужно отобразить зеркально по горизонтали
			;TNUM
cursorSBitmapX	db	%00000000				; TNUM	   | Номер тайла для левого верхнего угла.
								;          | 0,1,2,3,4,5й бит - Х координата в битмап
			;SPALTNUM				;          | 6,7й бит +
cursorSBitmapY	db	%00000000				; TNUM     | 0,1,2,3 бит - Y координата в битмап
								; SPAL     | 4,5,6,7й биты номер палитры (?)

;---------------------------------------------
cliWheelPos	dw	#0000					; Текущая позиция Wheel в консоли

mouseSelectB	dw	#0000					; Начальный адрес выделения мышью
mouseSelectE	dw	#0000					; Конечный адрес выделения мышью

;---------------------------------------------
enableCursors	db	%00001111				; отображать ли курор на экране:
								; bit 0 - 0й экран (TXT)
								; bit 1 - 1й экран (GFX)
								; bit 2 - 2й экран (GFX)
								; bit 3 - 3й экран (GFX)
;---------------------------------------------
op_typeA	equ	varAddr					; адрес начала типа переменных (1 байт на 1 переменную):
								; 	0 - undef
								; 	1 - signed int (16 bit) от -32768 до 32767
								; 	2 - string длинной 255 символов

op_varA		equ	varAddr + 26 * 1			; адрес начала данных переменных типа signed int
								;	2 байта на 1 значение переменной

op_cycleA	equ	op_varA + 26 * 2			; адрес начала для циклов:
								; 	2 байта начальное значение переменной в цикле
								;	2 байта конечное значение переменной в цикле
								;	2 байта номер строки куда перейти при операторе next

op_strA		equ	op_cycleA + 26 * 6			; адрес начала данных переменных типа string
								; 	255 байт + #00 на 1 переменную
;---------------------------------------------
scrollOffset	dw	#0000					; Позиция всего текста (прокрутка)

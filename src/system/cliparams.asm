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

bootDevide	db	deviceSDZC				; С чего загрузились (SD-карта)

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

iBufferPos	db	#00
iBuffer		ds	iBufferSize,#00

fileLength	dw	#0000,#0000
storeKey	db	#00					; временное сохрание символа под курсором

rootSearch	db	flagDir,".",#00
rootPath	db	"/",#00
binPath		db	"/bin",#00

; resPath		db	"/system/res.sys",#00
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

		;        x8  x0  x9  x1  xA  x2  xB  x3  xC  x4  xD  x5  xE  x6  xF  x7

keyMap_E0
; 		db	    #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00		; 0x		Таблица расширенных клавиш
; 		db	 #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00
; 		db	     #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00	; 1x
; 		db	 #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00
; 		db	     #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00	; 2x
; 		db	 #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00
; 		db	     #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00	; 3x
; 		db	 #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00
; 		db	     #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00	; 4x
; 		db	 #00,    #00,    "/",    #00,    #00,    #00,    #00,    #00
; 		db	     #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00	; 5x
; 		db	 #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00
; 		db	    #00,    #00,    #00,    #00,    #00,    #00,     #00,    #00	; 6x
		db	 #00,   aEnd,    #00, aCurLeft, aHome,   #00,    #00,    #00
		db	   aInsert,aDelete, aCurDown,#00,aCurRight,aCurUp,  #00,    #00		; 7x
		db	 #00,    #00, aPageDown, #00,    #00,  aPageUp,  #00,    #00




		;        x8  x0  x9  x1  xA  x2  xB  x3  xC  x4  xD  x5  xE  x6  xF  x7	
keyMap_0A	db	    #00,    aF9,    #00,    aF5,    aF3,    aF1,    aF2,    #00		; 0x		Таблица обычных клавиш
		db	#00,   aF10,    aF8,    aF6,    aF4,    aTab,    "`",    #00
		db	    #00,    #00,    #00,    #00,    #00,    "q",    "1",    #00		; 1x
		db	#00,    #00,    "z",    "s",    "a",    "w",    "2",    #00
		db	    #00,    "c",    "x",    "d",    "e",    "4",    "3",    #00		; 2x
		db	#00,    " ",    "v",    "f",    "t",    "r",    "5",    #00
		db	    #00,    "n",    "b",    "h",    "g",    "y",    "6",    #00		; 3x
		db	#00,    #00,    "m",    "j",    "u",    "7",    "8",    #00
		db	    #00,    ",",    "k",    "i",    "o",    "0",    "9",    #00		; 4x
		db	#00,    ".",    "/",    "l",    ";",    "p",    "-",    #00
		db	    #00,    #00,    "'",    #00,    "[",    "=",    #00,    #00		; 5x
		db	#00,    #00,  aEnter,   "]",    #00,    "\\",   #00,    #00
		db	    #00,    #00,    #00,    #00,    #00,    #00,aBackspace, #00		; 6x
		db	#00,    "1",    #00,    "4",    "7",    #00,    #00,    #00
		db	    "0",    ".",    "2",    "5",    "6",    "8",   aEsc,    #00		; 7x
		db	aF11,   "+",    "3",    "-",    "*",    "9",    #00,    #00
		db	     #00,    #00,    #00,    aF7,    #00,    #00,    #00,    #00	; 8x
; 		db	 #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00

		;        x8  x0  x9  x1  xA  x2  xB  x3  xC  x4  xD  x5  xE  x6  xF  x7
keyMap_0B	db	    #00,    aF9,    #00,    aF5,    aF3,    aF1,    aF2,    #00		; 0x		Таблица клавиш + shift
		db	#00,    #00,    aF8,    aF6,    aF4,   aTab,    "~",    #00
		db	    #00,    #00,    #00,    #00,    #00,    "Q",    "!",    #00		; 1x
		db	#00,   aF10,    "Z",    "S",    "A",    "W",    "@",    #00
		db	    #00,    "C",    "X",    "D",    "E",    "$",    "#",    #00		; 2x
		db	#00,    " ",    "V",    "F",    "T",    "R",    "%",    #00
		db	    #00,    "N",    "B",    "H",    "G",    "Y",    "^",    #00		; 3x
		db	#00,    #00,    "M",    "J",    "U",    "&",    "*",    #00
		db	    #00,    ",",    "K",    "I",    "O",    ")",    "(",    #00		; 4x
		db	#00,    ">",    "?",    "L",    ":",    "P",    "_",    #00
		db	    #00,    #00,    "\"",   #00,    "{",    "+",    #00,    #00		; 5x
		db	#00,    #00,  aEnter,   "}",    #00,    "|",    #00,    #00
		db	    #00,    #00,    #00,    #00,    #00,    #00,aBackspace, #00		; 6x
		db	#00,    #00,    #00,    #00,    #00,    #00,    #00,    #00
		db	    #00,    #00,    #00,    #00,    #00,    #00,   aEsc,    #00		; 7x
		db	aF11,   "+",    #00,    "-",    "*",    #00,    #00,    #00
		db	     #00,    #00,    #00,    aF7,    #00,    #00,    #00,    #00	; 8x
; 		db	 #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00

		include	"cp866.asm"

		;        x8  x0  x9  x1  xA  x2  xB  x3  xC  x4  xD  x5  xE  x6  xF  x7
keyMap_1A	db	    #00,    aF9,    #00,    aF5,    aF3,    aF1,    aF2,    #00		; 0x		Таблица обычных клавиш (русская раскладка)
		db	#00,   aF10,    aF8,    aF6,    aF4,   aTab,    re1,    #00
		db	    #00,    #00,    #00,    #00,    #00,    rii,    "1",    #00		; 1x	
		db	#00,    #00,    rya,    ryi,    rf,     rc,     "2",    #00
		db	    #00,    rs,     rch,     rv,     ru,    "4",    "3",    #00		; 2x
		db	#00,    " ",     rm,     ra,     re,     rk,    "5",    #00
		db	    #00,     rt,     ri,     rr,     rp,     rn,    "6",    #00		; 3x
		db	#00,    #00,   rmzn,     ro,     rg,    "7",    "8",    #00
		db	    #00,     rb,     rl,    rsh,    rsch,   "0",    "9",    #00		; 4x
		db	#00,    ryu,    ".",     rd,    rzh,     rz,    "-",    #00
		db	    #00,    #00,    re2,    #00,     rh,    "=",    #00,    #00		; 5x
		db	#00,    #00,  aEnter,  rtzn,    #00,    "\\",   #00,    #00
		db	    #00,    #00,    #00,    #00,    #00,    #00,aBackspace, #00		; 6x
		db	#00,    "1",    #00,    "4",    "7",    #00,    #00,    #00
		db	    "0",    ",",    "2",    "5",    "6",    "8",   aEsc,    #00		; 7x
		db	aF11,   "+",    "3",    "-",    "*",    "9",    #00,    #00
		db	     #00,    #00,    #00,    aF7,    #00,    #00,    #00,    #00	; 8x
; 		db	 #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00

		;        x8  x0  x9  x1  xA  x2  xB  x3  xC  x4  xD  x5  xE  x6  xF  x7
keyMap_1B	db	    #00,    aF9,    #00,    aF5,    aF3,    aF1,    aF2,    #00		; 0x		Таблица обычных клавиш (русская раскладка) + shift
		db	#00,   aF10,    aF8,    aF6,    aF4,   aTab,    rE1,    #00
		db	    #00,    #00,    #00,    #00,    #00,    rII,    "!",    #00		; 1x
		db	#00,    #00,    rYA,    rYI,     rF,     rC,    "\"",   #00
		db	    #00,     rS,    rCH,     rV,     rU,    ";",    rNN,    #00		; 2x
		db	#00,    " ",     rM,     rA,     rE,     rK,    "%",    #00
		db	    #00,     rT,     rI,     rR,     rP,     rN,    ":",    #00		; 3x
		db	#00,    #00,   rMZN,     rO,     rG,    "?",    "*",    #00
		db	    #00,     rB,     rL,    rSH,   rSCH,    ")",    "(",    #00		; 4x
		db	#00,    rYU,    ".",     rD,    rZH,     rZ,    "_",    #00
		db	    #00,    #00,    rE2,    #00,     rH,    "+",    #00,    #00		; 5x
		db	#00,    #00,  aEnter,  rTZN,    #00,    "/",    #00,    #00
		db	    #00,    #00,    #00,    #00,    #00,    #00,aBackspace, #00		; 6x
		db	#00,    #00,    #00,    #00,    #00,    #00,    #00,    #00
		db	    #00,    #00,    #00,    #00,    #00,    #00,   aEsc,    #00		; 7x
		db	aF11,   "+",    #00,    "-",    "*",    #00,    #00,    #00
		db	     #00,    #00,    #00,    aF7,    #00,    #00,    #00,    #00	; 8x
; 		db	 #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00

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

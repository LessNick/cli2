;---------------------------------------
; CLi² (Command Line Interface) default keymap (EN/RU)
; 2016 © breeze/fishbone crew
;---------------------------------------

		MODULE	default_key

		org	#C000

		include	"cp866.asm"
		include "../../system/ascii_keys.h.asm"
		include "alt.h.asm"
		
sKeyMap
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
		db	#00,   aF10,    aF8,    aF6,    aF4,    aTab,    "`",   #00
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

		;        x8  x0  x9  x1  xA  x2  xB  x3  xC  x4  xD  x5  xE  x6  xF  x7
keyMap_0C	db	    #00,    aF9,    #00,    aF5,    aF3,    aF1,    aF2,    #00		; 0x		Таблица клавиш + alt gr
		db	#00,   aF10,    aF8,    aF6,    aF4,    aTab,   "`",    #00
		db	    #00,    #00,    #00,    #00,    #00,    bTL,    "1",    #00		; 1x
		db	#00,    #00,    bBL,     bM,    bML,     bT,    st2,    #00
		db	    #00,    bBR,     bB,    bMR,    bTR,    "4",    num,    #00		; 2x
		db	#00,    " ",    "v",    "f",    "t",    "r",    "5",    #00
		db	    #00,    "n",    "b",    "h",    "g",    "y",    "6",    #00		; 3x
		db	#00,    #00,    "m",    "j",    "u",    "7",    "8",    #00
		db	    #00,    elO,    "k",    "i",    "o",    st0,    "9",    #00		; 4x
		db	#00,    elC,    tre,    "l",    ";",    "p",    del,    #00
		db	    #00,    #00,    "'",    #00,    inU,    apx,    #00,    #00		; 5x
		db	#00,    #00,  aEnter,   inD,    #00,    "\\",   #00,    #00
		db	    #00,    #00,    #00,    #00,    #00,    #00,aBackspace, #00		; 6x
		db	#00,    "1",    #00,    "4",    "7",    #00,    #00,    #00
		db	    "0",    ".",    "2",    "5",    "6",    "8",   aEsc,    #00		; 7x
		db	aF11,   "+",    "3",    "-",    "*",    "9",    #00,    #00
		db	     #00,    #00,    #00,    aF7,    #00,    #00,    #00,    #00	; 8x
; 		db	 #00,    #00,    #00,    #00,    #00,    #00,    #00,    #00


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
keyMap_1B	db	    #00,    aF9,    #00,    aF5,    aF3,    aF1,    aF2,    #00		; 0x		Таблица клавиш (русская раскладка) + shift
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

		;        x8  x0  x9  x1  xA  x2  xB  x3  xC  x4  xD  x5  xE  x6  xF  x7
keyMap_1C	db	    #00,    aF9,    #00,    aF5,    aF3,    aF1,    aF2,    #00		; 0x		Таблица клавиш (русская раскладка) + alt gr
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

eKeyMap
; 	DISPLAY "sKeyMap = ",/A,sKeyMap
; 	DISPLAY "keyMap_E0 = ",/A,keyMap_E0
; 	DISPLAY "keyMap_0A = ",/A,keyMap_0A
; 	DISPLAY "keyMap_0B = ",/A,keyMap_0B
; 	DISPLAY "keyMap_0C = ",/A,keyMap_0C
; 	DISPLAY "keyMap_1A = ",/A,keyMap_1A
; 	DISPLAY "keyMap_1B = ",/A,keyMap_1B
; 	DISPLAY "keyMap_1C = ",/A,keyMap_1C
; 	DISPLAY "eKeyMap = ",/A,eKeyMap
; 	DISPLAY "default.key size = ",/A,eKeyMap-sKeyMap

	SAVEBIN "install/system/res/keymaps/default.key", sKeyMap, eKeyMap-sKeyMap

	ENDMODULE

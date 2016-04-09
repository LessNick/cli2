;Understand, Correct, Improve           ___
;________/| _________________/\__/\____/  /_____
;\  ____/ |/   __/  /  / __ /  \/  \  \  /   __/
;|   __/  /\__   \    /  __ \      /     \  _/ \
;|___\ \__\____  //__/\_____/\    /__/\  /_____/
;+-------------\/breeze'13----\  /crew-\/------+
;                              \/
; ____      ____ 
;|    _----_    |  GLaDOS based KERNEL•8 (Eito/)
;|  _/ _||_ \_  |  «we do what we can because we must»
;  |  //\/\\  |    Copyright © 1995,1996 Spectrum Warriors corp. All right reserved
;  |=| \  / |=|    Copyright © 1997,2000 Ascendancy Cr.Lb. All right reserved
;  |_ \_\/_/ _|    Copyright © 2001,2016 Fishbone Crew. All right reserved
;|   \_ || _/   |  Written by breeze/fishbone crew | http://fishbone.untergrund.net/
;|_____----_____|  fishbone@speccy.su


;---------------------------------------
; CLi² (Command Line Interface)
; 2012,2016 © breeze/fishbone crew
;---------------------------------------

	DEVICE ZXSPECTRUM128

; 	define buildSexyBoot				; Сборка загрузчика системы boot.$c
; 	define buildKernel				; Сборка всей системы
; 	define buildRes					; Сборка файлов ресурсов (Pal, Cur, Fnt, keymap)
; 	define buildTest				; Сборка тестового приложения test
; 	define buildEcho				; Сборка команды echo
; 	define buildLoadPal				; Сборка утилиты loadpal
; 	define buildLoadFont				; Сборка утилиты loadfont
; 	define buildSleep				; Сборка команды sleep
; 	define buildType				; Сборка команды type
; 	define buildKeyScan				; Сборка утилиты keyscan
; 	define buildLoadMod				; Сборка утилиты loadmod
; 	define buildLoadMus				; Сборка утилиты loadmus
; 	define buildCursor				; Сборка утилиты cursor
; 	define buildMiceTest				; Сборка утилиты micetest
; 	define buildGliTest				; Сборка утилиты glitest
;  	define buildLoadSxg				; Сборка утилиты loadsxg
; 	define buildNvram				; Сборка утилиты nvram
; 	define buildHello				; Сборка тестового приложения hello
; 	define buildMkdir				; Сборка команды mkdir
; 	define buildScreenFX				; Сборка приложения screenFX
;  	define buildDate				; Сборка приложения date
	define buildTestSave				; Сборка тестового приложения testsave

; 	define buildBoing				; Сборка тестовой демки boing
; 	define buildTestFile				; Сборка тестового приложения testfile
; 	define buildDisk2trd				; Сборка приложения disk2trd

; 	define buildLoader				; Сборка загрузчика системы (плагин для WC)
;-------------------------------------------------------------------------
	ifdef buildLoader	
	; CLi² Loader
	DISPLAY "Start build: Loader..."
	include "cliloader/main.asm"
	endif
;-------------------------------------------------------------------------
	ifdef buildSexyBoot	
	; CLi² Sexy Boot
	DISPLAY "Start build: SexyBoot..."
	include "sexyBoot/main.asm"
	endif
;-------------- загрузчик или ядро системы -------------------------------

	ifdef buildKernel
	DISPLAY "Start build: Kernel..."
;-------------------------------------------------------------------------
	; Используется, если собирается только система (без приложения)
	include "system/constants.asm"
;-------------------------------------------------------------------------
	include "system/main.asm" 			; CLi² Kernel
	include "drivers/main.asm"			; CLi² Drivers
	include "libs/gli.asm"				; CLi² Graphics Library

;-------------------------------------------------------------------------
	; Используется, если собирается только система (без приложения)
	include "system/errorcodes.asm"
	include "system/api.h.asm"
	include "drivers/drivers.h.asm"
	include "libs/gli.h.asm"
;-------------------------------------------------------------------------
	endif

	ifdef buildRes
	DISPLAY "Start build: Resources..."
	
	include "res/pals/cli.pal.asm"			; CLi² 16 colors palette for text mode (CLi colors)
	include "res/pals/zx.pal.asm"			; CLi² 16 colors palette for text mode (ZX colors)
	
	include "res/cursors/default.cur.asm"			; CLi² default cursor
	
	include "res/fonts/8x8/default.fnt.asm"		; CLi² default font
	include "res/fonts/8x8/alt.fnt.asm"		; CLi² alternative font
	include "res/fonts/8x8/bge.fnt.asm"		; CLi² bge font
	include "res/fonts/8x8/bred.fnt.asm"		; CLi² bred font
	include "res/fonts/8x8/buratino.fnt.asm"	; CLi² buratino font
	include "res/fonts/8x8/ibm.fnt.asm"		; CLi² ibm font
	include "res/fonts/8x8/light.fnt.asm"		; CLi² light font
	include "res/fonts/8x8/robat.fnt.asm"		; CLi² robat font
	
	include "res/fonts/16x16/apple_j.fnt.asm"	; 16c color font 8x16

	include "res/keymaps/default.key.asm"		; Таблица раскладки клавиатуры (EN/RU)
	endif
;-------------------------------------------------------------------------

	ifndef buildKernel

		ifdef buildTest
		; CLi² test application
		DISPLAY "Start build: Test..."
		include "app/test.asm"
		endif

		ifdef buildEcho
		; CLi² echo application
		DISPLAY "Start build: Echo..."
		include "app/echo.asm"
		endif

		ifdef buildLoadPal
		; CLi² load palette application
		DISPLAY "Start build: LoadPal..."
		include "app/loadPal.asm"
		endif

		ifdef buildLoadFont
		; CLi² load font application
		DISPLAY "Start build: LoadFont..."
		include "app/loadFont.asm"
		endif

		ifdef buildSleep
		; CLi² sleep application
		DISPLAY "Start build: Sleep..."
		include "app/sleep.asm"
		endif

		ifdef buildType
		; CLi² type application
		DISPLAY "Start build: Type..."
		include "app/type.asm"
		endif

		ifdef buildKeyScan
		; CLi² keyboard scancode application
		DISPLAY "Start build: KeyScan..."
		include "app/keyScan.asm"
		endif

		ifdef buildLoadMod
		; CLi² mod loader application
		DISPLAY "Start build: LoadMod..."
		include "app/loadMod.asm"
		endif

		ifdef buildLoadMus
		; CLi² ay loader application
		DISPLAY "Start build: LoadMus..."
		include "app/loadMus.asm"
		endif

		ifdef buildCursor
		; CLi² cursor application
		DISPLAY "Start build: Cursor..."
		include "app/cursor.asm"
		endif

		ifdef buildMiceTest
		; CLi² mice test application
		DISPLAY "Start build: MiceTest..."
		include "app/miceTest.asm"
		endif

		ifdef buildGliTest
		; CLi² mice test gli
		DISPLAY "Start build: GLITest..."
		include "app/gliTest.asm"
		endif

		ifdef buildLoadSxg
		; CLi² mice test gli
		DISPLAY "Start build: LoadSXG..."
		include "app/loadSxg.asm"
		endif

		ifdef buildNvram
		; CLi² nvram info & tool application
		DISPLAY "Start build: NVRam..."
		include "app/nvram.asm"
		endif

		ifdef buildHello
		; CLi² hello world application
		DISPLAY "Start build: Hello..."
		include "app/hello.asm"
		endif

		ifdef buildBoing
		; CLi² demo 1
		DISPLAY "Start build: Boing..."
		include "demo/boing.asm"
		endif

		ifdef buildMkdir
		; CLi² mkdir application
		DISPLAY "Start build: MKdir..."
		include "app/mkdir.asm"
		endif

		ifdef buildTestSave
		; CLi² testsave application
		DISPLAY "Start build: testsave..."
		include "app/testsave.asm"
		endif

		ifdef buildTestFile
		; CLi² testsave application
		DISPLAY "Start build: testfile..."
		include "app/testfile.asm"
		endif

		ifdef buildScreenFX
		; CLi² screenFX application
		DISPLAY "Start build: screenFX..."
		include "app/screenFX.asm"
		endif

		ifdef buildDate
		; CLi² date application
		DISPLAY "Start build: date..."
		include "app/date.asm"
		endif

		ifdef buildDisk2trd
		; CLi² disk2trd application
		DISPLAY "Start build: disk2trd..."
		include "app/disk2trd.asm"
		endif

	endif

; 	DISPLAY "showHelp",/A,showHelp
; 	DISPLAY "shPrint_0",/A,shPrint_0
; 	DISPLAY "_printStatusString",/A,_printStatusString

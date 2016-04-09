;---------------------------------------
; CLi² (Command Line Interface)
; 2013,2016 © breeze/fishbone crew
;---------------------------------------------
; Command's table below with all jump vectors
;---------------------------------------------
cmdTable
;--- A ---
;--- B ---
;--- C ---
	db	"cd"
	db	"*"
	dw	changeDirCmd

	db	"cls"				; -g очистить графический экран
	db	"*"
	dw	clearScreen
;--- D ---
	db	"dir"
	db	"*"
	dw	ll
;--- E ---
;--- F ---
;--- G ---
;--- H ---
	db	"help"
	db	"*"
	dw	showHelp
;--- I ---
;--- J ---
;--- K ---
;--- L ---
	db	"ll"
	db	"*"
	dw	ll

	db	"ls"
	db	"*"
	dw	ls

	db	"locale"
	db	"*"
	dw	locale

;--- M ---
;--- N ---
;--- O ---
;--- P ---
	db	"pwd"
	db	"*"
	dw	pathWorkDir
;--- Q ---
;--- R ---
	db	"rehash"
	db	"*"
	dw	scopeBinaryCmd

;--- S ---
	db	"screen"
	db	"*"
	dw	switchScreen

	db	"sh"
	db	"*"
	dw	sh
;--- T ---
;--- U ---
;--- V ---
;--- W ---
;--- X ---
;--- Y ---
;--- Z ---

;--- table end marker ---
	db	#00

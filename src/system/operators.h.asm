;---------------------------------------
; CLi² (Command Line Interface)
; 2016 © breeze/fishbone crew
;---------------------------------------------
; Operators's table below with all jump vectors
;---------------------------------------------
opTable
;--- A ---
;--- B ---
;--- C ---
;--- D ---
;--- E ---
;--- F ---
	db	".for"
	db	"*"
	dw	_opFor
;--- G ---
;--- H ---
;--- I ---
;--- J ---
;--- K ---
;--- L ---
;--- M ---
;--- N ---
	db	".next"
	db	"*"
	dw	_opNext
;--- O ---
;--- P ---
;--- Q ---
;--- R ---
;--- S ---
	db	".set"
	db	"*"
	dw	_opSet
;--- T ---
;--- U ---
;--- V ---
;--- W ---
;--- X ---
;--- Y ---
;--- Z ---

;--- table end marker ---
	db	#00

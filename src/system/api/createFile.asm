;---------------------------------------
; CLi² (Command Line Interface) API
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
; MODULE: #2A createFile
;---------------------------------------
; Создать файл в активной директории
; i:HL - имя файла(1-255),#00
;   BC,DE размер файла в байтах
;         (bc - младшая часть, de - старшая часть)
;---------------------------------------
_createFile	ld	a,flagFile
		call	prepareSaveEntry

		ld	hl,entryForSearch
		ld	a,fMkFile
		jp	fatDriver
;---------------------------------------

;---------------------------------------
; CLi² (Command Line Interface) Graphics Library Header
; 2013,2014 © breeze/fishbone crew
;---------------------------------------
gfxLibrary		equ	kernelStart+#09		; Точка входа в Graphics Library

initGli			equ	#00			; Начальная инициализация Graphics Library
reInitGli		equ	#01			; Переинициализация Graphics Library (вторичный «тёплый» пуск)
getGliVersion		equ	#02			; Получить версию Graphics Library
							; o: H - major, L - minor version

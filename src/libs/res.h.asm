;---------------------------------------
; CLi² (Command Line Interface) Residents Header
; 2014,2015 © breeze/fishbone crew
;---------------------------------------
prgResidents		equ	#800c			; Точка входа в api резидентов

initResidents		equ	#00			; Начальная инициализация	

reInitResidents		equ	#01			; Переинициализация (вторичный «тёплый» пуск)

getVerResidents		equ	#02			; Получить версию Residents Core
							; o: H - major, L - minor version

getResidents		equ	#03			; Получить список загруженных резидентов

loadResident		equ	#04			; Установить резидент
							; i: HL - адрес расположения резидента
							;    BC - размер резидента

deleteResident		equ	#05			; Удалить резидента

callResidentMain	equ	#06			; Вызов обработчика резидентов

sentToResident		equ	#07			; Отправить данные резиденту

getFromResident		equ	#08			; Получить данные от резидента

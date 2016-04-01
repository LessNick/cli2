;---------------------------------------
; CLi² (Command Line Interface) Drivers Header
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
cliDrivers		equ	#7006			; Точка входа в Drivers

initDrivers		equ	#00			; Начальная инициализация драйверов
reInitDrivers		equ	#01			; Переинициализация драйверов (вторичный «тёплый» пуск)
getDrvVersion		equ	#02			; Получить версию драйвера
							; o: H - major, L - minor version
;---------------------------------------
; Kempstone Mouse driver Header
;---------------------------------------
mouseInit		equ	#03			; Инициализация драйвера мыши
							; i: hl - ширина, de - высота рабочей области
							;    256x192, 320x240, 360x288 итд 

mouseUpdate		equ	#04			; Обновление данных из портов мыши (вызывается 1 раз за прервывание)

getMouseX		equ	#05			; Получить координаты X мыши
							; o: HL - координата X (16bit)

getMouseY		equ	#06			; Получить координаты Y мыши
							; o: HL - координата Y (16bit)

getMouseDeltaX		equ	#07			; Получить дельту смещения мыши по оси X
							; o: HL - дельта X (16bit)

getMouseDeltaY		equ	#08			; Получить дельту смещения мыши по оси Y
							; o: HL - дельта Y (16bit)

getMouseRawX		equ	#09			; Получить RAW данные с порта X
							; o: H=0, L - RAW X (8bit)

getMouseRawY		equ	#0A			; Получить RAW данные с порта Y
							; o: H=0, L - RAW Y (8bit)

getMouseRawW		equ	#0B			; Получить данные с порта колёсика
							; o: H=0, L - RAW Y (8bit) от 0 до 15

getMouseButtons		equ	#0C			; Получить состояние кнопок мыши
 							; o: A - биты состояния:
 							;    bit0: левая кнопка (1=нажата)
 							;    bit1: правая кнопка (1=нажата)
 							;    bit2: средняя кнопка (1=нажата)
 							;    bit3: зарезервировано

getMouseW		equ	#0D			; Получить положение колёсика мыши
							; o: HL - данные Wheel (16bit)

getMouseDeltaW		equ	#0E			; Получить дельту смещения колёсика мыши
							; o: HL - дельта (16bit)

resetMouseWheel		equ	#0F			; Сбросить положение колёсика мыши

;---------------------------------------
gsInit			equ	#10			; Инициализация NeoGS (reset)
							; i: нет параметров
							; o: нет данных

gsStatus		equ	#11			; Получить статус устройства:
							; o: a = #00 - нет ошибок (GS present)
							;    a = #01-#ff - что-то не так

gsDetect		equ	#12			; Проверка наличия карты (NeoGS)

gsUpload4Bytes		equ	#13			; Загрузка 4 байтов данных в NeoGS
gsWaitLastByte		equ	#14			; Ожидание загрузки последнего байта

gsSendCmd		equ	#15			; Отправить команду карте

gsSendWaitCmd		equ	#16			; Отправить команду и дождаться ответа

gsPlay			equ	#17			; Play

gsStop			equ	#18			; Stop
gsCont			equ	#19			; Cont

gsResetFlags		equ	#1A			; Сбрасывает флаги Data bit и Command bit

gsWarmRestart		equ	#1B			; Сбрасывает полностью GS, но пропускает этапы определения
							; количества страниц памяти и их проверки, что очень сильно ускоряет
							; процесс инициализации.

gsColdRestart		equ	#1C			; Сбрасывает полностью GS

gsGetRAMPages		equ	#1D			; Получить число страниц на GS. (В базовой версии 3 страницы)
							; o: a = число страниц
							
gsLoadModule		equ	#1E			; Загрузка модуля в память

gsOpenStream		equ	#1F			; Открыть поток

gsCloseStream		equ	#20			; Закрыть поток

gsResetTrack		equ	#21			; Переустановить номер текущего трека

gsGetMasterVolume	equ	#22			; Получить громкость проигрывания модулей
gsSetMasterVolume	equ	#23			; Установить громкость проигрывания модулей

gsGetFXMasterVolume	equ	#24			; Получить громкость проигрывания эффектов
gsSetFXMasterVolume	equ	#25			; Установить громкость проигрывания эффектов

;---------------------------------------
pt3init			equ	#26			; Инициализация AY
							; Пердварительно должн быть загружены данные в AYBANK
pt3play			equ	#27			; Воспроизведение следующего блока данных (int)
pt3mute			equ	#28			; Заткнуть все регистры AY
pt3loopEnable		equ	#29			; reserved
pt3loopDisable		equ	#2A			; reserved
pt3setType		equ	#2B			; reserved

;---------------------------------------
; CLi² (Command Line Interface) Loader
; 2013,2014 © breeze/fishbone crew
;---------------------------------------

		org	#6000

sCliLoader
		include "pluginHead.asm"
		include "cliloader.asm"
eCliLoader	nop

	SAVEBIN "install/wc/CLI2.WMF", sCliLoader, eCliLoader-sCliLoader

;---------------------------------------
; CLi² (Command Line Interface) main block
; 2013,2016 © breeze/fishbone crew
;---------------------------------------
		org	kernelStart

sCliKernel
		include "cli.asm"
		include "ps2.asm"
		include "api.asm"

		include "print.asm"
		include "printE.asm"
		include "budder.asm"
		include "dma_dis.asm"
; 		include "fat_dis.asm"
		
		include "commands.asm"
		include "operators.asm"
		include "dir.asm"
		include "ls.asm"
		include "ll.asm"
		include "run.asm"
		include "sh.asm"
		
		include "hex2int.asm"

		include "messages.asm"
		include "cliparams.asm"
		include "commands.h.asm"
		include "operators.h.asm"
		
; 		include "wc.h.asm"
		include "tsconf.h.asm"
		include "fat.h.asm"

		db	"last kernel string"
		db	#00,#00,#00
eCliKernel	nop

	DISPLAY "-------------------------------------"
	DISPLAY "kernel size",/A,eCliKernel-sCliKernel
	DISPLAY "kernel end",/A,eCliKernel
	DISPLAY "-------------------------------------"
	SAVEBIN "install/system/kernel.sys", sCliKernel, eCliKernel-sCliKernel

;---------------------------------------
; CLi² (Command Line Interface) System Messages
; 2013,2015 © breeze/fishbone crew
;---------------------------------------

promptMsg	db	"1>"
		db	#00

restoreMsg	db	16,16,17,16,#00
returnMsg	db	#0d,#00

errorMsg	db	"Error: ",#00
unknownCmdMsg	db	"Unknown command.",#0d,#00
cantReadDirMsg	db	"Can't read directory.",#0d,#00
errorParamsMsg	db	"Wrong parameters.",#0d,#00
dirNotFoundMsg	db	"Directory not found.",#0d,#00
wrongAppMsg	db	"Wrong application file format.",#0d,#00
; wrongResMsg	db	"Wrong resident file format.",#0d,#00
fileNotFoundMsg	db	"File ",243,#00
fileNotFoundMsg0 db	242," not found.",#0d,#00
errorDevMsg	db	"Can't initializing the boot device.",#0d,#00
errorLimitMsg	db	"Maximum diapason -32767 to 32767.",#0d,#00

errorFileTooBig	db	"File size is too big. Not enough memory.",#0d,#00

okBinMgs	db	"System directory '/bin' successfully rescaned.",#0d,#00
errorBinMgs	db	"System directory '/bin' not found.",#0d,#00
; errorDrvMgs	db	"System file '/system/drivers.sys' not found.",#0d,#00
; errorGliMgs	db	"System file '/system/gli.sys' not found.",#0d,#00
; errorStartUpMgs	db	"System file '/system/startup.sh' not found.",#0d,#00

kernelPanicMgs	db	"Critical Error! System halted.",#00

bootErrorMgs	db	"System file ",243,#00
bootErrorMgs0	db	242," not found.",#0d,#00

iAsteriskMsg	db	" \\x09 ",#00
iOpenBracketMsg	db	"[ ",#00
iOkMsg		db	"  OK  ",#00
iErrorMsg	db	"ERROR!",#00
iCloseBracketMsg db	" ]",#0d,#00

continueMgs	db	"Press ",20," any key ",20," to continue.",#0d,#00

textScrollMgs	db	"Scroll?",#00
textScrollMgsE	db	"       ",#00

helpMsg		db	"Available commands",#00
helpMsg1	db	"(embedded):",#0d,#00

helpMsg2	db	"(external):",#0d,#00

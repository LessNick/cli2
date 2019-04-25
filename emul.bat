call mount.bat

xcopy /y /s /e /c /h install\boot.$c z:\
xcopy /y /s /e /c /h install\test.txt z:\
xcopy /y /s /e /c /h install z:\
xcopy /y /s /e /c /h install\bin z:\bin
xcopy /y /s /e /c /h install\system z:\system
xcopy /y /s /e /c /h install\demo z:\demo
xcopy /y /s /e /c /h install\demo\*.sh z:\demo
xcopy /y /s /e /c /h install\music z:\music
xcopy /y /s /e /c /h install\images z:\images

call umount.bat

xcopy /y /s /e /c /h cli2.lst c:\Emu\pentevo\Unreal.dev\

c:\Emu\pentevo\Unreal.dev\Unreal.exe

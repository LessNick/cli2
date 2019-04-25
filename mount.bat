echo select vdisk file="c:\Emu\pentevo\Unreal.dev\100.vhd" >tmp.sce
echo attach vdisk >>tmp.sce
diskpart /s tmp.sce
del tmp.sce

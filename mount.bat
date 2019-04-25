echo select vdisk file="c:\Emu\pentevo\Unreal.dev\100.vhd" > tmp.sce
echo attach vdisk >> tmp.sce
echo select partition 1 >> tmp.sce
echo assign letter=Z >> tmp.sce
diskpart /s tmp.sce
del tmp.sce

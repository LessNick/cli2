@echo off
SET PROJECT=cli2
sjasmplus.exe --lst=%PROJECT%.lst --inc=src\. src\main.asm

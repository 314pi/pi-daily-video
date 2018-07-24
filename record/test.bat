@echo off
set /p "input=Enter text: "
call :strlen "%input%", len
echo Length is %len%
echo %input%
exit/B

:strlen string len
setlocal enabledelayedexpansion
set "token=#%~1" & set "len=0"
for /L %%A in (12,-1,0) do (
    set/A "len|=1<<%%A"
    for %%B in (!len!) do if "!token:~%%B,1!"=="" set/A "len&=~1<<%%A"
)
EndLocal & set %~2=%len%
exit/B
@echo off
setlocal enabledelayedexpansion
if exist "temp.txt" del temp.txt
copy NUL temp.txt
for /f "delims=" %%L in (output.txt) do find "%%L" temp.txt || echo %%L>>temp.txt
del output.txt
ren temp.txt output.txt
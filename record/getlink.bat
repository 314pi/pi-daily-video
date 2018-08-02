@echo off
setlocal
call apps.bat
set "kenh=%1"
set "stt=%2"
if [%kenh%]==[] set "kenh=test"
if [%stt%]==[] set /a stt=1
if %stt% geq 5 set /a stt=4
for /f "delims=" %%a in ('%ini% tv.ini [%kenh%] source%stt%') do ( %%a )
call set source=%%source%stt%%%
if not "%source%" == "" set "source=%source: =%"
if "%source%" == "" goto :eof
%wget% -qO- %source% > "%scriptpath%\tmp\%kenh%.1"
%grep% -Eo "function init" "%scriptpath%\tmp\%kenh%.1" > NUL
if %errorlevel% equ 0 (
	%grep% -Eo "'http[^\,]+'" "%scriptpath%\tmp\%kenh%.1" > "%scriptpath%\tmp\%kenh%.2"
	%sed% "s/'//g" "%scriptpath%\tmp\%kenh%.2" > "%scriptpath%\tmp\%kenh%.3"
	type NUL > "%scriptpath%\tmp\%kenh%.4"
	for /f %%i in (%scriptpath%\tmp\%kenh%.3) do (
		%wget% -qO- "%%i" >> "%scriptpath%\tmp\%kenh%.4"
		echo. >> "%scriptpath%\tmp\%kenh%.4"
	)
) else (
	echo May be YOUTUBE
)
%sed% "/^\s*$/d" "%scriptpath%\tmp\%kenh%.4" > "%scriptpath%\tmp\%kenh%.5"
%sed% "s/ //g" "%scriptpath%\tmp\%kenh%.5" > "%scriptpath%\tmp\%kenh%.6"
%grep% -Eo "^.*m3u8$" "%scriptpath%\tmp\%kenh%.6" > "%scriptpath%\tmp\%kenh%.0"
setlocal EnableExtensions EnableDelayedExpansion
for /l %%i in (1,1,4) do ( !ini! tv.ini [!kenh!] link%%i== )
set /a count=1
for /f %%i in (%scriptpath%\tmp\%kenh%.0) do (
	!ini! tv.ini [!kenh!] link!count!=%%i
	set /a "count+=1"
	if !count! geq 5 goto :eof
)
endlocal
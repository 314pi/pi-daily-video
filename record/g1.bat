@echo off
setlocal EnableExtensions EnableDelayedExpansion
call apps.bat
set "kenh=%1"
set "stt=%2"
if [%kenh%]==[] set "kenh=test"
if [%stt%]==[] set /a stt=1
type NUL>"%scriptpath%\tmp\%kenh%_link.txt"
:GetLink1
for /f "delims=" %%a in ('%ini% tv.ini [%kenh%] source%stt%') do ( %%a )
call set source="%%source%stt%%%"
if not %source% == "" set source=%source: =%
if %source% == "" (
	set /a stt+=1
	if %stt% geq 10 goto :eof
	goto GetLink1 )
title [%kenh%] - [lim=%lim%]
echo Source[%stt%]: %source%
call :Iframe %source% %kenh%_%stt% %kenh%





set /a stt+=1
if %stt% geq 10 goto :eof
goto GetLink1

goto :eof

:Iframe
	@echo off
	setlocal enableextensions enabledelayedexpansion
	call apps.bat
	set "size=0"
	set "source=%~1"
	set "filename=%~2"
	set "chan=%~3"
	%wget% -qO- %source% | call rep "\x22" "'" | %grep% -Eo "<iframe.*</iframe>" | %grep% -Eo "'http[^ ]+'">"%scriptpath%\tmp\%filename%.txt"
	for /f "usebackq" %%i in ('%scriptpath%\tmp\%filename%.txt') do set "size=%%~zi"
	if !size! equ 0 goto FileEmpty
	call rep.bat "'" "" /x /f "%scriptpath%\tmp\%filename%.txt" /O -
	set /a "count=1"
	for /f "usebackq" %%i in ("%scriptpath%\tmp\%filename%.txt") do (
		!wget! -qO- "%%i" | call rep "\x22" "'" | !grep! -Eo "<iframe.*</iframe>" | %!grep! -Eo "'http[^ ]+'" && (
			call :Iframe "%%i" !filename!_!count! !chan!
			set /a "count+=1"
		) || ( echo %%i>>"!scriptpath!\tmp\!chan!_link.txt" )
	)
	:FileEmpty
	endlocal & exit /b
	
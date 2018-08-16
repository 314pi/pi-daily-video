@echo off
setlocal EnableExtensions EnableDelayedExpansion
call apps.bat
set "kenh=%1"
set "stt=%2"
if [%kenh%]==[] set "kenh=test"
if [%stt%]==[] set /a stt=1
:GetLink1
for /f "delims=" %%a in ('%ini% tv.ini [%kenh%] source%stt%') do ( %%a )
call set source="%%source%stt%%%"
if not %source% == "" set source=%source: =%
if %source% == "" (
	set /a stt+=1
	if %stt% geq 10 goto :eof
	goto GetLink1 )
title [%kenh%] - [lim=%lim%]
:Iframe
echo ==========================================================
echo Source [%stt%]: %source%
%wget% -qO- %source%>"%scriptpath%\tmp\%kenh%src.txt"
%grep% -Eo "<iframe.*</iframe>" "%scriptpath%\tmp\%kenh%src.txt">"%scriptpath%\tmp\%kenh%ifr.txt" && (
	call rep.bat "\x22" "'" /x /f "%scriptpath%\tmp\%kenh%ifr.txt" /O -
	%grep% -Eo "'http[^ ]+'" "%scriptpath%\tmp\%kenh%ifr.txt">"%scriptpath%\tmp\%kenh%lnk.txt"
	call rep.bat "'" "" /x /f "%scriptpath%\tmp\%kenh%lnk.txt" /O -
	for /f "usebackq" %%a in ("%scriptpath%\tmp\%kenh%lnk.txt") do (
		%wget% -qO- %source%>"%scriptpath%\tmp\%kenh%src.txt"
		
	)
	pause
	set /a stt+=1
	goto GetLink1
)

:Iframe
	@echo off
	setlocal enableextensions enabledelayedexpansion
	call apps.bat
	set "source=%~1"
	
	
	endlocal & exit /b
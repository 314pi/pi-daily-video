@echo off
setlocal
call apps.bat
set lims[0]=700
set lims[1]=1000
set lims[2]=1300
set /a limc=0
:ChangeLim
if %limc% geq 3 (
	echo KHONG CO LINK
	goto :eof )
set /a lim=lims[%limc%]
title [lim=%lim%]
set "kenh=%1"
set "stt=%2"
if [%kenh%]==[] set "kenh=test"
if [%stt%]==[] set /a stt=1
if %stt% geq 11 set /a stt=1
:GetLink1
if %stt% geq 11 ( 
	set /a limc+=1
	goto :ChangeLim 
)
if exist .\tmp\%kenh%.* del "%scriptpath%\tmp\%kenh%.*"
for /f "delims=" %%a in ('%ini% tv.ini [%kenh%] source%stt%') do ( %%a )
call set source="%%source%stt%%%"
if not %source% == "" set source=%source: =%
if %source% == "" (
	set /a stt+=1
	goto :GetLink1 )
echo Source [%stt%]: %source%
type NUL > "%scriptpath%\tmp\%kenh%.4"
%wget% -qO- %source% > "%scriptpath%\tmp\%kenh%.1"
%grep% -Eo "http[^\,]+m3u8" "%scriptpath%\tmp\%kenh%.1" > "%scriptpath%\tmp\%kenh%.2" && (
	echo Kieu 1 [ http://-- m3u8 ]
	copy "%scriptpath%\tmp\%kenh%.2" "%scriptpath%\tmp\%kenh%.4" > NUL 
)
%grep% -Eo "function init" "%scriptpath%\tmp\%kenh%.1" > NUL && (
	echo Kieu 2 [ function init ]
	%grep% -Eo "'http[^\,]+'" "%scriptpath%\tmp\%kenh%.1" > "%scriptpath%\tmp\%kenh%.2"
	%sed% "s/'//g" "%scriptpath%\tmp\%kenh%.2" > "%scriptpath%\tmp\%kenh%.3"
	for /f %%i in (%scriptpath%\tmp\%kenh%.3) do (
		%wget% -qO- "%%i" >> "%scriptpath%\tmp\%kenh%.4"
		echo. >> "%scriptpath%\tmp\%kenh%.4" )
)
%sed% "/^\s*$/d" "%scriptpath%\tmp\%kenh%.4" > "%scriptpath%\tmp\%kenh%.5"
%sed% "s/ //g" "%scriptpath%\tmp\%kenh%.5" > "%scriptpath%\tmp\%kenh%.6"
%grep% -Eo "^.*m3u8$" "%scriptpath%\tmp\%kenh%.6" > "%scriptpath%\tmp\%kenh%.0"
setlocal EnableExtensions EnableDelayedExpansion
for /l %%i in (1,1,4) do ( !ini! tv.ini [!kenh!] link%%i== )
set /a count=1
for /f %%i in (%scriptpath%\tmp\%kenh%.0) do (
	!streamlink! "%%i" > "%scriptpath%\tmp\%kenh%.7"
	findstr /i "Available streams" < "%scriptpath%\tmp\%kenh%.7" && (
		echo =================================================
		echo Source [!stt!] link No. !count! : %%i
		call :GetRes res %%i
		if !res! leq !lim! (
			echo [ !res! ] ^< [ lim=!lim! ] - OK
			!ini! tv.ini [!kenh!] link!count!=%%i
			!ini! tv.ini [!kenh!] resolution=!res!
			set /a "count+=1" 
		) else (
			echo [ !res! ] ^> [ lim=!lim! ] - Khong su dung link nay
		)
	)
	if !count! geq 5 goto :eof
)
if %count% equ 1 (
	set /a stt+=1
	goto :GetLink1 )
::if exist .\tmp\%kenh%.* del "%scriptpath%\tmp\%kenh%.*"
endlocal
goto :eof

:GetRes
	@echo off
	setlocal
	set "link=%~2"
	call apps.bat
	%ffprobe% -v error -select_streams v:0 -show_entries stream=height,width -of csv=s=x:p=0 "%link%" > "%scriptpath%\tmp\%kenh%.8"
	for /f %%x in (' findstr /i "x" %scriptpath%\tmp\%kenh%.8 ') do set "res=%%x"
	for /f "tokens=1 delims=x" %%x in ("%res%") do set /a "res1=%%x"
	endlocal & if not "%~1"=="" set /a "%~1=%res1%" & exit /b

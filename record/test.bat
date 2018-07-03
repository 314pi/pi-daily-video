@echo off
set a=00:10:00
call :TTN a "%a%"
echo %a%
set /a x=%a% -100
echo %x%


: TTN num time
	setlocal enableextensions disabledelayedexpansion
	if "%~2"=="" ( set "yy=%time%" ) else ( set "yy=%~2" )
	set /a h=100%yy:~0,2% %% 100
	if %h% lss 10 set h=0%h%
	set /a num=(1%h%-100)*3600 + (1%yy:~3,2%-100)*60 + (1%yy:~6,2%-100)
	endlocal & if not "%~1"=="" set /a "%~1=%num%" & exit /b
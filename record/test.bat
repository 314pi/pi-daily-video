@echo off
cls
call :TimeSub dur "16:00:00,00" "18:00:00,00"
echo %dur%

goto :eof

: TimeSub st xx yy
	setlocal enableextensions disabledelayedexpansion
	if "%~3"=="" ( set "yy=%time%" ) else ( set "yy=%~3" )
	set /a h=%yy:~0,2%
	if %h% lss 10 set h=0%h%
	set /a end=(1%h%-100)*3600 + (1%yy:~3,2%-100)*60 + (1%yy:~6,2%-100)
	
	set "xx=%~2"
	set /a h=%xx:~0,2%
	if %h% lss 10 set h=0%h%
	set /a start=(1%h%-100)*3600 + (1%xx:~3,2%-100)*60 + (1%xx:~6,2%-100)
	
	if %start% geq %end% (
		set /a num=%start% - %end%
	) else (
		set /a num=%end% - %start% )
	set /a gio=%num% / 3600
	set /a phut=(%num% - %gio%*3600) / 60
	set /a giay=(%num% - %gio%*3600 - %phut%*60)

	if %gio% geq 24 set /a gio=%gio%-24
	if %gio% lss 10 set gio=0%gio%
	if %phut% lss 10 set phut=0%phut%
	if %giay% lss 10 set giay=0%giay%

	endlocal & if not "%~1"=="" set "%~1=%gio%:%phut%:%giay%" & exit /b
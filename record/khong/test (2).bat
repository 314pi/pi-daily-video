call :ini t tv.ini test stop

:: Test if time contains "correct" (usual) data. Else try something else
    echo(%t%|findstr /i /r /x /c:"[0-9:,.apm -]*" >nul || ( 
        set "t="
        for /f "tokens=2" %%a in ('2^>nul robocopy "|" . /njh') do (
            if not defined t set "t=%%a,00"
        )
        rem If we do not have a valid time string, leave
        if not defined t exit /b
    )
	
echo %t%
::call :getStop stop 1 30
::echo %stop%
goto :eof


:: Thoi gian thuc hien ghi Video
:getStop stop gi ph
	@echo off
	setlocal enableextensions disabledelayedexpansion
	if not "%~2"=="" (
		set /a tg=%~2
	) else (
		set /a tg=0 )
	if not "%~3"=="" (
		set /a tp=%~3
	) else (
		set /a tp=0 )

	set start=%time%
	set /a thoigian=(1%start:~0,2%-100)*3600 + (1%start:~3,2%-100)*60 + (1%start:~6,2%-100) + %tg%*3600 + %tp%*60
	
	set /a gio=%thoigian% / 3600
	if %gio% geq 24 set /a gio=%gio%-24
	set /a phut=(%thoigian% - %gio%*3600) / 60
	set /a giay=(%thoigian% - %gio%*3600 - %phut%*60)
	
	if %gio% lss 10 set gio=0%gio%
	if %phut% lss 10 set phut=0%phut%
	if %giay% lss 10 set giay=0%giay%

	endlocal & if not "%~1"=="" set "%~1=%gio%:%phut%:%giay%,00" & exit /b
	
::Doc file cau hinh TV.INI
:ini bien [tepini] [muc] [khoa]
	@echo off
	setlocal enableextensions enabledelayedexpansion
	set file=%~2
	set area=[%~3]
	set key=%~4
	set currarea=
	for /f "usebackq delims=" %%a in ("!file!") do (
		set ln=%%a
		if "x!ln:~0,1!"=="x[" (
			set currarea=!ln!
		) else (
			for /f "tokens=1,2 delims==" %%b in ("!ln!") do (
				set currkey=%%b
				set currval=%%c
				if "x!area!"=="x!currarea!" if "x!key!"=="x!currkey!" (
					goto done
				)
			)
		)
	)
	:done
	endlocal & if not "%~1"=="" set "%~1=%currval%" & exit /b
	goto :eof
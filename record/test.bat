@echo off
setlocal enableextensions enabledelayedexpansion
cls
call :ini b tv.ini thvl1 link1
echo %b%
goto :eof




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
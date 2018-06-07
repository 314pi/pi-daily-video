@echo off
setlocal enabledelayedexpansion
cls
set simple=%1
if [%simple%]==[] set simple=1
::==================================================================
set ffprobe=C:\Program Files (x86)\Streamlink\ffmpeg\ffprobe.exe
set ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe
set name=%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ts
set name=%name: =% 

::==================================================================
if exist p4j.txt del p4j.txt
copy NUL p4j.txt
if %simple% equ 1 goto simple
::==============================COMPLEX JOIN
for %%i in (part*.ts) do (
:: Sua file goc and if Resolution # 640x360 then change resolution to 640x360 keep video quality
	"!ffprobe!" -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 %%i >reso.txt
	set /p reso=<reso.txt
	del reso.txt
	if "x!reso:640x360=!" == "x!reso!" (
		::echo CHU Y .....!reso!
		::pause
		"!ffmpeg!" -i %%i -strict experimental -vcodec libx264 -vf scale=640:360 -crf 30 -ss 0 -t 10800 repair%%i
 	) else (
		"!ffmpeg!" -probesize 50M -analyzeduration 50M -i %%i -vcodec copy -acodec copy -ss 0 -to 10800 repair%%i
	)
	timeout /t 3 /nobreak
	::del %%i
	::ren repair%%i %%i
:: Insert to join list text file
	echo file 'repair%%i' >> p4j.txt
)

:: Join
"%ffmpeg%" -f concat -i p4j.txt -c copy join_%name%
del p4j.txt
goto :eof
::==============================SIMPLE JOIN PARTS
:simple
(for %%i in (part*.ts) do @echo file '%%i') > p4j.txt
"%ffmpeg%" -f concat -i p4j.txt -c copy join_%name%
del p4j.txt
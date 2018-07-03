@echo off
setlocal enabledelayedexpansion & cls
::::::::::::::::: START
set del1=00:01:02
::::::::::::::::: P I
set fil1=00:10:32
::::::::::::::::: QC I
set adv1=00:14:32
::::::::::::::::: P II
set fil2=00:30:32
::::::::::::::::: QC II
set adv2=00:33:32
::::::::::::::::: P III
set sub2=00:39:00
::=================================
set thumb=tdqmm.jpg
set tap=33
set /a sub=1
call :TTN del1 %del1%
call :TTN fil1 %fil1%
call :TTN adv1 %adv1%
call :TTN fil2 %fil2%
call :TTN adv2 %adv2%
call :TTN sub2 %sub2%
set /a sub1=del1 + 10
set /a fil3=sub2 - 10
if %sub% equ 0 ( set "sub1=%del1%" & set "fil3=%sub2%" )
set filename=phim.mp4
set ffmpeg=%ProgramFiles(x86)%\Streamlink\ffmpeg\ffmpeg.exe
::"%ffmpeg%" -loop 1 -i %thumb% -vf "drawtext=fontfile='arial_0.ttf':text='TAP %tap%':x=w-tw-15:y=15:fontsize=50:fontcolor=red" -c:v libx264 -t 2 -pix_fmt yuv420p -y thumb.mp4
echo Separating Sengments ...
"%ffmpeg%" -fflags +genpts -i %filename% -map 0 -c copy -segment_times %del1%,%sub1%,%fil1%,%adv1%,%fil2%,%adv2%,%fil3%,%sub2% -f segment -reset_timestamps 1 -v error -y seg%%d.mp4
del seg0.mp4 seg3.mp4 seg5.mp4 seg8.mp4
if %sub% equ 0 goto IgSub
::=================================Set font size for SUB 1 and SUB 2
set "subfont1=11" & set "subfont2=13"
set subtext1=-vf "[in]drawtext=fontfile='arial_0.ttf':textfile=sub1.txt:x=(w-text_w)/2:y=5:fontsize=%subfont1%:fontcolor=white, drawtext=fontfile='arial_0.ttf':text=%tap%:x=w-text_w:y=0:fontsize=40:fontcolor=red[out]"
set subtext2=-vf "drawtext=fontfile='arial_0.ttf':textfile=sub2.txt:x=(w-text_w)/2:y=5:fontsize=%subfont2%:fontcolor=white"
::================================= Make SUB 1
echo Makeking SUB 1...
timeout /t 3 /nobreak > NUL
"%ffmpeg%" -i seg1.mp4 %subtext1% -vcodec libx264 -crf 30 -c:a copy -ss 0 -t 10800 -y sub1.mp4
del seg1.mp4
ren sub1.mp4 seg1.mp4
::================================= Make SUB 2
echo Making SUB 2 ...
timeout /t 3 /nobreak > NUL
"%ffmpeg%" -i seg7.mp4 %subtext2% -vcodec libx264 -crf 30 -c:a copy -ss 0 -t 10800 -y sub2.mp4
del seg7.mp4
ren sub2.mp4 seg7.mp4

:IgSub
if %sub% equ 0 del seg1.mp4 seg7.mp4
echo ffconcat version 1.0 > p4j.txt
::echo file thumb.mp4 >> p4j.txt
(for %%i in (seg*.mp4) do @echo file %%i) >> p4j.txt
echo Joining segs...
set name=%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.mp4
set name=%name: =%
timeout /t 3 /nobreak > NUL
"%ffmpeg%" -y -v error -i p4j.txt -map 0 -c copy -y join_%name%
del p4j.txt

goto :eof

: TTN num time
	setlocal enableextensions disabledelayedexpansion
	if "%~2"=="" ( set "yy=%time%" ) else ( set "yy=%~2" )
	set /a h=100%yy:~0,2% %% 100
	if %h% lss 10 set h=0%h%
	set /a num=(1%h%-100)*3600 + (1%yy:~3,2%-100)*60 + (1%yy:~6,2%-100)
	endlocal & if not "%~1"=="" set /a "%~1=%num%" & exit /b
@echo off
setlocal enabledelayedexpansion & cls
::::::::::::::::: START
set del1=00:00:00
::::::::::::::::: TEXT I
set sub1=00:00:30
::::::::::::::::: P I
set fil1=00:17:36
::::::::::::::::: QC I
set adv1=00:22:43
::::::::::::::::: P II
set fil2=00:33:38
::::::::::::::::: QC II
set adv2=00:38:46
::::::::::::::::: P III
set fil3=00:52:10
:::::::::::::::::TEXT II -> END
set sub2=00:52:40
::=================================
set thumb=tdqmm.jpg
set tap=33
set /a sub=1
if %sub% equ 0 ( set "sub1=%del1%" & set "fil3=%sub2%" )
set filename=phim.ts
set ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg2\ffmpeg.exe
::"%ffmpeg%" -loop 1 -i %thumb% -vf "drawtext=fontfile='arial_0.ttf':text='TAP %tap%':x=w-tw-15:y=15:fontsize=50:fontcolor=red" -c:v libx264 -t 2 -pix_fmt yuv420p -y thumb.ts
echo Separating Sengments ...
"%ffmpeg%" -fflags +genpts -i %filename% -map 0 -c copy -segment_times %del1%,%sub1%,%fil1%,%adv1%,%fil2%,%adv2%,%fil3%,%sub2% -f segment -reset_timestamps 1 -v error seg%%d.ts
if %sub% equ 0 goto IgSub
::=================================Set font size for SUB 1 and SUB 2
set "subfont1=11" & set "subfont2=13"
set subtext1=-vf "drawtext=fontfile='arial_0.ttf':textfile=sub1.txt:x=(w-text_w)/2:y=10:fontsize=%subfont1%:fontcolor=white"
set subtext2=-vf "drawtext=fontfile='arial_0.ttf':textfile=sub2.txt:x=(w-text_w)/2:y=10:fontsize=%subfont2%:fontcolor=white"
::================================= Make SUB 1
echo Makeking SUB 1...
timeout /t 3 /nobreak > NUL
"%ffmpeg%" -i seg1.ts %subtext1% -vcodec libx264 -crf 20 -c:a copy -ss 0 -t 10800 sub1.ts
del seg1.ts
ren sub1.ts seg1.ts
::================================= Make SUB 2
echo Making SUB 2 ...
timeout /t 3 /nobreak > NUL
"%ffmpeg%" -i seg7.ts %subtext2% -vcodec libx264 -crf 20 -c:a copy -ss 0 -t 10800 sub2.ts
del seg7.ts
ren sub2.ts seg7.ts

:IgSub
del seg0.ts seg3.ts seg5.ts seg8.ts
if %sub% equ 0 del seg1.ts seg7.ts
echo ffconcat version 1.0 > p4j.txt
::echo file thumb.ts >> p4j.txt
(for %%i in (seg*.ts) do @echo file %%i) >> p4j.txt
echo Joining segs...
set name=%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ts
set name=%name: =%
timeout /t 3 /nobreak > NUL
"%ffmpeg%" -y -v error -i p4j.txt -map 0 -c copy join_%name%
del p4j.txt
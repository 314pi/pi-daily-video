@echo off
setlocal enabledelayedexpansion
cls
::=================================LIST SEGNEMTS TO SEPARATE
set filename=filegoc.ts
set /a sub=0
set /a compress=0
set /a speedup=0

:: First seg - REMOVE
set del1=00:09:04

:: Segment for SUB 1 - File name=seg1.ts - Length = 10 seconds.
set sub1=00:09:14

:: seg1 of FILM
set fil1=00:21:51

:: Adv 1 - REMOVE
set adv1=00:26:21

:: seg2 of FILM
set fil2=00:39:51

:: Adv 2 - REMOVE
set adv2=00:44:19

::seg3 of FILM
set fil3=00:57:07

:: Segment for SUB 2 - Length = 60 seconds - Filename=seg7.ts
set sub2=00:58:07
if %sub% equ 0 ( set "sub1=%del1%" & set "fil3=%sub2%" )
:: Last seg - REMOVE (remain seg - auto make by ffmpeg)
::=================================
set ffprobe=C:\Program Files (x86)\Streamlink\ffmpeg\ffprobe.exe
set ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe
set vlcpath=C:\Program Files\VideoLAN\VLC\vlc.exe
if not exist "%vlcpath%" set vlcpath=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe
if not exist "%vlcpath%" set /p vlcpath=Enter VLC path: 
set voice_opt=-I dummy --play-and-exit --volume 1024
set upload="%vlcpath%" %voice_opt% upload.mp3
set start=%time%

::=================================SEPARATE RECORD FILE TO SEGMENTS
echo Separating Sengments ...
"%ffmpeg%" -i %filename% -c copy -segment_times %del1%,%sub1%,%fil1%,%adv1%,%fil2%,%adv2%,%fil3%,%sub2% -f segment seg%%d.ts

if %sub% equ 0 goto ig_sub
::=================================Set font size for SUB 1 and SUB 2
set subfont1=10
set subfont2=20
set subtext1=-vf "drawtext=fontfile='arial_0.ttf':textfile=sub1.txt:x=(w-text_w)/2:y=10:fontsize=%subfont1%:fontcolor=white"
set subtext2=-vf "drawtext=fontfile='arial_0.ttf':textfile=sub2.txt:x=(w-text_w)/2:y=10:fontsize=%subfont2%:fontcolor=white"
::================================= Make SUB 1
echo Makeking SUB 1...
timeout /t 3 /nobreak >NUL
"%ffmpeg%" -i seg1.ts -strict experimental %subtext1% -vcodec libx264 -crf 30 -c:a copy -ss 0 -t 60 sub1.ts
del seg1.ts
ren sub1.ts seg1.ts

::================================= Make SUB 2
echo Making SUB 2 ...
timeout /t 3 /nobreak >NUL
"%ffmpeg%" -i seg7.ts -strict experimental %subtext2% -vcodec libx264 -crf 30 -c:a copy -ss 0 -t 60 sub2.ts
del seg7.ts
ren sub2.ts seg7.ts

:ig_sub
::================================= Remove un-used segs
del seg0.ts seg3.ts seg5.ts seg8.ts
if %sub% equ 0 del seg1.ts seg7.ts

::================================= LIST segs FOR JOIN
(for %%i in (seg*.ts) do @echo file '%%i') > p4j.txt
echo Joining segs...
timeout /t 3 /nobreak >NUL
set name=%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ts
set name=%name: =% 
"%ffmpeg%" -f concat -i p4j.txt -c copy join_%name%
del p4j.txt

::============ Quality is good enough, the file size is lower by almost 40% from https://ubuntuforums.org/archive/index.php/t-2040541.html
if %compress% equ 0 goto ig_compress
echo Re encoding (compressing) ...
timeout /t 5 /nobreak >NUL
::set speed=-filter_complex "[0:v]setpts=(1/1.08)*PTS[v];[0:a]atempo=1.08[a]" -map "[v]" -map "[a]"
"%ffmpeg%" -i join_%name% -strict experimental -vcodec libx264 -crf 30 -c:a copy -ss 0 -t 10800 comp_%name%
:ig_compress
::=================================Speedup video and audio
if %speedup% equ 0 goto ig_speedup
REM echo Speedup Video and Audio ...
REM timeout /t 5 /nobreak >NUL
REM "%vlcpath%" -I dummy -vvv comp_%name% --rate=2.0 --sout=file/ts:rate_%name% vlc://quit
:ig_speedup
::=================================Time have
echo START @: %start% / END @: %time%
%upload%
@echo off
setlocal enabledelayedexpansion & cls
set filename=phim.mp4
set /a sub=1
set /a compress=0
set /a speedup=1
set pispd=1.1
set special=0
set logo=htv21.png
::::::::::::::::::: First seg - REMOVE
set del1=00:00:00
::::::::::::::::::: Segment for SUB 1 - File name=seg1.mp4 - Length = 10 seconds.
set sub1=00:00:10
::::::::::::::::::: seg1 of FILM
set fil1=00:13:00
::::::::::::::::::: Adv 1 - REMOVE
set adv1=00:17:45
::::::::::::::::::: seg2 of FILM
set fil2=00:33:29
::::::::::::::::::: Adv 2 - REMOVE
set adv2=00:38:31
:::::::::::::::::::seg3 of FILM
set fil3=00:49:21
::::::::::::::::::: Segment for SUB 2 - Length = 60 seconds - Filename=seg7.mp4
set sub2=00:49:31

if %sub% equ 0 ( set "sub1=%del1%" & set "fil3=%sub2%" )
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
"%ffmpeg%" -i %filename% -c copy -segment_times %del1%,%sub1%,%fil1%,%adv1%,%fil2%,%adv2%,%fil3%,%sub2% -f segment seg%%d.mp4

if %sub% equ 0 goto ig_sub
::=================================Set font size for SUB 1 and SUB 2
set "subfont1=10" & set "subfont2=15"
:: USE FOR SPECIAL MODE
if %special% equ 1 ( set "subfont1=20" & set "subfont2=30")
set subtext1=-vf "drawtext=fontfile='arial_0.ttf':textfile=sub1.txt:x=(w-text_w)/2:y=10:fontsize=%subfont1%:fontcolor=white"
set subtext2=-vf "drawtext=fontfile='arial_0.ttf':textfile=sub2.txt:x=(w-text_w)/2:y=10:fontsize=%subfont2%:fontcolor=white"
::================================= Make SUB 1
echo Makeking SUB 1...
timeout /t 3 /nobreak >NUL
"%ffmpeg%" -i seg1.mp4 -strict experimental %subtext1% -vcodec libx264 -crf 30 -c:a copy -ss 0 -t 10800 sub1.mp4
del seg1.mp4
ren sub1.mp4 seg1.mp4
if %special% equ 1 (
	"%ffmpeg%" -i seg1.mp4 -i %logo% -strict experimental -vcodec libx264 -crf 30 -filter_complex "overlay=main_w-overlay_w-5:5" -c:a copy -ss 0 -t 10800 sub1.mp4
	del seg1.mp4
	ren sub1.mp4 seg1.mp4
)

::================================= Make SUB 2
echo Making SUB 2 ...
timeout /t 3 /nobreak >NUL
"%ffmpeg%" -i seg7.mp4 -strict experimental %subtext2% -vcodec libx264 -crf 30 -c:a copy -ss 0 -t 10800 sub2.mp4
del seg7.mp4
ren sub2.mp4 seg7.mp4

:ig_sub
::================================= Remove un-used segs
del seg0.mp4 seg3.mp4 seg5.mp4 seg8.mp4
if %sub% equ 0 del seg1.mp4 seg7.mp4

::================================= LIST segs FOR JOIN
(for %%i in (seg*.mp4) do @echo file '%%i') > p4j.txt
echo Joining segs...
timeout /t 3 /nobreak >NUL
set name=%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.mp4
set name=%name: =% 
"%ffmpeg%" -f concat -i p4j.txt -c copy join_%name%
del p4j.txt

::============ Quality is good enough, the file size is lower by almost 40% from https://ubuntuforums.org/archive/index.php/t-2040541.html
if %compress% equ 0 goto ig_compress
if %speedup% equ 0 (
	set speed=-c:a copy
) else (
	set speed=-filter_complex "[0:v]setpts=(1/%pispd%)*PTS[v];[0:a]atempo=%pispd%[a]" -map "[v]" -map "[a]"
)
echo Re encoding (compressing) ...
timeout /t 5 /nobreak >NUL
::set speed=-filter_complex "[0:v]setpts=(1/1.25)*PTS[v];[0:a]atempo=1.25[a]" -map "[v]" -map "[a]"
"%ffmpeg%" -i join_%name% -vcodec libx264 -crf 30 %speed% -ss 0 -t 10800 comp_%name%
:ig_compress
::=================================Speedup video and audio
::if %speedup% equ 0 goto ig_speedup
REM echo Speedup Video and Audio ...
REM timeout /t 5 /nobreak >NUL
REM "%vlcpath%" -I dummy -vvv comp_%name% --rate=2.0 --sout=file/ts:rate_%name% vlc://quit
:::ig_speedup
::=================================Time have
echo START @: %start% / END @: %time%
::%upload%
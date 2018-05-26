@echo off
setlocal enabledelayedexpansion
cls
::=================================LIST SEGNEMTS TO SEPARATE
set filename=filegoc.ts

:: First seg - REMOVE
set del1=00:11:41

:: Segment for SUB 1 - File name=part1.ts - Length = 60 seconds.
set sub1=00:12:41

:: Part1 of FILM
set fil1=00:24:18

:: Adv 1 - REMOVE
set adv1=00:26:13

:: Part2 of FILM
set fil2=00:38:20

:: Adv 2 - REMOVE
set adv2=00:38:44

::Part3 of FILM
set fil3=00:49:00

:: Segment for SUB 2 - Length = 60 seconds - Filename=part7.ts
set sub2=00:50:00

:: Last seg - REMOVE (remain part - auto make by ffmpeg)

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
::cls
echo Separating Sengments ...
"%ffmpeg%" -i %filename% -c copy -segment_times %del1%,%sub1%,%fil1%,%adv1%,%fil2%,%adv2%,%fil3%,%sub2% -f segment part%%d.ts
::pause

::================================= Make SUB 1
::cls
echo Makeking SUB 1...
timeout /t 3 /nobreak >NUL
"%ffmpeg%" -i part1.ts -strict experimental -vf "drawtext=fontfile='arial_0.ttf':textfile=sub1.txt:x=(w-text_w)/2:y=10:fontsize=10:fontcolor=white" -vcodec libx264 -crf 30 -c:a copy -ss 0 -t 60 sub1.ts
del part1.ts
ren sub1.ts part1.ts
::pause

::================================= Make SUB 2
::cls
echo Making SUB 2 ...
timeout /t 3 /nobreak >NUL
"%ffmpeg%" -i part7.ts -strict experimental -vf "drawtext=fontfile='arial_0.ttf':textfile=sub2.txt:x=(w-text_w)/2:y=10:fontsize=20:fontcolor=white" -vcodec libx264 -crf 30 -c:a copy -ss 0 -t 60 sub2.ts
del part7.ts
ren sub2.ts part7.ts
::pause

::================================= Remove un-used Parts
del part0.ts part3.ts part5.ts part8.ts
::pause

::================================= LIST PARTS FOR JOIN
(for %%i in (part*.ts) do @echo file '%%i') > p4j.txt
::pause

::=================================JOIN PARTS
::cls
echo Joining parts...
timeout /t 3 /nobreak >NUL
set name=%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ts
set name=%name: =% 
"%ffmpeg%" -f concat -i p4j.txt -c copy join_%name%

::============ Quality is good enough, the file size is lower by almost 40% from https://ubuntuforums.org/archive/index.php/t-2040541.html
::cls
echo Re encoding (compressing) ...
timeout /t 5 /nobreak >NUL
"%ffmpeg%" -i join_%name% -strict experimental -vcodec libx264 -crf 30 -c:a copy -ss 0 -t 10800 nen_%name%

::=================================Time have
::cls
echo START @: %start% / END @: %time%
%upload%
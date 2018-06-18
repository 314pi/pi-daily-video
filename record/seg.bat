@echo off
setlocal enabledelayedexpansion & cls
::::::::::::::::: Bat Dau Phim
set del1=00:00:20
::::::::::::::::: P I
set fil1=00:21:24
::::::::::::::::: QC I
set adv1=00:22:30
::::::::::::::::: P II
set fil2=00:22:30
::::::::::::::::: QC II
set adv2=00:22:30
:::::::::::::::::P 3
set fil3=01:59:59
::=================================
set filename=phim.mp4
set ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg2\ffmpeg.exe
echo Separating Sengments ...
"%ffmpeg%" -fflags +genpts -i %filename% -map 0 -c copy -segment_times %del1%,%fil1%,%adv1%,%fil2%,%adv2%,%fil3% -f segment -segment_format mp4 -reset_timestamps 1 -v error seg%%d.mp4
del seg0.mp4 seg2.mp4 seg4.mp4 seg6.mp4
echo ffconcat version 1.0 > p4j.txt
(for %%i in (seg*.mp4) do @echo file %%i) >> p4j.txt
echo Joining segs...
set name=%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.mp4
set name=%name: =%
timeout /t 3 /nobreak > NUL
"%ffmpeg%" -y -v error -i p4j.txt -map 0 -c copy join_%name%
del p4j.txt
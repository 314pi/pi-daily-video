@echo off
set tap=BayTinhYeu_5
set input=%tap%.mp4
set output=%tap%.ok.mp4
set ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg2\ffmpeg.exe
::=====================
"%ffmpeg%" -i "%input%" -ss 00:00:16 -to 01:01:11 -movflags faststart -fflags +genpts -v error -vcodec copy -acodec copy "%output%"
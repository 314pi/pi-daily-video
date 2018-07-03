@echo off
set input=filegoc.mp4
set output=phim.mp4
set ffmpeg=%ProgramFiles(x86)%\Streamlink\ffmpeg\ffmpeg.exe
::=====================
"%ffmpeg%" -i "%input%" -ss 00:17:24 -to 01:55:09 -movflags faststart -fflags +genpts -v error -vcodec copy -acodec copy "%output%
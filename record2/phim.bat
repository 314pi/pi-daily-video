@echo off
set input=filegoc.mp4
set output=phim.mp4
set ffmpeg=%ProgramFiles(x86)%\Streamlink\ffmpeg\ffmpeg.exe
::=====================
"%ffmpeg%" -i "%input%" -ss 00:00:00 -to 01:56:30 -movflags faststart -fflags +genpts -v error -vcodec copy -acodec copy "%output%
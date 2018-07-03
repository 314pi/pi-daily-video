@echo off
set input=LatMatHungThu_6.mp4
set output=c_LatMatHungThu_6.mp4
set ffmpeg=%ProgramFiles(x86)%\Streamlink\ffmpeg\ffmpeg.exe
::=====================
"%ffmpeg%" -i "%input%" -ss 00:00:17 -to 00:59:56 -movflags faststart -fflags +genpts -v error -vcodec copy -acodec copy "%output%
del %input%
ren %output% %input%
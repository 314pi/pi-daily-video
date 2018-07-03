@echo off
set ffmpeg=%ProgramFiles(x86)%\Streamlink\ffmpeg\ffmpeg.exe
set tem=..\tem
set spd=1.1
set start=%time%
::=====================
for %%a in (*.mp4) do (
	"%ffmpeg%" -i %%a -c copy -vn -y %tem%\audio.m4a
	"%ffmpeg%" -i %%a -c copy -an -y %tem%\video.mp4
	"%ffmpeg%" -i %tem%\video.mp4 -filter:v "setpts=1/%spd%*PTS" -y %tem%\vspd.mp4
	"%ffmpeg%" -i %tem%\audio.m4a -filter:a "atempo=%spd%" -y %tem%\aspd.m4a
	"%ffmpeg%" -i %tem%\vspd.mp4 -i %tem%\aspd.m4a -c copy -y ..\spd_%%a
)
echo [start: %start% ]-[end: %time% ]
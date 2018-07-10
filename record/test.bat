set scriptpath=%~dp0
set scriptpath=%scriptpath:~0,-1%
echo %scriptpath%
if not "x%PROCESSOR_ARCHITECTURE:64=%" == "x%PROCESSOR_ARCHITECTURE%" ( 
	set ffmpeg=%scriptpath%\streamlink\ffmpeg64\ffmpeg.exe
	set ffprobe=%scriptpath%\streamlink\ffmpeg64\ffprobe.exe
	set ffplay=%scriptpath%\streamlink\ffmpeg64\ffplay.exe
	set vlc=%scriptpath%\streamlink\vlc64\vlc.exe
) else (
	set ffmpeg=%scriptpath%\streamlink\ffmpeg32\ffmpeg.exe
	set ffprobe=%scriptpath%\streamlink\ffmpeg32\ffprobe.exe
	set ffplay=%scriptpath%\streamlink\ffmpeg32\ffplay.exe
	set vlc=%scriptpath%\streamlink\vlc32\vlc.exe
)
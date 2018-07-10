if not "x%PROCESSOR_ARCHITECTURE:64=%" == "x%PROCESSOR_ARCHITECTURE%" ( 
	echo 64 
	set ffmpeg=.\streamlink\ffmpeg64\ffmpeg.exe
	set ffprobe=.\streamlink\ffmpeg64\ffprobe.exe
	set ffplay=.\streamlink\ffmpeg64\ffplay.exe
	set vlc=.\streamlink\vlc64\vlc.exe
)
"%vlc%"
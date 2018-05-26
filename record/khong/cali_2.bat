@echo off
setlocal enabledelayedexpansion
set p_ffprobe=C:\Program Files (x86)\Streamlink\ffmpeg\ffprobe.exe
set p_ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe
set pcopy=-vcodec copy -acodec copy
cls
::=================================================================
for /f "tokens=1,2,3 delims=," %%L in (p4c.txt) do (
	if not [%%M] == [] (
		set p_file=%%L
		set p_start=%%M
		set p_end=%%N
		if "%%N" == "end" (
			"!p_ffprobe!" -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 %%L >temp.txt
			set /p p_end=<temp.txt
		)
		set p_split=!pcopy! -ss !p_start! -to !p_end! cali_!p_file!
		"%p_ffmpeg%" -i !p_file! !p_split!
	) else (
		ren %%L cali_%%L
	)
)
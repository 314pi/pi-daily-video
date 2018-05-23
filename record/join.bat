set filename=join_%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ts
set filename=%filename: =% 
"C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe" -f concat -i l4j.txt -c copy %filename%
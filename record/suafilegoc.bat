"C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe" -probesize 50M  -analyzeduration 50M -i filegoc.ts -vcodec copy -acodec copy -ss 0 -to 10800 split.ts
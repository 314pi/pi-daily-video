set pcopy=-vcodec copy -acodec copy
set part1=%pcopy% -ss 00:00:00 -to 00:01:00 part1.ts 

"C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe" -probesize 50M  -analyzeduration 50M -i autosplit.ts %part1%
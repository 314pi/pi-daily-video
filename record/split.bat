set part1=-vcodec copy -acodec copy -ss 00:07:04 -to 00:19:07 part1.ts
set part2=-vcodec copy -acodec copy -ss 00:22:57 -to 00:34:39 part2.ts
set part3=-vcodec copy -acodec copy -ss 00:38:57 -to 00:55:59 part3.ts

"C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe" -i split.ts %part1% %part2% %part3%
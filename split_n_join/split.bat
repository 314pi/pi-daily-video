set part1=-vcodec copy -acodec copy -ss 00:00:00 -to 00:05:08 part1.ts
set part2=-vcodec copy -acodec copy -ss 00:09:41 -to 00:45:08 part2.ts
set part3=-vcodec copy -acodec copy -ss 00:45:43 -to 00:59:59 part3.ts

"C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe" -i split.ts %part1% %part2% %part3%
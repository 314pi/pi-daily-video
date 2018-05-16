set filename=thvl1_%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set vlc=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe -I dummy --sout=file/ts:%filename%.ts --run-time 4200 --play-and-exit

set thvl1=http://talk2.vcdn.vn/hls/9068ed7d7c3a6661a8e31fbfd4498ea5/1636896d974/thoixungan/index.m3u8

start "thvl1" streamlink --player "%vlc%" %thvl1% worst --hls-segment-threads 3

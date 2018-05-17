set filename=thvl1_%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ts
set filename=%filename: =% 
set vlc=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe -I dummy --sout=file/ts:%filename% --network-caching=60000 --run-time 4200 --play-and-exit

set thvl1=http://talk2.vcdn.vn/hls/c056383b080b512d0629dc43b39c018d/1636b77954c/thoixungan/index.m3u8

:start_record

tasklist /fi "WindowTitle eq pi-thvl1" | find /i "streamlink.exe" || start "pi-thvl1" streamlink --player "%vlc%" %thvl1% worst --hls-segment-threads 3

timeout /t 10 /nobreak

goto start_record
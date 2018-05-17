set filename=vtv1_%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set vlc=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe -I dummy --sout=file/ts:%filename%.ts --network-caching=60000 --run-time 5400 --play-and-exit

set vtv1=http://vtvgo-live-appobj.b5695cde.cdnviet.com/aaffd1627b4d0e95fb35e5731b04fc761526488236/live/_definst_/vtv1-mid.m3u8

start "pi-vtv1" streamlink --player "%vlc%" %vtv1% worst --hls-segment-threads 3

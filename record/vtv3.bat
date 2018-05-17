set filename=vtv3_%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set vlc=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe -I dummy --sout=file/ts:%filename%.ts --network-caching=60000 --run-time 5400 --play-and-exit

set vtv3=http://vtvgo-live-appobj.b5695cde.cdnviet.com/af178cd077821b2925bfec0de489272f1526488254/live/_definst_/vtv3-mid.m3u8

start "pi-vtv3" streamlink --player "%vlc%" %vtv3% worst --hls-segment-threads 3

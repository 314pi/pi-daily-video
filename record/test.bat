set vlcpath=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe
set filename=thvl1_%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ts
set filename=%filename: =% 
set plogo=--logo-file logo.png --logo-x=10 --logo-y=10 --logo-opacity=164
set psout=--sout=#transcode{vcodec=h264,sfilter=logo}:std{access=file,dst=%filename%}}
set pothers=-I dummy --run-time 4200 --play-and-exit
set vlc=%vlcpath% %plogo% %psout% %pothers%
start "pi-thvl1" streamlink --player "%vlc%" "http://talk2.vcdn.vn/hls/71770336eb829b724d1bb50550a688f8/1637822ee60/thoixungan/index.m3u8" worst --hls-segment-threads 3
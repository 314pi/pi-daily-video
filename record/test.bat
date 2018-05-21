set vlcpath=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe
set filename=thvl1_%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ts
set filename=%filename: =% 
set plogo=--logo-file logo.png --logo-x=10 --logo-y=10 --logo-opacity=164
set psout=--sout=#transcode{vcodec=h264,sfilter=logo}:std{access=file,dst=%filename%}}
set pothers=-I dummy --run-time 4200 --play-and-exit
set vlc=%vlcpath% %plogo% %psout% %pothers%
start "pi-thvl1" streamlink --player "%vlc%" "http://talk2.vcdn.vn/hls/71770336eb829b724d1bb50550a688f8/1637822ee60/thoixungan/index.m3u8" worst --hls-segment-threads 3

cvlc v4l2:///dev/video0 --quiet-synchro --no-osd --sub-filter=marq --marq-marquee='%Y-%m-%d %H:%M:%S' --marq-color=32768 --marq-position=20 --marq-opacity=25 --marq-refresh=-1 --marq-size=15 :v4l2-standard= :input-slave=alsa://hw:0,0 :live-caching=200 :sout='#transcode{vcodec=h264,vb=2000,acodec=mpga,ab=128,channels=2,samplerate=44100,sfilter=marq}:duplicate{dst=http{dst=:8080/stream.wmv},dst=file{dst=stream.mp4,no-overwrite}}' :sout-keep

{{Module|name=marq|type=Video subfilter|description=Overlays text on the video}}

The marq subfilter can be used to display text on a video.

== Options ==

{{Option
|name=marq-marquee
|value=string
|default=VLC
|description=Marquee text to display. Since VLC version 0.9.0 you can use [[Documentation:Play_HowTo/Format_String|format strings]] to display time information}}

{{Option
|name=marq-x
|value=integer
|default=0 (0.8.6d and prior: -1)
|description=X offset from upper left corner. (0.8.6d and prior: This is only if both marq-x and marq-y are positive)
}}

{{Option
|name=marq-y
|value=integer
|default=0
|description=Y offset from upper left corner. (0.8.6d and prior: This is only if both marq-x and marq-y are positive)
}}

{{Option
|name=marq-position
|value=integer
|default=5
|description=Marquee position: 0=center, 1=left, 2=right, 4=top, 8=bottom, you can also use combinations of these values, eg 6 = top-right. (0.8.6d and prior: This is only used if marq-x or marq-y are negative)
}}

{{Option
|name=marq-opacity
|value=integer
|default=255
|description=Marquee opacity. 0 is transparent, 255 is fully opaque.
}}

{{Option
|name=marq-color
|value=integer
|default=16777215 (0xFFFFFF, white)
|description=Marquee color. Use the decimal value of the HTML color code.
}}

{{Option
|name=marq-size
|value=integer
|default=-1
|description=Font size in pixels. -1 uses the default font size
}}

{{Option
|name=marq-timeout
|value=integer
|default=0
|description=Number of millitseconds the marquee must remain displayed. 0 means forever.
}}

{{Option
|name=marq-refresh
|value=integer
|default=1000
|description=Number of milliseconds between string updates. This is mainly useful when using meta data or time format string sequences.
}}

== Examples ==

Example command line use '''(VLC 2.0.0 and newer)''':
 % '''vlc --sub-source="marq{marquee=test,color=16776960} somevideo.avi'''
:This example displays yellow ''test'' text in the top left corner of video

Example command line use '''(VLC 0.9.0 - 1.1.13)''':
 % '''vlc --sub-filter "marq{marquee=\$t (\$P%%),color=16776960}:marq{marquee=%H:%M:%S,position=6}" somevideo.avi'''
 % '''vlc --sub-filter 'marq{marquee=$t ($P%%),color=16776960}:marq{marquee=%H:%M:%S,position=6}' somevideo.avi'''
:This command line will show the stream's title ($t) and current position ($P) in the upper left corner and the current time in the upper right corner. Note that we have to escape $ characters when running this from command line in UNIX shells (this is why we use \$ instead of $). The second line uses single quotes to delimit the string so we don't need to escape the $ character.
:On windows the command line would be:
 C:\Program Files\VideoLAN\VLC\>'''vlc.exe --sub-filter=marq{marquee=$t ($P%%),color=16776960}:marq{marquee=%H:%m%s,position=6} somevideo.avi'''

Example command line '''(All versions including VLC 0.8.6d and prior)''':
 % '''vlc --sub-filter=marq --marq-marquee="Obvious Watermark" --marq-position=0 --marq-size=50 --marq-opacity=25 --marq-color=32768 somevideo.avi'''
:This command will show centered transparent green text. Text sized too large to fit the video window will not appear, and may crash VLC.

== See also ==
* [[Documentation:Format_String]]
* [[Documentation:Modules/rss]]

{{Stub}}

{{Documentation footer}}

[[Category:Video Filters]]



% % vlc -vvv input_stream -sout-keep
-sout=#transcode{acodec=mp3}:duplicate{dst=display{delay=6000},
dst=gather:std{mux=mpeg1,dst=:8080/stream.mp3,access=http},select="novideo"} 

 start "pi-vtv1" streamlink --player "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe -I dummy --network-caching=60000 --play-and-exit --run-time 4200 --sub-filter=marq --marq-file=marq1.txt --marq-position=6 --marq-size=15 --marq-y=15 --sout=#transcode{vcodec=h264, scale=1, sfilter=logo, sfilter=marq}:std{access=file, dst=vtv1_2105_183234.ts}" http://vtvgo-live-appobj.b5695cde.cdnviet.com/ba5e10b633a92d2151e53a59b5562f1a1526912367/live/_definst_/vtv1-mid.m3u8 worst --hls-segment-threads 3
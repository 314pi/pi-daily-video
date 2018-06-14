@echo off 
setlocal enabledelayedexpansion 
set "vlcpath=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe"
set "voice_opt=-I dummy --play-and-exit --volume 1024"
cls
set chs[0]=thvl1
set chs[1]=vtv1
set chs[2]=vtv3
::set chs[3]=todaytv
::set chs[4]=htv2

set "x=0"
:LenLoop 
if defined chs[%x%] ( 
   set /a "x+=1"
   goto :LenLoop 
)

set /a len=%x%-1
for /l %%n in (0,1,%len%) do ( 
	set "sec=[!chs[%%n]!]"
	echo !sec!
	if !sec! equ [thvl1] 	set channel=thvl1.mp3
	if !sec! equ [vtv1] 	set channel=vtv1.mp3
	if !sec! equ [vtv3] 	set channel=vtv3.mp3
	if !sec! equ [todaytv] 	set channel=todaytv.mp3
	if !sec! equ [htv2] 	set channel=htv2.mp3
	set /a "nolink = 0"
	for /l %%i in (1,1,4) do (
		set key=link%%i
		for /f "delims=" %%a in ('ini.exe tv.ini !sec! !key!') do (
			%%a
			set link=!link%%i!
			if not "!link!" == "" ( 
				echo checking [!key!] ...
				streamlink "!link!" | find /i "Available streams" || (
					ini.exe tv.ini !sec! !key!==
					set /a "nolink +=1"
					echo [ remove this break url ]
				)
			) else (
				set /a "nolink += 1"
			)
		)
	)
	if !nolink! geq 4 (
		set canhbao="!vlcpath!" !voice_opt! !channel! ccl.mp3
		!canhbao!
	)
	echo _________________________________________
)
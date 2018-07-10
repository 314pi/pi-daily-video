@echo off
setlocal enabledelayedexpansion
call apps.bat
if exist tv.cop (
	if exist z:\tv.ini copy /y z:\tv.ini .\tv.ini
)
set "voice_opt=-I dummy --play-and-exit --volume 1024"
cls
set chs[0]=thvl1
set chs[1]=vtv1
set chs[2]=vtv3
::set chs[3]=htv2
::set chs[4]=todaytv

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
	for /l %%i in (0,1,4) do (
		set key=link%%i
		for /f "delims=" %%a in ('%ini% tv.ini !sec! !key!') do (
			%%a
			set link=!link%%i!
			if not "!link!" == "" (
				echo checking [!key!] ...
				"%streamlink%" "!link!" > ca.txt
				findstr /i "Available streams" < ca.txt || (
					set /a "nolink +=1"
					if %%i geq 1 (
						echo [ remove this break url ]
						%ini% tv.ini !sec! !key!== 
					)
				)
				del ca.txt
			) else (
				set /a "nolink += 1"
			)
		)
	)
	if !nolink! geq 5 (
		set canhbao="!vlc!" !voice_opt! !channel! ccl.mp3
		!canhbao!
	)
	echo _________________________________________
)
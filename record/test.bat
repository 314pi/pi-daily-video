for /f "delims=" %%x in (thvl1.txt) do set thvl1=%%x
echo %thvl1%
streamlink %thvl1% | find /i "Available streams" || echo ahahahaa
@echo off
cd /d %~dp0
::%1 start mshta vbscript:createobject("wscript.shell").run("""%~0"" ::",0)(window.close)&&exit

start /b overture-windows-amd64.exe -c ./config.yml
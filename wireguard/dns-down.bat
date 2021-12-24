@ECHO OFF 
cd /d %~dp0
%1 start mshta vbscript:createobject("wscript.shell").run("""%~0"" ::",0)(window.close)&&exit

taskkill /im overture-windows-amd64.exe /f

ping -n 2 127.1 >nul
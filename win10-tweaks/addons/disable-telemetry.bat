@echo off

echo Running %~n0...

cd /d "%~dp0"

if "%1"=="ok" goto SKIP_ELEVATE
echo call :Elevate "%0" ok
call :Elevate "%0" ok
exit
:SKIP_ELEVATE

goto ElevateEnd

:Elevate
	set COMMAND=%*
	ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
	ECHO UAC.ShellExecute "cmd", "/c %COMMAND%", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
	"%temp%\OEgetPrivileges.vbs"
goto :eof

:ElevateEnd

REM ================================================================

REM Import external utils here
set HOSTS=..\data\hosts.exe

for /F "usebackq tokens=*" %%A in ("telemetry-hosts.txt") do call :CheckAndAddHost %%A

goto End

:CheckAndAddHost
	set THE_HOST=%*

	if NOT "%THE_HOST%"=="%THE_HOST:#=%" (
		REM Comment has been found... skipping...
		goto :eof
	) 

	%HOSTS% set %THE_HOST% 0.0.0.0 >nul
goto :eof

:End
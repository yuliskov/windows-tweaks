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

set DATA_DIR=..\..\data

REM Import external utils here
set HOSTS=%DATA_DIR%\hosts.exe
set HOSTS_FILE=%~n0.txt

REM Doing backup one time only
if not exist "%WinDir%\System32\drivers\etc\hosts.bak" copy /y "%WinDir%\System32\drivers\etc\hosts" "%WinDir%\System32\drivers\etc\hosts.bak" >nul

REM Copy template
copy /y "%DATA_DIR%\hosts.origin" "%WinDir%\System32\drivers\etc\hosts" >nul

for /F "usebackq tokens=*" %%A in ("%HOSTS_FILE%") do call :CheckAndAddHost %%A

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
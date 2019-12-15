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

set TASKS_FILE=%~n0.txt

REM prepare for fix
taskkill /im msosync.exe /f 2>nul

for /F "usebackq tokens=*" %%A in ("%TASKS_FILE%") do call :DisableLog %%A

goto End

:DisableLog
	set THE_TASK=%*

	if NOT "%THE_TASK%"=="%THE_TASK:#=%" (
		REM Comment has been found... skipping...
		goto :eof
	)

	wevtutil set-log "%THE_TASK%" /enabled:false
	wevtutil clear-log "%THE_TASK%"
goto :eof

:End

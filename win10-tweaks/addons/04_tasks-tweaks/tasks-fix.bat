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

set TASKS_FILE_DISABLE=%~n0-disable.txt

set TASKS_FILE_ENABLE=%~n0-enable.txt

REM prepare for fix
taskkill /im msosync.exe /f >nul 2>nul

for /F "usebackq tokens=*" %%A in ("%TASKS_FILE_DISABLE%") do call :DisableTask %%A

for /F "usebackq tokens=*" %%A in ("%TASKS_FILE_ENABLE%") do call :EnableTask %%A

goto End

:DisableTask
	set THE_TASK=%*

	if NOT "%THE_TASK%"=="%THE_TASK:#=%" (
		REM Comment has been found... skipping...
		goto :eof
	)

	REM echo disabling %THE_TASK%...

	schtasks /Change /DISABLE /TN "%THE_TASK%" >nul 2>nul
goto :eof

:EnableTask
	set THE_TASK=%*

	if NOT "%THE_TASK%"=="%THE_TASK:#=%" (
		REM Comment has been found... skipping...
		goto :eof
	)

	REM echo disabling %THE_TASK%...

	schtasks /Change /ENABLE /TN "%THE_TASK%" >nul 2>nul
goto :eof

:End

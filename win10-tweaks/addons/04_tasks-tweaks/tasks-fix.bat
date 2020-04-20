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

REM Create UserSid env var: https://misctechmusings.com/batch-get-sid
for /f %%i in ('wmic useraccount where name^="%UserName%" get sid ^| findstr ^S\-d*') do set UserSid=%%i

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

	REM for /f "tokens=2 delims= " %%x in ('schtasks /query /fo list ^| findstr "%THE_TASK%"') do echo disabling "%%x" "%THE_TASK%"

	schtasks /Change /DISABLE /TN "%THE_TASK%" >nul 2>nul
goto :eof

:EnableTask
	set THE_TASK=%*

	if NOT "%THE_TASK%"=="%THE_TASK:#=%" (
		REM Comment has been found... skipping...
		goto :eof
	)

	REM for /f "tokens=2 delims= " %%x in ('schtasks /query /fo list ^| findstr "%THE_TASK%"') do echo enabling "%%x" "%THE_TASK%"

	schtasks /Change /ENABLE /TN "%THE_TASK%" >nul 2>nul
goto :eof

:End

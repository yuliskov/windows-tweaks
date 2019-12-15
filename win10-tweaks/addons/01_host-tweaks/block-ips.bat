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

set IPS_FILE=%~n0.txt

REM Remove old rules
powershell -Command "Remove-NetFirewallRule -DisplayName \"Block Telemetry IPs\" -ErrorAction SilentlyContinue"

for /F "usebackq tokens=*" %%A in ("%IPS_FILE%") do call :CheckAndAddHost %%A

goto End

:CheckAndAddHost
	set THE_HOST=%*

	if NOT "%THE_HOST%"=="%THE_HOST:#=%" (
		REM Comment has been found... skipping...
		goto :eof
	) 

	powershell -Command "New-NetFirewallRule -DisplayName \"Block Telemetry IPs\" -Direction Outbound -Action Block -RemoteAddress %THE_HOST%" >nul 2>nul
goto :eof

:End
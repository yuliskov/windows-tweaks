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

REM Unwanted Windows services (BEGIN)
REM Details: https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/disable-services.ps1

REM Import external utils here
set SERVICES_DISABLED=%~n0-disabled.txt
set SERVICES_MANUAL=%~n0-manual.txt

for /F "usebackq tokens=*" %%A in ("%SERVICES_DISABLED%") do call :SetServicesDisabled %%A
for /F "usebackq tokens=*" %%A in ("%SERVICES_MANUAL%") do call :SetServicesManual %%A

goto End

:SetServicesManual
	set THE_LINE=%*

	if NOT "%THE_LINE%"=="%THE_LINE:#=%" (
		REM Comment has been found... skipping...
		goto :eof
	) 

	sc config "%THE_LINE%" start=demand >nul
	sc stop "%THE_LINE%" >nul
goto :eof

:SetServicesDisabled
	set THE_LINE=%*

	if NOT "%THE_LINE%"=="%THE_LINE:#=%" (
		REM Comment has been found... skipping...
		goto :eof
	) 

	sc config "%THE_LINE%" start=disabled >nul
	sc stop "%THE_LINE%" >nul
goto :eof

:End
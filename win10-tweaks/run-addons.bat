@echo off

cd /d "%~dp0"

if "%1"=="ok" goto SKIP_ELEVATE
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

REM =========================================

echo Running addons...
set ADDONS_TEMPLATE=addons\*.bat
pushd "%CD%"
for /r %%f in ("%ADDONS_TEMPLATE%") do call "%%f" ok
popd

REM Are we running from scheduled task? Limit to basic job only.
REM NOTE: exit /b to return "operation completed successfully"
if "%1"=="task" exit /b

echo Running system tweaks (should be executed only once)...

set CORE_TEMPLATE=core\*.bat
pushd "%CD%"
for /r %%f in ("%CORE_TEMPLATE%") do call "%%f" ok
popd
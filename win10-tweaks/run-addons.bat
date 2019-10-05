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

set ADDONS_DIR=addons
pushd "%CD%"
for /r %ADDONS_DIR% %%f in (*.bat) do call "%%f" ok
popd

REM Are we running from the scheduled task? Limit to basic job only.
if "%1"=="task" goto SKIP_CORE_TWEAKS

echo Running System tweaks...

set CORE_DIR=core
pushd "%CD%"
for /r %CORE_DIR% %%f in (*.bat) do call "%%f" ok
popd

:SKIP_CORE_TWEAKS
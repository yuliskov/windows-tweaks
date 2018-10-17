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

REM make %JAVA_HOME% var to point to the latest java installed 
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_171

set JAVA_HOME_DIR_TEMPLATE=%ProgramFiles%\Java\jdk*
for /d %%f in ("%JAVA_HOME_DIR_TEMPLATE%") do call :JavaHomeFix %%f

goto End

:JavaHomeFix
	set JAVA_HOME_DIR=%*
	echo Updating Java home dir to "%JAVA_HOME_DIR%"...
	setx /m JAVA_HOME "%JAVA_HOME_DIR%" >nul
goto :eof

:End
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

echo Blocking unwanted services (Adobe)...

REM Adobe Autoupdate Service
sc config AdobeUpdateService start=disabled >nul
sc stop AdobeUpdateService >nul

REM Adobe Genuine Integrity Service
sc config "AGSService" start=disabled >nul
sc stop "AGSService" >nul

echo Blocking license hosts (Adobe)...

%HOSTS% set lmlicenses.wip4.adobe.com 0.0.0.0 >nul
%HOSTS% set lm.licenses.adobe.com 0.0.0.0 >nul
%HOSTS% set na1r.services.adobe.com 0.0.0.0 >nul
%HOSTS% set hlrcv.stage.adobe.com 0.0.0.0 >nul
%HOSTS% set practivate.adobe.com  0.0.0.0 >nul
%HOSTS% set activate.adobe.com 0.0.0.0 >nul

echo Cleaning Adobe Cache (frees up to 20 GB)...
rmdir /s /q "%AppData%\Adobe\Common\Media Cache Files" 2>nul

echo Disabling Adobe background processes...
ren "%ProgramFiles(x86)%\Adobe\Adobe Creative Cloud\CCXProcess\CCXProcess.exe" "CCXProcess.exe.bak" 2>nul
ren "%ProgramFiles(x86)%\Common Files\Adobe\OOBE\PDApp\IPC\AdobeIPCBroker.exe" "AdobeIPCBroker.exe.bak" 2>nul

REM TODO: Fix Adobe offline activation, remove:
REM "C:\Program Files (x86)\Common Files\Adobe\PCF"

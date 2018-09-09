@echo off
REM make %JAVA_HOME% var to point to the latest java installed 
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_171

set JAVA_HOME_DIR_TEMPLATE=%ProgramFiles%\Java\jdk*
for /d %%f in ("%JAVA_HOME_DIR_TEMPLATE%") do call :JavaHomeFix %%f
goto End

:JavaHomeFix
	set JAVA_HOME_DIR=%*
	echo fixing Java home dir to "%JAVA_HOME_DIR%"
	call :Elevate setx /m JAVA_HOME ""%JAVA_HOME_DIR%""
goto :eof

:Elevate
	set COMMAND=%*
	ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
	ECHO UAC.ShellExecute "cmd", "/c %COMMAND%", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
	"%temp%\OEgetPrivileges.vbs"
goto :eof

:End
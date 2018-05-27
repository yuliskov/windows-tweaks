@echo off

set THIS_NAME=%~dpf0
set IDEA_PROFILE_DIR_TEMPLATE=%UserProfile%\.IntelliJIdea*
for /d %%f in ("%IDEA_PROFILE_DIR_TEMPLATE%") do call :IdeaLicenseFix %%f
REM comment line below in case you want only reset trial
call :SetupTask
goto End

:IdeaLicenseFix
	echo Processing %IDEA_PROFILE_DIR%...
	set IDEA_PROFILE_DIR=%1
    del "%IDEA_PROFILE_DIR%\config\eval" /q
	type "%IDEA_PROFILE_DIR%\config\options\options.xml" | findstr /v evlsprt > "%IDEA_PROFILE_DIR%\config\options\options_new.xml"
	copy "%IDEA_PROFILE_DIR%\config\options\options_new.xml" "%IDEA_PROFILE_DIR%\config\options\options.xml" /y >nul
	reg delete "HKEY_CURRENT_USER\Software\JavaSoft\Prefs\jetbrains\idea" /f 2>nul
	echo done
goto :eof

:Elevate
	set COMMAND=%*
	ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
	ECHO UAC.ShellExecute "cmd", "/c %COMMAND%", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
	"%temp%\OEgetPrivileges.vbs"
goto :eof

:SetupTask
	echo Setting up scheduled task...
	set MY_TASK_NAME="Reset Idea Trial"
	REM run task every 25 days (MO) on this user account (IT)
	set MY_TASK_COMMAND=schtasks /Create /TN "%MY_TASK_NAME%" /SC DAILY /MO 25 /IT /TR ""%THIS_NAME%"" /RL HIGHEST /F
	schtasks /query /TN %MY_TASK_NAME% >NUL 2>&1
	if %errorlevel% NEQ 0 call :Elevate %MY_TASK_COMMAND%
	echo done
goto :eof

:End
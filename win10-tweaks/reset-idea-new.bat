@echo off

set THIS_NAME=%~dpf0
set BLANK_TASK=%temp%/blank_task.xml
set MY_TASK_NAME="TEST Reset Idea Trial"
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
	REM run task every 25 days (MO) on this user account (IT)
	REM set MY_TASK_COMMAND=schtasks /Create /TN "%MY_TASK_NAME%" /SC DAILY /MO 25 /IT /TR ""%THIS_NAME%"" /RL HIGHEST /F
	set MY_TASK_COMMAND=schtasks /Create /TN "%MY_TASK_NAME%" /xml ""%BLANK_TASK%"" /F
	set MY_TASK_COMMAND2=schtasks /Change /TN "%MY_TASK_NAME%" /SC DAILY /MO 25 /IT /TR ""%THIS_NAME%"" /RL HIGHEST /F
	schtasks /query /TN %MY_TASK_NAME% >NUL 2>&1
	if %errorlevel% NEQ 0 (
		call :WriteBlankTask
		call :Elevate %MY_TASK_COMMAND%
		REM call :Elevate %MY_TASK_COMMAND2%
	)
	echo done
goto :eof

:WriteBlankTask
	echo ^<?xml version="1.0" encoding="UTF-16"?^>^ > "%BLANK_TASK%"
	echo ^<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task"^>^ >> "%BLANK_TASK%"
	echo ^<Triggers^>^ >> "%BLANK_TASK%"
	echo ^<CalendarTrigger^>^ >> "%BLANK_TASK%"
	echo ^<StartBoundary^>2018-07-01T20:00:00^</StartBoundary^>^ >> "%BLANK_TASK%"
	echo ^<Enabled^>true^</Enabled^>^ >> "%BLANK_TASK%"
	echo ^<ScheduleByDay^>^ >> "%BLANK_TASK%"
	echo ^<DaysInterval^>25^</DaysInterval^>^ >> "%BLANK_TASK%"
	echo ^</ScheduleByDay^>^ >> "%BLANK_TASK%"
	echo ^</CalendarTrigger^>^ >> "%BLANK_TASK%"
	echo ^</Triggers^>^ >> "%BLANK_TASK%"
	echo ^<Settings^>^ >> "%BLANK_TASK%"
	echo ^<StartWhenAvailable^>true^</StartWhenAvailable^>^ >> "%BLANK_TASK%"
	echo ^</Settings^>^ >> "%BLANK_TASK%"
	echo ^<Actions Context="Author"^>^ >> "%BLANK_TASK%"
	echo ^<Exec^>^ >> "%BLANK_TASK%"
	echo ^<Command^>"%THIS_NAME%"^</Command^>^ >> "%BLANK_TASK%"
	echo ^</Exec^>^ >> "%BLANK_TASK%"
	echo ^</Actions^>^ >> "%BLANK_TASK%"
	echo ^</Task^> >> "%BLANK_TASK%"
goto :eof

:End
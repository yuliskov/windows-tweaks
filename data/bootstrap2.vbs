Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

scriptdir = fso.GetParentFolderName(WScript.ScriptFullName)
shell.CurrentDirectory = scriptdir

thisDate = Year(Now) & Month(Now) & Day(Now)
lockFile = shell.ExpandEnvironmentStrings("%UserProfile%") & "\Lock_" & thisDate & ".lck"
lockFileTemplate = shell.ExpandEnvironmentStrings("%UserProfile%") & "\Lock_*.lck"

REM Wscript.Echo lockFileTemplate

' Run script every monday and do check that script already runned at this day
If Weekday(Date) = vbMonday And Not fso.FileExists(lockFile) Then
    REM cleanup previous runs
    On error resume next
    fso.DeleteFile lockFileTemplate, True

    Set objFile = fso.CreateTextFile(lockFile, True)
    objFile.Write "Script has run " & thisDate & " already"
    objFile.Close

    If Not WScript.Arguments.Count = 0 Then
        ReDim args(WScript.Arguments.Count - 1)
        For i = 0 To WScript.Arguments.Count - 1
            If InStr(WScript.Arguments(i), " ") > 0 Then
                ' query contains a space
                args(i) = """" & WScript.Arguments(i) & """"
            Else
                args(i) = WScript.Arguments(i)
            End If
        Next

        shell.Run Join(args, " "), 1, False
    End If
End If


if fso.FileExists(lockFile) Then
    REM task already has been executed for today
    
    REM exit from the script
Else If fso.FileExists(nextRun) And nextRun.lessOrEqual(thisDate) Then
    REM it's time run the scheduled task

    REM create lockFile
    
    REM run the task

    REM remove old nextRun file and create new one with the date in the future
Else
    REM the task is running for the first time

    REM create lockFile

    REM run the task

    REM create new nextRun file with the date in the future
End If 
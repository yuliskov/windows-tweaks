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
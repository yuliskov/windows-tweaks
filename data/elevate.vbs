'usage: elevate.vbs -c <full_path_to_script> [script_arguments]

Set App = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")

If WScript.Arguments(0) = "-c" Then
    ' UAC

    args = Chr(34) & WScript.ScriptFullName & Chr(34)
    For Each arg in WScript.Arguments
        If Len(arg) > 10 Then arg = Chr(34) & arg & Chr(34)
        If arg <> "-c" Then args = args & " " & arg
    Next
    App.ShellExecute "wscript.exe", args, "", "runas", 1
Else
    REM already elevated?

    args = ""
    For Each arg in WScript.Arguments
        REM WScript.Echo arg
        If Len(arg) > 10 Then arg = Chr(34) & arg & Chr(34)
        args = args & arg & " "
    Next

    REM WScript.Echo args.Length
    WshShell.Run args, 1, False
End If

Set App = Nothing
Set WshShell = Nothing

' Details: https://ss64.com/vb/run.html
' An example running 'Demo.cmd' with invisible.vbs
' wscript.exe "invisible.vbs" "demo.cmd" //nologo

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

	CreateObject("Wscript.Shell").Run Join(args, " "), 0, False
End If
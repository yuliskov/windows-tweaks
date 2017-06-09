REM Error Fix: Event Id: 10, Source: WMI
REM http://support.microsoft.com/kb/950375

On Error Resume Next ' Skip error when object not exist

If WScript.Arguments.length = 0 Then
	' UAC
	Set App = CreateObject("Shell.Application")
	'Pass a bogus argument with leading blank space, say [ uac]
	App.ShellExecute "wscript.exe", Chr(34) & _
	WScript.ScriptFullName & Chr(34) & " uac", "", "runas", 1
Else
	' Code
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:" _
	& "{impersonationLevel=impersonate}!\\" _
	& strComputer & "\root\subscription")
	
	Set obj1 = objWMIService.Get("__EventFilter.Name='BVTFilter'")

	set obj2set = obj1.Associators_("__FilterToConsumerBinding")

	set obj3set = obj1.References_("__FilterToConsumerBinding")



	For each obj2 in obj2set
					REM WScript.echo "Deleting the object"
					REM WScript.echo obj2.GetObjectText_
					obj2.Delete_
	next

	For each obj3 in obj3set
					REM WScript.echo "Deleting the object"
					REM WScript.echo obj3.GetObjectText_
					obj3.Delete_
	next

	REM WScript.echo "Deleting the object"
	REM WScript.echo obj1.GetObjectText_
	obj1.Delete_
End If
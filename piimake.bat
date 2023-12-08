<!DOCTYPE rem|
for %%x in (system32 syswow64) do if exist "%SystemRoot%\%%x" set SystemLeaf=%%x
start "%~n0" "%SystemRoot%\%SystemLeaf%\mshta.exe" "%~f0"
goto :eof
>
<head>
<title>Endorphin Browser PII Creation Assistant</title>
<meta http-equiv="MSThemeCompatible" content="yes">
<style>
html
{
	margin: 20px 0px 40px 0px;
	font: 14px sans-serif;
	background-color: silver;
	height: 100%;
	overflow: hidden;
}
body
{
	margin: 0;
	overflow: hidden;
	border: none;
	height: 100%;
}
#top fieldset
{
	border-left-width: 0;
	border-right-width: 0;
	border-bottom-width: 0;
}
#bottom fieldset
{
	border-left-width: 0;
	border-right-width: 0;
	border-top-width: 0;
}
center
{
	height: 100%;
}
iframe
{
	width: 49.9%;
	height: 50%;
}
div
{
	width: 100%;
	white-space: nowrap;
	position: absolute;
}
#top
{
	top: 3px;
}
#bottom
{
	margin-top: 5px;
	bottom: 5px;
}
button
{
	margin-left: 5px;
	margin-top: 5px;
}
a
{
	color: blue;
	background-color: silver;
	position: absolute;
	right: 10px;
	top: 3px;
}
span
{
	position: absolute;
	right: 10px;
	bottom: 5px;
}
</style>
<comment id="dot">
endorphin.exe icudt56.dll icuin56.dll icuuc56.dll Qt5OpenGL.dll Qt5Positioning.dll
Qt5Sensors.dll Qt5Sql.dll Qt5WebKit.dll Qt5WebKitWidgets.dll Qt5Widgets.dll
Qt5Core.dll Qt5Gui.dll Qt5Multimedia.dll Qt5MultimediaWidgets.dll Qt5Network.dll wolfssl.dll
</comment>
<comment id="platforms">
qwindows.dll
</comment>
<comment id="imageformats">
qwebp.dll qdds.dll qgif.dll qicns.dll qico.dll qjpeg.dll qmng.dll qtga.dll qwbmp.dll qwebp.dll
</comment>
<comment id="mediaservice">
ffmpeg-plugin.dll dsengine.dll
</comment>
<script type="text/vbs">
Option Explicit

Const AddOnName = "Endorphin Browser"

SetLocale 1033

Dim splitAtWhitespace
Set splitAtWhitespace = New RegExp
splitAtWhitespace.Pattern = "\S+"
splitAtWhitespace.Global = True

Dim fso, wsh
Set fso = CreateObject("Scripting.FileSystemObject")
Set wsh = CreateObject("WScript.Shell")

Dim home, inst
home = fso.GetParentFolderName(location.pathname)
inst = wsh.RegRead("HKCR\CLSID\{A31E2E44-714B-11D6-8A19-000102228262}\LocalServer32\")
inst = fso.GetParentFolderName(Replace(inst, """", ""))

Function IsAdmin
	On Error Resume Next
	wsh.RegRead "HKEY_USERS\S-1-5-19\Environment\TEMP"
	IsAdmin = Err.number = 0
End Function

Function AddOnFolder
	AddOnFolder = Replace(home, home, inst, 1, Intrusive.checked) & "\AddOn"
End Function

Function CreateFolder(path)
	On Error Resume Next
	fso.CreateFolder path
	CreateFolder = Err.Number = 0
End Function

Function DeleteFolder(path)
	On Error Resume Next
	fso.DeleteFolder path
	DeleteFolder = Err.Number = 0
End Function

Function MakeShellLink(path)
	MakeShellLink = Len(path) & "#" & path
End Function

Function PreferPlugin(name)
	Dim check
	Set check = document.getElementById(name)
	If check Is Nothing Then
		PreferPlugin = True
	Else
		PreferPlugin = check.checked
	End If
End Function

Sub CreateAddon_OnClick
	Dim i, frame, line, path, file, name
	CreateFolder(AddOnFolder)
	If CreateFolder(AddOnFolder & "\" & AddOnName) Then
		Intrusive_OnClick
		path = AddOnFolder & "\" & AddOnName & "\Common"
		If CreateFolder(path) Then
			fso.CreateTextFile(path & "\endorphin.lnk").Write MakeShellLink("""\flash\AddOn\Endorphin\endorphin.exe""")
		End If
	End If
	For i = 0 To document.frames.length - 1
		Set frame = document.frames(i)
		If Not frame.frameElement.disabled Then
			path = AddOnFolder & "\" & AddOnName & "\" & frame.frameElement.name
			If CreateFolder(path) Then
				For Each name In splitAtWhitespace.Execute(dot.text)
					fso.CopyFile home & "\" & frame.frameElement.name & "\" & name, path & "\"
				Next
				path = AddOnFolder & "\" & AddOnName & "\" & frame.frameElement.name & "\platforms"
				If CreateFolder(path) Then
					For Each name In splitAtWhitespace.Execute(platforms.text)
						fso.CopyFile home & "\" & frame.frameElement.name & "\platforms\" & name, path & "\"
					Next
				End If
				path = AddOnFolder & "\" & AddOnName & "\" & frame.frameElement.name & "\imageformats"
				If CreateFolder(path) Then
					For Each name In splitAtWhitespace.Execute(imageformats.text)
						fso.CopyFile home & "\" & frame.frameElement.name & "\imageformats\" & name, path & "\"
					Next
				End If
				path = AddOnFolder & "\" & AddOnName & "\" & frame.frameElement.name & "\mediaservice"
				If CreateFolder(path) Then
					For Each name In splitAtWhitespace.Execute(mediaservice.text)
						If fso.FileExists(home & "\" & frame.frameElement.name & "\mediaservice\" & name) And PreferPlugin(name) Then
							fso.CopyFile home & "\" & frame.frameElement.name & "\mediaservice\" & name, path & "\"
							Exit For
						End If
					Next
				End If
			End If
			path = AddOnFolder & "\" & AddOnName & "\" & fso.GetFileName(frame.frameElement.src)
			Set file = fso.CreateTextFile(path, True)
			For Each line In Split(frame.document.body.innerText, vbCrLf)
				line = Trim(line)
				if Len(line) > 4 And InStr(line, "#name") = Len(line) - 4 Then
					file.WriteLine AddOnName & "#name"
				ElseIf Len(line) > 21 And InStr(line, "#TARGET_os_version_") = Len(line) - 21 Then
					file.WriteLine FormatNumber(Right(frame.frameElement.name, 3) / 100, 2) & " " & Right(line, 22)
				ElseIf InStr(1, line, "; file ", vbTextCompare) = 1 Then
					For Each name In splitAtWhitespace.Execute(dot.text)
						file.WriteLine "\" & frame.frameElement.name & "\" & name & " > \flash\AddOn\Endorphin\ #NO"
					Next
					For Each name In splitAtWhitespace.Execute(platforms.text)
						file.WriteLine "\" & frame.frameElement.name & "\platforms\" & name & " > \flash\AddOn\Endorphin\platforms\ #NO"
					Next
					For Each name In splitAtWhitespace.Execute(imageformats.text)
						file.WriteLine "\" & frame.frameElement.name & "\imageformats\" & name & " > \flash\AddOn\Endorphin\imageformats\ #NO"
					Next
					For Each name In splitAtWhitespace.Execute(mediaservice.text)
						If fso.FileExists(home & "\" & frame.frameElement.name & "\mediaservice\" & name) And PreferPlugin(name) Then
							file.WriteLine "\" & frame.frameElement.name & "\mediaservice\" & name & " > \flash\AddOn\Endorphin\mediaservice\ #NO"
							Exit For
						End If
					Next
					If AddDesktopLink.checked Then file.WriteLine "\Common\endorphin.lnk > \Windows\Desktop\ #NO"
					If AddToStartMenu.checked Then file.WriteLine "\Common\endorphin.lnk > \Windows\Programs\ #NO"
				' ElseIf InStr(1, line, "; registry ", vbTextCompare) = 1 Then
				' ElseIf InStr(1, line, "; uninstall ", vbTextCompare) = 1 Then
				ElseIf Len(line) <> 0 And InStr(line, "\") = 0 And InStr(line, ";") = 0 Then
					file.WriteLine line
				End If
			Next
		End If
	Next
End Sub

Sub DeleteAddon_OnClick
	If DeleteFolder(AddOnFolder & "\" & AddOnName) Then Intrusive_OnClick
End Sub

Sub Intrusive_OnClick
	CreateAddon.disabled = fso.FolderExists(AddOnFolder & "\" & AddOnName)
	DeleteAddon.disabled = Not CreateAddon.disabled
End Sub

Sub ShowLicense_OnClick
	showModalDialog "LICENSE.GPL2", Nothing, "dialogWidth=40em"
End Sub

Sub Window_OnLoad
	Dim i, frame
	For i = 0 To document.frames.length - 1
		Set frame = document.frames(i)
		frame.frameElement.src = Replace(frame.frameElement.src, "about:", inst & "\AddOn\HTML_AddOn\")
	Next
	Intrusive.disabled = Not IsAdmin
	Intrusive.checked = Not Intrusive.disabled
	Intrusive_OnClick
	Version.innerText = fso.GetFileVersion(home & "\x86_800\endorphin.exe")
End Sub
</script>
</head>
<body>
<div id='top'>
<fieldset>
<legend>Templates</legend>
</fieldset>
</div>
<center>
<iframe name="arm_800" src="about:KTP_Mob_4.pii"></iframe>
<iframe name="arm_800" src="about:KTP_Mobile_7_9.pii"></iframe>
<iframe name="arm_800" src="about:TP_10F_Mobile.pii"></iframe>
<iframe name="x86_800" src="about:CP_GX_800.pii"></iframe>
</center>
<div id='bottom'>
<fieldset></fieldset>
<button id="CreateAddon">Create ProSave Addon</button>
<button id="DeleteAddon">Delete ProSave Addon</button>
<label for="Intrusive" title="This option allows an install right beside ProSave's stock addons (requires admin rights)">
<input id="Intrusive" type="checkbox">Intrusive</label>
<label for="AddDesktopLink" title="This option creates a desktop link to the application">
<input id="AddDesktopLink" type="checkbox" checked>on desktop</label>
<label for="AddToStartMenu" title="This option adds the application to the start menu">
<input id="AddToStartMenu" type="checkbox" checked>in start menu</label>
<label for="ffmpeg-plugin.dll" title="This option installs the ffmpeg-plugin.dll instead of the dsengine.dll, if available for the platform">
<input id="ffmpeg-plugin.dll" type="checkbox">ffmpeg plugin</label>
<button id="ShowLicense" title="GPL-2.0-or-later">&#9878; Show License</button>
</div>
<a href="#nowhere" unselectable="on" onclick="vbs:wsh.Run(Me.innerText)">https://github.com/datadiode/browser</a>
<span disabled id="Version"></span>
</body>

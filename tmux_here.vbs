Option Explicit

Const contSTR_CYGWIN_PATH = "C:\cygwin64"
Const contSTR_MSYS_PATH = "C:\msys64"
Const contSTR_INVOKING_ENV = "THERE_INVOKING"
Const contSTR_CHERE_INVOKING_ENV = "CHERE_INVOKING"
Const constLANG = "ja_JP.UTF-8"

Dim objShell
Dim colEnv
Dim objParam
Dim objFSO
Dim str_cygwin_path
Dim str_msys_path
Dim strSys
Dim strDir
Dim strIcon
Dim strQuery
Dim intRet
Dim objService
Dim colQfeSet
Dim objQfe

Function AppendPath(strPath, strToAppend)
  if Left(strPath, 1) = "\" Then
    AppendPath = strPath & strToAppend
  Else
    AppendPath = strPath & "\" & strToAppend
  End If
End Function

Set objShell = WScript.CreateObject("WScript.Shell")
Set colEnv = objShell.Environment("Process")
colEnv("LANG") = constLANG
str_cygwin_path = colEnv("CYGWIN_BASE")
If str_cygwin_path = "" Then
  str_cygwin_path = contSTR_CYGWIN_PATH
End If
str_msys_path = colEnv("MSYS2_BASE")
If IsNull(str_msys_path) Then
  str_msys_path = contSTR_MSYS_PATH
End If

Set objParam = WScript.Arguments

strQuery = "Select * From Win32_Process Where ExecutablePath='"

If objParam.Named.Exists("Sys") Then
    strSys = objParam.Named.Item("Sys")
Else
    MsgBox("Usage:" & vbCr & "    tmux_here.vbs /Sys:[cygwin|msys] /Dir:[initial-directory]")
    Set objParam = Nothing
    Set colEnv = Nothing
    Set objShell = Nothing
    WScript.Quit 1
End If

If objParam.Named.Exists("Dir") Then
    strDir = objParam.Named.Item("Dir")
    Set objFSO = WScript.CreateObject("Scripting.FileSystemObject")
    If Not objFSO.FolderExists(strDir) Then
        MsgBox(strDir & " dose not exist.")
        Set objFSO = Nothing
        WScript.Quit 3
    End If
    Set objFSO = Nothing
Else
    MsgBox("Usage:" & vbCr & "    tmux_here.vbs /Sys:[cygwin|msys] /Dir:[initial-directory]")
    Set objParam = Nothing
    Set colEnv = Nothing
    Set objShell = Nothing
    WScript.Quit 1
End If

If strSys = "cygwin" Then
    colEnv("PATH") = AppendPath(str_cygwin_path , "bin") & ";C:\Windows\System32"
    strIcon = AppendPath(str_cygwin_path, "Cygwin.ico")
    strQuery = strQuery & Replace(AppendPath(str_cygwin_path, "bin\mintty.exe"), "\", "\\") & "'"
ElseIf strSys = "msys" Then
    colEnv("PATH") = AppendPath(str_msys_path, "usr\bin") & ";C:\Windows\System32"
    colEnv("MSYSTEM") = "MSYS"
    strIcon = AppendPath(str_msys_path, "msys2.ico")
    strQuery = strQuery & Replace(AppendPath(str_msys_path, "usr\bin\mintty.exe"), "\", "\\") & "'"
Else
    MsgBox("Usage:" & vbCr & "    tmux_here.vbs /Sys:[cygwin|msys] /Dir:[initial-directory]")
    Set objParam = Nothing
    Set colEnv = Nothing
    Set objShell = Nothing
    WScript.Quit 1
End if

intRet = objShell.Run("cmd.exe /c ps.exe | grep.exe tmux & if Errorlevel 1 exit 1", 0, True)
If intRet = 0 Then
    intRet = objShell.Run("zsh -c 'tmux setenv " & contSTR_INVOKING_ENV & " 1'", 0, True)
    If intRet <> 0 Then
        WScript.Echo "Failed tmux setenv."
        Set objParam = Nothing
        Set colEnv = Nothing
        Set objShell = Nothing
        WScript.Quit 2
    End If
    intRet = objShell.Run("zsh -c 'tmux neww -c ""`cygpath """  & strDir & """`""'", 0, True)
    If intRet <> 0 Then
        objShell.Run "zsh -c 'tmux setenv " & contSTR_INVOKING_ENV & " 0'", 0, True
        WScript.Echo "Failed tmux neww."
        Set objParam = Nothing
        Set colEnv = Nothing
        Set objShell = Nothing
        WScript.Quit 2
    End If
    Set objService = WScript.CreateObject("WbemScripting.SWbemLocator").ConnectServer
    Set colQfeSet = objService.ExecQuery(strQuery)

    If Not IsNull(colQfeSet) Then
      For Each objQfe in colQfeSet
        objShell.AppActivate(CStr(objQfe.ProcessId))
      Next
    End If
    Set colQfeSet = Nothing
    Set objService = Nothing
    Set objParam = Nothing
    Set colEnv = Nothing
    Set objShell = Nothing
Else
    colEnv(contSTR_INVOKING_ENV) = 1
    colEnv(contSTR_CHERE_INVOKING_ENV) = 1
    On Error Resume Next
    objShell.CurrentDirectory = strDir
    If Err.Number <> 0 Then
        WScript.Echo "Failed change current directory to" & strDir & "."
        Set objParam = Nothing
        Set colEnv = Nothing
        Set objShell = Nothing
        WScript.Quit 3
    End If

    Err.Clear
    On Error GoTo 0

    objShell.Run("mintty.exe -c %HOME%\.minttyrc_" & strSys & " -i " & strIcon & " zsh --login")
    Set objParam = Nothing
    Set colEnv = Nothing
    Set objShell = Nothing
End if

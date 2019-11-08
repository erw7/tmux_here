# tmux\_here

## Installation

```
git clone https://github.com/erw7/tmux_here.git
PowerShell -NoLogo -NoProfile -Command New-Item -Type HardLink C:\msys64\tmux_here.vbs -Value tmux_here.vbs
```

Add the following to the registry:

```
Windows Registry Editor Version 5.00



[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\background\shell\msys_tmux]

@="MSYS2 Tmux Here"
"Icon"="C:\\\\msys64\\\\msys2.ico"


[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\background\shell\msys_tmux\command]

@="\\"C:\\\\Windows\\\\System32\\\\WScript.exe\\" \\"C:\\\\msys64\\\\tmux_here.vbs\\" \\"/Sys:msys\\" \\"/Dir:%V\\""


[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\shell\msys_tmux]

@="MSYS2 Tmux Here"
"Icon"="C:\\\\msys64\\\\msys2.ico"


[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\shell\msys_tmux\command]

@="\\"C:\\\\Windows\\\\System32\\\\WScript.exe\\" \\"C:\\\\msys64\\\\tmux_here.vbs\\" \\"/Sys:msys\\" \\"/Dir:%1\\""
```

```
Windows Registry Editor Version 5.00



[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\background\shell\cygwin_tmux]

@="Cygwin Tmux Here"
"Icon"="C:\\\\Cygwin64\\\\Cygwin.ico"


[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\background\shell\cygwin_tmux\command]

@="\\"C:\\\\Windows\\\\System32\\\\WScript.exe\\" \\"C:\\\\msys64\\\\tmux_here.vbs\\" \\"/Sys:cygwin\\" \\"/Dir:%V\\""


[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\shell\cygwin_tmux]

@="Cygwin Tmux Here"
"Icon"="C:\\\\Cygwin64\\\\Cygwin.ico"


[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\shell\cygwin_tmux\command]

@="\\"C:\\\\Windows\\\\System32\\\\WScript.exe\\" \\"C:\\\\msys64\\\\tmux_here.vbs\\" \\"/Sys:cygwin\\" \\"/Dir:%1\\""
```

If Cygwin and MSYS2 are installed in a location other than `C:\Cygwin64` or `C:\Msys64`, set the path to the `CYGWIN_BASE` or `MSYS2_BASY` environment variable.

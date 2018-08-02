Attribute VB_Name = "Module1"
Option Explicit

' ShowWindow() Commands
Public Const SW_HIDE = 0
Public Const SW_SHOWNORMAL = 1
Public Const SW_NORMAL = 1
Public Const SW_SHOWMINIMIZED = 2
Public Const SW_SHOWMAXIMIZED = 3
Public Const SW_MAXIMIZE = 3
Public Const SW_SHOWNOACTIVATE = 4
Public Const SW_SHOW = 5
Public Const SW_MINIMIZE = 6
Public Const SW_SHOWMINNOACTIVE = 7
Public Const SW_SHOWNA = 8
Public Const SW_RESTORE = 9
Public Const SW_SHOWDEFAULT = 10
Public Const SW_MAX = 10

Declare Function ShowWindow Lib "user32" (ByVal hwnd As Long, _
                                          ByVal nCmdShow As Long) As Long


Declare Function SetForegroundWindow Lib "user32" (ByVal hwnd As Long) As Long

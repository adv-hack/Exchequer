Attribute VB_Name = "Module1"
Option Explicit

Public Declare Function SetForegroundWindow Lib "user32" _
      (ByVal hwnd As Long) As Long

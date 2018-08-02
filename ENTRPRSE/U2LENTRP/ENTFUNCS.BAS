Attribute VB_Name = "Module1"

Option Explicit

' Maps onto a Pascal ShortString
Type PascalString
    StrLen  As String * 1
    Str     As String * 255
End Type


Declare Function EntDefaultLogin Lib "ENTFUNCS.DLL" (ByRef UserId As PascalString, ByRef PWord As PascalString) As Integer


Declare Function EntCustValue Lib "ENTFUNCS.DLL" (ByVal WantValue As Integer, ByRef Company As PascalString, ByRef CustCode As PascalString, ByVal Year As Integer, ByVal Period As Integer, ByRef CustBal As Double) As Integer


Attribute VB_Name = "Module1"
Option Explicit

' Exchequer Ireland Toolkit DLL Backdoor function
' Call prior to Ex_InitDll passing "DEBUGMODE121"
' as a parameter:-
'
' Delphi declaration:-
'
'   Procedure EX_SETRELEASECODE(RELCODE : PCHAR); STDCALL;
'
Declare Sub EX_SETRELEASECODE Lib "ENTDLL32.DLL" (ByVal SecretCode As String)


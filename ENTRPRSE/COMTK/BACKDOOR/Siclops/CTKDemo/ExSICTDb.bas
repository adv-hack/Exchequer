Attribute VB_Name = "Module1"
Option Explicit

' FSH Siclops COM Toolkit Debug Mode function
' Call with 1937, 294746 And -936531 in the params respectively
' and the function will generate the 3 params to be passed into
' the IConfiguration.SetDebugMode method of the COMTK.  This should
' be done after the COMTK has been created but before OpenToolkit
' is called.
'
' Delphi declaration:-
'
'   Procedure EXEIRE_CTKDebugMode (Var I1, I2, I3 : LongInt); StdCall;
'
Declare Sub EXEIRE_CTKDebugMode Lib "EXSICTBD.DLL" (ByRef I1&, ByRef I2&, ByRef I3&)



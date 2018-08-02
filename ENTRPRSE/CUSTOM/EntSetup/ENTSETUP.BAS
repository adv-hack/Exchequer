Attribute VB_Name = "EntSetup"
Option Explicit


' Returns the current Enterprise directory as configured on
' the workstation.  The following values can be returned:-
'
'   0      The function completed successfully
'   1001   Unknown Exception, see EnterpriseDir for text description
'   1002   Unable to Find Enterprise Directory
'   1003   EnterpriseDir PChar too short
'
Declare Function GetEnterpriseDir Lib "EntSetup.Dll" _
                   (ByVal EnterpriseDir As String) As Integer


' Adds a COM Plug-In into the COMClients section of EntCustm.Ini,
' the following values can be returned:-
'
'   0      The function completed successfully
'   1001   Unknown Exception, see EnterpriseDir for text description
'   1002   EnterpriseDir is not a valid Enterprise system
'   1003   PlugInPath does not point to a valid COM Plug-In
'
Declare Function AddCOMPlugIn Lib "EntSetup.Dll" _
                   (ByVal EnterpriseDir As String, _
                    ByVal PlugInPath As String, _
                    ByVal PlugInDesc As String) As Integer


' Adds a Delphi DLL Plug-In into EntCustm.Ini, Note DLLName should
' be the name of the DLL excluding any path and extension information.
' The following values can be returned:-
'
'   0      The function completed successfully
'   1001   Unknown Exception, see EnterpriseDir for details
'   1002   EnterpriseDir is not a valid Enterprise system
'   1003   DLLName does not point to a valid Delphi DLL Plug-In
'
Declare Function AddDLLPlugIn Lib "EntSetup.Dll" _
                   (ByVal EnterpriseDir As String, _
                    ByVal DLLName As String, _
                    ByVal PlugInDesc As String) As Integer


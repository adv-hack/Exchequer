Attribute VB_Name = "EntRegUtils"
Option Explicit

' Reg Key Security Options...
Const READ_CONTROL = &H20000
Const KEY_QUERY_VALUE = &H1
Const KEY_ENUMERATE_SUB_KEYS = &H8
Const KEY_NOTIFY = &H10
Const KEY_READ = KEY_QUERY_VALUE + KEY_ENUMERATE_SUB_KEYS + KEY_NOTIFY + READ_CONTROL

' Reg Key ROOT Types...
Const HKEY_CLASSES_ROOT = &H80000000

'---------------------------------------------------------------
'-Registry API Declarations...
'---------------------------------------------------------------
Private Declare Function RegOpenKeyEx Lib "advapi32" Alias "RegOpenKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, ByRef phkResult As Long) As Long
Private Declare Function RegQueryValueEx Lib "advapi32" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, ByRef lpType As Long, ByVal lpData As String, ByRef lpcbData As Long) As Long
Private Declare Function RegCloseKey Lib "advapi32" (ByVal hKey As Long) As Long

' Looks up and returns the path of the currently registered Enterprise OLE Server
Public Function GetEnterpriseDir(Default As String) As String
    Dim hReg&, Res&
    Dim hData$, hDataLen&

    GetEnterpriseDir$ = Default$
    
    ' Try to open registry and get directory of currently registered Enterprise
    Res& = RegOpenKeyEx(HKEY_CLASSES_ROOT, _
                        "CLSID\{D7AF2B20-8D38-11CF-BD36-444553540000}\LocalServer32", _
                        0, _
                        KEY_READ, _
                        hReg&)
                        
    If (Res& = 0) Then
        ' Try to read default value
        hData$ = String$(255, " ")
        hDataLen& = Len(hData$)
        Res& = RegQueryValueEx(hReg&, "", 0, 0, hData$, hDataLen&)
        
        If (Res& = 0) And (hDataLen& > 12) Then
            ' Extract Path of OLE Server removing the OLE Server filename - Enterole.Exe
            GetEnterpriseDir$ = Left$(hData$, hDataLen& - 13)
        End If ' Res& = 0
    
        ' Close registry key
        RegCloseKey (hReg&)
    End If ' Res& = 0
End Function

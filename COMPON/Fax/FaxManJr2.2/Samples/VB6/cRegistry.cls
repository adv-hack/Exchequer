VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRegistry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Description = "Registry class for setting and storing values."
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
' cRegistry Class is used for storing and retrieving
' information in the Registry.
' Note: GetSettings and SaveSettings are easier to use, but leak handles,
' and seem to have problems on certain machines.
' Note that if a Key isn't created you can't write or read information.
' You will get the error# 1777 - "Class cRegistry not Initialized."

Option Explicit

Private Const REG_SZ As Long = 1
Private Const REG_DWORD As Long = 4
Private Const HKEY_CLASSES_ROOT = &H80000000
Private Const HKEY_CURRENT_USER = &H80000001
Private Const HKEY_LOCAL_MACHINE = &H80000002
Private Const HKEY_USERS = &H80000003
Private Const ERROR_NONE = 0
Private Const ERROR_BADDB = 1
Private Const ERROR_BADKEY = 2
Private Const ERROR_CANTOPEN = 3
Private Const ERROR_CANTREAD = 4
Private Const ERROR_CANTWRITE = 5
Private Const ERROR_OUTOFMEMORY = 6
Private Const ERROR_ARENA_TRASHED = 7
Private Const ERROR_ACCESS_DENIED = 8
Private Const ERROR_INVALID_PARAMETERS = 87
Private Const ERROR_NO_MORE_ITEMS = 259
Private Const ERROR_SUCCESS& = 0&
Private Const KEY_ALL_ACCESS = &H3F
Private Const REG_OPTION_NON_VOLATILE = 0

Private Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
' Closes a key in the system registry

Private Declare Function RegCreateKeyEx Lib "advapi32.dll" Alias "RegCreateKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal Reserved As Long, ByVal lpClass As String, ByVal dwOptions As Long, ByVal samDesired As Long, ByVal lpSecurityAttributes As Long, phkResult As Long, lpdwDisposition As Long) As Long
' Create a new key under a specified key. Recommended  for use under Win32
' If key already exists, this funciton opens the existing key

Private Declare Function RegOpenKeyEx Lib "advapi32.dll" Alias "RegOpenKeyExA" (ByVal hKey As Long, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, phkResult As Long) As Long
' Opens an existing key. Recommended for use under Win32

Private Declare Function RegQueryValueExString Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, ByVal lpData As String, lpcbData As Long) As Long
' Returns a value for a key

Private Declare Function RegQueryValueExLong Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, lpData As Long, lpcbData As Long) As Long
' Returns a value for a key

Private Declare Function RegQueryValueExNULL Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, ByVal lpData As Long, lpcbData As Long) As Long
' Returns a value for a key

Private Declare Function RegSetValueExString Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, ByVal lpValue As String, ByVal cbData As Long) As Long
' Sets the value for a specific key

Private Declare Function RegSetValueExLong Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, lpValue As Long, ByVal cbData As Long) As Long
' Sets the value for a specific key


Private mlvg_hKey As Long
Private mbln_bInit As Boolean

Public Function CreateKey(strKeyNameKeyIN As String, Optional lngHKeyIN As Long = HKEY_CURRENT_USER) As Boolean
    Dim lngRet As Long

    lngRet = RegCreateKeyEx(lngHKeyIN, strKeyNameKeyIN, 0&, _
              vbNullString, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, _
              0&, mlvg_hKey, lngRet)
              
' hkey - Long, Handle of an oen key or one of the standard key names
' lpSubKey - string, name of the key to open
'  Reserved - long, set to zero
'  lpClass - String, A class name for the key
'  dwOptions - Long, sero or the folloing constant:
'        REG_OPTION_VOLATILE - this key is not saved and will vanish
'        when the system is restarted
' samDesired - Long, one or more constants with prefix KEY_?? combined to
'       describe which operations are allowed with this key
' lpSecurityAttributes A structure describing security for this key
'       May be  NULL (redefine to be ByVal as NULL). Not applicable
'       to Win95
' phkResult - Long, a variable to load with a handle to open key
' lpdwDisposition - Long, a variable to load with one of the following
'       constants:
'       REG_CREATED_NEW_KEY - a new key was created
'       REG_OPENED_EXISTING_KEY - an existing key was opened

    
    If lngRet = ERROR_SUCCESS Then
        CreateKey = True
        mbln_bInit = True
    End If
End Function

Public Sub SetLong(strValue As String, lngData As Long)
    Dim lngValue As Long, lngRet As Long
    CheckInit

    lngValue = lngData
    lngRet = RegSetValueExLong(mlvg_hKey, strValue, 0&, REG_DWORD, lngValue, 4)
    
' hkey - Long, Handle of an oen key or one of the standard key names
' lpValueName - String - the name of the value to set
' Reserved - Long, not used, set to Zero
' dwType - Long, the type of data to set
' lpData - Byte, The first byte in a buffer containing the data
' cbData - Long, the length of the lpData buffer
End Sub

Public Sub SetStringValue(strValueIn As String, strDataIn As String)
    Dim strValue As String, lngRet As Long
    CheckInit
    
    strValue = strDataIn & Chr$(0)
    lngRet = RegSetValueExString(mlvg_hKey, strValueIn, 0&, REG_SZ, strValue, Len(strValue))
' hkey - Long, Handle of an open key or one of the standard key names
' lpValueName - String - the name of the value to set
' Reserved - Long, not used, set to Zero
' dwType - STring, the type of data to set
' lpData - Byte, The first byte in a buffer containing the data
' cbData - Long, the length of the lpData buffer
End Sub

Public Function GetLong(strValueIn As String, Optional lngDefaultIn As Long = 0) As Long
    Dim lngCCH As Long
    Dim lngLRC As Long
    Dim lngValue As Long
    Dim strValue As String
    Dim lngType As Long
    
    CheckInit
    On Error GoTo QueryValueExError
    
    GetLong = lngDefaultIn
    ' Determine the size and type of data to be read
    lngLRC = RegQueryValueExNULL(mlvg_hKey, strValueIn, 0&, lngType, 0&, lngCCH)
' hkey - Long, Handle of an open key or one of the standard key names
' lpValueName - String - the name of the value to retrieve
' Reserved - Long, not used, set to Zero
' lpType - Long, A variable toe load with the type of data retrieved
' lpData - Any, a buffer to load with the value specified
' lpcbData - Long, A variable that should be loaded with the length of the
'                      lpData buffer. On return it is set to the number of bytes
'                      Actually loaded in the buffer.

    If lngLRC <> ERROR_NONE Then Error 5

    If lngType = REG_DWORD Then
        lngLRC = RegQueryValueExLong(mlvg_hKey, strValueIn, 0&, REG_DWORD, lngValue, lngCCH)
' hkey - Long, Handle of an open key or one of the standard key names
' lpValueName - String - the name of the value to retrieve
' Reserved - Long, not used, set to Zero
' lpType - Long, A variable toe load with the type of data retrieved
' lpData - Any, a buffer to load with the value specified
' lpcbData - Long, A variable that should be loaded with the length of the
'                      lpData buffer. On return it is set to the number of bytes
'                      Actually loaded in the buffer.

        If lngLRC = ERROR_NONE Then GetLong = lngValue
    End If

    Exit Function
QueryValueExError:
End Function

Public Function GetStringValue(strValueIn As String, Optional strDefaultIn As String = "") As String
    Dim lngCCH As Long
    Dim lngLRC As Long
    Dim lngType As Long
    Dim lngValue As Long
    Dim strValue As String

    CheckInit
    On Error GoTo QueryValueExError
    
    GetStringValue = strDefaultIn
    
    ' Determine the size and type of data to be read
    lngLRC = RegQueryValueExNULL(mlvg_hKey, strValueIn, 0&, lngType, 0&, lngCCH)
    If lngLRC <> ERROR_NONE Then Error 5
    
    If lngType = REG_SZ Then
        ' For strings
        strValue = String(lngCCH, 0)
        lngLRC = RegQueryValueExString(mlvg_hKey, strValueIn, 0&, REG_SZ, strValue, lngCCH)
        If lngLRC = ERROR_NONE Then
            GetStringValue = Left$(strValue, lngCCH - 1)
        End If
    End If

    Exit Function
QueryValueExError:

End Function

Public Function OpenKey(strKeyNameIn As String, Optional lngHKeyIN As Long = HKEY_CURRENT_USER) As Boolean
    Dim lngRetVal As Long
    
    lngRetVal = RegOpenKeyEx(lngHKeyIN, strKeyNameIn, 0, KEY_ALL_ACCESS, mlvg_hKey)
' if successful, returns zero
    
' hkey - Long, Handle of an oen key or one of the standard key names
' lpSubKey - string, name of the key to open
'  ulOptions - long, unused, set to zero
' samDesired - Long, one or more constants with prefix KEY_?? combined to
        ' describe which operations are allowed with this key
' phkResult - Long, a variable to load with a handle to open key

    If lngRetVal = ERROR_NONE Then
        OpenKey = True
        mbln_bInit = True
    End If
End Function


Private Sub Class_Terminate()
    If mlvg_hKey <> 0 Then
        RegCloseKey (mlvg_hKey)
    End If
End Sub

Private Sub CheckInit()
    If mbln_bInit <> True Then
        Err.Raise 1777, "Class cRegistry not Initialized."
    End If
End Sub

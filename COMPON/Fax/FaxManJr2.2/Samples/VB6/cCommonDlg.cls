VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsCommonDialog"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Description = "Class for wrapping File Common Dialog functionality."
Attribute VB_Ext_KEY = "SavedWithClassBuilder" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
' clsCommonDialog Class is used in place of the CommonDialog control
' which is not available with all versions of VB.
' It also removes the extra dependencies.
' It is similiar in use to the CommonDialog Control for working with the
' file dialogs but it also provides default strings and
' a "sticky" directory.

Option Explicit

Private Type OPENFILENAME
        lngStructSize As Long
        lngHwndOwner As Long
        lngHInstance As Long
        lpstrFilter As String
        lpstrCustomFilter As String
        nMaxCustFilter As Long
        nFilterIndex As Long
        lpstrFile As String
        nMaxFile As Long
        lpstrFileTitle As String
        nMaxFileTitle As Long
        lpstrInitialDir As String
        lpstrTitle As String
        flags As Long
        nFileOffset As Integer
        nFileExtension As Integer
        lpstrDefExt As String
        lCustData As Long
        lpfnHook As Long
        lpTemplateName As String
End Type

Private Declare Function GetOpenFileName Lib "comdlg32.dll" Alias "GetOpenFileNameA" (udtOPENFILENAME As OPENFILENAME) As Long
' This function creates a system-defined dialog box that enables the user to select a file to open.

Private Declare Function GetSaveFileName Lib "comdlg32.dll" Alias "GetSaveFileNameA" (udtOPENFILENAME As OPENFILENAME) As Long
' This function creates a system-defined dialog box that enables the user to select a file to save.

'local variable(s) to hold property value(s)
Private mudtFilter As genuFileFilters
Private mstrCustomFilter As String
Private mstrFileName As String
Private mstrStartDirectory As String
Private mstrTitle As String
Private mblnSaveLastDir As Boolean

Public Enum genuFileFilters
    F_FaxManFiles = 1
    F_ImageFiles = 2
    F_TextFiles = 3
    F_LogFiles = 4
    F_TextAndMore = 5
    F_ImportFiles = 6
    F_Custom = 7
End Enum


Public Property Let SaveLastDir(ByVal blnVData As Boolean)
    mblnSaveLastDir = blnVData
End Property


Public Property Get SaveLastDir() As Boolean
    SaveLastDir = mblnSaveLastDir
End Property

Public Property Let Title(ByVal strVData As String)
    mstrTitle = strVData
End Property

Public Property Get Title() As String
    Title = mstrTitle
End Property

Public Property Let StartDirectory(ByVal strVData As String)
    mstrStartDirectory = strVData
End Property

Public Property Get StartDirectory() As String
    StartDirectory = mstrStartDirectory
End Property

Public Property Get FileName() As String
    FileName = mstrFileName
End Property

Public Property Let CustomFilter(ByVal strVData As String)
    mstrCustomFilter = strVData
End Property

Public Property Get CustomFilter() As String
    CustomFilter = mstrCustomFilter
End Property

Public Property Let Filter(ByVal vData As genuFileFilters)
    mudtFilter = vData
End Property

Public Property Get Filter() As genuFileFilters
    Filter = mudtFilter
End Property

Public Function ShowSave() As Boolean
    Dim udtOF As OPENFILENAME
    Dim lngRet As Long
    
    udtOF.lngStructSize = Len(udtOF)
    udtOF.lngHwndOwner = Screen.ActiveForm.hWnd
    udtOF.lpstrFilter = GetFilter
    udtOF.nMaxFile = 256
    udtOF.nMaxFileTitle = 255
    udtOF.lpstrFileTitle = mstrTitle & Chr$(0)
    udtOF.lpstrFile = Space$(255)
    udtOF.lpstrInitialDir = mstrStartDirectory
    
    lngRet = GetSaveFileName(udtOF)
    
    If lngRet Then
        mstrFileName = Left$(udtOF.lpstrFile, InStr(udtOF.lpstrFile, vbNullChar) - 1)
        If mblnSaveLastDir Then mstrStartDirectory = TrimPath(mstrFileName)
        ShowSave = True
    End If
End Function

Public Function ShowOpen() As Boolean
    Dim udtOF As OPENFILENAME
    Dim lngRet As Long
    
    udtOF.lngStructSize = Len(udtOF)
    udtOF.lngHwndOwner = Screen.ActiveForm.hWnd
    udtOF.lpstrFilter = GetFilter
    udtOF.nMaxFile = 256
    udtOF.nMaxFileTitle = 255
    udtOF.lpstrFileTitle = mstrTitle & Chr$(0)
    udtOF.lpstrFile = Space$(255)
    udtOF.lpstrInitialDir = mstrStartDirectory
    
    lngRet = GetOpenFileName(udtOF)
    
    If lngRet Then
        mstrFileName = Left$(udtOF.lpstrFile, InStr(udtOF.lpstrFile, vbNullChar) - 1)
        If mblnSaveLastDir Then mstrStartDirectory = TrimPath(mstrFileName)
        ShowOpen = True
    End If
End Function

Private Function GetFilter() As String
    Select Case mudtFilter
    Case F_FaxManFiles
        GetFilter = "FaxMan Files" & Chr(0) & "*.fmf;*.fmp" & Chr(0) & Chr(0)
    Case F_ImageFiles
        GetFilter = "Image Files" & Chr(0) & "*.bmp;*.tif;*.dcx;*.fmf;*.fmp" & Chr(0) & Chr(0)
    Case F_TextFiles
        GetFilter = "Text Files" & Chr(0) & "*.txt" & Chr(0) & Chr(0)
    Case F_LogFiles
        GetFilter = "Log Files" & Chr(0) & "*.log" & Chr(0) & Chr(0)
    Case F_TextAndMore
        GetFilter = "Text Files" & Chr(0) & "*.txt" & Chr(0) & "All Files" & Chr(0) & "*.*" & Chr(0) & Chr(0)
    Case F_ImportFiles
        GetFilter = "Importable Files" & Chr(0) & "*.bmp;*.tif;*.dcx;*.fmf;*.fmp;*.pdf;*.txt" & Chr(0) & Chr(0)
                    
    Case F_Custom
        GetFilter = mstrCustomFilter
    End Select
End Function

Private Function TrimPath(strPath As String) As String
    Dim intPlace As Integer, intCount As Integer
    
    For intCount = Len(strPath) - 1 To 0 Step -1
        intPlace = InStr(intCount, strPath, "\")
        If intPlace <> 0 Then Exit For
    Next intCount
    TrimPath = Left(strPath, intPlace)
End Function

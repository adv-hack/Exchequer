Attribute VB_Name = "mFaxJr"
Option Explicit

Global Const RegKey = "Software\VB and VBA Program Settings\pFaxJr\FaxManJr"
Global gstrDebug As String
Global gstrMessage As String

' The GetShortPathName function retrieves the short path form of a specified input path.
Public Declare Function GetShortPathName& Lib "kernel32" Alias "GetShortPathNameA" (ByVal lpszLongPath As String, ByVal lpszShortPath As String, ByVal cchBuffer As Long)


Function GetDeviceStr(theDevice As DeviceDesc) As String
' Return a User friendly device string.
    On Error Resume Next
    Dim strDevStr As String
    
    strDevStr = "Class "
    strDevStr = strDevStr & IIf(theDevice.bClass1, "1 ", "")
    strDevStr = strDevStr & IIf(theDevice.bClass2, "2 ", "")
    strDevStr = strDevStr & IIf(theDevice.bClass20, "2.0 ", "")
    strDevStr = strDevStr & IIf(theDevice.bClass21, "2.1 ", "")
    strDevStr = strDevStr & "Modem on Port " & Str(theDevice.Port) & "."
    
    GetDeviceStr = strDevStr
End Function

Function GetFaxStatus(fs As FaxStatusObj) As String
' Return helpful information for all the different events.
    Static intTimeOut As Integer

    Select Case (fs.LastEventType)
    Case EVENT_COMPLETE
        GetFaxStatus = "*** All Done *** " & fs.CurrentStatusDesc
        If (fs.ErrorCode Mod 100) <> 0 Then
            GetFaxStatus = GetFaxStatus & Str(fs.ErrorCode) & " " & fs.ErrorDesc
        End If
    Case EVENT_ENDTIME
        GetFaxStatus = "End Time: " & Str(fs.EndTime)
    Case EVENT_NEGOTIATION
        GetFaxStatus = "Negotiated Parameters:" & _
            " Speed=" & Str(fs.ConnectSpeed) & _
            " Res=" & Str(fs.NegotiatedResolution) & _
            "RemoteID=" & fs.RemoteID
    Case EVENT_PAGES
' This may need to be handled differently
' In the cases of sending and receiving
        GetFaxStatus = "Page " & Str(fs.PagesCompleted) & " of " & Str(fs.Pages)
    Case EVENT_RECEIVE_FILENAME
        GetFaxStatus = "FileName: " & fs.ReceiveFileName
    Case EVENT_STARTTIME
        GetFaxStatus = "StartTime: " & Str(fs.StartTime)
    Case EVENT_STATUS
        GetFaxStatus = "Status: " & fs.CurrentStatusDesc
        If fs.ErrorCode > 0 Then
            GetFaxStatus = GetFaxStatus & Str(fs.ErrorCode) & " " & fs.ErrorDesc
        End If
    Case EVENT_TIMEOUT
' Only Used with WaitForEvent
    Case Else
    End Select
End Function


Public Sub LoadChoices(FJ As FaxmanJr)
    On Error Resume Next
' Loads all FMJR transient properties from registry
' Note: GetSettings and SaveSettings are easier to use, but leak handles,
' and seem to have problems on certain machines.
    Dim cReg As New cRegistry
    
' HKEY_CURRENT_USER\Software\VB and VBA Program Settings\pFaxJr
    If (cReg.OpenKey(RegKey)) Then
        FJ.Class = cReg.GetLong("Class", 1)
        If (cReg.GetStringValue("DeviceInit", "None") <> "None" Or _
                cReg.GetStringValue("DeviceInit", "None") <> "") Then
            FJ.DeviceInit = cReg.GetStringValue("DeviceInit")
        End If
        If (cReg.GetStringValue("DeviceReset", "None") <> "None" Or _
                cReg.GetStringValue("DeviceReset", "None") <> "") Then
            FJ.DeviceReset = cReg.GetStringValue("DeviceReset")
        End If
        FJ.FaxBanner = cReg.GetStringValue("FaxBanner")
        FJ.FaxComments = cReg.GetStringValue("FaxComments")
        FJ.FaxCompany = cReg.GetStringValue("FaxCompany")
        FJ.FaxCoverPage = cReg.GetStringValue("FaxCoverPage")
        FJ.FaxName = cReg.GetStringValue("FaxName")
        FJ.FaxResolution = cReg.GetStringValue("FaxResolution")
        FJ.FaxSubject = cReg.GetStringValue("FaxSubject")
        FJ.FaxUserData = cReg.GetStringValue("FaxUserData")
        FJ.LocalID = cReg.GetStringValue("LocalID")
        FJ.ReceiveDir = cReg.GetStringValue("ReceiveDir", App.Path)
        FJ.UserCompany = cReg.GetStringValue("UserCompany")
        FJ.UserFaxNumber = cReg.GetStringValue("UserFaxNumber")
        FJ.UserName = cReg.GetStringValue("UserName")
        FJ.UserVoiceNumber = cReg.GetStringValue("UserVoiceNumber")
        gstrDebug = cReg.GetStringValue("Debug", "ON")
        gstrMessage = cReg.GetStringValue("Message", "ON")
    Else
' No information in Registry
' lets put some logical defaults in here.
        gstrMessage = "ON"
        gstrDebug = "ON"
        FJ.Class = FAX_1
        FJ.ReceiveDir = App.Path
    End If
    Set cReg = Nothing
End Sub

Public Sub SaveChoices(FJ As FaxmanJr)
' Saves all FMJR transient properties to registry
    Dim cReg As New cRegistry
    
    If cReg.OpenKey(RegKey) <> True Then
        If cReg.CreateKey(RegKey) <> True Then
            Exit Sub
        End If
    End If
    cReg.SetLong "Class", FJ.Class
    cReg.SetStringValue "DeviceInit", FJ.DeviceInit
    cReg.SetStringValue "DeviceReset", FJ.DeviceReset
    cReg.SetStringValue "FaxBanner", FJ.FaxBanner
    cReg.SetStringValue "FaxComments", FJ.FaxComments
    cReg.SetStringValue "FaxCompany", FJ.FaxCompany
    cReg.SetStringValue "FaxCoverPage", FJ.FaxCoverPage
    cReg.SetStringValue "FaxName", FJ.FaxName
    cReg.SetStringValue "FaxResolution", FJ.FaxResolution
    cReg.SetStringValue "FaxSubject", FJ.FaxSubject
    cReg.SetStringValue "FaxUserData", FJ.FaxUserData
    cReg.SetStringValue "LocalID", FJ.LocalID
    cReg.SetStringValue "ReceiveDir", FJ.ReceiveDir
    cReg.SetStringValue "UserCompany", FJ.UserCompany
    cReg.SetStringValue "UserFaxNumber", FJ.UserFaxNumber
    cReg.SetStringValue "UserName", FJ.UserName
    cReg.SetStringValue "UserVoiceNumber", FJ.UserVoiceNumber
    cReg.SetStringValue "Debug", gstrDebug
    cReg.SetStringValue "Message", gstrMessage

    Set cReg = Nothing
End Sub

Private Function OpenFile() As Integer
' Used for debugging
    Dim intFileNum As Integer
    
    intFileNum = FreeFile
    Open GetUniqueFileName("txt") For Output As intFileNum
    
    Print #intFileNum, "-----------------------------------"
    Print #intFileNum, "FaxManFaxJr Debug Log File:"
    Print #intFileNum, "Application Title:  " & App.Title
    Print #intFileNum, "Log Initialized:  " & Date & "  " & Time
    Print #intFileNum, "-----------------------------------"
    OpenFile = intFileNum
End Function

Public Function GetUniqueFileName(strExt As String)
    Static strPath As String
    Static intCounter As Integer
    Dim strFile As String
    Dim strShort As String
    Dim intPlace As Integer
    
    If strPath = "" Then
        strShort = String(500, " ")
        strFile = Dir(App.Path & "\*.*")
        GetShortPathName App.Path & "\" & strFile, strShort, 500
        strPath = TrimPath(strShort)
    End If
    
' This needs to be a unique filename
    Do
        strFile = Trim(strPath & "Fax" & Trim(Str(intCounter)) & "." & strExt)
        intCounter = intCounter + 1
    Loop While Dir(strFile) <> ""
    
    GetUniqueFileName = strFile
End Function

Private Function TrimPath(strPath As String) As String
    Dim intPlace As Integer, intCount As Integer
    
    For intCount = Len(strPath) - 1 To 0 Step -1
        intPlace = InStr(intCount, strPath, "\")
        If intPlace <> 0 Then Exit For
    Next intCount
    TrimPath = Left(strPath, intPlace)
End Function

Public Sub DumpStr(strS As String)
' Output information to user window and log file if set to ON.
    Static intFileNo As Integer
    
    frmFaxJr.lwlb1.AddItem strS
    frmFaxJr.lwlb1.ListIndex = frmFaxJr.lwlb1.NewIndex
    
If gstrDebug = "ON" Then
' Debug Log Information
    If intFileNo = 0 Then
        intFileNo = OpenFile
    End If
    
    Print #intFileNo, strS
End If
End Sub

Public Sub GetAll(FS1 As FaxStatusObj)
' Dump all status infomation.
    DumpStr "***********************************************"
    DumpStr "RemoteID: " & FS1.RemoteID
    If Trim(FS1.ReceiveFileName) <> "" Then
        DumpStr "*** Receive Filename: " & FS1.ReceiveFileName
    End If
    DumpStr "Connect Speed: " & Str(FS1.ConnectSpeed)
    DumpStr "Resolution: " & Str(FS1.NegotiatedResolution)
    DumpStr "Status: " & FS1.CurrentStatusDesc
    DumpStr "Start Time: " & Str(FS1.StartTime)
    DumpStr "End Time: " & Str(FS1.EndTime)
    DumpStr "Page: " & FS1.Pages & " of " & FS1.PagesCompleted
    If FS1.ErrorCode > 0 Then
        DumpStr "Error: " & Str(FS1.ErrorCode) & " " & FS1.ErrorDesc
    End If
End Sub

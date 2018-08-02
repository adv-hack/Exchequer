VERSION 5.00
Object = "{07728B40-6223-11D2-BA57-00002149093D}#1.0#0"; "FMJr10.dll"
Object = "{2C228B97-82DC-41C2-81C9-22F7C90FCC65}#1.0#0"; "FmPrint4.ocx"
Begin VB.Form frmFaxJr 
   Caption         =   "FaxManJr- VB6 Sample App"
   ClientHeight    =   4905
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4110
   Icon            =   "FaxJr.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4888.145
   ScaleMode       =   0  'User
   ScaleWidth      =   4115.018
   StartUpPosition =   3  'Windows Default
   Begin FaxmanJrCtl.FaxmanJr FaxmanJr1 
      Left            =   3480
      OleObjectBlob   =   "FaxJr.frx":0442
      Top             =   2640
   End
   Begin VB.CommandButton cmdChoice 
      Caption         =   "&Choice"
      Height          =   315
      Left            =   1800
      TabIndex        =   13
      Top             =   2160
      Width           =   1335
   End
   Begin VB.ComboBox cboChoice 
      Height          =   315
      Left            =   1800
      Style           =   2  'Dropdown List
      TabIndex        =   12
      Tag             =   "aright"
      Top             =   2160
      Visible         =   0   'False
      Width           =   2175
   End
   Begin VB.TextBox txtChoice 
      Height          =   315
      Left            =   1800
      TabIndex        =   11
      Tag             =   "aright"
      Top             =   2160
      Width           =   2175
   End
   Begin VB.ComboBox cboOption 
      Height          =   315
      Left            =   120
      Style           =   2  'Dropdown List
      TabIndex        =   10
      Top             =   2160
      Width           =   1575
   End
   Begin VB.CommandButton cmdOptions 
      Caption         =   "&Options \/"
      Height          =   495
      Left            =   120
      TabIndex        =   9
      Top             =   1560
      Width           =   975
   End
   Begin VB.CommandButton cmdReceive 
      Caption         =   "&Receive"
      Height          =   495
      Left            =   2640
      TabIndex        =   8
      Top             =   1560
      Width           =   1335
   End
   Begin VB.ListBox lwlb1 
      Height          =   2010
      Left            =   120
      TabIndex        =   7
      Tag             =   "aboth"
      Top             =   2640
      Width           =   3135
   End
   Begin VB.CommandButton cmdSend 
      Caption         =   "&Send"
      Height          =   495
      Left            =   1200
      TabIndex        =   6
      Top             =   1560
      Width           =   1335
   End
   Begin VB.CommandButton cmdDevice 
      Caption         =   "&Device"
      Height          =   285
      Left            =   120
      TabIndex        =   5
      Top             =   1080
      Width           =   735
   End
   Begin VB.CommandButton cmdFiles 
      Caption         =   "&Files"
      Height          =   285
      Left            =   120
      TabIndex        =   4
      Top             =   120
      Width           =   735
   End
   Begin VB.TextBox txtDevice 
      Height          =   285
      Left            =   1200
      TabIndex        =   3
      Tag             =   "aright"
      Top             =   1080
      Width           =   2775
   End
   Begin VB.TextBox txtNumber 
      Height          =   285
      Left            =   1200
      TabIndex        =   2
      Tag             =   "aright"
      Top             =   600
      Width           =   2775
   End
   Begin VB.TextBox txtFiles 
      Height          =   285
      Left            =   1200
      TabIndex        =   1
      Tag             =   "aright"
      Top             =   120
      Width           =   2775
   End
   Begin FmPrintCtl.FmPrinter FmPrinter1 
      Height          =   480
      Left            =   3480
      OleObjectBlob   =   "FaxJr.frx":04DC
      TabIndex        =   14
      Top             =   3960
      Width           =   480
   End
   Begin FaxmanJrCtl.FaxFinder FaxFinder1 
      Left            =   3480
      OleObjectBlob   =   "FaxJr.frx":0526
      Top             =   3360
   End
   Begin VB.Label lblLabel2 
      Caption         =   "Number"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   600
      Width           =   855
   End
End
Attribute VB_Name = "frmFaxJr"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim mblnReceive As Boolean
Dim mclsCD As New clsCommonDialog

Private Sub cboChoice_LostFocus()

    ActOnChoice
    
End Sub


Private Sub cmdDevice_Click()

' Load device information into FaxMan Jr. control
' and display for user.
    ' Continuing to click on the button presents more choices.
    Static intDevice As Integer
    Dim ddobjMyDevice As DeviceDesc
    Dim strDevStr As String
    
    If FaxFinder1.DeviceCount = 0 Then
'  DeviceCount - Returns the number of fax devices found by the FaxMan Jr. control
        txtDevice.Text = "No Devices Detected."
        Exit Sub
    End If
    
    If intDevice > FaxFinder1.DeviceCount - 1 Then
        intDevice = 0
    End If

    Set ddobjMyDevice = FaxFinder1.Item(intDevice)
' Item - Returns a DeviceDesc object for each faxmodem found during Auto Detection.

    txtDevice.Text = GetDeviceStr(ddobjMyDevice)
    txtDevice.Refresh

    ' Class - Specifies the class this device currently supports (Class 1, Class 2, or Class 2.0).
    FaxmanJr1.Class = IIf(ddobjMyDevice.bClass20, FAX_20, FaxmanJr1.Class)
    FaxmanJr1.Class = IIf(ddobjMyDevice.bClass2, FAX_2, FaxmanJr1.Class)
    FaxmanJr1.Class = IIf(ddobjMyDevice.bClass1, FAX_1, FaxmanJr1.Class)
    FaxmanJr1.Class = IIf(ddobjMyDevice.bClass21, FAX_21, FaxmanJr1.Class)
    FaxmanJr1.Port = ddobjMyDevice.Port

    intDevice = intDevice + 1
    
End Sub

Private Sub cmdFiles_Click()

'  Specify files to fax.
'  Multiple files will be chained together.
    On Error Resume Next
    
    mclsCD.Filter = F_FaxManFiles
    
    If mclsCD.ShowOpen Then
        AddFiles mclsCD.FileName
    End If
    
End Sub

Private Sub cboOption_Click()

' Present Other FaxMan Jr. Properties to user.
    DisplayChoices
    
End Sub

Private Sub cmdOptions_Click()

' Display other FaxMan Jr. Choices to user
Static blnOption As Boolean
    If blnOption = False Then
' Hide Choices
        cmdOptions.Caption = "&Options \/"
        cboOption.Visible = False
        txtChoice.Visible = False
        cboChoice.Visible = False
        cmdChoice.Visible = False
        lwlb1.Top = cboOption.Top
        blnOption = True
    Else
' Show Choices
        cmdOptions.Caption = "&Options /\"
        cboOption.Visible = True
        txtChoice.Visible = True
        cmdChoice.Visible = True
        DisplayChoices
        lwlb1.Top = cboOption.Top + (cboOption.Height * 1.5)
        blnOption = False
    End If
    Form_Resize
    
End Sub

Private Sub cmdReceive_Click()

' Prepare the modem to receive a fax.
    If FaxmanJr1.Status <> DEV_READY Then
'Status - Returns the state of the FaxMan Jr control
            If FaxmanJr1.Status = DEV_LISTENING Then
                DumpStr "!!!!! Device already listening !!!!!"
            Else
                DumpStr "!!!!! Device currently in use !!!!!"
            End If
            Exit Sub
    End If
        
    DumpStr "***********************************************"
    DumpStr "****       Preparing to Receive Fax        ****"
    DumpStr "***********************************************"
    
    DumpStr "Receive Path: " & FaxmanJr1.ReceiveDir
    FaxmanJr1.Receive (1) ' 1 Ring


End Sub

Private Sub cmdSend_Click()

' Send a fax based on current information.
    If FaxmanJr1.Status <> DEV_READY And FaxmanJr1.Status <> DEV_LISTENING Then
            DumpStr "!!!!! Device currently in use !!!!!"
            Exit Sub
    End If

    FaxmanJr1.FaxFiles = txtFiles.Text
    FaxmanJr1.FaxNumber = txtNumber.Text
    FaxmanJr1.SendFax
    
' These could be cleared after faxing
'    txtFiles.Text = ""
'    txtNumber.Text = ""
    
    DumpStr "***********************************************"
    DumpStr "****         Sending New Fax               ****"
    DumpStr "***********************************************"

End Sub

Private Sub cbSetOption_Click()

    ActOnChoice
    
End Sub

Private Sub cmdChoice_Click()

    ActOnChoice
    
End Sub


Private Sub FaxmanJr1_CompletionStatus(ByVal pStatObj As FaxmanJrCtl.IFaxStatusObj)

' Fired when the fax job has completed to let your application know
'      what the end-result of the job was

'FaxMan Jr. keeps track of the current state of the faxing process in the Status object
    DumpStr GetFaxStatus(pStatObj)
    DumpStr " "
    DumpStr "***********************************************"
    DumpStr "****           Completed Fax               ****"
    DumpStr "***********************************************"
    DumpStr "*** RemoteID: " & pStatObj.RemoteID
' Returns the ID string of the remote Fax machine
    If Trim(pStatObj.ReceiveFileName) <> "" Then
        DumpStr "*** Receive Filename: " & pStatObj.ReceiveFileName
    End If
    DumpStr "*** Connect Speed: " & Str(pStatObj.ConnectSpeed)
    DumpStr "*** Resolution: " & Str(pStatObj.NegotiatedResolution)
' Returns the negotiated resolution of the fax session
'     may not be the same as the FaxResolution property because the
'     receiving machine may not allow the requested resolution.

    DumpStr "*** Status: " & pStatObj.CurrentStatusDesc
' Returns a string describing the current status of the fax send or
'     receive operation
    DumpStr "*** Start Time: " & Str(pStatObj.StartTime)
    DumpStr "*** End Time: " & Str(pStatObj.EndTime)
    DumpStr "*** Pages: " & pStatObj.Pages
' Returns the total number of pages in the current fax job
    If pStatObj.ErrorCode > 0 Then
        DumpStr "*** Error: " & Str(pStatObj.ErrorCode) & " " & pStatObj.ErrorDesc
    End If
    DumpStr "***********************************************"
    
End Sub

Private Sub FaxmanJr1_EndTime(ByVal pStatObj As FaxmanJrCtl.IFaxStatusObj)

' Fired when the faxmodem has hung up the phone line
    DumpStr GetFaxStatus(pStatObj)
    
End Sub

Private Sub FaxmanJr1_Message(ByVal bsMsg As String, ByVal bNewLine As Integer)

' Fired when a debug string is output
    ' This Event provides all the strings passed to and from the modem.
    ' This information is essential to solving any problems that might come
    ' up in the field.  Make sure to include an option for dumping this information
    ' to a log file in your final application.
    Static strBuff As String
    
    If gstrMessage = "ON" Then
        strBuff = strBuff & bsMsg
        If bNewLine Then
            If strBuff <> "" Then
                DumpStr strBuff
                strBuff = ""
            End If
        End If
    End If
    
End Sub

Private Sub FaxmanJr1_NegotiatedParms(ByVal pStatObj As FaxmanJrCtl.IFaxStatusObj)

' This event is fired when the faxmodem has completed initial
' negotiations with the remote fax device
    DumpStr GetFaxStatus(pStatObj)
    
End Sub

Private Sub FaxmanJr1_Pages(ByVal pStatObj As FaxmanJrCtl.IFaxStatusObj)

' The Pages event is fired once at the start of a sending operation
'     to indicate the number of total pages (including cover page) to be sent.

    DumpStr GetFaxStatus(pStatObj)
    
End Sub

Private Sub FaxmanJr1_ReceiveFileName(ByVal pStatObj As FaxmanJrCtl.IFaxStatusObj)

' This event is fired during a receive session to indicate the path and
'      filename of the file used to store the received fax

    DumpStr GetFaxStatus(pStatObj)
    
End Sub

Private Sub FaxmanJr1_Ring(pnAction As Integer)

' This event is fired in the context of a Listen method call whenever
'     a ring is detected on the phone line
    DumpStr "Ring"
    pnAction = 1
    
    cmdChoice.Caption = "&Receive Now"
    
    If mblnReceive Then
        pnAction = 2
        mblnReceive = False
        cmdChoice.Caption = "&Receiving"
    End If
    
End Sub

Private Sub FaxmanJr1_StartTime(ByVal pStatObj As FaxmanJrCtl.IFaxStatusObj)

' Fired after the faxmodem dials out
    DumpStr GetFaxStatus(pStatObj)
    
End Sub

Private Sub FaxmanJr1_Status(ByVal pStatObj As FaxmanJrCtl.IFaxStatusObj)

' Fired during fax send/receive sessions to indicate significant
' milestones during the process
' This is one of the more useful Events.
' It is helpful in providing information to the user regarding
' the status of their fax.
    DumpStr GetFaxStatus(pStatObj)
    
End Sub

Private Sub FmPrinter1_PrintComplete()
' In an application without a Faxing User interface this is the IDEAL event
' for programatically scheduling your fax.
' This is also a fine event to pop up a dialog if you need specific infomation
' like a fax number prior to sending the fax.
    Dim job As PrintJob
    If FmPrinter1.PrintJobCount > 0 Then
        Set job = FmPrinter1.GetNextPrintJob()
        AddFiles job.FileName
    End If
End Sub

Private Sub Form_Load()
    Dim appname As String

' Load FaxMan Jr Settings from the registry.
    LoadChoices FaxmanJr1
' Populate the Options combo Box.
    LoadOptions
' Act on the choices for selecting default info.
    cmdOptions_Click
' Load information for Common Dialog Class.
    mclsCD.StartDirectory = App.Path
    mclsCD.SaveLastDir = True
    
    If False = FmPrinter1.IsPrinterInstalled Then
        MsgBox ("Installing Printer driver, this may take a little while.")
        Me.MousePointer = vbHourglass
        FmPrinter1.PrintFilesPath = App.Path
        FmPrinter1.InstallPrinter App.Path
        Me.MousePointer = vbUseDefaultCursor
    End If
    
End Sub

Private Sub Form_Resize()

' The key to this function working are the tags on the controls.
' This allows the user to resize the dialog and view more information.
    Dim intMarg As Integer
    Dim intCounter As Integer
    Dim intCX As Integer
    Dim intCY As Integer
    
    intMarg = 120
    
    For intCounter = 0 To frmFaxJr.Count - 1
        If Left(frmFaxJr.Controls(intCounter).Tag, 1) = "a" Then
            intCX = frmFaxJr.ScaleWidth - (intMarg + frmFaxJr.Controls(intCounter).Left)
            intCY = frmFaxJr.ScaleHeight - (intMarg + frmFaxJr.Controls(intCounter).Top)
        End If
        If frmFaxJr.Controls(intCounter).Tag Like "aright" And intCX > 0 Then
            frmFaxJr.Controls(intCounter).Width = intCX
        End If
        If frmFaxJr.Controls(intCounter).Tag Like "abottom" And intCY > 0 Then
            frmFaxJr.Controls(intCounter).Height = intCY
        End If
        If frmFaxJr.Controls(intCounter).Tag Like "aboth" And intCX > 0 And intCY > 0 Then
            frmFaxJr.Controls(intCounter).Width = intCX
            frmFaxJr.Controls(intCounter).Height = intCY
        End If
    Next intCounter
    
End Sub

Private Sub Form_Unload(Cancel As Integer)

' Store FaxMan Jr settings in the registry.
    SaveChoices FaxmanJr1
    If FaxmanJr1.Status <> DEV_READY Then
' If device is busy tell it to quit in middle of fax.
        FaxmanJr1.CancelFax
    End If
' Close all opened files
    Reset
    
End Sub

Private Sub txtChoice_LostFocus()

' There may be a better event to do this in but this one works.
    ActOnChoice
    
End Sub

Private Sub LoadOptions()

' Populate combo box.
    With cboOption
        .AddItem "Class", 0
        .AddItem "Device Init", 1
        .AddItem "Device Reset", 2
        .AddItem "Fax Banner", 3
        .AddItem "Fax Comments", 4
        .AddItem "Fax Company", 5
        .AddItem "Fax Cover Page", 6
        .AddItem "Fax Name", 7
        .AddItem "Fax Resolution", 8
        .AddItem "Fax Subject", 9
        .AddItem "Fax User Data", 10
        .AddItem "Import Files", 11
        .AddItem "Local Id", 12
        .AddItem "Receive Dir", 13
        .AddItem "Cancel Fax", 14
        .AddItem "User Company", 15
        .AddItem "User Fax Number", 16
        .AddItem "User Name", 17
        .AddItem "User Voice Num.", 18
        .AddItem "View Fax", 19
        .AddItem "Debug Log File", 20
        .AddItem "Listen", 21
        .AddItem "Messages", 22
    End With
    
End Sub
 
Private Sub DisplayChoices()

' Display the correct control depending on whats needed.
    txtChoice.Visible = True
    cmdChoice.Visible = False
    cboChoice.Visible = False
    Select Case cboOption.ListIndex
        Case 0
            cboChoice.Visible = True
            txtChoice.Visible = False
            cboChoice.Clear
            cboChoice.AddItem "Class 1", 0
            cboChoice.AddItem "Class 2", 1
            cboChoice.AddItem "Class 2.0", 2
            cboChoice.AddItem "Class 2.1", 3
            cboChoice.ListIndex = FaxmanJr1.Class - 1
        Case 1
            txtChoice.Text = FaxmanJr1.DeviceInit
' DeviceInit - Determines the string used to initialize a faxmodem
        Case 2
            txtChoice.Text = FaxmanJr1.DeviceReset
' DeviceReset - Determines the string used to reset a faxmodem
        Case 3
            txtChoice.Text = FaxmanJr1.FaxBanner
' FaxBanner - line of text that may be added to the top of each fax page sent
        Case 4
            txtChoice.Text = FaxmanJr1.FaxComments
' FaxComments - comments displayed on the coverpage
        Case 5
            txtChoice.Text = FaxmanJr1.FaxCompany
' FaxCompany - name of the Company to which the fax is being sent
        Case 6
            txtChoice.Text = FaxmanJr1.FaxCoverPage
        Case 7
            txtChoice.Text = FaxmanJr1.FaxName
' FaxName - the name of the Fax recipient
        Case 8
            cboChoice.Visible = True
            txtChoice.Visible = False
            cboChoice.Clear
            cboChoice.AddItem "Low Resolution", 0
            cboChoice.AddItem "High Resolution", 1
            cboChoice.ListIndex = FaxmanJr1.FaxResolution
' FaxResolution - resolution to be used when transmitting the fax
        Case 9
            txtChoice.Text = FaxmanJr1.FaxSubject
' FaxSubject - normally only used on banners and cover pages
        Case 10
            txtChoice.Text = FaxmanJr1.FaxUserData
' FaxUserData - This string is made available so an application can store
' whatever information it would like along with the fax.
' This string may be used on banners and coverpages with the %e format specifier.
        Case 11
            cmdChoice.Visible = True
            txtChoice.Visible = False
            cmdChoice.Caption = "&Import File"
        Case 12
            txtChoice.Text = FaxmanJr1.LocalID
' LocalID - the 20 character identifier used to identify this
' faxmodem during fax transmissions
        Case 13
            txtChoice.Text = FaxmanJr1.ReceiveDir
' Sets the directory where FaxMan Jr. will place subsequently received faxes
        Case 14
            cmdChoice.Visible = True
            txtChoice.Visible = False
            cmdChoice.Caption = "&Cancel Fax"
        Case 15
            txtChoice.Text = FaxmanJr1.UserCompany
' The UserCompany is the name of the Company which is sending the fax
        Case 16
            txtChoice.Text = FaxmanJr1.UserFaxNumber
' The UserFaxNumber is the Fax Number of the Company which is sending the fax.
        Case 17
            txtChoice.Text = FaxmanJr1.UserName
' The UserName is the name of the person which is sending the fax
        Case 18
            txtChoice.Text = FaxmanJr1.UserVoiceNumber
' The UserVoiceNumber field is for the voice number of the person
'     which is sending the fax
        Case 19
            cmdChoice.Visible = True
            txtChoice.Visible = False
            cmdChoice.Caption = "&View Fax"
        Case 20
            cmdChoice.Visible = True
            txtChoice.Visible = False
            cmdChoice.Caption = "&Debug " & gstrDebug
        Case 21
            cmdChoice.Visible = True
            txtChoice.Visible = False
            cmdChoice.Caption = "&Listen Now"
        Case 22
            cmdChoice.Visible = True
            txtChoice.Visible = False
            cmdChoice.Caption = "Message " & gstrMessage
    End Select
    
End Sub
Private Sub ActOnChoice()

' Set the appropriate properties or complete requested action.
    On Error Resume Next
    Select Case cboOption.ListIndex
        Case 0
            FaxmanJr1.Class = cboChoice.ListIndex + 1
' Specifies the class this device currently supports
' (Class 1, Class 2, Class 2.0 or Class 2.1).

        Case 1
            FaxmanJr1.DeviceInit = txtChoice.Text
        Case 2
            FaxmanJr1.DeviceReset = txtChoice.Text
        Case 3
            FaxmanJr1.FaxBanner = txtChoice.Text
        Case 4
            FaxmanJr1.FaxComments = txtChoice.Text
        Case 5
            FaxmanJr1.FaxCompany = txtChoice.Text
' The FaxCompany is the name of the Company to which the fax is being sent
        Case 6
            FaxmanJr1.FaxCoverPage = txtChoice.Text
        Case 7
            FaxmanJr1.FaxName = txtChoice.Text
' Specifies the name of the Fax recipient
' used only on banners and cover pages. Setting this property is optional.

        Case 8
            FaxmanJr1.FaxResolution = cboChoice.ListIndex
' Specifies the resolution to be used when transmitting the fax
        Case 9
            FaxmanJr1.FaxSubject = txtChoice.Text
'normally only used on banners and cover pages
        Case 10
            FaxmanJr1.FaxUserData = txtChoice.Text
' The FaxUserData is a user defined field for fax information.
' The FaxUserData property is a string that is associated with a particular
' fax file. This string is made available so an application can store whatever
' information it would like along with the fax.
' This string may be used on banners and coverpages with the %e format specifier.

        Case 11
' Import Files
            Dim dFile As String
            
            mclsCD.Filter = F_ImportFiles
            If mclsCD.ShowOpen Then
                dFile = GetUniqueFileName("fmf")
                FaxmanJr1.ImportFiles dFile, mclsCD.FileName
                AddFiles Trim(dFile)
            End If
        Case 12
            FaxmanJr1.LocalID = txtChoice.Text
' Specifies the 20 character identifier used to identify this faxmodem
' during fax transmissions
        Case 13
            FaxmanJr1.ReceiveDir = txtChoice.Text
' Sets the directory where FaxMan Jr. will place subsequently received faxes
        Case 14
            FaxmanJr1.CancelFax
' Cancels the currently in-progress fax operation.
        Case 15
            FaxmanJr1.UserCompany = txtChoice.Text
' The UserCompany is the name of the Company which is sending the fax
        Case 16
            FaxmanJr1.UserFaxNumber = txtChoice.Text
' the Fax Number of the Company which is sending the fax.
        Case 17
            FaxmanJr1.UserName = txtChoice.Text
' the name of the person which is sending the fax
        Case 18
            FaxmanJr1.UserVoiceNumber = txtChoice.Text
' the voice number of the person which is sending the fax.
        Case 19
            Dim X, sDir As String, i As Integer
            Dim nPlace As Integer, sShort As String
' Navigate up one dir
            sDir = App.Path
            For i = Len(sDir) - 1 To 0 Step -1
                nPlace = InStr(i, sDir, "\")
                If nPlace <> 0 Then Exit For
            Next i
            sDir = Left(sDir, nPlace)
            sShort = String(500, " ")
            GetShortPathName txtFiles.Text, sShort, 500
            sDir = sDir & "viewer\faxprinter.exe " & Trim(sShort)
            
            X = Shell(sDir, 1)
        Case 20
            gstrDebug = IIf(gstrDebug = "ON", "OFF", "ON")
            cmdChoice.Caption = "&Debug " & gstrDebug
        Case 21
            If cmdChoice.Caption = "&Listen Now" Then
                If FaxmanJr1.Status <> DEV_READY Then
                    If FaxmanJr1.Status = DEV_LISTENING Then
                        DumpStr "!!!!! Device already listening !!!!!"
                    Else
                        DumpStr "!!!!! Device currently in use !!!!!"
                    End If
                    Exit Sub
                End If
                cmdChoice.Caption = "&Listening"
                FaxmanJr1.Listen
' Causes the FaxMan Jr. control to listen for incoming calls
            ElseIf cmdChoice.Caption = "&Receive Now" Then
                mblnReceive = True
            Else
                cmdChoice.Caption = "&Listen Now"
            End If
        Case 22
            gstrMessage = IIf(gstrMessage = "ON", "OFF", "ON")
            cmdChoice.Caption = "&Message " & gstrMessage
    End Select
    
End Sub

Private Sub ProcessEvents(intStatusIN As Integer)

' Non event driven implementation.
'
' Note the WaitForEvent prevents the application from getting
' stuck in an endless loop.
' Extreme caution should be used when terminating your application
' if this value is set to a very large number or to small of a number.
' When the value is to big or small messaging thread problems can emerge.
' A good range is between 100 and 2000.
    Dim intCount As Integer
    intCount = 0
    Do While FaxmanJr1.Status = intStatusIN
        FaxmanJr1.WaitForEvent (10000)
' Waitforevent method Waits for a change in the control’s status
        If FaxmanJr1.StatusObject.LastEventType <> EVENT_TIMEOUT Then
' LastEventType property Returns an integer which indicates the
' last type of event that ocurred
            intCount = 0
            GetAll FaxmanJr1.StatusObject
' Statusobject property, Returns a StatusObject containing the
' current status of the FaxMan Jr control
        Else
            intCount = intCount + 1
            If intCount > 8 Then     ' 90 idle seconds
                Exit Sub
                DumpStr "!!!!!!!!!!! TIMED OUT !!!!!!!!!!!!"
            End If
        End If
    Loop
    
End Sub

Private Sub AddFiles(newFile As String)

' Add the file to the end of the string using the "+" delimitor.
    If txtFiles.Text <> "" Then
        txtFiles.Text = txtFiles.Text & "+" & newFile
    Else
        txtFiles.Text = newFile
    End If
    txtFiles.Refresh
    
End Sub







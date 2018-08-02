VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmMain 
   Caption         =   "Government Gateway"
   ClientHeight    =   9975
   ClientLeft      =   60
   ClientTop       =   630
   ClientWidth     =   8280
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   9975
   ScaleWidth      =   8280
   StartUpPosition =   2  'CenterScreen
   Begin MSComctlLib.ProgressBar pgbPoll 
      Height          =   300
      Left            =   4200
      TabIndex        =   18
      Top             =   9660
      Visible         =   0   'False
      Width           =   4065
      _ExtentX        =   7170
      _ExtentY        =   529
      _Version        =   393216
      Appearance      =   1
   End
   Begin MSComctlLib.StatusBar stbStatus 
      Align           =   2  'Align Bottom
      Height          =   375
      Left            =   0
      TabIndex        =   17
      Top             =   9600
      Width           =   8280
      _ExtentX        =   14605
      _ExtentY        =   661
      Style           =   1
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
   End
   Begin VB.CommandButton cmdRestoreDefaults 
      Caption         =   "Restore &Defaults"
      Height          =   375
      Left            =   4920
      TabIndex        =   16
      Top             =   9120
      Width           =   1335
   End
   Begin VB.Timer tmrPoll 
      Enabled         =   0   'False
      Interval        =   5000
      Left            =   7320
      Top             =   1200
   End
   Begin VB.TextBox txtDocumentPath 
      Height          =   315
      Left            =   360
      TabIndex        =   0
      Text            =   "C:\temp\SampleSubmissionRequest.xml"
      ToolTipText     =   "The XML document you wish to submit"
      Top             =   480
      Width           =   7215
   End
   Begin VB.CommandButton cmdBrowse 
      Caption         =   "..."
      Height          =   318
      Left            =   7680
      TabIndex        =   1
      Top             =   480
      Width           =   315
   End
   Begin TabDlg.SSTab tabXML 
      Height          =   4935
      Left            =   240
      TabIndex        =   10
      Top             =   3960
      Width           =   7695
      _ExtentX        =   13573
      _ExtentY        =   8705
      _Version        =   393216
      Style           =   1
      Tabs            =   4
      Tab             =   2
      TabsPerRow      =   4
      TabHeight       =   520
      TabCaption(0)   =   "S&ource XML"
      TabPicture(0)   =   "frmMain.frx":0442
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "txtXMLSource"
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "&Response XML"
      TabPicture(1)   =   "frmMain.frx":045E
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "txtXMLReceive"
      Tab(1).ControlCount=   1
      TabCaption(2)   =   "&Protocol Events"
      TabPicture(2)   =   "frmMain.frx":047A
      Tab(2).ControlEnabled=   -1  'True
      Tab(2).Control(0)=   "lblInfo"
      Tab(2).Control(0).Enabled=   0   'False
      Tab(2).Control(1)=   "lvwEvents"
      Tab(2).Control(1).Enabled=   0   'False
      Tab(2).ControlCount=   2
      TabCaption(3)   =   "&Breakpoints"
      TabPicture(3)   =   "frmMain.frx":0496
      Tab(3).ControlEnabled=   0   'False
      Tab(3).Control(0)=   "lvwBreakpoints"
      Tab(3).ControlCount=   1
      Begin MSComctlLib.ListView lvwBreakpoints 
         Height          =   3975
         Left            =   -74880
         TabIndex        =   15
         ToolTipText     =   "Check a box to set a breakpoint"
         Top             =   480
         Width           =   7455
         _ExtentX        =   13150
         _ExtentY        =   7011
         View            =   3
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         Checkboxes      =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   2
         BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            Text            =   "Break on"
            Object.Width           =   4233
         EndProperty
         BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   1
            Text            =   "Description"
            Object.Width           =   8819
         EndProperty
      End
      Begin VB.TextBox txtXMLReceive 
         Height          =   3885
         Left            =   -74880
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   12
         Text            =   "frmMain.frx":04B2
         ToolTipText     =   "The most recent response received from the Gateway"
         Top             =   480
         Width           =   7455
      End
      Begin VB.TextBox txtXMLSource 
         Height          =   3885
         Left            =   -74880
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   11
         ToolTipText     =   "The initial submission XML"
         Top             =   480
         Width           =   7455
      End
      Begin MSComctlLib.ListView lvwEvents 
         Height          =   3375
         Left            =   120
         TabIndex        =   13
         ToolTipText     =   "Double-click an event to view the request and response messages"
         Top             =   480
         Width           =   7455
         _ExtentX        =   13150
         _ExtentY        =   5953
         View            =   3
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         FullRowSelect   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   7
         BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            Text            =   "ID"
            Object.Width           =   1270
         EndProperty
         BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   1
            Text            =   "Time"
            Object.Width           =   1482
         EndProperty
         BeginProperty ColumnHeader(3) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   2
            Text            =   "Request"
            Object.Width           =   2540
         EndProperty
         BeginProperty ColumnHeader(4) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   3
            Text            =   "Response"
            Object.Width           =   3598
         EndProperty
         BeginProperty ColumnHeader(5) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   4
            Text            =   "HTTP Text"
            Object.Width           =   2822
         EndProperty
         BeginProperty ColumnHeader(6) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   5
            Text            =   "Correlation ID"
            Object.Width           =   5892
         EndProperty
         BeginProperty ColumnHeader(7) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
            SubItemIndex    =   6
            Text            =   "Info"
            Object.Width           =   12347
         EndProperty
      End
      Begin VB.Label lblInfo 
         BorderStyle     =   1  'Fixed Single
         Height          =   855
         Left            =   120
         TabIndex        =   19
         Top             =   3960
         Width           =   7455
      End
   End
   Begin VB.CommandButton cmdSubmit 
      Caption         =   "&Submit"
      Default         =   -1  'True
      Height          =   375
      Left            =   6600
      TabIndex        =   14
      ToolTipText     =   "Start the submission process"
      Top             =   9120
      Width           =   1335
   End
   Begin MSComDlg.CommonDialog dlgMain 
      Left            =   7800
      Top             =   1200
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Frame Frame1 
      Caption         =   "Gateway Submission Server"
      Height          =   2055
      Left            =   240
      TabIndex        =   2
      Top             =   1560
      Width           =   7695
      Begin VB.OptionButton optHTML 
         Caption         =   "Base-64 encoded XML within HTML"
         Height          =   255
         Left            =   2400
         TabIndex        =   21
         Top             =   1680
         Width           =   3855
      End
      Begin VB.OptionButton optXML 
         Caption         =   "XML"
         Height          =   255
         Left            =   1440
         TabIndex        =   20
         Top             =   1680
         Value           =   -1  'True
         Width           =   855
      End
      Begin VB.TextBox txtGatewayURL 
         Height          =   315
         Left            =   600
         TabIndex        =   4
         Text            =   "https://secure.dev.gateway.gov.uk/ggsubmission.asp"
         ToolTipText     =   "The URL of the Government Gateway"
         Top             =   360
         Width           =   6855
      End
      Begin VB.TextBox txtPassword 
         Height          =   315
         IMEMode         =   3  'DISABLE
         Left            =   5160
         PasswordChar    =   "*"
         TabIndex        =   9
         ToolTipText     =   "Your password"
         Top             =   1200
         Width           =   2295
      End
      Begin VB.TextBox txtUsername 
         Height          =   315
         Left            =   1440
         TabIndex        =   7
         ToolTipText     =   "Your assigned Vendor ID"
         Top             =   1200
         Width           =   2655
      End
      Begin VB.CheckBox chkAuthentication 
         Caption         =   "Requires &Authentication"
         Height          =   255
         Left            =   600
         TabIndex        =   5
         Top             =   840
         Value           =   1  'Checked
         Width           =   2055
      End
      Begin VB.Label Label4 
         Caption         =   "Submit as:"
         Height          =   255
         Left            =   120
         TabIndex        =   22
         Top             =   1680
         Width           =   975
      End
      Begin VB.Label Label3 
         Caption         =   "&URL:"
         Height          =   255
         Left            =   120
         TabIndex        =   3
         Top             =   390
         Width           =   495
      End
      Begin VB.Label lblUsername 
         Caption         =   "User&name:"
         Height          =   255
         Left            =   600
         TabIndex        =   6
         Top             =   1230
         Width           =   855
      End
      Begin VB.Label lblPassword 
         Caption         =   "&Password:"
         Height          =   255
         Left            =   4320
         TabIndex        =   8
         Top             =   1230
         Width           =   855
      End
   End
   Begin VB.PictureBox Picture1 
      Align           =   1  'Align Top
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   1215
      Left            =   0
      ScaleHeight     =   1215
      ScaleWidth      =   8280
      TabIndex        =   23
      Top             =   0
      Width           =   8280
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "&Document to submit:"
         ForeColor       =   &H00FFFFFF&
         Height          =   195
         Left            =   360
         TabIndex        =   24
         Top             =   240
         Width           =   1455
      End
   End
   Begin VB.Line Line1 
      X1              =   240
      X2              =   7920
      Y1              =   9000
      Y2              =   9000
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuInstructions 
         Caption         =   "&Instructions"
      End
      Begin VB.Menu mnuReadMe 
         Caption         =   "View &ReadMe.txt"
      End
      Begin VB.Menu mnuSeparator 
         Caption         =   "-"
      End
      Begin VB.Menu mnuAbout 
         Caption         =   "&About"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'/////////////////////////////////////////////////////////////////////////////////
'//
'// Form        :   frmMain
'// Description :   Main GUI Form for VBInjector application.
'//                 Form is used to capture data required to successfully post
'//                 supplied content to a specified URL.
'//
'/////////////////////////////////////////////////////////////////////////////////
'//
'//

Option Explicit

' Constants used for error handling
Private Const mstrMODULENAME As String = " frmMain "

' Constants to help window resizing
Private Const WIN_MIN_WIDTH As Long = 8400
Private Const WIN_MIN_HEIGHT As Long = 10665
Private Const WIN_BORDER = 120
Private Const WIN_BORDER_LARGE = 240


' The maximum file size we load into a textbox - set a little lower than 64Kb
Private Const MAX_FILESIZE As Long = 64000

' These are the IDs of the tabs on the tabstrip
Private Const TAB_SOURCE As Long = 0    ' posted XML tab index
Private Const TAB_RECEIVED As Long = 1  ' received XML tab index
Private Const TAB_EVENTS As Long = 2    ' protocol events tab index


' Timer constants, used when polling the Gateway server
Private Const TIMER_INTERVAL As Long = 500  ' 500 = 0.5 secs, timer fires to update status

' Constants for the columns in the Event log display
Private Const COL_TIME As Long = 1
Private Const COL_REQUEST As Long = 2
Private Const COL_RESPONSE As Long = 3
Private Const COL_HTTPTEXT As Long = 4
Private Const COL_CORRELATIONID As Long = 5
Private Const COL_INFO As Long = 6

' status messages displayed in the UI
Private Const STATUS_SENDING As String = "Sending to Gateway server..."
Private Const STATUS_WAITING As String = "Waiting to poll the server..."
Private Const DEFAULT_URL As String = "https://secure.dev.gateway.gov.uk/submission"
Private Const URLFILE As String = "urls.txt"

' File prefixes using by various text file encoding formats
Private Const PREFIX_UNICODE_BIG As String = "þÿ"
Private Const PREFIX_UNICODE_LITTLE As String = "ÿþ"
Private Const PREFIX_UTF8 As String = "ï»¿"




' Member variables -------------------------------------------------------------------------------
Private mlEventID As Long   ' Counter ID assigned to events received from Gateway server
Private WithEvents mobjProcessor As CSubmissionProcessor   ' Submission protocol management object
Attribute mobjProcessor.VB_VarHelpID = -1
Private mlPollInterval As Long  ' gateway polling interval in milliseconds
Private mcolBreakpoints As Collection
Private mbolFilepathChanged As Boolean  'note if filepath changed
Private mbXMLLoaded As Boolean  ' Has the Source XML been loaded OK into the textbox?




'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Form_Initialize()
'//         Initialise member variables.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub Form_Initialize()
    Dim FileNum As Integer
    Dim strTemp As String
    
    mlEventID = 0
    mlPollInterval = 0
    mbXMLLoaded = False
    
    'load up the URL combo
    
    FileNum = FreeFile
    On Error GoTo noFile
    Open URLFILE For Input As FileNum
    Do While Not EOF(1)
        Line Input #FileNum, strTemp
        comboGatewayURL.AddItem (strTemp)
    Loop
    Close FileNum
noFile:
    
    Set mobjProcessor = New CSubmissionProcessor
    Set mcolBreakpoints = New Collection
    ' add all the possible break points we can set
    
    Dim objBreakPoint As CBreakpoint
    
    Set objBreakPoint = New CBreakpoint
    objBreakPoint.Init "submission_acknowledge", "Break when a Submission Acknowledgement is received", FUNCTION_SUBMIT, QUALIFIER_ACK
    mcolBreakpoints.Add objBreakPoint, objBreakPoint.Name
    
    Set objBreakPoint = New CBreakpoint
    objBreakPoint.Init "submission_response", "Break when a Submission Response is received", FUNCTION_SUBMIT, QUALIFIER_RES
    mcolBreakpoints.Add objBreakPoint, objBreakPoint.Name
    
    Set objBreakPoint = New CBreakpoint
    objBreakPoint.Init "delete_acknowledge", "Break when a Delete Acknowledgement is received", FUNCTION_DELETE, QUALIFIER_ACK
    mcolBreakpoints.Add objBreakPoint, objBreakPoint.Name
    
    Set objBreakPoint = New CBreakpoint
    objBreakPoint.Init "all responses", "Break on all response types", "*", "*"
    mcolBreakpoints.Add objBreakPoint, objBreakPoint.Name
    
    
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Form_Resize()
'//         Move controls on the form to fill the window
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub Form_Resize()
    On Error Resume Next
    
    If (Me.Width > WIN_MIN_WIDTH) Then
        ' we can resize the form
        Line1.X2 = ScaleWidth - 2 * WIN_BORDER
        cmdSubmit.Left = ScaleWidth - cmdSubmit.Width - WIN_BORDER_LARGE - WIN_BORDER
        cmdRestoreDefaults.Left = ScaleWidth - cmdRestoreDefaults.Width - cmdSubmit.Width - 3 * WIN_BORDER_LARGE
        tabXML.Width = ScaleWidth - WIN_BORDER - 2 * WIN_BORDER_LARGE
        txtXMLSource.Width = tabXML.Width - 2 * WIN_BORDER
        txtXMLReceive.Width = tabXML.Width - 2 * WIN_BORDER
        lvwBreakpoints.Width = tabXML.Width - 2 * WIN_BORDER
        lvwEvents.Width = tabXML.Width - 2 * WIN_BORDER
        lblInfo.Width = tabXML.Width - 2 * WIN_BORDER
        pgbPoll.Left = ScaleWidth - pgbPoll.Width - 20
    End If
    
    If (Me.Height > WIN_MIN_HEIGHT) Then
        ' we can resize according to height
        Line1.Y1 = ScaleHeight - 5 * WIN_BORDER_LARGE
        Line1.Y2 = ScaleHeight - 5 * WIN_BORDER_LARGE
        cmdSubmit.Top = ScaleHeight - 4 * WIN_BORDER_LARGE
        cmdRestoreDefaults.Top = ScaleHeight - 4 * WIN_BORDER_LARGE
        tabXML.Height = ScaleHeight - tabXML.Top - 6 * WIN_BORDER_LARGE
    
        txtXMLSource.Height = tabXML.Height - tabXML.TabHeight - 3 * WIN_BORDER
        txtXMLReceive.Height = tabXML.Height - tabXML.TabHeight - 3 * WIN_BORDER
        lvwBreakpoints.Height = tabXML.Height - tabXML.TabHeight - 3 * WIN_BORDER
        lvwEvents.Height = tabXML.Height - tabXML.TabHeight - lblInfo.Height - 3 * WIN_BORDER
        lblInfo.Top = tabXML.Height - lblInfo.Height - WIN_BORDER
        pgbPoll.Top = ScaleHeight - pgbPoll.Height - 20
    End If
    
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Form_Terminate()
'//         Perform cleanup
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub Form_Terminate()
    Set mobjProcessor = Nothing
End Sub


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   ClearEventLog()
'//         Initialise controls on the form.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub Form_Load()
    
    On Error Resume Next
    
    '// Assign caption property
    Me.Caption = APPLICATION_NAME
    'App.ProductName & " " & App.Major & "." & App.Minor & "." & App.Revision
    
    tabXML.Tab = TAB_SOURCE
    
    '  add the list of breakpoints that we are allowed to set to the breakpoint listview control
    Dim obj As CBreakpoint
    For Each obj In mcolBreakpoints
        AddBreakPointToList obj
    Next obj

    'set up defaults
    SetDefaults
    
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   AddBreakPointToList()
'//         Add the specified breakpoint to the list of available breakpoints.
'//
'// Inputs: objBreakPoint
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub AddBreakPointToList(objBreakPoint As CBreakpoint)
    On Error GoTo Handler

    Dim item As ListItem
    
    ' Add the event message to the listview along with ID and time
    Set item = lvwBreakpoints.ListItems.Add(, objBreakPoint.Name, objBreakPoint.Name)
    item.SubItems(1) = objBreakPoint.Description
    
    Exit Sub
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Cleanup()
'//         Clean up from the last submission.  This means destroying the last submission and
'//         clearing out the event log control on the tab strip.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub Cleanup()

    On Error GoTo Handler
    
    Set mobjProcessor = New CSubmissionProcessor
    mlEventID = 0
    lvwEvents.ListItems.Clear
    txtXMLReceive.Text = ""
    lblInfo.Caption = ""
    
    Exit Sub
Handler:
    ReportError Err.Number, Err.Source, Err.Description

End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   chkAuthentication_Click()
'//         If a secure connection is required then enable the username ans password controls, so
'//         that the user may specify them.  If not, clear these controls and disable them.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub chkAuthentication_Click()

    '// In the event of an error call the error handler
    On Error GoTo ErrHandler

    Debug.Print "chkAuthentication_Click(): commented out lines that warn that authentication is required"
'    '// If no authentication is required clear the values of the username and password textbox
'    If chkAuthentication.Value = vbUnchecked Then
'
'        If (MsgBox("The Government Gateway Test Service requires authentication.  Are you sure you want to switch authentication off?", vbYesNo + vbQuestion, APPLICATION_NAME & " - Warning") = vbYes) Then
'            txtUsername.Text = ""
'            txtPassword.Text = ""
'        Else
'            ' return the checkbox to checked state
'            chkAuthentication.Value = vbChecked
'            Exit Sub
'        End If
'    End If

    '// Toggle the enabled values of the username and password textbox & labels
    If (chkAuthentication.Value = vbChecked) Then
        lblUsername.Enabled = True
        lblPassword.Enabled = True
        txtUsername.Enabled = True
        txtPassword.Enabled = True
        txtUsername.BackColor = vbWindowBackground
        txtPassword.BackColor = vbWindowBackground
    Else
        lblUsername.Enabled = False
        lblPassword.Enabled = False
        txtUsername.Enabled = False
        txtPassword.Enabled = False
        txtUsername.BackColor = vbButtonFace
        txtPassword.BackColor = vbButtonFace
    End If
    
    '// Set the focus to the username (this will error out if the username enabled value is false
    txtUsername.SetFocus
    
    Exit Sub

ErrHandler:
    Exit Sub

End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   cmdBrowse_Click()
'//         Open the standard Windows File Open dialog to browse for the source XML document.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub cmdBrowse_Click()

    '// In the event of an error call the error handler
    On Error GoTo ErrHandler

    '// Set Filename property to blank
    With dlgMain
        .FileName = ""
        
        .Flags = cdlOFNHideReadOnly
        '// Initiate the Open dialog box
        .InitDir = App.Path & "\Docs"
        .Filter = "XML Files|*.xml|All files|*.*"
    
    
        .Orientation = cdlLandscape
        .ShowOpen
     End With
    
    '// Assign filename property to document textbox value
    If (dlgMain.FileName <> "") Then
        txtDocumentPath = dlgMain.FileName
        
    ' show the selected XML source file in the tab strip
        ShowSourceXML
        mbolFilepathChanged = False
    End If
    


    Exit Sub

ErrHandler:
    Resume Next
    
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   LogEvent()
'//         Log an event in the EVents control on the tab strip
'// Input:  strEvent - The text of the event message to log
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub LogEvent(strEvent As String)
    On Error GoTo Handler

    Dim item As ListItem

    ' Add the event message to the listview along with ID and time
    Set item = lvwEvents.ListItems.Add(, , mlEventID)
    item.SubItems(COL_TIME) = Format$(Now(), "hh:mm:ss")
    item.SubItems(COL_INFO) = strEvent

    ' increment the event ID, ready for the next event
    mlEventID = mlEventID + 1

    Exit Sub
Handler:
    ReportError Err.Number, Err.Source, Err.Description

End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   LogLastMessage()
'//         Log the details of the last message sent and received to/from the Gateway
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub LogLastMessage()

    On Error GoTo Handler
    
    Dim item As ListItem
    
    ' Add the event message to the listview along with ID and time
    Set item = lvwEvents.ListItems.Add(, , mlEventID)
    item.SubItems(COL_TIME) = Format$(Now(), "hh:mm:ss")
    
    With mobjProcessor.LastRequest
    
        item.SubItems(COL_HTTPTEXT) = .Response.HTTPStatus & " " & .Response.HTTPStatusText
        item.SubItems(COL_REQUEST) = .Message.MsgFunction & "_" & .Message.MsgQualifier
        item.SubItems(COL_RESPONSE) = .Response.Message.MsgFunction & "_" & .Response.Message.MsgQualifier
        item.SubItems(COL_CORRELATIONID) = .Response.Message.CorrelationID
        item.SubItems(COL_INFO) = .Response.StateText
    End With
    
    ' increment the event ID, ready for the next event
    mlEventID = mlEventID + 1

    Exit Sub
Handler:
    ReportError Err.Number, Err.Source, Err.Description

End Sub


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   ShowSourceXML()
'//         Load the XML source file specified in the txtDocumentPath control, and display it on the
'//         tab strip.
'//         If the file cannot be opened an explanation is placed in the control instead.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub ShowSourceXML()
    On Error GoTo Handler
    
    Dim strTemp As String
    Dim lSize As Long
    Dim FileNum As Integer
        
    
    ' clear the source XML control
    txtXMLSource = ""
    lSize = 0
    mbXMLLoaded = False
    stbStatus.SimpleText = ""
    
    If (txtDocumentPath.Text <> "") Then
        ' Open the specified document for input
        FileNum = FreeFile
        Open txtDocumentPath.Text For Input As FileNum
            ' get the first line, checking for Unicode prefixes in the file
            ' The VB file handling functions do not handle Unicode automatically for us, so we will
            ' have to strip of any prefixes ourseleves.
            If Not EOF(1) Then
                Line Input #FileNum, strTemp
                If (Left$(strTemp, Len(PREFIX_UNICODE_BIG)) = PREFIX_UNICODE_BIG) Then
                    strTemp = Mid$(strTemp, Len(PREFIX_UNICODE_BIG) + 1)
                ElseIf (Left$(strTemp, Len(PREFIX_UNICODE_LITTLE)) = PREFIX_UNICODE_LITTLE) Then
                    strTemp = Mid$(strTemp, Len(PREFIX_UNICODE_LITTLE) + 1)
                ElseIf (Left$(strTemp, Len(PREFIX_UTF8)) = PREFIX_UTF8) Then
                    strTemp = Mid$(strTemp, Len(PREFIX_UTF8) + 1)
                End If
                lSize = lSize + Len(strTemp)
                txtXMLSource = txtXMLSource & strTemp & vbCrLf
            End If
        
            ' Now loop through the rest of the document adding an entry line by line into the XML textbox
            Do While (Not EOF(1) And lSize < MAX_FILESIZE)
                Line Input #FileNum, strTemp
                lSize = lSize + Len(strTemp)
                txtXMLSource = txtXMLSource & strTemp & vbCrLf
            Loop
        Close FileNum
    End If
    
    ' switch to the tab with the source XML control, and load the XML
    tabXML.Tab = TAB_SOURCE
        
    ' determine whether the file was too big
    If (lSize >= MAX_FILESIZE) Then
        txtXMLSource = "The source XML file is too big to be displayed.  You can still use " & _
                        "this sample application to send the specified message to the " & _
                        "Gateway, but you will not be able to view it."
        Exit Sub
    End If
    
    'check username and vendor name
    If InStr(txtXMLSource.Text, ">" & txtUsername.Text & "</VendorID>") = 0 And chkAuthentication.Value = vbChecked Then
        stbStatus.SimpleText = "The username does not match the XML source SenderID"
    Else
        stbStatus.SimpleText = ""
    End If
    
    ' set flag so we know XML loaded OK into text box
    mbXMLLoaded = True
        
        
    Exit Sub
Handler:
    ' explain why the file contents could not be displayed
    txtXMLSource.Text = "The source XML '" & txtDocumentPath.Text & "' could not be displayed: " & Err.Description
    stbStatus.SimpleText = ""
    
End Sub


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   cmdSubmit_Click()
'//         Send the XML document to the Gateway server.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub cmdSubmit_Click()

    '// In the event of an error call the error handler
    On Error GoTo Handler
    
    Screen.MousePointer = vbHourglass
    cmdSubmit.Enabled = False
    cmdRestoreDefaults.Enabled = False
    
    '// Temporary string to hold data from file specified
    Dim strTemp As String
    
    ' Clear up from any previus submissions
    Cleanup
    tabXML.Tab = TAB_EVENTS
    Me.Refresh  ' repaint the form


    ' Check to ensure a url has been entered
    If txtGatewayURL = "" Then
        MsgBox "Please enter a valid URL.  The URL must start with https:// or http://", vbExclamation, APPLICATION_NAME & " - Warning"
        txtGatewayURL.SetFocus
        Exit Sub
    End If
    
    ' Check to see if there is any XML to post
    If txtDocumentPath = "" And txtXMLSource = "" Then
        MsgBox "You must either select a document or type some XML before attempting to post to the URL.", _
            vbExclamation, APPLICATION_NAME & " - Warning"
        txtDocumentPath.SetFocus
        Exit Sub
    End If
    
    
    ' OK - all the checks are done, let's go post that document
    Dim objResponse As CResponse
    
    If optHTML.Value Then
        mobjProcessor.SubmissionFormat = FORMAT_HTML
    Else
        mobjProcessor.SubmissionFormat = FORMAT_XML
    End If
    Set objResponse = mobjProcessor.Begin(GetSourceXML, txtPassword.Text, txtUsername.Text, txtGatewayURL.Text)
    
    ProcessGatewayResponse objResponse
    
    
    Exit Sub

Handler:
    Screen.MousePointer = vbNormal
    Dim strErrorDesc As String
    strErrorDesc = Err.Description
    
    Select Case Err.Number
        Case ERR_SUBMISSIONABORT
            ' nothing to do here - the user has chosen to abort the submission during the debug process
            
        Case Else
            MsgBox Err.Number & vbCrLf & App.Title & mstrMODULENAME & _
                   Err.Source & vbCrLf & Err.Description, vbExclamation, APPLICATION_NAME & " - Error"
    End Select
    
    On Error Resume Next
    
    LogEvent strErrorDesc
    
    cmdSubmit.Enabled = True
    
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   GetSourceXML()
'//         Get the source XML document as a string. If the doc cannot be opened we return an
'//         empty string
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Function GetSourceXML() As String
    On Error GoTo Handler
    
    Dim FileNum As Integer
    Dim strXML As String
    Dim strTemp As String
    
    If mbXMLLoaded Then
        ' The XML source doc is loaded into the text box
        strXML = txtXMLSource.Text
    Else
        ' we must get the source doc from disk
        Dim doc As MSXML2.DOMDocument30
        
        Set doc = New DOMDocument30
        
        ' The document will be validated later in the Request object, so don't worry about doibg it here.
        doc.validateOnParse = False
        doc.preserveWhiteSpace = True
        
        doc.Load txtDocumentPath.Text
        strXML = doc.XML
    End If
    
    GetSourceXML = strXML
    
    Exit Function
    
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   ProcessGatewayResponse()
'//         Look at the response returned from the Government Gateway, and process accordingly.
'//         eg update UI, set/cancel polling timer
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub ProcessGatewayResponse(ByVal objResponse As CResponse)

    On Error GoTo Handler

    ' display the returned XML on the tab strip
    If (Not objResponse.Message Is Nothing) Then
        If (objResponse.Message.XML = "") Then
            txtXMLReceive.Text = objResponse.Message.MsgText
        Else
            txtXMLReceive.Text = objResponse.Message.XML
        End If
    End If
    ' record the protocol events on the event list
    LogLastMessage
    
    
    ' Check if the submission is finished or if an error occurred.  If either of these
    ' situations occur then no more processing is performed, otherwise we set up a timer
    ' to poll the server at regular intervals so that the submission may be completed.
    If (mobjProcessor.State <> SS_ERROR And mobjProcessor.State <> SS_FINISHED) Then
        ' start the timer to poll the Gateway
        mlPollInterval = objResponse.Message.PollInterval
        tmrPoll.Interval = TIMER_INTERVAL
        tmrPoll.Enabled = True
        ShowProgressBar True
        stbStatus.SimpleText = STATUS_WAITING
    Else
        ' we have finished our communications with the server
        ShowProgressBar False
        cmdSubmit.Enabled = True
        cmdRestoreDefaults.Enabled = True
        Screen.MousePointer = vbNormal
    End If
    
    Exit Sub
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub



'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   lvwBreakpoints_ItemCheck()
'//         An item in the Breakpoints listview has been checked/unchecked.  Update the
'//         appropriate breakpoint object with the changes.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub lvwBreakpoints_ItemCheck(ByVal item As MSComctlLib.ListItem)
    On Error GoTo Handler
    
    Dim obj As CBreakpoint
    Set obj = mcolBreakpoints(item.Key)
    
    obj.IsSet = item.Checked
    
    Exit Sub
Handler:
    ReportError Err.Number, Err.Source, Err.Description

End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   lvwEvents_Click()
'//         Put the info text in a label for easy viewing
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub lvwEvents_Click()
    On Error GoTo Handler

    ' get the selected item in the listview
    Dim item As ListItem
    Set item = lvwEvents.SelectedItem

    If Not item Is Nothing Then
        lblInfo.Caption = item.SubItems(COL_INFO)
    End If
    
    Exit Sub
Handler:
    ' do nothing
    Exit Sub
    
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   lvwEvents_DblClick()
'//         Open a dialog showing the requset and response XML messages that relate to the
'//         currently selected event in the events list.
'//
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub lvwEvents_DblClick()
    On Error GoTo Handler

    ' get the selected item in the listview
    Dim item As ListItem
    Set item = lvwEvents.SelectedItem

    If Not item Is Nothing Then
        Dim frm As frmReceived
        Set frm = New frmReceived
        
        'set the form up to show the appropriate XML docs
        If (mobjProcessor.Request(item.Index).Response.Message.XML = "") Then
            ' use MsgText property for the response text since the response may not be XML
            frm.mstrXMLResponse = mobjProcessor.Request(item.Index).Response.Message.MsgText
        Else
            frm.mstrXMLResponse = mobjProcessor.Request(item.Index).Response.Message.XML
        End If

        frm.mstrXMLSource = mobjProcessor.Request(item.Index).Message.XML            ' use XML property for request, since we know we sent valid XML, and the MsgText property returns raw text data before any changes were made to the XML
        frm.mstrErrors = mobjProcessor.Request(item.Index).Response.StateText
        frm.Show vbModal
        
    End If
    
    Exit Sub
Handler:
    ' do nothing
    Exit Sub
'    MsgBox Err.Number & vbCrLf & App.Title & mstrMODULENAME & _
'           Err.Source & vbCrLf & Err.Description
    
End Sub
' show about help box modally
Private Sub mnuAbout_Click()
    frmAbout.Show vbModal
End Sub

'end application
Private Sub mnuExit_Click()
    Unload Me
End Sub

'show help dialog modally
Private Sub mnuInstructions_Click()
    frmInstructions.Show vbModal
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   mnuReadMe_Click()
'//         Open the readme file.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub mnuReadMe_Click()
    On Error GoTo Handler
    Shell "notepad.exe " & App.Path & "\ReadMe.txt", vbNormalFocus
    
    Exit Sub
Handler:
    ReportError Err.Number, Err.Source, Err.Description
    
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   mobjProcessor_BeforeSend()
'//         The request message is about to be sent to the gateway server.  Put our debug hook
'//         here to allow the user to view and/or edit the message that the submission processor
'//         is about to send.
'//
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub mobjProcessor_BeforeSend(objRequest As CRequest, bAbort As Boolean)
    On Error GoTo Handler

    Dim frm As frmReceived
    Dim objBreakPoint As CBreakpoint
    
    If (mobjProcessor.LastRequest Is Nothing) Then
        ' No previous request, ==> no response - so we can't possibly break!
        Exit Sub
    End If
    
    
    ' determine whether we need to break here.
    ' we do this by examining the last response object, and checking if it matches any of the
    ' breakpoints the user set.
    
    For Each objBreakPoint In mcolBreakpoints
        If objBreakPoint.IsSet Then
            
            ' This breakpoint is set, see if it matches the last response
            If objBreakPoint.MsgFunction = "*" Or _
              (objBreakPoint.MsgFunction = mobjProcessor.LastRequest.Response.Message.MsgFunction And _
               objBreakPoint.MsgQualifier = mobjProcessor.LastRequest.Response.Message.MsgQualifier) Then
                
                ' There is a breakpoint that matches, so open the dialog to let the user view the next request
                Set frm = New frmReceived
                
                'initialise the dialog in debug mode
                frm.mbIsDebugging = True
                frm.mbAbort = False
                frm.mstrXMLSource = objRequest.XML
                
                frm.Show vbModal
                
                ' check what the user did in the dialog, and act accordingly
                If frm.mbAbort Then
                    ' the user wants to quit processing
                    bAbort = True
                Else
                    ' reset source XML to be whatever is in the dialog - the user may have changed it
                    objRequest.XML = frm.mstrXMLSource
                End If
            End If
        End If
    Next objBreakPoint
    
    Exit Sub
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   tmrPoll_Timer()
'//         When the timer fires, we need to check if it's time to poll the server again
'//
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub tmrPoll_Timer()

    On Error GoTo Handler
    
    Static lElapsed As Long
    
    ' The timer is fired serveral times for each polling period, so we can see that the app
    ' is still running by way of the progress bar
    lElapsed = lElapsed + TIMER_INTERVAL
    
    ' update the progress bar
    pgbPoll.Value = pgbPoll.Max * lElapsed / mlPollInterval
    
    If (lElapsed >= mlPollInterval) Then
        ' We are ready to poll the server
        ' 1st stop the timer
        tmrPoll.Enabled = False
        stbStatus.SimpleText = STATUS_SENDING
        Me.Refresh
        lElapsed = 0
        
        ' The the protocol processor to perform the next iteration for this submission
        Dim objResponse As CResponse
        Set objResponse = mobjProcessor.Process
        
        ProcessGatewayResponse objResponse
        
    End If
    
    Exit Sub
    
Handler:
    Screen.MousePointer = vbNormal
    Dim strErrorDesc As String
    strErrorDesc = Err.Description
    
    Select Case Err.Number
        Case ERR_SUBMISSIONABORT
            ' nothing to do here
            
        Case Else
            MsgBox Err.Number & vbCrLf & App.Title & mstrMODULENAME & _
                   Err.Source & vbCrLf & Err.Description, vbExclamation, APPLICATION_NAME & " - Error"
    End Select
    
    On Error Resume Next
    
    LogEvent strErrorDesc
    
    cmdSubmit.Enabled = True
    cmdRestoreDefaults.Enabled = True
    stbStatus.SimpleText = ""
    pgbPoll.Visible = False
End Sub

Private Sub txtDocumentPath_Change()
    mbolFilepathChanged = True
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   txtDocumentPath_LostFocus()
'//         When the source document path control loses focus, load the specified XML document
'//         into the XMl source control on the tab strip.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub txtDocumentPath_LostFocus()

    On Error GoTo Handler
    
    If txtXMLSource.Text = "" Or mbolFilepathChanged = True Then
        ShowSourceXML
    End If
    
    mbolFilepathChanged = False
    
    Exit Sub
Handler:
    ReportError Err.Number, Err.Source, Err.Description
    
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   ShowProgressBar()
'//         Show/Hide the progress / status indicators.
'// Input:  bShow
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub ShowProgressBar(ByVal bShow As Boolean)
    pgbPoll.Visible = bShow
    If Not bShow Then
        stbStatus.SimpleText = ""
    End If
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   ReportError()
'//         Report any errors raised to the UI to the user.
'// Input:  ErrNum - The error number
'//         ErrSrc - the source of the error
'//         ErrDesc - Description of the error
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub ReportError(ByVal ErrNum As Long, ByVal ErrSrc As String, ByVal ErrDesc As String)
    
    MsgBox ErrNum & vbCrLf & App.Title & mstrMODULENAME & _
           ErrSrc & vbCrLf & ErrDesc, vbExclamation, APPLICATION_NAME & " - Error"
        
End Sub


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   SetDefaults()
'//         Reset the UI controls to their default settings.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub SetDefaults()
    On Error GoTo Handler

    txtDocumentPath.Text = App.Path & "\Submission.xml"
    txtGatewayURL.Text = DEFAULT_URL
    chkAuthentication.Value = vbUnchecked
    lvwEvents.ListItems.Clear
    ClearBreakpoints
    txtXMLSource.Text = ""
    txtXMLReceive.Text = ""
    stbStatus.SimpleText = ""
    
    Exit Sub
Handler:
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Sub


'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   ClearBreakpoints()
'//         Clear the breakpoints in the breakpoint list.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub ClearBreakpoints()
    
    Dim item As ListItem
    
    For Each item In lvwBreakpoints.ListItems
        item.Checked = False
    Next item
    
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   cmdBrowse_LostFocus()
'//         Load the source XML into the control.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub cmdBrowse_LostFocus()
    On Error GoTo Handler
    
    If txtXMLSource.Text = "" Or mbolFilepathChanged Then
        ShowSourceXML
    End If
    
    mbolFilepathChanged = False
    
    Exit Sub
Handler:
    ReportError Err.Number, Err.Source, Err.Description
    
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   cmdRestoreDefaults_Click()
'//         Reset to contents of the UI controls to the start-up defaults.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub cmdRestoreDefaults_Click()
    On Error GoTo Handler
    
    SetDefaults
    
    Exit Sub
Handler:
    ReportError Err.Number, Err.Source, Err.Description
    
End Sub





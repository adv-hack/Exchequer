VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "tabctl32.ocx"
Begin VB.Form frmReceived 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "GovTalk Messages"
   ClientHeight    =   8190
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   9015
   ControlBox      =   0   'False
   Icon            =   "frmReceived.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8190
   ScaleWidth      =   9015
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox txtErrors 
      Appearance      =   0  'Flat
      BackColor       =   &H8000000F&
      BorderStyle     =   0  'None
      Height          =   495
      Left            =   240
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   5
      Text            =   "frmReceived.frx":000C
      Top             =   7440
      Width           =   5775
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Abort"
      Height          =   375
      Left            =   6240
      TabIndex        =   4
      ToolTipText     =   "Abort the submission process"
      Top             =   7440
      Visible         =   0   'False
      Width           =   1215
   End
   Begin TabDlg.SSTab tabXML 
      Height          =   6975
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   8775
      _ExtentX        =   15478
      _ExtentY        =   12303
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "Re&quest"
      TabPicture(0)   =   "frmReceived.frx":0019
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "txtSentContent"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "Res&ponse"
      TabPicture(1)   =   "frmReceived.frx":0035
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "txtReceivedContent"
      Tab(1).ControlCount=   1
      Begin VB.TextBox txtSentContent 
         Height          =   6375
         Left            =   120
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   3
         Top             =   480
         Width           =   8535
      End
      Begin VB.TextBox txtReceivedContent 
         Height          =   6375
         Left            =   -74880
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         ScrollBars      =   3  'Both
         TabIndex        =   2
         Top             =   480
         Width           =   8535
      End
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&Close"
      Default         =   -1  'True
      Height          =   375
      Left            =   7680
      TabIndex        =   0
      Top             =   7440
      Width           =   1215
   End
   Begin VB.Label lblStatus 
      Caption         =   "Status:"
      Height          =   255
      Left            =   240
      TabIndex        =   6
      Top             =   7200
      Width           =   1095
   End
End
Attribute VB_Name = "frmReceived"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'/////////////////////////////////////////////////////////////////////////////////////////////////
'//
'// Form        :   frmReceived
'// Description :   Form used to display the XML returned from the Gateway server and during the
'//                 debugging process to show the XML abount to be sent to the gateway.
'//
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
'//
'//

Option Explicit

' These are the IDs of the tabs on the tabstrip
Private Const TAB_SOURCE As Long = 0    ' source XML tab index
Private Const TAB_RECEIVED As Long = 1  ' received XML tab index


Public mstrXMLResponse As String
Public mstrXMLSource As String
Public mstrErrors As String
Public mbIsDebugging As Boolean
Public mbAbort As Boolean

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   cmdCancel_Click()
'//         User has chosen to abort the current submission process.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub cmdCancel_Click()
    mbAbort = True
    
    Unload Me
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   cmdOK_Click()
'//         Close the dialog and continue
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub cmdOK_Click()
    On Error GoTo Handler

    ' if we are debugging the user could have changed the XML
    If (mbIsDebugging) Then
        ' must check that the XML is still valid
        Dim objMessage As CMessage
        Set objMessage = New CMessage
        
        objMessage.XML = txtSentContent.Text    ' if this does not throw an error, then we have valid XML
        
        ' update the variable in case the user has edited the source text in the dialog
        mstrXMLSource = txtSentContent.Text
    End If
    
    Unload Me
    Exit Sub
Handler:
    ' Don't close the dialog...give the user the opportunity to fix the error
    MsgBox "The source XML is no longer syntactically correct. " & Err.Description, vbInformation, APPLICATION_NAME & " - Error"
    
End Sub

'/////////////////////////////////////////////////////////////////////////////////////////////////
'// Name:   Form_Load()
'//         Initialise controls on the form.
'//
'/////////////////////////////////////////////////////////////////////////////////////////////////
Private Sub Form_Load()

    Me.Caption = APPLICATION_NAME & " - " & Me.Caption
    txtReceivedContent.Text = mstrXMLResponse
    txtSentContent.Text = mstrXMLSource
    txtErrors.Text = mstrErrors
    
    Screen.MousePointer = vbDefault
    
    If mbIsDebugging Then
        ' must setup the dialog in debugging mode
        txtSentContent.Locked = False   ' we allow the user to edit the data about to be sent
        tabXML.TabEnabled(TAB_RECEIVED) = False ' There is no receieved text to display
        cmdCancel.Visible = True
        cmdOK.Caption = "&Continue"
        
    End If
    
    ' finally, just to make the form look tidier
    If (txtErrors.Text = "") Then
        txtErrors = "Message OK."
    End If
    

End Sub

Private Sub Form_Unload(Cancel As Integer)
    If mbIsDebugging Then
        Screen.MousePointer = vbHourglass
    End If
End Sub

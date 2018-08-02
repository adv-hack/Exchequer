VERSION 5.00
Begin VB.Form frmInstructions 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Instructions"
   ClientHeight    =   6090
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7140
   Icon            =   "frmInstructions.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6090
   ScaleWidth      =   7140
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame frmTextFrame 
      Height          =   5175
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   6855
      Begin VB.TextBox txtUsage 
         BackColor       =   &H8000000F&
         Height          =   4695
         Left            =   120
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         TabIndex        =   2
         Top             =   240
         Width           =   6495
      End
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Close"
      Default         =   -1  'True
      Height          =   375
      Left            =   5880
      TabIndex        =   0
      Top             =   5520
      Width           =   1095
   End
End
Attribute VB_Name = "frmInstructions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'/////////////////////////////////////////////////////////////////////////////////
'//
'// Form        :   frmHelp
'// Description :   This form displays some brief help text.
'//
'//
'//
'/////////////////////////////////////////////////////////////////////////////////
'//
'//

Option Explicit
    
Private Sub cmdClose_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    Me.Caption = APPLICATION_NAME & " - " & Me.Caption
    txtUsage.Text = GetHelpText
End Sub

Private Function GetHelpText() As String
GetHelpText = "1. Select a GovTalk XML document to send to the Government Gateway.  Your selected document " & _
    "will be displayed on the Source XML tab.  If you want, you can edit this document here before " & _
    "you send it. It will not be saved to disk." & vbCrLf & vbCrLf & _
    "2. Specify the URL of the Government Gateway server you wish to test with.  If the Gateway " & _
    "requires username/password authentication then enter these too." & vbCrLf & vbCrLf & _
    "3. Click the Submit button.  This starts the GovTalk submission process by sending the XML " & _
    "source document to the gateway.  For each request sent to the Gateway an entry is placed in " & _
    "the list on the Protocol Events tab showing the result of the request.  Double click an item " & _
    "in the list to see the request/response pair of XML documents for that event.  The Response " & _
    "XML tab shows the most recently received message from the Gateway server." & vbCrLf & vbCrLf & _
    "The breakpoint facility allows you to view a GovTalk message, and make changes to it before " & _
    "it is sent.  Set a breakpoint by checking the boxes on the Breakpoint tab.  When a response " & _
    "is received that matches the breakpoint the application will pause just before the next " & _
    "message is sent to the server.  At this point you can review and/or edit the message that " & _
    "is about to be sent, or abort the submission process altogether." & vbCrLf & vbCrLf & _
    "Further information please see readme file " & App.Path & "readme.txt" & vbCrLf & vbCrLf & _
    "For latest information see http://www.gateway.gov.uk."

End Function

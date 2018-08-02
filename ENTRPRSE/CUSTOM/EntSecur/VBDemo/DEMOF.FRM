VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3795
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7410
   LinkTopic       =   "Form1"
   ScaleHeight     =   3795
   ScaleWidth      =   7410
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtMessage 
      Height          =   315
      Left            =   1290
      MaxLength       =   100
      TabIndex        =   24
      Top             =   1830
      Width           =   4665
   End
   Begin VB.CommandButton cmdReadSec 
      Caption         =   "Read Security"
      Height          =   315
      Left            =   6090
      TabIndex        =   21
      Top             =   2340
      Width           =   1200
   End
   Begin VB.CommandButton cmdAddUser 
      Caption         =   "Add User"
      Height          =   315
      Left            =   6090
      TabIndex        =   20
      Top             =   2700
      Width           =   1200
   End
   Begin VB.CommandButton cmdRemoveUser 
      Caption         =   "Remove User"
      Height          =   315
      Left            =   6090
      TabIndex        =   19
      Top             =   3060
      Width           =   1200
   End
   Begin VB.CommandButton cmdResetUCount 
      Caption         =   "Reset UCount"
      Height          =   315
      Left            =   6090
      TabIndex        =   18
      Top             =   3420
      Width           =   1200
   End
   Begin VB.CommandButton cmdPlugIn4 
      Caption         =   "Plug-In 4"
      Height          =   315
      Left            =   6090
      TabIndex        =   17
      Top             =   1530
      Width           =   1200
   End
   Begin VB.CommandButton cmdPlugIn3 
      Caption         =   "Plug-In 3"
      Height          =   315
      Left            =   6090
      TabIndex        =   16
      Top             =   1170
      Width           =   1200
   End
   Begin VB.CommandButton cmdPlugIn2 
      Caption         =   "Plug-In 2"
      Height          =   315
      Left            =   6090
      TabIndex        =   15
      Top             =   810
      Width           =   1200
   End
   Begin VB.CommandButton cmdPlugIn1 
      Caption         =   "Plug-In 1"
      Height          =   315
      Left            =   6090
      TabIndex        =   8
      Top             =   450
      Width           =   1200
   End
   Begin VB.ComboBox lstSecType 
      Height          =   315
      ItemData        =   "DemoF.frx":0000
      Left            =   1290
      List            =   "DemoF.frx":000D
      Style           =   2  'Dropdown List
      TabIndex        =   6
      Top             =   1470
      Width           =   2535
   End
   Begin VB.TextBox txtDesc 
      Height          =   315
      Left            =   1290
      MaxLength       =   100
      TabIndex        =   5
      Top             =   1110
      Width           =   4665
   End
   Begin VB.TextBox txtSecurityId 
      Height          =   315
      Left            =   1290
      MaxLength       =   16
      TabIndex        =   3
      Top             =   750
      Width           =   1935
   End
   Begin VB.TextBox txtSystemId 
      Height          =   315
      Left            =   1290
      MaxLength       =   16
      TabIndex        =   1
      Top             =   390
      Width           =   1935
   End
   Begin VB.Label lblVer 
      Alignment       =   1  'Right Justify
      Height          =   345
      Left            =   5310
      TabIndex        =   26
      Top             =   60
      Width           =   1995
   End
   Begin VB.Label lblSystemId 
      Alignment       =   1  'Right Justify
      Caption         =   "Message"
      Height          =   255
      Index           =   8
      Left            =   30
      TabIndex        =   25
      Top             =   1890
      Width           =   1155
   End
   Begin VB.Label lblESN 
      Caption         =   "System Id"
      Height          =   255
      Left            =   1290
      TabIndex        =   23
      Top             =   90
      Width           =   2955
   End
   Begin VB.Label lblSystemId 
      Alignment       =   1  'Right Justify
      Caption         =   "Exch Site No"
      Height          =   255
      Index           =   7
      Left            =   30
      TabIndex        =   22
      Top             =   90
      Width           =   1155
   End
   Begin VB.Label lblSystemStatus 
      Height          =   255
      Left            =   1290
      TabIndex        =   14
      Top             =   2370
      Width           =   4125
   End
   Begin VB.Label lblLicUCount 
      Height          =   255
      Left            =   1290
      TabIndex        =   13
      Top             =   2730
      Width           =   4125
   End
   Begin VB.Label lblCurrUserCount 
      Height          =   255
      Left            =   1290
      TabIndex        =   12
      Top             =   3090
      Width           =   4125
   End
   Begin VB.Label lblSystemId 
      Alignment       =   1  'Right Justify
      Caption         =   "System Status"
      Height          =   255
      Index           =   6
      Left            =   30
      TabIndex        =   11
      Top             =   2370
      Width           =   1155
   End
   Begin VB.Label lblSystemId 
      Alignment       =   1  'Right Justify
      Caption         =   "Lic User Count"
      Height          =   255
      Index           =   5
      Left            =   30
      TabIndex        =   10
      Top             =   2730
      Width           =   1155
   End
   Begin VB.Label lblSystemId 
      Alignment       =   1  'Right Justify
      Caption         =   "Curr User Count"
      Height          =   255
      Index           =   4
      Left            =   30
      TabIndex        =   9
      Top             =   3090
      Width           =   1155
   End
   Begin VB.Line Line1 
      X1              =   30
      X2              =   7335
      Y1              =   2250
      Y2              =   2250
   End
   Begin VB.Label lblSystemId 
      Alignment       =   1  'Right Justify
      Caption         =   "Sec Type"
      Height          =   255
      Index           =   3
      Left            =   30
      TabIndex        =   7
      Top             =   1500
      Width           =   1155
   End
   Begin VB.Label lblSystemId 
      Alignment       =   1  'Right Justify
      Caption         =   "Description"
      Height          =   255
      Index           =   2
      Left            =   30
      TabIndex        =   4
      Top             =   1170
      Width           =   1155
   End
   Begin VB.Label lblSystemId 
      Alignment       =   1  'Right Justify
      Caption         =   "Security Id"
      Height          =   255
      Index           =   1
      Left            =   30
      TabIndex        =   2
      Top             =   810
      Width           =   1155
   End
   Begin VB.Label lblSystemId 
      Alignment       =   1  'Right Justify
      Caption         =   "System Id"
      Height          =   255
      Index           =   0
      Left            =   30
      TabIndex        =   0
      Top             =   450
      Width           =   1155
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim oEntSecurity As EnterpriseSecurity.ThirdParty

Private Sub cmdAddUser_Click()
    Dim Res&
  
    Res& = oEntSecurity.AddUserCount
    MsgBox "AddUserCount: " + Str(Res&)
    
    Call cmdReadSec_Click
End Sub

Private Sub cmdPlugIn1_Click()
    txtSystemId.Text = "EXWAFFLEMA001056"
    txtSecurityId.Text = "@AFn48D9!Dla$9aA"
    txtDesc.Text = "Exchequer Waffle Maker v1.00 for Enterprise"
    lstSecType.ListIndex = 2    ' System + User Count
    txtMessage.Text = ""
End Sub

Private Sub cmdPlugIn2_Click()
    txtSystemId.Text = "EXCHBACSBC001057"
    txtSecurityId.Text = "WibbleWibbleWibb"
    txtDesc.Text = "Exchequer Barclays BACS Plug-In v1.32"
    lstSecType.ListIndex = 0    ' System Only
    txtMessage.Text = "For Sales or Technical help contact your Exchequer Reseller"
End Sub

Private Sub cmdPlugIn3_Click()
    txtSystemId.Text = "EXCHUPLIFT002156"
    txtSecurityId.Text = "tfilpU_reuqehcxE"
    txtDesc.Text = "Exchequer Uplift Plug-In v3.00"
    lstSecType.ListIndex = 1    ' User Count Only
    txtMessage.Text = "Contact Sales on +44 (0) 1202 298008"
End Sub

Private Sub cmdPlugIn4_Click()
    txtSystemId.Text = "EXCHQRLIVE999000"
    txtSecurityId.Text = "hsTniPeviLrqhcxE"
    txtDesc.Text = "IRIS Exchequer Expenses and Timesheets v1.00"
    lstSecType.ListIndex = 2    ' System + User Count
    txtMessage.Text = ""
End Sub

Private Sub cmdRemoveUser_Click()
    Dim Res&
  
    Res& = oEntSecurity.RemoveUserCount
    MsgBox "RemoveUserCount: " + Str(Res&)
    
    Call cmdReadSec_Click
End Sub

Private Sub cmdResetUCount_Click()
    Dim Res&
  
    Res& = oEntSecurity.ResetUserCount
    MsgBox "ResetUserCount: " + Str(Res&)
    
    Call cmdReadSec_Click
End Sub

Private Sub Form_Load()
    ' Create an Enterprise Security object
    Set oEntSecurity = CreateObject("EnterpriseSecurity.ThirdParty")
    
    ' Set ESN
    lblVer.Caption = oEntSecurity.Version
    lblESN.Caption = oEntSecurity.ExchequerSiteNumber
        
    ' Default to first set of default plug-in details
    Call cmdPlugIn4_Click
End Sub

Private Sub Form_Unload(Cancel As Integer)
    ' Free the Enterprise Security Object
    Set oEntSecurity = Nothing
End Sub

Private Sub cmdReadSec_Click()
    Dim Res&
    
    With oEntSecurity
        ' Identifying ID Code of the Third-Party Application or Plug-In -
        ' 10 Alphanumeric + 6 Numeric - can also be used as a stock code for
        ' tracking and reporting sales
        .tpSystemIdCode = txtSystemId.Text
        
        ' Security Code to prevent unauthorised access to the security details
        ' for the Third-Party Application or Plug-In, without this code it isn't
        ' possible to increment / decrement /reset the user counts from an app
        .tpSecurityCode = txtSecurityId.Text
        
        ' Textual Description of the Third-Party Application or Plug-In for
        ' on-screen display
        .tpDescription = txtDesc.Text
        
        ' Type of security being used by the Third-Party Application or Plug-In
        .tpSecurityType = lstSecType.ListIndex
               
        ' Contact / Sales message
        .tpMessage = txtMessage.Text
                       
        ' Read the Security Information from the Security Database
        Res& = .ReadSecurity
        If (Res = 0) Then
            ' System Status
            Select Case .tpSystemStatus
                Case 0
                    lblSystemStatus.Caption = "0 - Disabled"
                Case 1
                    lblSystemStatus.Caption = "1 - 30-Day"
                Case 2
                    lblSystemStatus.Caption = "2 - Fully Released"
                Case Else
                    lblSystemStatus.Caption = Str(.tpSystemStatus) + " - Unknown"
            End Select
            
            ' Licenced User Count
            lblLicUCount.Caption = Str(.tpUserCount)
            
            ' Current User Count
            lblCurrUserCount.Caption = Str(.tpCurrentUsers)
        Else
            MsgBox "The following error occurred reading the Licence Information:- " + _
                   String$(2, 13) + .LastErrorString + String$(2, 13) + _
                   "Please contact your Technical Support"
        End If
    End With ' oEntSecurity
End Sub

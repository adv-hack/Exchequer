VERSION 5.00
Begin VB.Form Form_Customer 
   Appearance      =   0  'Flat
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Exchequer Enterprise Toolkit DLL - Customer Account Demo"
   ClientHeight    =   5595
   ClientLeft      =   1065
   ClientTop       =   1590
   ClientWidth     =   7605
   FillColor       =   &H00FF0000&
   BeginProperty Font 
      Name            =   "MS Sans Serif"
      Size            =   8.25
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H80000008&
   Icon            =   "CUSTOMER.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   5595
   ScaleWidth      =   7605
   Begin VB.TextBox Text_Email 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   975
      TabIndex        =   32
      Top             =   3825
      Width           =   3720
   End
   Begin VB.Frame Frame1 
      Appearance      =   0  'Flat
      Caption         =   " Customer/Supplier Account Functions"
      ForeColor       =   &H80000008&
      Height          =   735
      Index           =   1
      Left            =   105
      TabIndex        =   30
      Top             =   15
      Width           =   7410
      Begin VB.Label Label2 
         Appearance      =   0  'Flat
         Caption         =   "These functions allow you to access and maintain the Customers or Suppliers within an Exchequer or Exchequer Enterprise System."
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000008&
         Height          =   450
         Index           =   0
         Left            =   135
         TabIndex        =   31
         Top             =   240
         Width           =   7095
      End
   End
   Begin VB.Frame Frame1 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   30
      Index           =   0
      Left            =   75
      TabIndex        =   27
      Top             =   5025
      Width           =   7455
   End
   Begin VB.Frame Frame2 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   2115
      Left            =   6210
      TabIndex        =   18
      Top             =   900
      Width           =   1305
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "First"
         Height          =   375
         Index           =   0
         Left            =   60
         TabIndex        =   11
         Top             =   150
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Previous"
         Height          =   375
         Index           =   1
         Left            =   60
         TabIndex        =   12
         Top             =   525
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Find"
         Height          =   375
         Index           =   2
         Left            =   60
         TabIndex        =   13
         Top             =   900
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Next"
         Height          =   375
         Index           =   3
         Left            =   60
         TabIndex        =   14
         Top             =   1275
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Last"
         Height          =   375
         Index           =   4
         Left            =   60
         TabIndex        =   15
         Top             =   1650
         Width           =   1170
      End
   End
   Begin VB.Frame Frame3 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   855
      Left            =   6225
      TabIndex        =   26
      Top             =   3780
      Width           =   1305
      Begin VB.CommandButton Command2 
         Appearance      =   0  'Flat
         Caption         =   "Add"
         Height          =   315
         Index           =   0
         Left            =   60
         TabIndex        =   16
         Top             =   150
         Width           =   1170
      End
      Begin VB.CommandButton Command2 
         Appearance      =   0  'Flat
         Caption         =   "Edit"
         Height          =   315
         Index           =   1
         Left            =   60
         TabIndex        =   17
         Top             =   465
         Width           =   1170
      End
   End
   Begin VB.TextBox Text_Code 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   975
      MaxLength       =   6
      TabIndex        =   0
      Top             =   900
      Width           =   1230
   End
   Begin VB.TextBox Text_Name 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   2265
      TabIndex        =   1
      Top             =   900
      Width           =   3690
   End
   Begin VB.TextBox Text_Contact 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   975
      TabIndex        =   7
      Top             =   2850
      Width           =   3720
   End
   Begin VB.TextBox Text_Addr 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Index           =   0
      Left            =   975
      TabIndex        =   2
      Top             =   1275
      Width           =   3720
   End
   Begin VB.TextBox Text_Addr 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Index           =   1
      Left            =   975
      TabIndex        =   3
      Top             =   1575
      Width           =   3720
   End
   Begin VB.TextBox Text_Addr 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Index           =   2
      Left            =   975
      TabIndex        =   4
      Top             =   1875
      Width           =   3720
   End
   Begin VB.TextBox Text_Addr 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Index           =   3
      Left            =   975
      TabIndex        =   5
      Top             =   2175
      Width           =   3720
   End
   Begin VB.TextBox Text_Addr 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Index           =   4
      Left            =   975
      TabIndex        =   6
      Top             =   2475
      Width           =   3720
   End
   Begin VB.TextBox Text_Phone 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   975
      TabIndex        =   8
      Top             =   3225
      Width           =   3720
   End
   Begin VB.TextBox Text_Fax 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   975
      TabIndex        =   9
      Top             =   3525
      Width           =   3720
   End
   Begin VB.TextBox Text_Balance 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   975
      TabIndex        =   10
      Top             =   4365
      Width           =   1860
   End
   Begin VB.Label Label7 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Email"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   240
      Index           =   1
      Left            =   75
      TabIndex        =   33
      Top             =   3855
      Width           =   855
   End
   Begin VB.Label lblNoAccs 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   240
      Left            =   5760
      TabIndex        =   29
      Top             =   5130
      Width           =   1755
   End
   Begin VB.Label lblOutStTran 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   2940
      TabIndex        =   28
      Top             =   4395
      Width           =   3150
   End
   Begin VB.Label lblResult 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   240
      Left            =   105
      TabIndex        =   19
      Top             =   5130
      Width           =   5565
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Code"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   270
      Left            =   75
      TabIndex        =   25
      Top             =   930
      Width           =   855
   End
   Begin VB.Label Label4 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Contact"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   240
      Left            =   90
      TabIndex        =   24
      Top             =   2880
      Width           =   855
   End
   Begin VB.Label Label5 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      Caption         =   "Address"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   195
      Left            =   360
      TabIndex        =   23
      Top             =   1305
      Width           =   570
   End
   Begin VB.Label Label6 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Phone"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   240
      Left            =   75
      TabIndex        =   22
      Top             =   3255
      Width           =   855
   End
   Begin VB.Label Label7 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Fax"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   240
      Index           =   0
      Left            =   75
      TabIndex        =   21
      Top             =   3555
      Width           =   855
   End
   Begin VB.Label Label8 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Balance"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   225
      Left            =   60
      TabIndex        =   20
      Top             =   4395
      Width           =   855
   End
End
Attribute VB_Name = "Form_Customer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const Capt_Add = "Add"
Const Capt_Save = "Save"
Const Capt_Edit = "Edit"
Const Capt_Cancel = "Cancel"

Dim OrigCode$, Editing As Integer
Dim DLLLoaded%

Private Sub Command1_Click(Index As Integer)
    Dim AccRec As TBatchCURec
    Dim BalRec As THistoryBalRec
    Dim PChar As String * 255
    Dim RecLen As Long, BtrMode%
    Dim ActStr$, Result%
    
    PChar = Text_Code.Text + String$(255, 0)
    
    Select Case Index%
        Case 0 ' First
            BtrMode% = B_GetFirst%
            ActStr$ = "First"
        Case 1 ' Previous
            BtrMode% = B_GetPrev%
            ActStr$ = "Previous"
        Case 2 ' Find
            BtrMode% = B_GetGEq%
            ActStr$ = "First"
        Case 3 ' Next
            BtrMode% = B_GetNext%
            ActStr$ = "Next"
        Case 4 ' Last
            BtrMode% = B_GetLast%
            ActStr$ = "Last"
    End Select

    RecLen = Len(AccRec)
    Result% = EX_GETACCOUNT%(AccRec, RecLen, PChar$, 0, BtrMode%, AcType_Cust%, DllFalse%)
    
    lblResult.Caption = ""

    If Result% = 0 Then
        Text_Code.Text = Trim(AccRec.CustCode)
        Text_Name.Text = Trim(AccRec.Company)

        Text_Contact.Text = Trim(AccRec.Contact)
        
        Text_Addr(0).Text = Trim(AccRec.Addr(0).Address)
        Text_Addr(1).Text = Trim(AccRec.Addr(1).Address)
        Text_Addr(2).Text = Trim(AccRec.Addr(2).Address)
        Text_Addr(3).Text = Trim(AccRec.Addr(3).Address)
        Text_Addr(4).Text = Trim(AccRec.Addr(4).Address)

        Text_Phone.Text = Trim(AccRec.Phone)
        Text_Fax.Text = Trim(AccRec.Fax)
        Text_Email.Text = Trim(AccRec.EmailAddr)

        ' Get Account Balance
        BalRec.PeriodLen = Chr(3)
        BalRec.Period = "YTD"
        BalRec.YearLen = Chr(0)
        BalRec.Year = ""
        BalRec.Currency = 0
        PChar = AccRec.CustCode + String$(255, 0)
        RecLen = Len(BalRec)
        Result% = EX_GETACCOUNTBALANCE%(BalRec, RecLen, PChar$, 0)
        Text_Balance.Text = Format(BalRec.value#, "0.00")

        ' Outstanding Transactions
        PChar = AccRec.CustCode + String$(255, 0)
        If EX_HASOUTSTANDING(PChar) = DllTrue Then
            lblOutStTran.Caption = "(Transactions Outstanding)"
        Else
            lblOutStTran.Caption = "(No Transactions Outstanding)"
        End If
        
    Else
        Select Case Result%
            Case 9 ' End Of File
                lblResult.Caption = "The End Of file has been reached"
            Case Else
                If (Index = 2) Then
                    lblResult.Caption = "An error " + Str(Result%) + " occurred trying to find '" + Text_Code.Text + "'"
                Else
                    lblResult.Caption = "An error " + Str(Result%) + " occurred reading the " + ActStr$ + " record"
                End If
        End Select
    End If
End Sub

Private Sub Command2_Click(Index As Integer)
    Dim AccRec As TBatchCURec
    Dim RecLen%, Result%

    lblResult.Caption = ""
    
    Select Case Index%
        Case 0  ' Add/Save
            If (Command2(0).Caption = Capt_Add) Then
                ' Add
                Editing = False
                Command2(0).Caption = Capt_Save
                Command2(1).Caption = Capt_Cancel

                OrigCode$ = Text_Code.Text
                Text_Code.Text = ""
                Text_Name.Text = ""
                Text_Contact.Text = ""
                Text_Addr(0).Text = ""
                Text_Addr(1).Text = ""
                Text_Addr(2).Text = ""
                Text_Addr(3).Text = ""
                Text_Addr(4).Text = ""
                Text_Phone.Text = ""
                Text_Fax.Text = ""
                Text_Email.Text = ""
                Text_Code.SetFocus

                lblOutStTran.Caption = ""
            Else
                ' save
                Command2(0).Caption = Capt_Add
                Command2(1).Caption = Capt_Edit

                ' read fields into record
                AccRec.CustCode = Text_Code.Text
                AccRec.CustCodeLen = Chr(Len(AccRec.CustCode))
                AccRec.CustSupp = "C"
                AccRec.Company = Text_Name.Text
                AccRec.CompanyLen = Chr(Len(AccRec.Company))
                AccRec.Contact = Text_Contact.Text
                AccRec.ContactLen = Chr(Len(AccRec.Contact))
                
                AccRec.Addr(0).Address = Trim(Text_Addr(0).Text)
                AccRec.Addr(0).AddrLen = Chr(Len(AccRec.Addr(0).Address))
                AccRec.Addr(1).Address = Trim(Text_Addr(1).Text)
                AccRec.Addr(1).AddrLen = Chr(Len(AccRec.Addr(1).Address))
                AccRec.Addr(2).Address = Trim(Text_Addr(2).Text)
                AccRec.Addr(2).AddrLen = Chr(Len(AccRec.Addr(2).Address))
                AccRec.Addr(3).Address = Trim(Text_Addr(3).Text)
                AccRec.Addr(3).AddrLen = Chr(Len(AccRec.Addr(3).Address))
                AccRec.Addr(4).Address = Trim(Text_Addr(4).Text)
                AccRec.Addr(4).AddrLen = Chr(Len(AccRec.Addr(4).Address))
                AccRec.Phone = Text_Phone.Text
                AccRec.PhoneLen = Chr(Len(AccRec.Phone))
                AccRec.Fax = Text_Fax.Text
                AccRec.FaxLen = Chr(Len(AccRec.Fax))
                AccRec.EmailAddr = Trim(Text_Email.Text)
                AccRec.EmailAddrLen = Chr(Len(AccRec.EmailAddr))
                AccRec.PayType = "C"
                AccRec.VATCode = "S"
                AccRec.Currency = 1

                ' update db
                RecLen% = Len(AccRec)
                If Editing Then
                    Result% = EX_STOREACCOUNT(AccRec, RecLen%, 0, B_Update%)
                Else
                    Result% = EX_STOREACCOUNT(AccRec, RecLen%, 0, B_Insert%)
                End If

                Call GetNoAccs

                If Result% <> 0 Then
                    lblResult.Caption = "An error " + Str(Result%) + " occurred when the customer was saved"
                End If
            End If

        Case 1  ' Edit/Cancel
            If (Command2(1).Caption = Capt_Edit) Then
                ' edit
                Editing = True
                Command2(0).Caption = Capt_Save
                Command2(1).Caption = Capt_Cancel

                Text_Code.SetFocus
            Else
                ' cancel
                Command2(0).Caption = Capt_Add
                Command2(1).Caption = Capt_Edit

                Text_Code.Text = OrigCode$
                Call Command1_Click(2)
            End If

    End Select

    Command1(0).Enabled = (Command2(0).Caption = Capt_Add)
    Command1(1).Enabled = Command1(0).Enabled
    Command1(2).Enabled = Command1(0).Enabled
    Command1(3).Enabled = Command1(0).Enabled
    Command1(4).Enabled = Command1(0).Enabled
End Sub

Private Sub Form_Activate()
    Command1_Click (0)
End Sub

Private Sub Form_Load()
    ' Position window centrally on the screen
    Left = (Screen.Width - Width) / 2
    Top = (Screen.Height - Height) / 2
    
    ' Initialise the Toolkit DLL
    DLLLoaded% = EX_INITDLL()
    
    If DLLLoaded% <> 0 Then
        ' failed to startup correctly
        MsgBox "An error " + Str(DLLLoaded%) + " occurred when calling EX_INITDLL.", 16
    Else
        ' loaded AOK
        Call GetNoAccs
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim Result%

    ' Check the DLL Loaded OK
    If DLLLoaded% = 0 Then
        ' De-Initialise the Toolkit DLL
        Result% = EX_CLOSEDLL()
        
        If Result% <> 0 Then
            ' An error has occurred
            MsgBox "An error " + Str(Result%) + " occurred when calling EX_CLOSEDLL.", 16
        End If
    End If
End Sub

Private Sub GetNoAccs()
    Dim NoAccs&

    NoAccs& = EX_ACCOUNTFILESIZE&()
    lblNoAccs.Caption = Str(NoAccs&) + " Accounts"
End Sub

Private Sub Text_Code_KeyPress(KeyAscii As Integer)
    If (KeyAscii >= Asc("a")) And (KeyAscii <= Asc("z")) Then
        KeyAscii = Asc("A") + (KeyAscii - Asc("a"))
    End If
End Sub


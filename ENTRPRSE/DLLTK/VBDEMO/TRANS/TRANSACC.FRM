VERSION 5.00
Begin VB.Form Form_TransAcc 
   Appearance      =   0  'Flat
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Transaction Account Details"
   ClientHeight    =   1890
   ClientLeft      =   2175
   ClientTop       =   4095
   ClientWidth     =   5355
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
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   1890
   ScaleWidth      =   5355
   Begin VB.TextBox Text_AcCode 
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
      Height          =   285
      Left            =   795
      MaxLength       =   6
      TabIndex        =   0
      Top             =   90
      Width           =   1200
   End
   Begin VB.Label lblAccAdd 
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
      ForeColor       =   &H80000008&
      Height          =   225
      Index           =   4
      Left            =   795
      TabIndex        =   8
      Top             =   1410
      Width           =   4350
   End
   Begin VB.Label lblAccAdd 
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
      ForeColor       =   &H80000008&
      Height          =   225
      Index           =   3
      Left            =   795
      TabIndex        =   7
      Top             =   1170
      Width           =   4350
   End
   Begin VB.Label lblAccAdd 
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
      ForeColor       =   &H80000008&
      Height          =   225
      Index           =   2
      Left            =   795
      TabIndex        =   6
      Top             =   930
      Width           =   4350
   End
   Begin VB.Label lblAccAdd 
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
      ForeColor       =   &H80000008&
      Height          =   225
      Index           =   1
      Left            =   795
      TabIndex        =   5
      Top             =   690
      Width           =   4350
   End
   Begin VB.Label lblAccAdd 
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
      ForeColor       =   &H80000008&
      Height          =   225
      Index           =   0
      Left            =   795
      TabIndex        =   4
      Top             =   465
      Width           =   4350
   End
   Begin VB.Label lblAccName 
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
      ForeColor       =   &H80000008&
      Height          =   225
      Left            =   2070
      TabIndex        =   3
      Top             =   120
      Width           =   3075
   End
   Begin VB.Label Label5 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
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
      Index           =   1
      Left            =   30
      TabIndex        =   2
      Top             =   465
      Width           =   675
   End
   Begin VB.Label Label5 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "A/C"
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
      Index           =   0
      Left            =   270
      TabIndex        =   1
      Top             =   120
      Width           =   450
   End
End
Attribute VB_Name = "Form_TransAcc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Dim AccRec As TBatchCURec
    Dim PChar As String * 255
    Dim RecLen As Long, Result%
    
    ' Position window centrally on the screen
    Left = (Screen.Width - Width) / 2
    Top = (Screen.Height - Height) / 2

    ' Get Customer Record
    PChar = HeaderRec.CustCode + String$(255, 0)
    RecLen = Len(AccRec)
    Result% = EX_GETACCOUNT%(AccRec, RecLen, PChar$, 0, B_GetGEq%, AccFlag%, DllFalse%)
    
    ' Set Details
    Text_AcCode.Text = AccRec.CustCode
    lblAccName.Caption = AccRec.Company
    lblAccAdd(0).Caption = AccRec.Addr(0).Address
    lblAccAdd(1).Caption = AccRec.Addr(1).Address
    lblAccAdd(2).Caption = AccRec.Addr(2).Address
    lblAccAdd(3).Caption = AccRec.Addr(3).Address
    lblAccAdd(4).Caption = AccRec.Addr(4).Address
End Sub


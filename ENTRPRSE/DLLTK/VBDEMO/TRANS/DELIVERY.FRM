VERSION 5.00
Begin VB.Form Form_Delivery 
   Appearance      =   0  'Flat
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Transaction Delivery Details"
   ClientHeight    =   1545
   ClientLeft      =   2370
   ClientTop       =   3555
   ClientWidth     =   4125
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
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   1545
   ScaleWidth      =   4125
   Begin VB.TextBox Text_DelAddr 
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
      Index           =   4
      Left            =   735
      MaxLength       =   30
      TabIndex        =   5
      Top             =   1155
      Width           =   3300
   End
   Begin VB.TextBox Text_DelAddr 
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
      Index           =   3
      Left            =   735
      MaxLength       =   30
      TabIndex        =   4
      Top             =   885
      Width           =   3300
   End
   Begin VB.TextBox Text_DelAddr 
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
      Index           =   2
      Left            =   735
      MaxLength       =   30
      TabIndex        =   3
      Top             =   615
      Width           =   3300
   End
   Begin VB.TextBox Text_DelAddr 
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
      Index           =   1
      Left            =   735
      MaxLength       =   30
      TabIndex        =   2
      Top             =   345
      Width           =   3300
   End
   Begin VB.TextBox Text_DelAddr 
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
      Index           =   0
      Left            =   735
      MaxLength       =   30
      TabIndex        =   0
      Top             =   75
      Width           =   3300
   End
   Begin VB.Label Label1 
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
      Height          =   255
      Left            =   90
      TabIndex        =   1
      Top             =   105
      Width           =   720
   End
End
Attribute VB_Name = "Form_Delivery"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    ' Position window centrally on the screen
    Left = (Screen.Width - Width) / 2
    Top = (Screen.Height - Height) / 2

    ' Set fields
    Text_DelAddr(0).Text = HeaderRec.DAddr(0).Address
    Text_DelAddr(1).Text = HeaderRec.DAddr(1).Address
    Text_DelAddr(2).Text = HeaderRec.DAddr(2).Address
    Text_DelAddr(3).Text = HeaderRec.DAddr(3).Address
    Text_DelAddr(4).Text = HeaderRec.DAddr(4).Address
End Sub


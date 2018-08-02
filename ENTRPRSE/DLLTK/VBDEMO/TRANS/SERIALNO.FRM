VERSION 5.00
Begin VB.Form Form_SerialNo 
   Appearance      =   0  'Flat
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Transaction Line Serial/Batch Numbers"
   ClientHeight    =   2700
   ClientLeft      =   1260
   ClientTop       =   2955
   ClientWidth     =   5940
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
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   2700
   ScaleWidth      =   5940
   Begin VB.ListBox List1 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1920
      Left            =   90
      TabIndex        =   2
      Top             =   675
      Width           =   5745
   End
   Begin VB.Label Label1 
      Appearance      =   0  'Flat
      Caption         =   "Batch No"
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
      Index           =   2
      Left            =   2445
      TabIndex        =   4
      Top             =   435
      Width           =   1425
   End
   Begin VB.Label Label1 
      Appearance      =   0  'Flat
      Caption         =   "Serial No"
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
      Index           =   1
      Left            =   135
      TabIndex        =   3
      Top             =   450
      Width           =   990
   End
   Begin VB.Label lblStock 
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
      Height          =   270
      Left            =   1140
      TabIndex        =   1
      Top             =   60
      Width           =   3600
   End
   Begin VB.Label Label1 
      Appearance      =   0  'Flat
      Caption         =   "Stock Code"
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
      Index           =   0
      Left            =   105
      TabIndex        =   0
      Top             =   60
      Width           =   990
   End
End
Attribute VB_Name = "Form_SerialNo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    ' Position window centrally on the screen
    Left = (Screen.Width - Width) / 2
    Top = (Screen.Height - Height) / 2

End Sub


VERSION 5.00
Begin VB.Form frmEmailDetails 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Dialog Caption"
   ClientHeight    =   1395
   ClientLeft      =   2760
   ClientTop       =   3750
   ClientWidth     =   5505
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1395
   ScaleWidth      =   5505
   ShowInTaskbar   =   0   'False
   Begin VB.TextBox txtRecipAddr 
      Height          =   315
      Left            =   720
      TabIndex        =   6
      Top             =   945
      Width           =   3165
   End
   Begin VB.ComboBox lstEmailType 
      Height          =   315
      ItemData        =   "EmlDetsF.frx":0000
      Left            =   750
      List            =   "EmlDetsF.frx":000D
      Style           =   2  'Dropdown List
      TabIndex        =   5
      Top             =   135
      Width           =   1065
   End
   Begin VB.TextBox txtRecipName 
      Height          =   315
      Left            =   735
      TabIndex        =   2
      Top             =   555
      Width           =   3165
   End
   Begin VB.CommandButton CancelButton 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   4125
      TabIndex        =   1
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton OKButton 
      Caption         =   "OK"
      Height          =   375
      Left            =   4125
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
   Begin VB.Label Label9 
      Alignment       =   1  'Right Justify
      Caption         =   "Addr"
      Height          =   315
      Index           =   2
      Left            =   120
      TabIndex        =   7
      Top             =   990
      Width           =   495
   End
   Begin VB.Label Label9 
      Alignment       =   1  'Right Justify
      Caption         =   "Type"
      Height          =   315
      Index           =   1
      Left            =   180
      TabIndex        =   4
      Top             =   180
      Width           =   495
   End
   Begin VB.Label Label9 
      Alignment       =   1  'Right Justify
      Caption         =   "Name"
      Height          =   315
      Index           =   0
      Left            =   135
      TabIndex        =   3
      Top             =   600
      Width           =   495
   End
End
Attribute VB_Name = "frmEmailDetails"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Public Result As Boolean

Public Function EmailStr() As String
    EmailStr = lstEmailType.Text
End Function

Public Function SetDetails(emlType$, emlName$, emlAddr$)
    lstEmailType.Text = emlType$
    txtRecipName.Text = emlName$
    txtRecipAddr.Text = emlAddr$
End Function

Private Sub CancelButton_Click()
    Me.Hide
End Sub

Private Sub Form_Load()
    Result = False
    lstEmailType.ListIndex = 0
End Sub

Private Sub OKButton_Click()
    If (Trim(txtRecipName) <> "") Then
        If (Trim(txtRecipAddr) <> "") Then
            Result = True
            Me.Hide
        Else
            MsgBox "The Recipient Email Address must be set"
        End If
    Else
        MsgBox "The Recipient Name must be set"
    End If
End Sub

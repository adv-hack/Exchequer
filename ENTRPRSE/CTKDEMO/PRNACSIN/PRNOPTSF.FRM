VERSION 5.00
Begin VB.Form frmPrintOptions 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Dialog Caption"
   ClientHeight    =   2310
   ClientLeft      =   2760
   ClientTop       =   3750
   ClientWidth     =   4695
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2310
   ScaleWidth      =   4695
   ShowInTaskbar   =   0   'False
   Begin VB.Frame frCopies 
      Caption         =   " Copies "
      Height          =   705
      Left            =   90
      TabIndex        =   7
      Top             =   1500
      Width           =   3120
      Begin VB.TextBox txtCopies 
         Height          =   315
         Left            =   1545
         TabIndex        =   9
         Text            =   "1"
         Top             =   270
         Width           =   465
      End
      Begin VB.Label Label2 
         Alignment       =   1  'Right Justify
         Caption         =   "Number of Copies"
         Height          =   330
         Left            =   90
         TabIndex        =   8
         Top             =   315
         Width           =   1380
      End
   End
   Begin VB.Frame frPageRange 
      Caption         =   " Page Range "
      Height          =   1410
      Left            =   75
      TabIndex        =   0
      Top             =   45
      Width           =   3135
      Begin VB.TextBox txtFinishPage 
         Enabled         =   0   'False
         Height          =   315
         Left            =   2505
         TabIndex        =   6
         Text            =   "1"
         Top             =   960
         Width           =   465
      End
      Begin VB.TextBox txtStartPage 
         Enabled         =   0   'False
         Height          =   315
         Left            =   1725
         TabIndex        =   4
         Text            =   "1"
         Top             =   960
         Width           =   480
      End
      Begin VB.OptionButton optPageRange 
         Caption         =   "Page Range from"
         Height          =   330
         Left            =   135
         TabIndex        =   3
         Top             =   945
         Width           =   1695
      End
      Begin VB.OptionButton optCurrentPage 
         Caption         =   "Current Page"
         Height          =   330
         Left            =   135
         TabIndex        =   2
         Top             =   615
         Width           =   1350
      End
      Begin VB.OptionButton optAllPages 
         Caption         =   "All Pages"
         Height          =   330
         Left            =   135
         TabIndex        =   1
         Top             =   285
         Value           =   -1  'True
         Width           =   1185
      End
      Begin VB.Label Label1 
         Alignment       =   2  'Center
         Caption         =   "to"
         Height          =   330
         Left            =   2250
         TabIndex        =   5
         Top             =   1005
         Width           =   210
      End
   End
   Begin VB.CommandButton CancelButton 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   3360
      TabIndex        =   11
      Top             =   630
      Width           =   1215
   End
   Begin VB.CommandButton OKButton 
      Caption         =   "OK"
      Height          =   375
      Left            =   3360
      TabIndex        =   10
      Top             =   150
      Width           =   1215
   End
End
Attribute VB_Name = "frmPrintOptions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Public SelectedOpt%

Private Sub EnableFields(FldNo%)
    SelectedOpt% = FldNo%
    
    txtStartPage.Enabled = (FldNo% = 2)
    txtFinishPage.Enabled = txtStartPage.Enabled
End Sub

Private Sub CancelButton_Click()
    SelectedOpt% = -1
    Me.Hide
End Sub

Private Sub Form_Load()
    EnableFields (0)
End Sub

Private Sub OKButton_Click()
    Me.Hide
End Sub

Private Sub optAllPages_Click()
    EnableFields (0)
End Sub

Private Sub optCurrentPage_Click()
    EnableFields (1)
End Sub

Private Sub optPageRange_Click()
    EnableFields (2)
End Sub

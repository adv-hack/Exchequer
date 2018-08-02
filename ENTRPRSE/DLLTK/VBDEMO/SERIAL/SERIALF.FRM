VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   1035
      Left            =   870
      TabIndex        =   0
      Top             =   1035
      Width           =   2340
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
    Dim Sr As TBatchSerialRec
    Dim Res%
    
    Call EX_INITSERIAL(Sr, Len(Sr))
    Sr.SerialNo = "10000318"
    Sr.SerialNoLen = Chr(Len(Trim(Sr.SerialNo)))
       
    Res% = EX_GETSERIALBATCH(Sr, Len(Sr), B_GetGEq)
    MsgBox "Res: " + Str(Res) + Chr(13) + Sr.InDoc
End Sub

Private Sub Form_Load()
    Dim Res%
    
    Res% = EX_INITDLL%()
    If (Res% <> 0) Then MsgBox "EX_INITDLL called, status " + Str(Res%)
End Sub

Private Sub Form_OLEGiveFeedback(Effect As Long, DefaultCursors As Boolean)
    Call EX_CLOSEDLL
End Sub

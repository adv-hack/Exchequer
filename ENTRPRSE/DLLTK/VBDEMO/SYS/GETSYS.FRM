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
   Begin VB.CommandButton cmdGetSysData 
      Caption         =   "Get System Setup Info"
      Height          =   735
      Left            =   195
      TabIndex        =   0
      Top             =   255
      Width           =   4275
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdGetSysData_Click()
    Dim SysRec As TBatchSysRec
    Dim Res%
    
    Res% = EX_GETSYSDATA(SysRec, Len(SysRec))
    
    MsgBox "Company Name: " + Left(SysRec.UserName, Asc(SysRec.UserNameLen))
End Sub

Private Sub Form_Load()
    Dim Res%
    
    Res% = EX_INITDLL%()
    If (Res% <> 0) Then MsgBox "EX_INITDLL: " + Str(Res%)
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call EX_CLOSEDLL
End Sub

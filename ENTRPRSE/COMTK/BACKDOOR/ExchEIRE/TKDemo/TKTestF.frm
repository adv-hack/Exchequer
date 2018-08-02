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
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Dim Res%, SecretCode$
    
    ' Set the backdoor code to bypass the release code & user counts
    SecretCode$ = "DEBUGMODE121" + Chr(0)
    Call EX_SETRELEASECODE(SecretCode$)
    
    ' Call Ex_InitDLL to open the Exchequer/Enterprise database
    Res% = EX_INITDLL()
    MsgBox "EX_INITDLL called, status " + Str(Res%)
    
    ' Call Ex_CloseDLL to close the Exchequer/Enterprise
    ' database opened in the call to Ex_InitDLL
    Res% = EX_CLOSEDATA()
End Sub

VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   4920
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4215
   LinkTopic       =   "Form1"
   ScaleHeight     =   4920
   ScaleWidth      =   4215
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox lstLocations 
      Height          =   4545
      Left            =   180
      TabIndex        =   0
      Top             =   150
      Width           =   3870
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Dim LocR As TBatchMLocRec
    Dim KeyS As String * 255
    Dim Res%
    
    Res% = EX_INITDLL()
    If (Res% = 0) Then
        ' Load Locations
        KeyS = Chr(0)
        Res% = EX_GETLOCATION(LocR, Len(LocR), KeyS, 0, B_GetFirst, DllFalse)
        'Res% = EX_GETLOCATION(LocR, Len(LocR), KeyS, 0, B_StepFirst, DllFalse)
        'Res% = EX_GETLOCATION(LocR, Len(LocR), KeyS, 0, B_GetLast, DllFalse)
       ' Res% = EX_GETLOCATION(LocR, Len(LocR), KeyS, 0, B_StepLast, DllFalse)
        While (Res% = 0)
            lstLocations.AddItem Left(LocR.loCode, Asc(LocR.loCodeLen)) + " - " + Left(LocR.loName, Asc(LocR.loNameLen))
        
            Res% = EX_GETLOCATION(LocR, Len(LocR), KeyS, 0, B_GetNext, DllFalse)
            'Res% = EX_GETLOCATION(LocR, Len(LocR), KeyS, 0, B_StepNext, DllFalse)
            'Res% = EX_GETLOCATION(LocR, Len(LocR), KeyS, 0, B_GetPrev, DllFalse)
            'Res% = EX_GETLOCATION(LocR, Len(LocR), KeyS, 0, B_StepPrev, DllFalse)
        Wend
    Else
        MsgBox "EX_INITDLL: " + Str(Res%)
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call EX_CLOSEDLL
End Sub

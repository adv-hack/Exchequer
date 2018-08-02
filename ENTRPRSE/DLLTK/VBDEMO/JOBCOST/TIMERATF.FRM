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
   Begin VB.ListBox List1 
      Height          =   2010
      Left            =   135
      TabIndex        =   1
      Top             =   915
      Width           =   4365
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Get Time Rate"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   660
      Left            =   165
      TabIndex        =   0
      Top             =   75
      Width           =   4350
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
    Dim TimeRate As TBatchJobRateRec
    Dim Res%

    ' Init new TimeRate record
    Res% = EX_INITTIMERATE%(TimeRate, Len(TimeRate))
    If (Res% = 0) Then
        ' setup details in record
        With TimeRate
            ' Get Global Rate
            '.JEmpCode = ""
            '.JRateCode = "TRAIER-STD"
            
            ' Get employee specific rate
            .JEmpCode = "CINDY"
            .JRateCode = "CLERK"
                       
            .JEmpCodeLen = Chr(Len(Trim(.JEmpCode)))
            .JRateCodeLen = Chr(Len(Trim(.JRateCode)))
        End With  ' TimeRate
                
        Res% = EX_GETJOBTIMERATE(TimeRate, Len(TimeRate), 0, B_GetEq, DllFalse%)
     
        ' clear existing details from list
        List1.Clear
     
        If (Res% = 0) Then
            ' OK display details
            With TimeRate
                List1.AddItem "EmpCode:     " & .JEmpCode
                List1.AddItem "RateCode:    " & .JRateCode
                List1.AddItem "AnalCode:    " & .JAnalCode
                List1.AddItem "CostCcy:     " & Str(.CostCurr)
                List1.AddItem "Cost:        " & Str(.Cost)
                List1.AddItem "ChargeCcy:   " & Str(.ChargeCurr)
                List1.AddItem "ChargeRate:  " & Str(.ChargeRate)
                List1.AddItem "PayRollCode: " & Str(.PayRollCode)
            End With ' TimeRate
        Else
            MsgBox "EX_GETJOBTIMERATE: " + Str(Res%)
        End If
    Else
        ' Init Failed
        MsgBox "EX_INITTIMERATE: " + Str(Res%)
    End If
End Sub

Private Sub Form_Load()
    Dim Res%
    
    Res% = EX_INITDLL%()
    If (Res% <> 0) Then
        MsgBox "EX_INITDLL: " + Str(Res%)
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim Res%
    
    Res% = EX_CLOSEDLL%()
    If (Res% <> 0) Then
        MsgBox "EX_CLOSEDLL: " + Str(Res%)
    End If
End Sub

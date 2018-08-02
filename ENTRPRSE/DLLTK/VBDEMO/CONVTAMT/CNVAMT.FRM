VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "EX_CONVERTAMOUNT DEMO APP"
   ClientHeight    =   2280
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6945
   Icon            =   "CnvAmt.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2280
   ScaleWidth      =   6945
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton btnConvert 
      Caption         =   "&Convert"
      Height          =   405
      Left            =   5520
      TabIndex        =   4
      Top             =   600
      Width           =   1320
   End
   Begin VB.TextBox txtToAmt 
      Height          =   315
      Left            =   1560
      TabIndex        =   3
      Top             =   1830
      Width           =   1785
   End
   Begin VB.TextBox txtFromAmt 
      Height          =   315
      Left            =   1560
      TabIndex        =   1
      Text            =   "100"
      Top             =   990
      Width           =   1785
   End
   Begin VB.ComboBox lstTo 
      Height          =   315
      Left            =   1560
      TabIndex        =   2
      Text            =   "Combo1"
      Top             =   1455
      Width           =   3735
   End
   Begin VB.ComboBox lstFrom 
      Height          =   315
      Left            =   1560
      TabIndex        =   0
      Text            =   "Combo1"
      Top             =   615
      Width           =   3735
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "To Amount"
      Height          =   255
      Index           =   3
      Left            =   240
      TabIndex        =   9
      Top             =   1875
      Width           =   1215
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "To Currency"
      Height          =   255
      Index           =   2
      Left            =   240
      TabIndex        =   8
      Top             =   1500
      Width           =   1215
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "From Amount"
      Height          =   255
      Index           =   1
      Left            =   240
      TabIndex        =   7
      Top             =   1035
      Width           =   1215
   End
   Begin VB.Label Label2 
      Caption         =   "Convert the amount specified in ""From Currency"" into ""To Currency"":"
      Height          =   375
      Left            =   120
      TabIndex        =   6
      Top             =   120
      Width           =   5160
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "From Currency"
      Height          =   255
      Index           =   0
      Left            =   240
      TabIndex        =   5
      Top             =   660
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub btnConvert_Click()
    Dim FromCurr%, ToCurr%, Res%, Amount#
    
    FromCurr% = lstFrom.ListIndex + 1
    Amount# = CDbl(txtFromAmt.Text)
    
    ToCurr% = lstTo.ListIndex + 1
    
    Res% = EX_CONVERTAMOUNT(FromCurr%, ToCurr%, Amount#, 0)
    
    txtToAmt.Text = Str(Amount#)
End Sub

Private Sub Form_Load()
    Dim CuRec As TBatchCurrRec
    Dim RecLen As Long
    Dim I As Integer
    Dim Msg As String
        
    ' Position window centrally on the screen
    Left = (Screen.Width - Width) / 2
    Top = (Screen.Height - Height) / 2
    
    ' Initialise the Toolkit DLL
    DLLLoaded% = EX_INITDLL()
    
    If DLLLoaded% <> 0 Then
        ' failed to startup correctly
        MsgBox "An error " + Str(DLLLoaded%) + " occurred when calling EX_INITDLL.", 16
    Else
        ' Load currency lists
        lstFrom.Clear
        lstTo.Clear
        For I% = 1 To 30
            RecLen = Len(CuRec)
            Result% = EX_GETCURRENCY%(CuRec, RecLen, I%)

            Msg$ = Str(I%) & ": "
            If Result% = 0 Then
                Msg$ = Msg$ & Mid$(Mid$(CuRec.Name, 1, Asc(CuRec.NameLen)) + String(16, 32), 1, 16)
            Else
                Msg$ = Msg$ & "Error!"
            End If
            lstFrom.AddItem Msg
            lstTo.AddItem Msg
        Next I%
            
        lstFrom.ListIndex = 0
        lstTo.ListIndex = 1
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim Result%

    ' Check the DLL Loaded OK
    If DLLLoaded% = 0 Then
        ' De-Initialise the Toolkit DLL
        Result% = EX_CLOSEDLL()
        
        If Result% <> 0 Then
            ' An error has occurred
            MsgBox "An error " + Str(Result%) + " occurred when calling EX_CLOSEDLL.", 16
        End If
    End If
End Sub

Private Sub txtFromAmt_KeyPress(KeyAscii As Integer)
    ' Valid Characters : "0"-"9" "." BackSpace(8)
    If ((KeyAscii < Asc("0")) Or (KeyAscii > Asc("9"))) And (KeyAscii <> Asc(".")) And (KeyAscii <> 8) Then
        ' Invalid character
        KeyAscii = 0
    End If
End Sub

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
      Caption         =   "Click Me, Or Else!"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2295
      Left            =   360
      TabIndex        =   0
      Top             =   360
      Width           =   4095
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
    Dim DPath As String * 255
    Dim Res%
  
    Res% = EX_INITDLL%()
    
    If (Res% = 0) Then
        ' OK - Get Data Path
        
        DPath$ = String$(255, 32)
        Res% = EX_GETDATAPATH%(DPath)
        If (Res% = 0) Then
            MsgBox "DataPath: " + DPath
        Else
            MsgBox "EX_GETDATAPATH: " + Str(Res%)
        End If
        
        Res% = EX_CLOSEDLL%()
        If (Res% <> 0) Then
            MsgBox "EX_CLOSEDLL: " + Str(Res%)
        End If
    Else
        ' Error
        MsgBox "EX_INITDLL: " + Str(Res%)
    End If
End Sub

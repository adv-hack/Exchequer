VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   2655
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   2655
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Click Me, or Else!"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2415
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4455
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
    Dim Res%, Folio&, LineNo&, PLSize&
    Dim PLine As TBatchTLRec

    Res% = EX_INITDLL%()

    If (Res% = 0) Then
        ' OK - Get Transaction Line
        Folio& = 3555
        LineNo& = 1
        PLSize& = Len(PLine)
        Res% = EX_GETTLLINE(Folio&, LineNo&, PLine, PLSize&)

        If (Res% = 0) Then
            MsgBox "EX_GETTLLINE: " + PLine.Desc
        Else
            MsgBox "EX_GETTLLINE: " + Str(Res%)
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

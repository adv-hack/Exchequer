VERSION 5.00
Begin VB.Form frmDelQuote 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Toolkit SQU/PQU Deletion Demo"
   ClientHeight    =   645
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4260
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   645
   ScaleWidth      =   4260
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cdmDelQuote 
      Caption         =   "Delete Quote"
      Height          =   315
      Left            =   2880
      TabIndex        =   2
      Top             =   150
      Width           =   1200
   End
   Begin VB.TextBox txtOurRef 
      Height          =   315
      Left            =   1470
      MaxLength       =   9
      TabIndex        =   1
      Text            =   "SQU000000"
      Top             =   135
      Width           =   1245
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Quote OurRef:"
      Height          =   315
      Left            =   270
      TabIndex        =   0
      Top             =   180
      Width           =   1155
   End
End
Attribute VB_Name = "frmDelQuote"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cdmDelQuote_Click()
    Dim LastErr As PascalString
    Dim QuoteRef As String * 255
    Dim Res%
    
    QuoteRef$ = txtOurRef.Text + Chr$(0)
    Res% = EX_DELETEQUOTE(QuoteRef$)
    
    ' display Results
    LastErr = EX_GETLASTERRORDESC()
    MsgBox "Ex_DeleteQuote: " + Str(Res%) + " - """ + _
           Mid$(LastErr.Str, 1, LastErr.StrLen) + """"
End Sub

Private Sub Form_Load()
    Dim LastErr As PascalString
    Dim Res%
    
    Res% = EX_INITDLL()
    If (Res% <> 0) Then
        ' Error opening Toolkit
        LastErr = EX_GETLASTERRORDESC()
        MsgBox "The following error occurred whilst initialising the Toolkit DLL:-" + _
               Chr(13) + Chr(13) + "Error " + Str(Res%) + ": " + Mid$(LastErr.Str, 1, LastErr.StrLen) + _
               Chr(13) + Chr(13) + "Please contact your technical support"
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call EX_CLOSEDATA
End Sub

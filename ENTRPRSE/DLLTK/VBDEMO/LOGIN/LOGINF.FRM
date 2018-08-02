VERSION 5.00
Begin VB.Form frmEntLogin 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Enterprise Login"
   ClientHeight    =   1770
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6315
   Icon            =   "LoginF.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1770
   ScaleWidth      =   6315
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton btnLogin 
      Caption         =   "&Login"
      Height          =   315
      Left            =   2415
      TabIndex        =   2
      Top             =   1320
      Width           =   1200
   End
   Begin VB.TextBox edtPword 
      Height          =   330
      IMEMode         =   3  'DISABLE
      Left            =   4200
      PasswordChar    =   "*"
      TabIndex        =   1
      Top             =   810
      Width           =   1500
   End
   Begin VB.TextBox edtUserId 
      Height          =   330
      Left            =   1590
      TabIndex        =   0
      Top             =   810
      Width           =   1500
   End
   Begin VB.Label Label3 
      Caption         =   $"LoginF.frx":030A
      Height          =   495
      Left            =   105
      TabIndex        =   5
      Top             =   135
      Width           =   6120
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      Caption         =   "Password"
      Height          =   225
      Left            =   3165
      TabIndex        =   4
      Top             =   855
      Width           =   930
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "User Id"
      Height          =   225
      Left            =   555
      TabIndex        =   3
      Top             =   855
      Width           =   930
   End
End
Attribute VB_Name = "frmEntLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim OpenRes%

Private Sub btnLogin_Click()
    Dim UserName As String * 255
    Dim Password As String * 255
    Dim Res%
    
    UserName$ = UCase(Trim(edtUserId.Text)) + Chr(0)
    Password$ = UCase(Trim(edtPword.Text)) + Chr(0)

    Res% = EX_CHECKPASSWORD(UserName$, Password$)
    
    If (Res% <> 0) Then
        MsgBox "Login Failed, Please Retry"
        edtUserId.SetFocus
    Else
        MsgBox "Login Succeeded"
        Unload Me
    End If
End Sub

Private Sub edtPword_KeyPress(KeyAscii As Integer)
    If (KeyAscii >= 97) And (KeyAscii <= 122) Then
        ' Convert to Uppercase
        KeyAscii = KeyAscii - 32
    End If
End Sub

Private Sub edtUserId_KeyPress(KeyAscii As Integer)
    If (KeyAscii >= 97) And (KeyAscii <= 122) Then
        ' Convert to Uppercase
        KeyAscii = KeyAscii - 32
    End If
End Sub

Private Sub Form_Load()
    Dim Res%
    
    OpenRes% = 999
    
    Res% = EX_INITBTRIEVE%()
    If (Res% = 0) Then
        OpenRes% = EX_INITDLL%()
        If (OpenRes% <> 0) Then
            MsgBox "EX_INITDLL: " + Str(OpenRes%)
        End If
    Else
        MsgBox "Btrieve not running"
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim Res%
    
    If (OpenRes% = 0) Then
        Res% = EX_CLOSEDLL%()
        If (Res% <> 0) Then
            MsgBox "EX_CLOSEDLL: " + Str(Res%)
        End If
    End If
End Sub

VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3900
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   3870
   LinkTopic       =   "Form1"
   ScaleHeight     =   3900
   ScaleWidth      =   3870
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox edtCustCode 
      Height          =   330
      Left            =   1065
      MaxLength       =   6
      TabIndex        =   6
      Text            =   "A1HI01"
      Top             =   1740
      Width           =   2670
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Get Customer Balance"
      Height          =   540
      Left            =   90
      TabIndex        =   5
      Top             =   2145
      Width           =   3690
   End
   Begin VB.TextBox Text2 
      Height          =   330
      Left            =   1100
      TabIndex        =   4
      Text            =   "X"
      Top             =   510
      Width           =   2670
   End
   Begin VB.TextBox Text1 
      Height          =   330
      Left            =   1100
      TabIndex        =   2
      Text            =   "Manager"
      Top             =   150
      Width           =   2670
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Set OLE Server Default Login"
      Height          =   540
      Left            =   75
      TabIndex        =   0
      Top             =   930
      Width           =   3690
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "CustCode"
      Height          =   270
      Index           =   2
      Left            =   60
      TabIndex        =   7
      Top             =   1800
      Width           =   900
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Password"
      Height          =   270
      Index           =   1
      Left            =   90
      TabIndex        =   3
      Top             =   555
      Width           =   900
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "User Id"
      Height          =   270
      Index           =   0
      Left            =   90
      TabIndex        =   1
      Top             =   210
      Width           =   900
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

                          
Private Sub Command1_Click()
    Dim Uid As PascalString, PWd As PascalString
    Dim Res As Integer
    
    With Uid
        .Str = Trim(Text1.Text)
        .StrLen = Chr(Len(Trim(.Str)))
    End With ' UId
    With PWd
        .Str = Trim(Text2.Text)
        .StrLen = Chr(Len(Trim(.Str)))
    End With ' UId
    
    Res% = EntDefaultLogin(Uid, PWd)
    MsgBox "EntDefaultLogin: " + Str(Res%)
End Sub

Private Sub Command2_Click()
    Dim WantValue As Integer, Year As Integer, Period As Integer
    Dim Company As PascalString, CustCode As PascalString
    Dim CustBal As Double
    Dim Res%
    
    WantValue% = 0
    With Company
        .Str = "ZZZZ01"
        .StrLen = Chr(Len(Trim(.Str)))
    End With ' Company
    With CustCode
        .Str = Trim(edtCustCode.Text)
        .StrLen = Chr(Len(Trim(.Str)))
    End With ' CustCode
    Year% = 2006
    Period% = 0
    CustBal# = 0#
    
    Res% = EntCustValue(WantValue, Company, CustCode, Year, Period, CustBal#)
    
    MsgBox "EntCustValue: " + Str(Res%) + Chr(13) + Chr(13) + _
           "Balance: " + Str(CustBal#)
End Sub


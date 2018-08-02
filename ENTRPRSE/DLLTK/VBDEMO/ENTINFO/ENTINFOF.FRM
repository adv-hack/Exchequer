VERSION 5.00
Begin VB.Form frmEnterpriseInfo 
   Caption         =   "Get Enterprise Information"
   ClientHeight    =   3330
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6075
   LinkTopic       =   "Form1"
   ScaleHeight     =   3330
   ScaleWidth      =   6075
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtUserId 
      Height          =   330
      Left            =   1995
      TabIndex        =   10
      Top             =   2910
      Width           =   1530
   End
   Begin VB.TextBox txtCurrencyVersion 
      Height          =   330
      Left            =   1995
      TabIndex        =   8
      Top             =   1515
      Width           =   1455
   End
   Begin VB.TextBox txtEnterpriseVersion 
      Height          =   330
      Left            =   1995
      TabIndex        =   6
      Top             =   1140
      Width           =   2625
   End
   Begin VB.TextBox txtCompanyPath 
      Height          =   330
      Left            =   1995
      TabIndex        =   5
      Top             =   2400
      Width           =   3915
   End
   Begin VB.TextBox txtEnterprisePath 
      Height          =   330
      Left            =   1995
      TabIndex        =   3
      Top             =   2010
      Width           =   3915
   End
   Begin VB.CheckBox chkDefined 
      Alignment       =   1  'Right Justify
      Caption         =   "Enterprise Data Defined"
      Height          =   240
      Left            =   120
      TabIndex        =   1
      Top             =   780
      Width           =   2070
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Get Enterprise Data"
      Height          =   480
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   5865
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Current User Id"
      Height          =   210
      Index           =   4
      Left            =   285
      TabIndex        =   11
      Top             =   2970
      Width           =   1605
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Currency Version"
      Height          =   210
      Index           =   3
      Left            =   285
      TabIndex        =   9
      Top             =   1545
      Width           =   1605
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Enterprise Version"
      Height          =   210
      Index           =   2
      Left            =   285
      TabIndex        =   7
      Top             =   1200
      Width           =   1605
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Company Data Path"
      Height          =   210
      Index           =   1
      Left            =   285
      TabIndex        =   4
      Top             =   2460
      Width           =   1605
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Enterprise Path"
      Height          =   210
      Index           =   0
      Left            =   285
      TabIndex        =   2
      Top             =   2055
      Width           =   1605
   End
End
Attribute VB_Name = "frmEnterpriseInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
    Dim EntInfo As TEnterpriseInfoType
    Dim Res%
    
    Res% = EX_GETENTDATA(EntInfo, Len(EntInfo))
    If (Res% = 0) Then
        With EntInfo
            ' display data
            If (.eiDefined <> DllFalse) Then
                chkDefined.Value = 1
            Else
                chkDefined.Value = 0
            End If
            
            txtEnterpriseVersion.Text = Left(.eiEntVersion, Asc(.eiEntVersionLen))
            Select Case .eiCurrencyVer
                Case "P"
                    txtCurrencyVersion.Text = "Professional"
                Case "E"
                    txtCurrencyVersion.Text = "Euro"
                Case "G"
                    txtCurrencyVersion.Text = "Global"
            End Select
            
            txtEnterprisePath.Text = Left(.eiEntPath, Asc(.eiEntPathLen))
            txtCompanyPath.Text = Left(.eiDataPath, Asc(.eiDataPathLen))
            
            txtUserId.Text = Left(.eiUserName, Asc(.eiUserNameLen))
        End With ' EntInfo
    Else
        MsgBox "EX_GETENTDATA: " + Str(Res)
    End If
End Sub


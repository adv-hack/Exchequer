VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "EntSetup.DLL Test Application"
   ClientHeight    =   3540
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8445
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3540
   ScaleWidth      =   8445
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtPlugInDesc 
      Height          =   345
      Index           =   1
      Left            =   1410
      TabIndex        =   15
      Text            =   "Enterprise POR Carriage Plug-In"
      Top             =   3090
      Width           =   5265
   End
   Begin VB.TextBox txtPlugInDesc 
      Height          =   345
      Index           =   0
      Left            =   1410
      TabIndex        =   13
      Text            =   "Enterprise Cost Centre/Department Plug-In"
      Top             =   1620
      Width           =   5265
   End
   Begin VB.CommandButton cmdAddDLLPlugIn 
      Caption         =   "Add DLL Plug-In"
      Height          =   345
      Left            =   6750
      TabIndex        =   10
      Top             =   3115
      Width           =   1575
   End
   Begin VB.TextBox txtDLLName 
      Height          =   345
      Left            =   1410
      TabIndex        =   9
      Text            =   "ENTCARRG"
      Top             =   2670
      Width           =   1575
   End
   Begin VB.TextBox txtEntDir 
      Height          =   345
      Index           =   2
      Left            =   1410
      TabIndex        =   8
      Top             =   2250
      Width           =   5265
   End
   Begin VB.TextBox txtEntDir 
      Height          =   345
      Index           =   1
      Left            =   1410
      TabIndex        =   6
      Top             =   780
      Width           =   5265
   End
   Begin VB.TextBox txtPlugInPath 
      Height          =   345
      Left            =   1410
      TabIndex        =   4
      Text            =   "m:\440test\cccustom.exe"
      Top             =   1200
      Width           =   5265
   End
   Begin VB.CommandButton cmdAddCOMPlugIn 
      Caption         =   "Add COM Plug-In"
      Height          =   345
      Left            =   6750
      TabIndex        =   3
      Top             =   1635
      Width           =   1575
   End
   Begin VB.CommandButton cmdGetEntDir 
      Caption         =   "Get Ent Dir"
      Height          =   345
      Left            =   6750
      TabIndex        =   2
      Top             =   135
      Width           =   1575
   End
   Begin VB.TextBox txtEntDir 
      Height          =   345
      Index           =   0
      Left            =   1410
      TabIndex        =   1
      Top             =   135
      Width           =   5265
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "DLL Plug-In Path"
      Height          =   315
      Index           =   6
      Left            =   90
      TabIndex        =   16
      Top             =   3135
      Width           =   1275
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "COM Plug-In Path"
      Height          =   315
      Index           =   5
      Left            =   90
      TabIndex        =   14
      Top             =   1665
      Width           =   1275
   End
   Begin VB.Line Line1 
      Index           =   1
      X1              =   180
      X2              =   7950
      Y1              =   2130
      Y2              =   2130
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "DLL Name"
      Height          =   315
      Index           =   4
      Left            =   90
      TabIndex        =   12
      Top             =   2715
      Width           =   1275
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Enterprise Dir"
      Height          =   315
      Index           =   3
      Left            =   90
      TabIndex        =   11
      Top             =   2295
      Width           =   1275
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Enterprise Dir"
      Height          =   315
      Index           =   2
      Left            =   90
      TabIndex        =   7
      Top             =   825
      Width           =   1275
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "COM Plug-In Path"
      Height          =   315
      Index           =   1
      Left            =   90
      TabIndex        =   5
      Top             =   1245
      Width           =   1275
   End
   Begin VB.Line Line1 
      Index           =   0
      X1              =   180
      X2              =   7950
      Y1              =   660
      Y2              =   660
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Enterprise Dir"
      Height          =   315
      Index           =   0
      Left            =   90
      TabIndex        =   0
      Top             =   180
      Width           =   1275
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdAddCOMPlugIn_Click()
    Dim EntDir As String * 255
    Dim PlugInPath As String * 255
    Dim PlugInDesc As String * 255
    Dim Res%
    
    ' Allocate space for the PChars
    EntDir$ = txtEntDir(1).Text
    PlugInPath$ = txtPlugInPath.Text
    PlugInDesc$ = txtPlugInDesc(0).Text
        
    ' Call function to add a COM Plug-In into Entcustm.Ini in the Enterprise directory
    Res% = AddCOMPlugIn(EntDir$, PlugInPath$, PlugInDesc$)
    If (Res% = 0) Then
        ' Success
        MsgBox "The Plug-In has been added successfully"
    Else
        ' Error
        MsgBox "The following error occured adding a COM Plug-In:" + _
               String$(2, 13) + "Error " + Str(Res%) + " - " + Trim(EntDir)
    End If
End Sub

Private Sub cmdAddDLLPlugIn_Click()
    Dim EntDir As String * 255
    Dim DLLName As String * 255
    Dim PlugInDesc As String * 255
    Dim Res%
    
    ' Allocate space for the PChars
    EntDir$ = txtEntDir(1).Text
    DLLName$ = txtDLLName.Text
    PlugInDesc$ = txtPlugInDesc(1).Text
        
    ' Call function to add a Delphi DLL Plug-In into Entcustm.Ini in the Enterprise directory
    Res% = AddDLLPlugIn(EntDir$, DLLName$, PlugInDesc$)
    If (Res% = 0) Then
        ' Success
        MsgBox "The Plug-In has been added successfully"
    Else
        ' Error
        MsgBox "The following error occured adding a DLL Plug-In:" + _
               String$(2, 13) + "Error " + Str(Res%) + " - " + Trim(EntDir)
    End If
End Sub

Private Sub cmdGetEntDir_Click()
    Dim EntDir As String * 255
    Dim Res%
    
    ' Allocate space for the PChar
    EntDir$ = String(255, " ")
    
    ' Call function to get the Enterprise directory
    Res% = GetEnterpriseDir(EntDir)
    If (Res% = 0) Then
        ' Success
        For Res% = 0 To 2
            txtEntDir(Res%).Text = Trim(EntDir)
        Next Res%
    Else
        ' Error
        MsgBox "The following error occured getting the Enterprise Directory:" + _
               String$(2, 13) + "Error " + Str(Res%)
    End If
End Sub


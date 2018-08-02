VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Exchequer Web Security Test"
   ClientHeight    =   1335
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4035
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1335
   ScaleWidth      =   4035
   StartUpPosition =   3  'Windows Default
   Begin VB.Label lblPwordTomorrow 
      Height          =   285
      Left            =   2010
      TabIndex        =   5
      Top             =   900
      Width           =   1905
   End
   Begin VB.Label lblPwordToday 
      Height          =   285
      Left            =   2010
      TabIndex        =   4
      Top             =   510
      Width           =   1905
   End
   Begin VB.Label lblCOMVer 
      Height          =   285
      Left            =   2010
      TabIndex        =   3
      Top             =   120
      Width           =   1905
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Caption         =   "Tomorrow's Password"
      Height          =   285
      Left            =   20
      TabIndex        =   2
      Top             =   900
      Width           =   1900
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      Caption         =   "Today's Password"
      Height          =   285
      Left            =   20
      TabIndex        =   1
      Top             =   510
      Width           =   1900
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "COM Version"
      Height          =   285
      Left            =   20
      TabIndex        =   0
      Top             =   120
      Width           =   1900
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
Dim oWWWSecPW As Exchequer.SecPwords

Private Sub Form_Load()
    
    ' Create COM object
    Set oWWWSecPW = CreateObject("Exchequer.SecPwords")
    
    With oWWWSecPW
        lblCOMVer.Caption = .Version
        lblPwordToday.Caption = .PlugInToday
        lblPwordTomorrow.Caption = .PlugInTomorrow
    End With ' oWWWSecPW
    
    ' Release object reference to destroy COM Object
    Set oWWWSecPW = Nothing
End Sub

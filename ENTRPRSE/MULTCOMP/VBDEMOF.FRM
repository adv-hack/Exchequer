VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "VB Multi-Company Manager Demo"
   ClientHeight    =   1740
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8745
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1740
   ScaleWidth      =   8745
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox List1 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1530
      ItemData        =   "VBDemoF.frx":0000
      Left            =   105
      List            =   "VBDemoF.frx":0002
      TabIndex        =   0
      Top             =   105
      Width           =   8565
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Dim Companies As TCompanyArray
    Dim FuncRes%, ArraySize&
        
    ' load Companies from Enterprise
    ArraySize& = Len(Companies)
    FuncRes% = EX_GETCOMPANY%("C:\develop\entrprse", Companies, ArraySize&)
    
    List1.Clear
    If (FuncRes% = 0) And (ArraySize& > 0) Then
        For FuncRes% = 1 To ArraySize&
            With Companies.Companies(FuncRes%)
                List1.AddItem Mid(.CompCode, 1, Asc(.CompCodeLen)) + " - " + Mid(Mid(.CompName, 1, Asc(.CompNameLen)) + String(30, 32), 1, 30) + "  (" + Mid(.CompPath, 1, Asc(.CompPathLen)) + ")"
            End With
        Next FuncRes%
    Else
        ' error or 0 companies
        If (FuncRes% > 0) Then
            MsgBox "EX_GETCOMPANY returned an error " + Str(FuncRes%)
        Else
            MsgBox "No Comapnies Returned"
        End If
    End If
End Sub

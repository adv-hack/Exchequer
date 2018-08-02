VERSION 5.00
Begin VB.Form frmStkBom 
   Caption         =   "Form1"
   ClientHeight    =   6135
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   6135
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox List1 
      Height          =   4935
      ItemData        =   "StkBom.frx":0000
      Left            =   120
      List            =   "StkBom.frx":0002
      TabIndex        =   1
      Top             =   1080
      Width           =   4455
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Click Me"
      Height          =   735
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4455
   End
End
Attribute VB_Name = "frmStkBom"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
    Static P As TBatchBOMLinesRec
    Dim SKey As String * 255
    Dim Res%, PSIZE&, SMode%, I%

    Res% = EX_INITDLL%()

    If (Res% = 0) Then
        ' OK - Get BOM Details
        PSIZE& = Len(P)
        SKey = "PC/486D/1GB" + Chr(0)
        SMode = 0
        Res% = EX_GETSTOCKBOM(P, PSIZE, SKey, SMode)
        
        If (Res% = 0) Then
            ' load list with codes
            For I% = LBound(P.Items) To UBound(P.Items)
                If (Trim(P.Items(I%).StockCode) <> "") Then
                    ' got code
                    List1.AddItem (Trim(P.Items(I%).StockCode))
                Else
                    ' no code
                    Exit For
                End If
            Next I%
        Else
            MsgBox "Error calling EX_GETSTOCKBOM: " + Str(Res%)
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

VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8370
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   8370
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdDelete 
      Caption         =   "Delete Current"
      Height          =   315
      Left            =   7005
      TabIndex        =   2
      Top             =   615
      Width           =   1200
   End
   Begin VB.CommandButton cmdLoadDisc 
      Caption         =   "Load All"
      Height          =   315
      Left            =   7005
      TabIndex        =   1
      Top             =   210
      Width           =   1200
   End
   Begin VB.ListBox List1 
      Height          =   2790
      Left            =   135
      TabIndex        =   0
      Top             =   135
      Width           =   6765
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdDelete_Click()
    Dim DiscRec As TBatchDiscRec
    Dim WantStk As String
    Dim RecAddr As Long
    Dim Res%

    ' Make copy of discount to be deleted
    WantStk = List1.Text

    ' Setup the discount record to load the discounts
    Call EX_INITDISCOUNT(DiscRec, Len(DiscRec))
    With DiscRec
        .CustCode = "ABAP01"
        .CustCodeLen = Chr(Len(Trim(.CustCode)))
    End With ' DiscRec
     
    Res% = EX_GETDISCMATRIX(DiscRec, Len(DiscRec), 0, B_GetGEq, DllFalse)
    While (Res% = 0) And (DiscRec.CustCode = "ABAP01")
        If (WantStk = (DiscRec.StockCode + " (" + DiscRec.DiscType + ") (" + Str(DiscRec.DiscAmt) + ")")) Then
            ' Get record position for Delete call
            Res% = EX_GETRECORDADDRESS(9, RecAddr)
            
            If (Res% = 0) Then
                ' Delete discount record
                Res% = EX_DELETEDISCMATRIX(DiscRec, _
                                           Len(DiscRec), _
                                           0, _
                                           RecAddr)
                
                MsgBox "Ex_DeleteDiscMatrix: " + Str(Res%)
            Else
                ' Error getting record position
                MsgBox "Ex_GetRecordAddress: " + Str(Res%)
            End If
        End If

        If (Res% = 0) Then
            ' Force TK to load non-Qty Break items - flag gets reset when a QB header is loaded
            DiscRec.QtyBreak = DllFalse
            Res% = EX_GETDISCMATRIX(DiscRec, Len(DiscRec), 0, B_GetNext, DllFalse)
        End If
    Wend

    Call cmdLoadDisc_Click
End Sub

Private Sub cmdLoadDisc_Click()
    Dim DiscRec As TBatchDiscRec
    Dim Res%
    
    List1.Clear
    
    ' Setup the discount record to load the discounts for ABAP01
    Call EX_INITDISCOUNT(DiscRec, Len(DiscRec))
    With DiscRec
        .CustCode = "ABAP01"
        .CustCodeLen = Chr(Len(Trim(.CustCode)))
    End With ' DiscRec
     
    Res% = EX_GETDISCMATRIX(DiscRec, Len(DiscRec), 0, B_GetGEq, DllFalse)
    While (Res% = 0) And (DiscRec.CustCode = "ABAP01")
        List1.AddItem (DiscRec.StockCode + " (" + DiscRec.DiscType + ") (" + Str(DiscRec.DiscAmt) + ")")
    
        ' Force TK to load non-Qty Break items - flag gets reset when a QB header is loaded
        DiscRec.QtyBreak = DllFalse
        Res% = EX_GETDISCMATRIX(DiscRec, Len(DiscRec), 0, B_GetNext, DllFalse)
    Wend
End Sub

Private Sub Form_Load()
    Dim Res%
    
    Res% = EX_INITDLL()
    If (Res% <> 0) Then MsgBox "Ex_InitDLL: " + Str(Res%)
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call EX_CLOSEDATA
End Sub

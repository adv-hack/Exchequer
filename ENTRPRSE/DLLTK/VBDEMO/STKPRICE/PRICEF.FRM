VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "EX_CalcStockPrice Test Application"
   ClientHeight    =   4455
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5670
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4455
   ScaleWidth      =   5670
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox List1 
      Height          =   4155
      Left            =   60
      TabIndex        =   0
      Top             =   75
      Width           =   5475
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Dim StkPriceRec As TBatchStkPriceRec
    Dim Res%
    
    ' Open toolkit
    Res% = EX_INITDLL()
    If (Res% = 0) Then
        Call EX_INITSTKPRICE(StkPriceRec, Len(StkPriceRec))
        With StkPriceRec
            ' Account code
            '.CustCode = "ACEE02" ' Supplier
            .CustCode = "ABAP01" ' Customer
            .CustCodeLen = Chr(Len(Trim(.CustCode)))
            
            ' Stock Code
            .StockCode = "BAT-9PP3-ALK"
            .StockCodeLen = Chr(Len(Trim(.StockCode)))
            
            ' Quantity being sold
            .Qty = 1
            
            ' Currency for Requested Price
            .Currency = 1
        End With ' StkPriceRec
        
        ' No Location
        Res% = EX_CALCSTOCKPRICE(StkPriceRec, Len(StkPriceRec))
        DispDets Res%, StkPriceRec
    
        ' Location: AAA
        With StkPriceRec
            .LocCode = "AAA"
            .LocCodeLen = Chr(Len(Trim(.LocCode)))
        End With ' StkPriceRec
        Res% = EX_CALCSTOCKPRICE(StkPriceRec, Len(StkPriceRec))
        DispDets Res%, StkPriceRec
    
        ' Location: MAI
        With StkPriceRec
            .LocCode = "MAI"
            .LocCodeLen = Chr(Len(Trim(.LocCode)))
        End With ' StkPriceRec
        Res% = EX_CALCSTOCKPRICE(StkPriceRec, Len(StkPriceRec))
        DispDets Res%, StkPriceRec
    
        ' Close Toolkit
        EX_CLOSEDLL
    Else
        MsgBox "Ex_InitDLL: " + Str(Res%)
    End If
End Sub

Private Sub DispDets(Res As Integer, StkPriceRec As TBatchStkPriceRec)
    With StkPriceRec
        If (Res% = 0) Then
            List1.AddItem (Trim(.CustCode) + "/" + Trim(.StockCode) + "/" + Trim(.LocCode))
            List1.AddItem ("  Qty: " + Format(.Qty, "##0.00"))
            List1.AddItem ("  Price: " + Format(.Price, "##0.00"))
            List1.AddItem ("  Discount: " + .DiscChar + "/" + Format(.DiscVal, "##0.00"))
        Else
            List1.AddItem (Trim(.CustCode) + "/" + Trim(.StockCode) + "/" + Trim(.LocCode))
            List1.AddItem ("  ERROR: " + Str(Res%))
        End If

        List1.AddItem ("")
    End With ' StkPriceRec
End Sub


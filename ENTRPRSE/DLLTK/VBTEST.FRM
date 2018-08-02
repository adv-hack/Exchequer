VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Exchequer Enterprise Toolkit DLL - VB Record Test Utility"
   ClientHeight    =   3585
   ClientLeft      =   1185
   ClientTop       =   1935
   ClientWidth     =   7710
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   3585
   ScaleWidth      =   7710
   Begin VB.CommandButton Command25 
      Caption         =   "TBatchBinRec"
      Height          =   375
      Left            =   5880
      TabIndex        =   25
      Top             =   2520
      Width           =   1695
   End
   Begin VB.CommandButton Command24 
      Caption         =   "TBatchLinkRec"
      Height          =   375
      Left            =   3960
      TabIndex        =   24
      Top             =   2520
      Width           =   1710
   End
   Begin VB.CommandButton Command23 
      Caption         =   "TBatchSysRec"
      Height          =   375
      Left            =   120
      TabIndex        =   23
      Top             =   2520
      Width           =   1710
   End
   Begin VB.CommandButton Command22 
      Caption         =   "TBatchAutoBankRec"
      Height          =   375
      Left            =   2040
      TabIndex        =   22
      Top             =   2520
      Width           =   1710
   End
   Begin VB.CommandButton Command21 
      Caption         =   "TestProc"
      Height          =   375
      Left            =   105
      TabIndex        =   21
      Top             =   3105
      Width           =   1710
   End
   Begin VB.Frame Frame1 
      Height          =   30
      Left            =   90
      TabIndex        =   20
      Top             =   3000
      Width           =   7500
   End
   Begin VB.CommandButton Command20 
      Caption         =   "TBatchVATRec"
      Height          =   375
      Left            =   5880
      TabIndex        =   19
      Top             =   2040
      Width           =   1710
   End
   Begin VB.CommandButton Command19 
      Caption         =   "TBatchStkPriceRec"
      Height          =   375
      Left            =   5880
      TabIndex        =   18
      Top             =   1560
      Width           =   1710
   End
   Begin VB.CommandButton Command18 
      Caption         =   "TBatchCCDepRec"
      Height          =   375
      Left            =   5880
      TabIndex        =   17
      Top             =   1080
      Width           =   1710
   End
   Begin VB.CommandButton Command17 
      Caption         =   "TBatchNotesRec"
      Height          =   375
      Left            =   5880
      TabIndex        =   16
      Top             =   600
      Width           =   1710
   End
   Begin VB.CommandButton Command16 
      Caption         =   "TBatchMatchRec"
      Height          =   375
      Left            =   5880
      TabIndex        =   15
      Top             =   120
      Width           =   1710
   End
   Begin VB.CommandButton Command15 
      Caption         =   "TBatchMLocRec"
      Height          =   375
      Left            =   3960
      TabIndex        =   14
      Top             =   2025
      Width           =   1710
   End
   Begin VB.CommandButton Command14 
      Caption         =   "TBatchSLRec"
      Height          =   375
      Left            =   3960
      TabIndex        =   13
      Top             =   1560
      Width           =   1710
   End
   Begin VB.CommandButton Command13 
      Caption         =   "TBatchJHRec"
      Height          =   375
      Left            =   3960
      TabIndex        =   12
      Top             =   1080
      Width           =   1710
   End
   Begin VB.CommandButton Command12 
      Caption         =   "TBatchSRRec"
      Height          =   375
      Left            =   3945
      TabIndex        =   11
      Top             =   600
      Width           =   1710
   End
   Begin VB.CommandButton Command11 
      Caption         =   "TBatchBOMLinesRec"
      Height          =   375
      Left            =   3960
      TabIndex        =   10
      Top             =   120
      Width           =   1710
   End
   Begin VB.CommandButton Command10 
      Caption         =   "TBatchBOMRec"
      Height          =   375
      Left            =   2040
      TabIndex        =   9
      Top             =   2040
      Width           =   1710
   End
   Begin VB.CommandButton Command9 
      Caption         =   "TBatchNomRec"
      Height          =   375
      Left            =   2040
      TabIndex        =   8
      Top             =   1560
      Width           =   1710
   End
   Begin VB.CommandButton Command8 
      Caption         =   "THistoryBalRec"
      Height          =   375
      Left            =   2040
      TabIndex        =   7
      Top             =   1080
      Width           =   1710
   End
   Begin VB.CommandButton Command7 
      Caption         =   "TBatchSKRec"
      Height          =   375
      Left            =   2040
      TabIndex        =   6
      Top             =   600
      Width           =   1710
   End
   Begin VB.CommandButton Command6 
      Caption         =   "TSaleBandAry"
      Height          =   375
      Left            =   2040
      TabIndex        =   5
      Top             =   120
      Width           =   1710
   End
   Begin VB.CommandButton Command5 
      Caption         =   "TSaleBandsRec"
      Height          =   375
      Left            =   120
      TabIndex        =   4
      Top             =   2040
      Width           =   1710
   End
   Begin VB.CommandButton Command4 
      Caption         =   "TBatchLines"
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   1560
      Width           =   1710
   End
   Begin VB.CommandButton Command3 
      Caption         =   "TBatchTLRec"
      Height          =   375
      Left            =   105
      TabIndex        =   2
      Top             =   1080
      Width           =   1710
   End
   Begin VB.CommandButton Command2 
      Caption         =   "TBatchTHRec"
      Height          =   375
      Left            =   105
      TabIndex        =   1
      Top             =   600
      Width           =   1710
   End
   Begin VB.CommandButton Command1 
      Caption         =   "TBatchCURec"
      Height          =   375
      Left            =   105
      TabIndex        =   0
      Top             =   120
      Width           =   1710
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Private Sub Command1_Click()
    Dim CU As TBatchCURec
    Dim RecLen As Long
    
    With CU
        ' 1 - CustCode = "A1B2C3"
        .CustCode = "A1B2C3"
        .CustCodeLen = Chr(Len(Trim(.CustCode)))
        
        ' 2 - CustSupp = "D"
        .CustSupp = "D"
        
        ' 3 - VATRegNo = "12345"
        .VATRegNo = "12345"
        .VATRegNoLen = Chr(Len(Trim(.VATRegNo)))
        
        ' 4 - Phone = "aAbBcCdDeE"
        .Phone = "AaBbCcDdEe"
        .PhoneLen = Chr(Len(Trim(.Phone)))
        
        ' 5 - Currency = 587
        .Currency = 587
        
        ' 6 - PayTerms = 1087
        .PayTerms = 1087
        
        ' 7 - Discount = 1259.87
        .Discount = 1259.87
        
        ' 8 - PadChar2 = Chr(253)
        .PadChar2 = Chr(253)
        
        ' 9 - PayType = "R"
        .PayType = "R"
       
        ' 10 - PadChar3 = Chr(254)
        .PadChar3 = Chr(254)
                       
        ' 11 - DefCOSNom = 12394
        .DefCOSNom = 12394
            
        ' 12 - LastChar = Chr(255)
        .LastChar = Chr(255)
    End With

    RecLen = Len(CU)
    Call TESTCU(CU, RecLen)
End Sub

Private Sub Command10_Click()
    Dim BM As TBatchBOMRec
    Dim RecLen As Long
    
    With BM
      .StockCode = "kjhasdiuy"
      .StockCodeLen = Chr(Len(Trim(.StockCode)))
      .QtyCost = 92734.83
      .LastChar = Chr(255)
    End With

    RecLen = Len(BM)
    Call TESTBOM(BM, RecLen)
End Sub

Private Sub Command11_Click()
    Static BOMLines As TBatchBOMLinesRec
    Dim RecLen As Long
    
    For RecLen = LBound(BOMLines.Items) To UBound(BOMLines.Items)
        BOMLines.Items(RecLen).QtyUsed = RecLen + 1
    Next RecLen
        
    RecLen = Len(BOMLines)
    Call TESTBOMLINES(BOMLines, RecLen)
End Sub

Private Sub Command12_Click()
    Dim SR As TBatchSRRec
    Dim RecLen As Long
    
    With SR
      .SerialNo = "2342"
      .SerialNoLen = Chr(Len(Trim(.SerialNo)))
      .PadChar1 = Chr(254)
      .CurSell = 225
      .LastChar = Chr(255)
    End With

    RecLen = Len(SR)
    Call TESTSR(SR, RecLen)
End Sub

Private Sub Command13_Click()
    Dim JH As TBatchJHRec
    Dim RecLen As Long
    
    With JH
      .JobCode = "9812374"
      .JobCodeLen = Chr(Len(Trim(.JobCode)))
      .PadChar2 = Chr(252)
      .PadChar3 = Chr(253)
      .VATCode = Chr(254)
      .LastChar = Chr(255)
    End With

    RecLen = Len(JH)
    Call TESTJH(JH, RecLen)
End Sub

Private Sub Command14_Click()
    Dim SL As TBatchSLRec
    Dim RecLen As Long
    
    With SL
        .lsStkCode = "jlky34d"
        .lsStkCodeLen = Chr(Len(Trim(.lsStkCode)))
        .PadChar1 = Chr(252)
        .lsQtyMax = 122393.83
        .PadChar2 = Chr(253)
        .PadChar3 = Chr(254)
        .LastChar = Chr(255)
    End With

    RecLen = Len(SL)
    Call TESTSL(SL, RecLen)
End Sub

Private Sub Command15_Click()
    Dim ML As TBatchMLocRec
    Dim RecLen As Long
    
    With ML
        .loCode = "QQQ"
        .loCodeLen = Chr(Len(Trim(.loCode)))
        .PadChar1 = Chr(254)
        .loNominal(1) = 53917
        .LastChar = Chr(255)
    End With

    RecLen = Len(ML)
    Call TESTML(ML, RecLen)
End Sub

Private Sub Command16_Click()
    Dim MA As TBatchMatchRec
    Dim RecLen As Long
    
    With MA
      .DebitRef = "DEBIT"
      .DebitRefLen = Chr(Len(Trim(.DebitRef)))
      .CreditCr = -31411
      .BaseVal = 739123.93
      .LastChar = Chr(255)
    End With

    RecLen = Len(MA)
    Call TESTMATCH(MA, RecLen)
End Sub

Private Sub Command17_Click()
    Dim NT As TBatchNotesRec
    Dim RecLen As Long
    
    With NT
      .NoteSort = "AbC"
      .NoteSortLen = Chr(Len(Trim(.NoteSort)))
      .PadChar1 = Chr(254)
      .LastChar = Chr(255)
    End With

    RecLen = Len(NT)
    Call TESTNOTES(NT, RecLen)
End Sub

Private Sub Command18_Click()
    Dim CD As TBatchCCDepRec
    Dim RecLen As Long
    
    With CD
      .CCDepCode = "CCD"
      .CCDepCodeLen = Chr(Len(Trim(.CCDepCode)))
      .CCDepDesc = "Abcdefghij"
      .CCDepDescLen = Chr(Len(Trim(.CCDepDesc)))
      .LastChar = Chr(255)
    End With

    RecLen = Len(CD)
    Call TESTCD(CD, RecLen)
End Sub

Private Sub Command19_Click()
    Dim PR As TBatchStkPriceRec
    Dim RecLen As Long
    
    With PR
      .StockCode = "98wedaASD"
      .StockCodeLen = Chr(Len(Trim(.StockCode)))
      .PadChar1 = Chr(254)
      .Price = -76358.84
      .LastChar = Chr(255)
    End With

    RecLen = Len(PR)
    Call TESTSTKPR(PR, RecLen)
End Sub

Private Sub Command2_Click()
    Dim TH As TBatchTHRec
    Dim RecLen As Long
    
    With TH
        .RunNo = 846
        .FolioNum = 73614
        .AcPr = 769
        .LineCount = 12769
        .DiscAmount = 83732.87
        .PadChar2 = Chr(250) + Chr(251)
        .PadChar3 = Chr(249)
        .TotOrdOS = 37643.12
        .LastChar = Chr(255)
    End With

    RecLen = Len(TH)
    Call TESTTH(TH, RecLen)
End Sub

Private Sub Command20_Click()
    Dim VAT As TBatchVATRec
    Dim RecLen As Long
    
    With VAT
      .VATCode = Chr(252)
      .PadChar1 = Chr(253)
      .VATRate = 34729.34
      .PadChar2 = Chr(254)
      .LastChar = Chr(255)
    End With

    RecLen = Len(VAT)
    Call TESTVAT(VAT, RecLen)
End Sub

Private Sub Command21_Click()
    Dim P As ArrayType
    Dim Recs(1 To 100)  As ArrayRecType
    Dim PSIZE As Long, I%
        
    For I = LBound(Recs) To UBound(Recs)
        With Recs(I)
            .NumStr = Trim(Str(I))
            .NumStrLen = Chr(Len(.NumStr))
        End With
    Next I
        
    PSIZE = Len(P)
    Call TESTARRAY(Recs, PSIZE)
End Sub

Private Sub Command22_Click()
    'Static ABRec As TBatchAutoBankRec
    'Dim RecLen As Long
    
    'ABRec.LastChar = Chr(255)
        
    'RecLen = Len(ABRec)
    'Call TESTAUTOBANK(ABRec, RecLen)
End Sub

Private Sub Command23_Click()
    Static SysRec As TBatchSysRec
    Dim RecLen As Long
    
    SysRec.UserName = "AaBbCc"
    SysRec.UserNameLen = Chr(Len(Trim(SysRec.UserName)))
    
    SysRec.UserSort = "123456"
    SysRec.UserSortLen = Chr(Len(Trim(SysRec.UserSort)))
    
    SysRec.ExPr = 31985

    SysRec.LastChar = Chr(255)
        
    RecLen = Len(SysRec)
    Call TESTSYS(SysRec, RecLen)
End Sub

Private Sub Command24_Click()
    Dim LinkR As TBatchLinkRec
    
    Call EX_INITLINK(LinkR, Len(LinkR))
    With LinkR
        .LastChar = Chr(255)
    End With ' LinkR

    Call TESTLINK(LinkR, Len(LinkR))
End Sub

Private Sub Command25_Click()
    Dim BinRec As TBatchBinRec
    Dim RecLen As Long
    
    With BinRec
        .brBinCode = "A1B2C3D4E5"
        .brBinCodeLen = Chr(Len(Trim(.brBinCode)))
        .brSold = 1
        .brOutDate = "20030101"
        .brOutDateLen = Chr(Len(Trim(.brOutDate)))
        .brInDocLine = 27
        .brCostPriceCurrency = 587
        .brSalesPrice = 1259.87
        .PadChar7 = Chr(253)
        .brTagNo = 767
        .LastChar = Chr(255)
    End With

    RecLen = Len(BinRec)
    Call TESTBIN(BinRec, RecLen)

End Sub

Private Sub Command3_Click()
    Dim TL As TBatchTLRec
    Dim RecLen As Long
    
    With TL
        .TransRefNo = "AbCdEf"
        .TransRefNoLen = Chr(Len(Trim(.TransRefNo)))
        .CoRate = 984719.86
        .Qty = 9.42
        .VAT = 17.51
        .CostPrice = 128.99
        .MLocStk = "123"
        .MLocStkLen = Chr(Len(Trim(.MLocStk)))
        .LastChar = Chr(255)
    End With

    RecLen = Len(TL)
    Call TESTTL(TL, RecLen)
End Sub

Private Sub Command4_Click()
    Static TLines As TBatchLinesRec
    Dim RecLen As Long
    
    For RecLen = LBound(TLines.Lines) To UBound(TLines.Lines)
        TLines.Lines(RecLen).LineNo = RecLen + 1
    Next RecLen
        
    ' Note: following 2 lines cause overflow if merged!
    RecLen = Len(TLines)
    Call TESTTLINES(TLines, RecLen)
End Sub

Private Sub Command5_Click()
    Dim SB As TSaleBandsRec
    Dim RecLen As Long
    
    With SB
        .Currency = 1111
        .PadChar1 = Chr(253)
        .SalesPrice = 84873.42
        .PadChar2 = Chr(254)
        .LastChar = Chr(255)
    End With

    RecLen = Len(SB)
    Call TESTSB(SB, RecLen)
End Sub

Private Sub Command6_Click()
    Dim SA As TSaleBandAry
    Dim RecLen As Long
    
    For RecLen = LBound(SA.Band) To UBound(SA.Band)
        SA.Band(RecLen).Currency = RecLen + 1
    Next RecLen
        
    RecLen = Len(SA)
    Call TESTSA(SA, RecLen)
End Sub

Private Sub Command7_Click()
    Dim SK As TBatchSKRec
    Dim RecLen As Long
    
    With SK
        .StockCode = "1234567890123456"
        .StockCodeLen = Chr(Len(Trim(.StockCode)))
        .PadChar1 = Chr(244)
        .PadChar2 = Chr(245)
        .CostPrice = 98472.84
        .PadChar3 = Chr(246)
        .PadChar4 = Chr(247)
        .PadChar5 = Chr(248)
        .PadChar6 = Chr(249)
        .PadChar7 = Chr(250)
        .PadChar8 = Chr(251)
        .PadChar9 = Chr(252)
        .StLocation = "AbC"
        .StLocationLen = Chr(Len(Trim(.StLocation)))
        .PadChar11 = Chr(253)
        .LastChar = Chr(255)
    End With

    RecLen = Len(SK)
    Call TESTSK(SK, RecLen)
End Sub

Private Sub Command8_Click()
    Dim HB As THistoryBalRec
    Dim RecLen As Long
    
    With HB
      .PadChar1 = Chr(253)
      .PadChar2 = Chr(254)
      .LastChar = Chr(255)
    End With

    RecLen = Len(HB)
    Call TESTHB(HB, RecLen)
End Sub

Private Sub Command9_Click()
    Dim NM As TBatchNomRec
    Dim RecLen As Long
    
    With NM
        .NomCode = 98237
        .PadChar1 = Chr(252)
        .PadChar2 = Chr(253)
        .Spare = Chr(254)
        .LastChar = Chr(255)
    End With

    RecLen = Len(NM)
    Call TESTNM(NM, RecLen)
End Sub


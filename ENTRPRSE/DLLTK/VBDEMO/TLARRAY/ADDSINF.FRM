VERSION 5.00
Begin VB.Form frmTLArray 
   Caption         =   "Transaction Line Array Demo"
   ClientHeight    =   6405
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8520
   LinkTopic       =   "Form1"
   ScaleHeight     =   6405
   ScaleWidth      =   8520
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame1 
      Caption         =   "Read Transaction"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   5415
      Index           =   1
      Left            =   75
      TabIndex        =   3
      Top             =   915
      Width           =   8400
      Begin VB.TextBox edtPeriodYear 
         Height          =   375
         Left            =   4245
         TabIndex        =   23
         Top             =   1215
         Width           =   1050
      End
      Begin VB.TextBox edtYourRef 
         Height          =   375
         Left            =   4245
         TabIndex        =   20
         Top             =   1620
         Width           =   1845
      End
      Begin VB.TextBox edtAltRef 
         Height          =   375
         Left            =   4245
         TabIndex        =   19
         Top             =   2025
         Width           =   1830
      End
      Begin VB.TextBox edtDueDate 
         Height          =   375
         Left            =   1365
         TabIndex        =   17
         Top             =   2025
         Width           =   1455
      End
      Begin VB.TextBox edtTransDate 
         Height          =   375
         Left            =   1365
         TabIndex        =   15
         Top             =   1620
         Width           =   1455
      End
      Begin VB.TextBox edtOperator 
         Height          =   375
         Left            =   4245
         TabIndex        =   14
         Top             =   810
         Width           =   1440
      End
      Begin VB.CommandButton btnNextTrans 
         Caption         =   "Next Transaction"
         Height          =   495
         Left            =   6225
         TabIndex        =   13
         Top             =   1560
         Width           =   2010
      End
      Begin VB.CommandButton btnPrevTrans 
         Caption         =   "Previous Transaction"
         Height          =   495
         Left            =   6225
         TabIndex        =   12
         Top             =   540
         Width           =   2010
      End
      Begin VB.TextBox edtACCode 
         Height          =   375
         Left            =   1365
         TabIndex        =   8
         Top             =   1215
         Width           =   1455
      End
      Begin VB.TextBox edtCode 
         Height          =   375
         Left            =   1365
         TabIndex        =   7
         Top             =   810
         Width           =   1455
      End
      Begin VB.ListBox List_TransLines 
         BeginProperty Font 
            Name            =   "Courier New"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   2790
         Left            =   90
         TabIndex        =   6
         Top             =   2475
         Width           =   8175
      End
      Begin VB.CommandButton btnReadTrans 
         Caption         =   "Find Transaction"
         Height          =   495
         Left            =   6225
         TabIndex        =   4
         Top             =   1050
         Width           =   2010
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Operator"
         Height          =   255
         Index           =   9
         Left            =   2985
         TabIndex        =   25
         Top             =   885
         Width           =   1185
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Period/Year"
         Height          =   255
         Index           =   8
         Left            =   3000
         TabIndex        =   24
         Top             =   1275
         Width           =   1185
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Your Ref"
         Height          =   255
         Index           =   7
         Left            =   3000
         TabIndex        =   22
         Top             =   1665
         Width           =   1185
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Alt Ref"
         Height          =   255
         Index           =   5
         Left            =   3000
         TabIndex        =   21
         Top             =   2070
         Width           =   1185
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Due"
         Height          =   255
         Index           =   3
         Left            =   120
         TabIndex        =   18
         Top             =   2085
         Width           =   1185
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Date"
         Height          =   255
         Index           =   6
         Left            =   120
         TabIndex        =   16
         Top             =   1680
         Width           =   1185
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "A/C Code"
         Height          =   255
         Index           =   4
         Left            =   105
         TabIndex        =   11
         Top             =   1290
         Width           =   1200
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Transaction Ref"
         Height          =   255
         Index           =   2
         Left            =   105
         TabIndex        =   10
         Top             =   885
         Width           =   1200
      End
      Begin VB.Label lblLines 
         Alignment       =   1  'Right Justify
         Caption         =   "Line Count"
         Height          =   255
         Left            =   6810
         TabIndex        =   9
         Top             =   2175
         Width           =   1410
      End
      Begin VB.Label Label1 
         Caption         =   $"AddSINF.frx":0000
         Height          =   435
         Index           =   1
         Left            =   120
         TabIndex        =   5
         Top             =   300
         Width           =   6015
         WordWrap        =   -1  'True
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "Add Sales Invoice"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   825
      Index           =   0
      Left            =   60
      TabIndex        =   0
      Top             =   45
      Width           =   8400
      Begin VB.CommandButton btnAddSIN 
         Caption         =   "Add SIN"
         Height          =   495
         Left            =   6225
         TabIndex        =   1
         Top             =   210
         Width           =   2010
      End
      Begin VB.Label Label1 
         Caption         =   "Adds a Sales Invoice of 100 lines using the Transaction Line Array functions to get around the memory limitations in Visual Basic."
         Height          =   435
         Index           =   0
         Left            =   75
         TabIndex        =   2
         Top             =   300
         Width           =   6045
         WordWrap        =   -1  'True
      End
   End
End
Attribute VB_Name = "frmTLArray"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
    
Dim ArrayI As TLArrayInfoType

Private Sub btnAddSIN_Click()
    Dim TH As TBatchTHRec
    Dim TL As TBatchTLRec
    Dim Res%, I%, PSIZE&
    
    ' Re-Initialise the TL Array - avoids having to destroy and recreate it!
    With ArrayI
        .NumTL = 0              ' Number of lines in array
        .UsedSize = 0           ' Memory used by lines in array
    End With
        
    ' Init new TH record
    Res% = EX_INITTH(TH, Len(TH))
    With TH
        ' Assuming Overwrite_Trans_No is ON
        .OurRef = "SIN"
        .OurRefLen = Chr(Len(Trim(.OurRef)))

        .CustCode = "ACCO01"
        .CustCodeLen = Chr(Len(Trim(.CustCode)))
            
        .YourRef = "Wibble"
        .YourRefLen = Chr(Len(Trim(.YourRef)))
            
        .Currency = 1
        .AcYr = Year(Now) - 1900
        .AcPr = Month(Now)
    
        ' Transaction Date - Today
        .TransDate = Format$(Year(Now), "0000") + Format$(Month(Now), "00") + Format$(Day(Now), "00")
        .TransDateLen = Chr(Len(Trim(.TransDate)))

        ' Due Date - 1 Month
        .DueDate = Format$(Year(Now + 30), "0000") + Format$(Month(Now + 30), "00") + Format$(Day(Now + 30), "00")
        .DueDateLen = Chr(Len(Trim(.DueDate)))
    
        ' Company Currency Rate
        .CoRate = 1
        .DailyRate = 1#     ' formerly VATRate
    
        .TransDocHed = "SIN"
        .TransDocHedLen = Chr(Len(Trim(.TransDocHed)))
            
        .OpName = "EXTERN"
        .OpNameLen = Chr(Len(Trim(.OpName)))
    End With ' TH
   
    For I% = 1 To 100
        ' Init new TL record
        Res% = EX_INITTL(TL, Len(TL))
        
        TH.LineCount = TH.LineCount + 1
            
        With TL
            ' Line Number
            .LineNo = I%

            ' Nominal Code
            .NomCode = 10010
    
            ' Currency
            .Currency = TH.Currency
            .TSHCCurr = TH.Currency
            .CoRate = TH.CoRate
            .DailyRate = TH.DailyRate
       
            ' Quantity
            .Qty = 1#
            .QtyMul = 1#
    
            ' VAT
            .VATCode = "Z"    ' Standard
            .VAT = 0#
   
            ' customer
            .CustCodeLen = TH.CustCodeLen
            .CustCode = TH.CustCode
    
            ' Transaction Date
            .LineDateLen = TH.TransDateLen
            .LineDate = TH.TransDate

            ' Line Description
            .Desc = "Line: " + Str(I%)
            .DescLen = Chr(Len(Trim(.Desc)))
        End With ' TL
        
        ' Update transaction header for line details
        'TH.InvNetVal = TH.InvNetVal + (TL.Qty * TL.NetValue)
        'TH.InvVat = TH.InvVat + TL.VAT
        
        Res% = EX_ADDTLARRAYLINE(ArrayI, TL)
        If (Res <> 0) Then MsgBox "EX_ADDTLARRAYLINE: " + Str(Res%)
    Next I%
    
    ' Finalise Transaction details
    TH.InvVatAnal(0) = TH.InvVat
    
    ' Add Transaction
    Res% = EX_STORETLARRAY(TH, ArrayI.TLArray, Len(TH), ArrayI.UsedSize, 0, B_Insert%)
    If (Res% <> 0) Then MsgBox "EX_STORETLARRAY: " + Str(Res%)
      
    ' Automatically Load and Display the new transaction
    edtCode.Text = TH.OurRef
    LoadTrans (B_GetGEq)
End Sub

Private Sub LoadTrans(SearchMode%)
    Dim TH As TBatchTHRec
    Dim TL As TBatchTLRec
    Dim SearchKey As String * 255, strStockCode As String * 16
    Dim Res%, I%, PSIZE&
    Dim LineStr$, TmpDesc As String * 30, TmpQty As String * 10
    
    
    ' Build key for transaction
    SearchKey = edtCode.Text + Chr(0)

    ' Retrieve the transaction
    Res% = EX_GETTLARRAY(TH, Len(TH), ArrayI, SearchKey, 0, SearchMode%, DllFalse%)

    ' Check to see if a record was returned OK
    If (Res = 0) Then
        ' Display the Transaction Header Details
        edtCode.Text = TH.OurRef
        edtOperator.Text = Left(TH.OpName, Asc(TH.OpNameLen))
        edtACCode.Text = TH.CustCode
        edtTransDate.Text = Right(TH.TransDate, 2) + "/" + Mid(TH.TransDate, 5, 2) + "/" + Left(TH.TransDate, 4)
        edtDueDate.Text = Right(TH.DueDate, 2) + "/" + Mid(TH.DueDate, 5, 2) + "/" + Left(TH.DueDate, 4)
        edtPeriodYear.Text = Format(TH.AcPr, "00") + "/" + Format(TH.AcYr + 1900, "0000")
        edtYourRef.Text = Left(TH.YourRef, Asc(TH.YourRef))
        edtAltRef.Text = Left(TH.LongYrRef, Asc(TH.LongYrRef))
        lblLines.Caption = Str(TH.LineCount) + " lines found"
            
        ' Reset the list each time a new invoice is displayed.
        List_TransLines.Clear
            
        ' Run though the TLArray displaying any lines retrieved

        If (TH.LineCount > 0) Then
            For I = 1 To TH.LineCount
                ' Get line from TL Array
                Res% = EX_GETTLARRAYLINE(ArrayI, TL, Len(TL), I)
            
                If (Res% = 0) Then
                    With TL
                        ' Stock Code - can be blank in some SOP Transactions - ensure paddded to 16 for display
                        If (Asc(.StockCodeLen) > 0) Then
                            strStockCode = Left(.StockCode, Asc(.StockCodeLen))
                        Else
                            strStockCode = ""
                        End If
                        strStockCode = strStockCode + String$(16, " ")
                            
                        ' Line Description
                        TmpDesc$ = Left(.Desc, Asc(.DescLen))
                            
                        If (.Qty <> 0#) Then
                            TmpQty$ = Format(.Qty, "###0.00")
                        Else
                            TmpQty$ = ""
                        End If
                        LineStr$ = strStockCode + "   " + TmpQty$ + "   " + TmpDesc$
        
                        If (.NetValue <> 0#) Then
                            LineStr$ = LineStr$ + "   " + Format(.NetValue, "###,##0.00")
                        End If
        
                        List_TransLines.AddItem LineStr$
                    End With ' TL
                Else
                    MsgBox "EX_GETTLARRAYLINE called, status " + Str(Res%)
                End If ' (Res% = 0)
            Next I ' 1 To TH.LineCount
        End If ' (TH.LineCount > 0)
    Else
        MsgBox "EX_GETTLARRAY called, status " + Str(Res%)
    End If ' (Res = 0)
End Sub

Private Sub btnNextTrans_Click()
    Call LoadTrans(B_GetNext%)
End Sub

Private Sub btnPrevTrans_Click()
    Call LoadTrans(B_GetPrev%)
End Sub

Private Sub btnReadTrans_Click()
    Call LoadTrans(B_GetGEq%)
End Sub

Private Sub Form_Load()
    Dim Res%
    
    Res% = EX_INITDLL%()
    If (Res% = 0) Then
        ' DLL Initialised - Create a TLArray of 1000 elements - Uses approx 512K of memory
        Res% = EX_CREATETLARRAY(1000, ArrayI)
        If (Res% <> 0) Then MsgBox "EX_CREATETLARRAY: " + Str(Res%)
    Else
        MsgBox "EX_INITDLL: " + Str(Res%)
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim Res%
    
    ' De-Allocate the TLArray
    Call EX_DESTROYTLARRAY(ArrayI)

    ' Closedown the Toolkit DLL
    Res% = EX_CLOSEDLL%()
    If (Res% <> 0) Then MsgBox "EX_CLOSEDLL: " + Str(Res%)
End Sub

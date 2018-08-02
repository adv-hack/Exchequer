VERSION 5.00
Begin VB.Form Form_Transaction 
   Appearance      =   0  'Flat
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Exchequer Enterprise Toolkit DLL - Transaction Demo"
   ClientHeight    =   4350
   ClientLeft      =   300
   ClientTop       =   1845
   ClientWidth     =   8595
   FillColor       =   &H00FF0000&
   BeginProperty Font 
      Name            =   "MS Sans Serif"
      Size            =   8.25
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H80000008&
   Icon            =   "TRANSACT.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   4350
   ScaleWidth      =   8595
   Begin VB.CommandButton btnMatching 
      Appearance      =   0  'Flat
      Caption         =   "Matching"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Left            =   6015
      TabIndex        =   10
      Top             =   1650
      Width           =   1050
   End
   Begin VB.TextBox Text_Ccy 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   5820
      MaxLength       =   9
      TabIndex        =   8
      Top             =   1260
      Width           =   405
   End
   Begin VB.CommandButton btnDelivery 
      Appearance      =   0  'Flat
      Caption         =   "Delivery"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Left            =   4920
      TabIndex        =   9
      Top             =   1650
      Width           =   1050
   End
   Begin VB.CommandButton btnViewAcc 
      Appearance      =   0  'Flat
      Caption         =   ".."
      Height          =   300
      Left            =   1815
      TabIndex        =   1
      Top             =   900
      Width           =   180
   End
   Begin VB.TextBox Text_AltRef 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   2880
      MaxLength       =   20
      TabIndex        =   6
      Top             =   1605
      Width           =   1770
   End
   Begin VB.TextBox Text_YourRef 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   2880
      MaxLength       =   10
      TabIndex        =   5
      Top             =   1260
      Width           =   1770
   End
   Begin VB.TextBox Text_PerYr 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   2880
      MaxLength       =   6
      TabIndex        =   4
      Top             =   900
      Width           =   630
   End
   Begin VB.TextBox Text_DueDate 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   615
      MaxLength       =   10
      TabIndex        =   3
      Top             =   1605
      Width           =   1200
   End
   Begin VB.TextBox Text_TransDate 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   615
      MaxLength       =   10
      TabIndex        =   2
      Top             =   1260
      Width           =   1200
   End
   Begin VB.TextBox Text_AcCode 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   615
      MaxLength       =   6
      TabIndex        =   0
      Top             =   915
      Width           =   1200
   End
   Begin VB.Frame Frame1 
      Appearance      =   0  'Flat
      Caption         =   " Transaction Functions"
      ForeColor       =   &H80000008&
      Height          =   735
      Index           =   1
      Left            =   90
      TabIndex        =   29
      Top             =   45
      Width           =   8430
      Begin VB.Label Label2 
         Appearance      =   0  'Flat
         Caption         =   "These functions allow you to retrieve existing Transactions within Exchequer or Exchequer Enterprise and to add new transactions. "
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000008&
         Height          =   450
         Index           =   1
         Left            =   75
         TabIndex        =   27
         Top             =   240
         Width           =   8265
      End
   End
   Begin VB.ListBox List1 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1605
      Left            =   105
      TabIndex        =   11
      Top             =   2010
      Width           =   6945
   End
   Begin VB.Frame Frame1 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   30
      Index           =   0
      Left            =   90
      TabIndex        =   26
      Top             =   3915
      Width           =   8430
   End
   Begin VB.Frame Frame2 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   2115
      Left            =   7215
      TabIndex        =   18
      Top             =   825
      Width           =   1305
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "First"
         Height          =   375
         Index           =   0
         Left            =   60
         TabIndex        =   12
         Top             =   150
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Previous"
         Height          =   375
         Index           =   1
         Left            =   60
         TabIndex        =   13
         Top             =   525
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Find"
         Height          =   375
         Index           =   2
         Left            =   60
         TabIndex        =   14
         Top             =   900
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Next"
         Height          =   375
         Index           =   3
         Left            =   60
         TabIndex        =   15
         Top             =   1275
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Last"
         Height          =   375
         Index           =   4
         Left            =   60
         TabIndex        =   16
         Top             =   1650
         Width           =   1170
      End
   End
   Begin VB.Frame Frame3 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   855
      Left            =   7215
      TabIndex        =   25
      Top             =   2985
      Width           =   1305
      Begin VB.CommandButton btnAddTrans 
         Appearance      =   0  'Flat
         Caption         =   "&Close"
         Height          =   315
         Index           =   1
         Left            =   60
         TabIndex        =   32
         Top             =   465
         Width           =   1170
      End
      Begin VB.CommandButton btnAddTrans 
         Appearance      =   0  'Flat
         Caption         =   "&Add"
         Height          =   315
         Index           =   0
         Left            =   60
         TabIndex        =   17
         Top             =   150
         Width           =   1170
      End
   End
   Begin VB.TextBox Text_OurRef 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   5820
      MaxLength       =   9
      TabIndex        =   7
      Top             =   900
      Width           =   1155
   End
   Begin VB.Label Label10 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Alt. Ref"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   240
      Left            =   2100
      TabIndex        =   28
      Top             =   1635
      Width           =   720
   End
   Begin VB.Label Label9 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Per/Yr"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   195
      Left            =   2115
      TabIndex        =   31
      Top             =   945
      Width           =   720
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Your Ref"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   240
      Left            =   2100
      TabIndex        =   30
      Top             =   1290
      Width           =   720
   End
   Begin VB.Label lblResult 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   240
      Left            =   75
      TabIndex        =   19
      Top             =   4020
      Width           =   8415
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "OurRef"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   270
      Left            =   4905
      TabIndex        =   24
      Top             =   945
      Width           =   855
   End
   Begin VB.Label Label4 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Date"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   240
      Left            =   120
      TabIndex        =   23
      Top             =   1290
      Width           =   450
   End
   Begin VB.Label Label5 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "A/C"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   195
      Left            =   120
      TabIndex        =   22
      Top             =   945
      Width           =   450
   End
   Begin VB.Label Label6 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Due"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   240
      Left            =   120
      TabIndex        =   21
      Top             =   1635
      Width           =   450
   End
   Begin VB.Label Label7 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Currency"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   240
      Left            =   4920
      TabIndex        =   20
      Top             =   1290
      Width           =   855
   End
End
Attribute VB_Name = "Form_Transaction"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const Capt_Add = "&Add"
Const Capt_Save = "&Save"
Const Capt_Close = "&Close"
Const Capt_Cancel = "&Cancel"

Dim OrigCode$, Editing As Integer
Dim DLLLoaded%, IsSin%

Private Sub btnAddTrans_Click(Index As Integer)
    Dim LineLen&, HedLen&, Result%

    lblResult.Caption = ""
    
    Select Case Index%
        Case 0  ' Add/Save
            If (btnAddTrans(0).Caption = Capt_Add) Then
                ' Add
                Editing = False
                btnAddTrans(0).Caption = Capt_Save
                btnAddTrans(1).Caption = Capt_Cancel

                OrigCode$ = HeaderRec.OurRef

                ' Initialise records to default values
                Call NewTrans

                ' display record
                Call DisplayTrans

                Call EnableForAdd(True)
            Else
                ' Save
                HeaderRec.CustCode = Text_AcCode.Text
                HeaderRec.CustCodeLen = Chr(Trim(Len(HeaderRec.CustCode)))
                TranLines.Lines(0).CustCode = HeaderRec.CustCode
                TranLines.Lines(0).CustCodeLen = HeaderRec.CustCodeLen
                
                HeaderRec.YourRef = Text_YourRef.Text
                HeaderRec.YourRefLen = Chr(Len(Trim(HeaderRec.YourRef)))
                
                HeaderRec.LongYrRef = Text_AltRef.Text
                HeaderRec.LongYrRefLen = Chr(Len(Trim(HeaderRec.LongYrRef)))

                ' Add through Toolkit DLL
                HedLen = Len(HeaderRec)
                LineLen = Len(TranLines)
                Result% = EX_STORETRANS(HeaderRec, TranLines, HedLen, LineLen, 0, B_Insert%)

                If (Result% = 0) Then
                    lblResult.Caption = "Transaction Stored OK"

                    btnAddTrans(0).Caption = Capt_Add
                    btnAddTrans(1).Caption = Capt_Close

                    Call EnableForAdd(False)
                Else
                    lblResult.Caption = "Error " + Str(Result%) + " occurred storing the transaction"
                End If
            End If

        Case 1  ' Close/Cancel
            If (btnAddTrans(1).Caption = Capt_Close) Then
                ' Close
                End
            Else
                ' Cancel Add
                btnAddTrans(0).Caption = Capt_Add
                btnAddTrans(1).Caption = Capt_Close
                
                Call EnableForAdd(False)

                Text_OurRef.Text = OrigCode$
                Call Command1_Click(2)
            End If

    End Select
    
    Command1(0).Enabled = (btnAddTrans(0).Caption = Capt_Add)
    Command1(1).Enabled = Command1(0).Enabled
    Command1(2).Enabled = Command1(0).Enabled
    Command1(3).Enabled = Command1(0).Enabled
    Command1(4).Enabled = Command1(0).Enabled
End Sub

Private Sub btnDelivery_Click()
    Form_Delivery.Show 1
End Sub

' Gets the matching information for the sales transaction
' Gets and displays the SRC matching information
Private Sub btnMatching_Click()
    Dim MatchInfo As TBatchMatchRec
    Dim PChar As String * 255
    Dim Result%, RecLen&


    RecLen& = Len(MatchInfo)
    PChar$ = HeaderRec.OurRef + Chr(0)
    Result% = EX_GETMATCH(MatchInfo, RecLen&, PChar$, 0, B_GetGEq, DllFalse%)
    Do While (MatchInfo.DebitRef = HeaderRec.OurRef)
        If (Result = 0) And (Mid(MatchInfo.CreditRef, 1, 3) = "SRC") Then
            ' Have a sales receipt - display info and carry on incase it wasn't paid in full
            MsgBox "Invoice " + HeaderRec.OurRef + " was paid off by " + MatchInfo.CreditRef
        End If
    
        Result% = EX_GETMATCH(MatchInfo, RecLen&, PChar$, 0, B_GetNext, DllFalse%)
    Loop
End Sub

Private Sub btnViewAcc_Click()
    Form_TransAcc.Show 1

    Call DisplayTrans
End Sub

' Calculates various global values and adjusts the window accordingly
Private Sub CalcGlobs()
    Select Case HeaderRec.TransDocHed
        Case "ADJ"  ' Stock Adjustment
            AccFlag% = AcType_Any%

        Case "NOM"  ' Nominal Transfer
            AccFlag% = AcType_Any%

        ' Purchase Transactions
        Case "PBT", "PCR", "PDN", "PIN", "PJI", "POR", "PQU", "PRF", "PPI", "PPY"
            AccFlag% = AcType_Supp%

        ' Sales Transactions
        Case "SBT", "SCR", "SDN", "SIN", "SJI", "SOR", "SQU", "SRC", "SRF", "SRI"
            AccFlag% = AcType_Cust%

            IsSin% = (HeaderRec.TransDocHed = "SIN")
        
        ' Timesheet
        Case "TSH"
            AccFlag% = AcType_Any%

        Case Else
            ' Unknown Transaction Type
            AccFlag% = AcType_Any%
    End Select

    ' Disable the Customer/Supplier popup
    btnViewAcc.Enabled = (AccFlag% <> AcType_Any%)
    btnMatching.Enabled = IsSin%
End Sub

Private Sub Command1_Click(Index As Integer)
    Dim LineLen&, HedLen&
    Dim PChar$, ActStr$, BtrMode%, Result%

    PChar$ = Text_OurRef.Text + String$(255, 0)
    
    Select Case Index%
        Case 0 ' First
            BtrMode% = B_GetFirst%
            ActStr$ = "First"
        Case 1 ' Previous
            BtrMode% = B_GetPrev%
            ActStr$ = "Previous"
        Case 2 ' Find
            BtrMode% = B_GetGEq%
            ActStr$ = "First"
        Case 3 ' Next
            BtrMode% = B_GetNext%
            ActStr$ = "Next"
        Case 4 ' Last
            BtrMode% = B_GetLast%
            ActStr$ = "Last"
    End Select

    HedLen = Len(HeaderRec)
    LineLen = Len(TranLines)
    Result% = EX_GETTRANS(HeaderRec, TranLines, HedLen, LineLen, PChar$, 0, BtrMode%, DllFalse%)
    
    lblResult.Caption = ""

    If Result% = 0 Then
        Call DisplayTrans
    Else
        Select Case Result%
            Case 9 ' End Of File
                lblResult.Caption = "The End Of file has been reached"
            Case Else
                If (Index = 2) Then
                    lblResult.Caption = "An error " + Str(Result%) + " occurred trying to find '" + Text_OurRef.Text + "'"
                Else
                    lblResult.Caption = "An error " + Str(Result%) + " occurred reading the " + ActStr$ + " record"
                End If
        End Select
    End If
End Sub

Private Sub DisplayTrans()
    Dim LineStr As String, I As Integer, TmpStr As String
    
    Call CalcGlobs

    ' Customer/Supplier Account Code
    If btnViewAcc.Enabled Then
        Text_AcCode.Text = Trim(HeaderRec.CustCode)
    Else
        Text_AcCode.Text = ""
    End If

    ' Transaction Date
    Text_TransDate.Text = ConvDate(HeaderRec.TransDate)

    ' Due/Delivery Date
    Text_DueDate.Text = ConvDate(HeaderRec.DueDate)

    ' Period & Year
    Text_PerYr.Text = Format$(HeaderRec.AcPr, "00") + "/" + Format$(HeaderRec.AcYr, "00")

    ' Your Ref
    Text_YourRef.Text = HeaderRec.YourRef

    ' Alt Ref
    Text_AltRef.Text = HeaderRec.LongYrRef

    ' Transaction Reference Number
    Text_OurRef.Text = Trim(HeaderRec.OurRef)

    ' Currency
    Text_Ccy.Text = Str(HeaderRec.Currency)

    ' Clear and existing detail lines from list
    List1.Clear
    If (HeaderRec.LineCount > 0) Then
        ' display lines
        For I% = 1 To HeaderRec.LineCount
            ' Stock Code
            If (Trim(TranLines.Lines(I - 1).StockCode) <> "") And (Asc(Left$(TranLines.Lines(I - 1).StockCodeLen, 1)) > 0) Then
                LineStr = TranLines.Lines(I - 1).StockCode
            Else
                ' non-stock line
                LineStr = String(16, 32)
            End If
            
            LineStr = LineStr + "  "

            ' Qty
            If (TranLines.Lines(I - 1).Qty <> 0) Then
                ' convert Quantity to string
                TmpStr = Format(TranLines.Lines(I - 1).Qty, "##0.00")

                If (Len(TmpStr) < 6) Then
                    ' Pad qty to 6 characters
                    TmpStr = String(6 - Len(TmpStr), 32) + TmpStr
                End If
            Else
                TmpStr = String(6, 32)
            End If
            LineStr = LineStr + TmpStr + "  "

            ' Description
            LineStr = LineStr + Left(TranLines.Lines(I - 1).Desc, Asc(TranLines.Lines(I - 1).DescLen))

            List1.AddItem LineStr$
        Next
    End If
End Sub

' Enables fields for the Add Transaction State
Private Sub EnableForAdd(Enab%)
    ' Customer Code
    Text_AcCode.Enabled = Enab%
    btnViewAcc.Enabled = Not Enab%

    ' Transaction References
    Text_OurRef.Enabled = Not Enab%
    Text_YourRef.Enabled = Enab%
    Text_AltRef.Enabled = Enab%

    ' Delivery Address
    btnDelivery.Enabled = Not Enab%
    btnMatching.Enabled = Not Enab% And IsSin%

    If Enab% Then
        ' set focus to first control
        Text_AcCode.SetFocus
    End If
End Sub

Private Sub Form_Load()
    ' Position window centrally on the screen
    Left = (Screen.Width - Width) / 2
    Top = (Screen.Height - Height) / 2
    
    ' Initialise the Toolkit DLL
    DLLLoaded% = EX_INITDLL()
    
    If DLLLoaded% <> 0 Then
        ' failed to startup correctly
        MsgBox "An error " + Str(DLLLoaded%) + " occurred when calling EX_INITDLL.", 16
    Else
        ' load the first transaction
        Text_OurRef.Text = "SIN"
        Command1_Click (2)
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim Result%

    ' Check the DLL Loaded OK
    If DLLLoaded% = 0 Then
        ' De-Initialise the Toolkit DLL
        Result% = EX_CLOSEDLL()
        
        If Result% <> 0 Then
            ' An error has occurred
            MsgBox "An error " + Str(Result%) + " occurred when calling EX_CLOSEDLL.", 16
        End If
    End If
End Sub

Private Function GetTotalLines(TransRef As String) As Long
    Dim DocRef As String * 255
    Dim Res&

    DocRef = TransRef$ + Chr(0)
    Res& = EX_GETTOTALTRANSLINES(DocRef$)

    If (Res& > 0) Then
        ' AOK
        GetTotalLines& = Res&
    Else
        ' Error
        GetTotalLines& = 0
    End If
End Function

Private Sub Label3_Click()
    Dim RefStr$
    
    RefStr$ = Text_OurRef.Text
    If TransactionExists(RefStr$) Then
        MsgBox "Transaction Exists"
    Else
        MsgBox "No sush Transaction Exists"
    End If
End Sub

' Display a list of Serial Numbers for the current line
Private Sub List1_DblClick()
    
    MsgBox "Serial Number's cannot be displayed because of memory problems in Visual Basic 5" + Chr(10) + Chr(13) + Chr(10) + Chr(13) + "See List1.DblClick in TransAct.Frm for an example.", 48
    
    'Static SNoList As TBatchSRLinesRec
    'Dim Res%, LSize&, PChar As String * 255, I%

    'If (List1.ListIndex >= 0) Then
    '    ' re-initialise the array - as stored in heap to save stack space
    '    For I = LBound(SNoList.Lines) To UBound(SNoList.Lines)
    '        SNoList.Lines(I).SerialNo = ""
    '        SNoList.Lines(I).SerialNoLen = Chr(0)
    '    Next I
    '
    '    ' Get the Serial Numbers
    '    LSize& = Len(SNoList)
    '    PChar$ = HeaderRec.OurRef + Chr(0)
    '    Res% = EX_GETLINESERIALNOS(SNoList, LSize&, PChar$, TranLines.Lines(List1.ListIndex).LineNo, 0)
    '
    '    If (Res% = 0) Then
    '        ' Got Serial Numbers OK
    '        Form_SerialNo.lblStock.Caption = TranLines.Lines(List1.ListIndex).StockCode
    '        Form_SerialNo.List1.Clear
    '        For I = LBound(SNoList.Lines) To UBound(SNoList.Lines)
    '            Form_SerialNo.List1.AddItem SNoList.Lines(I).SerialNo + "  " + SNoList.Lines(I).BatchNo
    '        Next I
    '
    '        Form_SerialNo.Show 1
    '    Else
    '        lblResult.Caption = "No Serial Numbers could be retrieved for the line"
    '    End If
    'End If
End Sub

' Initialises the Transaction Header and Lines for the Add Transaction Function
Private Sub NewTrans()
    Dim I%

    ' Run Number - Init to Zero
    HeaderRec.RunNo = 0

    ' Run Number - Init to Zero
    HeaderRec.FolioNum = 0

    ' Customer
    HeaderRec.CustCode = ""
    HeaderRec.CustCodeLen = Chr(Len(Trim(HeaderRec.CustCode)))

    ' Transaction Number
    HeaderRec.OurRef = NextDocNo("SIN")
    HeaderRec.OurRefLen = Chr(Len(Trim(HeaderRec.OurRef)))
    
    ' Your Ref
    HeaderRec.YourRef = ""
    HeaderRec.YourRefLen = Chr(Len(Trim(HeaderRec.YourRef)))
    
    ' Alt Ref
    HeaderRec.LongYrRef = ""
    HeaderRec.LongYrRefLen = Chr(Len(Trim(HeaderRec.LongYrRef)))
                                                    
    ' Currency (0 if Single Currency, else 1-30 )
    HeaderRec.Currency = 1
    
    ' Year and Period
    HeaderRec.AcYr = Year(Now) - 1900
    HeaderRec.AcPr = Month(Now)
    
    ' Transaction Date - Today
    HeaderRec.TransDate = Format$(Year(Now), "0000") + Format$(Month(Now), "00") + Format$(Day(Now), "00")
    HeaderRec.TransDateLen = Chr(Len(Trim(HeaderRec.TransDate)))

    ' Due Date - 1 Month
    HeaderRec.DueDate = Format$(Year(Now + 30), "0000") + Format$(Month(Now + 30), "00") + Format$(Day(Now + 30), "00")
    HeaderRec.DueDateLen = Chr(Len(Trim(HeaderRec.DueDate)))
    
    ' Company Currency Rate
    HeaderRec.CoRate = 1
    
    ' Number of Detail Lines
    HeaderRec.LineCount = 0
    
    ' Document Type
    HeaderRec.TransDocHed = "SIN"
    HeaderRec.TransDocHedLen = Chr(Len(Trim(HeaderRec.TransDocHed)))

    ' Invoice Value
    HeaderRec.InvNetVal = 0#
    HeaderRec.TotOrdOS = 0#
    HeaderRec.Settled = 0#
    HeaderRec.TotalWeight = 0#
    HeaderRec.TotalCost = 0#

    ' VAT
    HeaderRec.DailyRate = 1#
    HeaderRec.InvVat = 0#
    For I = LBound(HeaderRec.InvVatAnal) To UBound(HeaderRec.InvVatAnal)
      HeaderRec.InvVatAnal(I) = 0#
    Next I
    HeaderRec.ManVAT = DllFalse%
    
    ' VAT Delivery Terms
    HeaderRec.DelTerms = ""
    HeaderRec.DelTermsLen = Chr(Len(Trim(HeaderRec.DelTerms)))
    
    ' Discount
    HeaderRec.DiscSetl = 0
    HeaderRec.DiscSetAm = 0
    HeaderRec.DiscAmount = 0
    HeaderRec.DiscDays = 0
    HeaderRec.DiscTaken = DllFalse%

    ' User Id
    HeaderRec.OpName = "EXTERN"
    HeaderRec.OpNameLen = Chr(Len(Trim(HeaderRec.OpName)))
    
    ' Delivery Address
    For I = LBound(HeaderRec.DAddr) To UBound(HeaderRec.DAddr)
        HeaderRec.DAddr(I).Address = ""
        HeaderRec.DAddr(I).AddrLen = Chr(Len(Trim(HeaderRec.DAddr(I).Address)))
    Next I

    ' User Definable fields
    HeaderRec.DocUser1 = ""
    HeaderRec.DocUser1Len = Chr(Len(Trim(HeaderRec.DocUser1)))
    HeaderRec.DocUser2 = ""
    HeaderRec.DocUser2Len = Chr(Len(Trim(HeaderRec.DocUser2)))

    ' Job Costing fields
    HeaderRec.DJobCode = ""
    HeaderRec.DJobCodeLen = Chr(Len(Trim(HeaderRec.DJobCode)))
    HeaderRec.DJobAnal = ""
    HeaderRec.DJobAnalLen = Chr(Len(Trim(HeaderRec.DJobAnal)))

    ' Intrastat
    HeaderRec.TransNat = 0
    HeaderRec.TransMode = 0
    
    ' Miscellaneous
    HeaderRec.HoldFlg = 0
    HeaderRec.PrintedDoc = DllFalse%
    
    ' ****************** Line 1 *************************
    HeaderRec.LineCount = HeaderRec.LineCount + 1
    
    ' Transaction Reference Number
    TranLines.Lines(0).TransRefNoLen = HeaderRec.OurRefLen
    TranLines.Lines(0).TransRefNo = HeaderRec.OurRef
    TranLines.Lines(0).FolioNum = HeaderRec.FolioNum

    ' Line Number
    TranLines.Lines(0).LineNo = 1

    ' Nominal Code
    TranLines.Lines(0).NomCode = 54030
    
    ' Currency
    TranLines.Lines(0).Currency = HeaderRec.Currency
    TranLines.Lines(0).CoRate = HeaderRec.CoRate
    TranLines.Lines(0).DailyRate = HeaderRec.DailyRate
    TranLines.Lines(0).TSHCCurr = HeaderRec.Currency
    
    ' Cost Centre - must be set if Cost Centres turned on
    TranLines.Lines(0).CC = ""
    TranLines.Lines(0).CCLen = Chr(Len(Trim(TranLines.Lines(0).CC)))
    
    ' Department - must be set if Cost Centres turned on
    TranLines.Lines(0).Dep = ""
    TranLines.Lines(0).DepLen = Chr(Len(Trim(TranLines.Lines(0).Dep)))
    
    ' Stock Code - no stock code as I don't know what stock items are going to be available
    TranLines.Lines(0).StockCode = ""
    TranLines.Lines(0).StockCodeLen = Chr(Len(Trim(TranLines.Lines(0).StockCode)))
    
    ' Quantity
    TranLines.Lines(0).Qty = 1#
    TranLines.Lines(0).QtyMul = 1#
    TranLines.Lines(0).QtyWOFF = 0#
    TranLines.Lines(0).QtyDel = 0#
    
    ' Value
    TranLines.Lines(0).NetValue = 100#
    HeaderRec.InvNetVal = HeaderRec.InvNetVal + TranLines.Lines(0).NetValue
    
    ' Cost
    TranLines.Lines(0).CostPrice = 45#
    HeaderRec.TotalCost = HeaderRec.TotalCost + TranLines.Lines(0).CostPrice
    
    ' Discount
    TranLines.Lines(0).Discount = 0#
    TranLines.Lines(0).DiscountChr = " "
    
    ' VAT
    ' Note: Should use EX_GETVATRATE to get the correct rate defined in
    '       Enterprise for this calculation, NOT hard code as 17.5
    TranLines.Lines(0).VATCode = "S"    ' Standard
    TranLines.Lines(0).VAT = TranLines.Lines(0).NetValue * (17.5 / 100)
    
    
    HeaderRec.InvVat = HeaderRec.InvVat + TranLines.Lines(0).VAT
    HeaderRec.InvVatAnal(0) = HeaderRec.InvVatAnal(0) + TranLines.Lines(0).VAT

    ' customer
    TranLines.Lines(0).CustCodeLen = HeaderRec.CustCodeLen
    TranLines.Lines(0).CustCode = HeaderRec.CustCode
    
    ' Transaction Date
    TranLines.Lines(0).LineDateLen = HeaderRec.TransDateLen
    TranLines.Lines(0).LineDate = HeaderRec.TransDate

    ' Line Type
    TranLines.Lines(0).Payment = DllFalse%
                       
    ' Item Number
    TranLines.Lines(0).item = ""
    TranLines.Lines(0).ItemLen = Chr(Len(Trim(TranLines.Lines(0).item)))

    ' Line Description
    TranLines.Lines(0).Desc = "3mm Inverse Flange Sprocket"
    TranLines.Lines(0).DescLen = Chr(Len(Trim(TranLines.Lines(0).Desc)))

    ' Weight in Kg
    TranLines.Lines(0).LWeight = 0#
    
    ' Line Location - leave blank as not using stock
    TranLines.Lines(0).MLocStk = ""
    TranLines.Lines(0).MLocStkLen = Chr(Len(Trim(TranLines.Lines(0).MLocStk)))
    
    ' Job Costing link
    TranLines.Lines(0).JobCode = ""
    TranLines.Lines(0).JobCodeLen = Chr(Len(Trim(TranLines.Lines(0).JobCode)))
    TranLines.Lines(0).AnalCode = ""
    TranLines.Lines(0).AnalCodeLen = Chr(Len(Trim(TranLines.Lines(0).AnalCode)))
                        
    ' Doc Line Type Link
    TranLines.Lines(0).DocLTLink = 0
                        
    ' Bill Of Materials Parent Id
    TranLines.Lines(0).KitLink = 0

    ' Transaction Line Type
    TranLines.Lines(0).LineType = " "
End Sub

' Returns the next document number for DocType$ type transactions
' (DocType$ should be SDN, SIN, SRI, PDN, PIN, ADJ, NOM ...)
Private Function NextDocNo(DocType$) As String
    Dim Res%, Want$, NextNo$, Upd%
    
    Want$ = DocType$
    NextNo$ = String(255, 32)
    Upd% = DllTrue%
    Res% = EX_GETNEXTTRANSNO%(Want$, NextNo$, Upd%)
    
    If (Res% = 0) Then
        ' function was AOK
        NextDocNo$ = Mid(NextNo$, 1, 9)

    Else
        ' something didn't work
        NextDocNo$ = ""
    End If
End Function

Private Sub Text_AcCode_KeyPress(KeyAscii As Integer)
    If (KeyAscii >= Asc("a")) And (KeyAscii <= Asc("z")) Then
        ' convert lowercase letters to uppercase
        KeyAscii = Asc("A") + (KeyAscii - Asc("a"))
    Else
        ' limit to "A"-"Z" and "0"-"9"
        If (KeyAscii >= Asc("A")) And (KeyAscii <= Asc("Z")) Then
            ' AOK
        Else
            If (KeyAscii >= Asc("0")) And (KeyAscii <= Asc("9")) Then
                ' AOK
            Else
                KeyAscii = 0
            End If
        End If
    End If
End Sub

Private Sub Text_OurRef_KeyPress(KeyAscii As Integer)
    If (KeyAscii >= Asc("a")) And (KeyAscii <= Asc("z")) Then
        ' convert lowercase letters to uppercase
        KeyAscii = Asc("A") + (KeyAscii - Asc("a"))
    Else
        ' limit to "A"-"Z" and "0"-"9"
        If (KeyAscii >= Asc("A")) And (KeyAscii <= Asc("Z")) Then
            ' AOK
        Else
            If (KeyAscii >= Asc("0")) And (KeyAscii <= Asc("9")) Then
                ' AOK
            Else
                KeyAscii = 0
            End If
        End If
    End If
End Sub

' Returns True if the specified Transaction exists
Private Function TransactionExists(TransRef$) As Integer
    Dim THRec As TBatchTHRec
    Dim PChar As String * 255
    Dim Result%, HedLen&

    HedLen = Len(THRec)
    PChar$ = TransRef$ + Chr(0)
    Result% = EX_GETTRANSHED(THRec, HedLen, PChar$, 0, B_GetEq, DllFalse%)
    
    TransactionExists = (Result% = 0)
End Function


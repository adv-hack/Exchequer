VERSION 5.00
Begin VB.Form Form_Customer 
   Appearance      =   0  'Flat
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Exchequer Enterprise Toolkit DLL - Stock Demo"
   ClientHeight    =   4680
   ClientLeft      =   735
   ClientTop       =   1515
   ClientWidth     =   7605
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
   Icon            =   "STOCK.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   4680
   ScaleWidth      =   7605
   Begin VB.ComboBox List_Type 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      Height          =   315
      Left            =   990
      Style           =   2  'Dropdown List
      TabIndex        =   8
      Top             =   3525
      Width           =   2715
   End
   Begin VB.Frame Frame1 
      Appearance      =   0  'Flat
      Caption         =   "Stock Functions"
      ForeColor       =   &H80000008&
      Height          =   735
      Index           =   1
      Left            =   105
      TabIndex        =   25
      Top             =   15
      Width           =   7410
      Begin VB.Label Label2 
         Appearance      =   0  'Flat
         Caption         =   "These functions allow you to access and maintain the Stock items within an Exchequer or Exchequer Enterprise System."
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
         Index           =   0
         Left            =   135
         TabIndex        =   21
         Top             =   240
         Width           =   7095
      End
   End
   Begin VB.Frame Frame1 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   30
      Index           =   0
      Left            =   75
      TabIndex        =   24
      Top             =   4275
      Width           =   7455
   End
   Begin VB.Frame Frame2 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   2115
      Left            =   6210
      TabIndex        =   16
      Top             =   900
      Width           =   1305
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "First"
         Height          =   375
         Index           =   0
         Left            =   60
         TabIndex        =   9
         Top             =   150
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Previous"
         Height          =   375
         Index           =   1
         Left            =   60
         TabIndex        =   10
         Top             =   525
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Find"
         Height          =   375
         Index           =   2
         Left            =   60
         TabIndex        =   11
         Top             =   900
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Next"
         Height          =   375
         Index           =   3
         Left            =   60
         TabIndex        =   12
         Top             =   1275
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Last"
         Height          =   375
         Index           =   4
         Left            =   60
         TabIndex        =   13
         Top             =   1650
         Width           =   1170
      End
   End
   Begin VB.Frame Frame3 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   855
      Left            =   6225
      TabIndex        =   23
      Top             =   3315
      Width           =   1305
      Begin VB.CommandButton Command2 
         Appearance      =   0  'Flat
         Caption         =   "Add"
         Height          =   315
         Index           =   0
         Left            =   60
         TabIndex        =   14
         Top             =   150
         Width           =   1170
      End
      Begin VB.CommandButton Command2 
         Appearance      =   0  'Flat
         Caption         =   "Edit"
         Height          =   315
         Index           =   1
         Left            =   60
         TabIndex        =   15
         Top             =   465
         Width           =   1170
      End
   End
   Begin VB.TextBox Text_Code 
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
      Height          =   315
      Left            =   975
      MaxLength       =   16
      TabIndex        =   0
      Top             =   900
      Width           =   2670
   End
   Begin VB.TextBox Text_Desc 
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
      Height          =   315
      Index           =   5
      Left            =   975
      MaxLength       =   35
      TabIndex        =   6
      Top             =   2775
      Width           =   4950
   End
   Begin VB.TextBox Text_Desc 
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
      Height          =   315
      Index           =   0
      Left            =   975
      MaxLength       =   35
      TabIndex        =   1
      Top             =   1275
      Width           =   4950
   End
   Begin VB.TextBox Text_Desc 
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
      Height          =   315
      Index           =   1
      Left            =   975
      MaxLength       =   35
      TabIndex        =   2
      Top             =   1575
      Width           =   4950
   End
   Begin VB.TextBox Text_Desc 
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
      Height          =   315
      Index           =   2
      Left            =   975
      MaxLength       =   35
      TabIndex        =   3
      Top             =   1875
      Width           =   4950
   End
   Begin VB.TextBox Text_Desc 
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
      Height          =   315
      Index           =   3
      Left            =   975
      MaxLength       =   35
      TabIndex        =   4
      Top             =   2175
      Width           =   4950
   End
   Begin VB.TextBox Text_Desc 
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
      Height          =   315
      Index           =   4
      Left            =   975
      MaxLength       =   35
      TabIndex        =   5
      Top             =   2475
      Width           =   4950
   End
   Begin VB.TextBox Text_Parent 
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
      Height          =   315
      Left            =   990
      MaxLength       =   16
      TabIndex        =   7
      Top             =   3225
      Width           =   2715
   End
   Begin VB.Label lblResult 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   240
      Left            =   105
      TabIndex        =   17
      Top             =   4380
      Width           =   7395
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Code"
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
      Left            =   75
      TabIndex        =   22
      Top             =   930
      Width           =   855
   End
   Begin VB.Label Label5 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      Caption         =   "Description"
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
      Left            =   135
      TabIndex        =   20
      Top             =   1305
      Width           =   795
   End
   Begin VB.Label Label6 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Parent"
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
      Left            =   75
      TabIndex        =   19
      Top             =   3255
      Width           =   855
   End
   Begin VB.Label Label7 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Type"
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
      Left            =   75
      TabIndex        =   18
      Top             =   3555
      Width           =   855
   End
End
Attribute VB_Name = "Form_Customer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const Capt_Add = "Add"
Const Capt_Save = "Save"
Const Capt_Edit = "Edit"
Const Capt_Cancel = "Cancel"

Dim OrigCode$, Editing As Integer
Dim DLLLoaded%
Dim STRec As TBatchSKRec

Private Sub Command1_Click(Index As Integer)
    Dim PChar As String * 255
    Dim RecLen As Long, BtrMode%
    Dim ActStr$, Result%
    
    PChar = Text_Code.Text + String$(255, 0)
    
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

    RecLen = Len(STRec)
    Result% = EX_GETSTOCK%(STRec, RecLen, PChar$, 0, BtrMode%, DllFalse%)
    
    lblResult.Caption = ""

    If Result% = 0 Then
        Text_Code.Text = Trim(STRec.StockCode)

        Text_Desc(0).Text = Trim(STRec.Desc(1).Desc)
        Text_Desc(1).Text = Trim(STRec.Desc(2).Desc)
        Text_Desc(2).Text = Trim(STRec.Desc(3).Desc)
        Text_Desc(3).Text = Trim(STRec.Desc(4).Desc)
        Text_Desc(4).Text = Trim(STRec.Desc(5).Desc)
        Text_Desc(5).Text = Trim(STRec.Desc(6).Desc)
        
        Text_Parent.Text = Trim(STRec.StockCat)
        Select Case STRec.StockType
            Case "D"    ' Description Only
                List_Type.ListIndex = 1
            Case "G"    ' Group
                List_Type.ListIndex = 2
            Case "M"    ' Bill Of Materials
                List_Type.ListIndex = 4
            Case "P"    ' Product
                List_Type.ListIndex = 0
            Case "X"    ' Discontinued
                List_Type.ListIndex = 3
            Case Else
                List_Type.ListIndex = -1
        End Select
    Else
        Select Case Result%
            Case 9 ' End Of File
                lblResult.Caption = "The End Of file has been reached"
            Case Else
                If (Index = 2) Then
                    lblResult.Caption = "An error " + Str(Result%) + " occurred trying to find '" + Text_Code.Text + "'"
                Else
                    lblResult.Caption = "An error " + Str(Result%) + " occurred reading the " + ActStr$ + " record"
                End If
        End Select
    End If
End Sub

Private Sub Command2_Click(Index As Integer)
    Dim RecLen%, Result%, I%

    lblResult.Caption = ""
    
    Select Case Index%
        Case 0  ' Add/Save
            If (Command2(0).Caption = Capt_Add) Then
                ' Add
                Editing = False
                Command2(0).Caption = Capt_Save
                Command2(1).Caption = Capt_Cancel

                Call SetEnabled(1)

                OrigCode$ = Text_Code.Text
                Text_Code.Text = ""
                
                For I% = 0 To 5
                    Text_Desc(I%).Text = ""
                Next I%

                Text_Parent.Text = ""

                Text_Code.SetFocus
            Else
                ' save
                Command2(0).Caption = Capt_Add
                Command2(1).Caption = Capt_Edit

                ' read fields into record
                
                If Not Editing% Then
                    Call NewStockRec(STRec)
                
                    STRec.StockCode = Text_Code.Text + String(16, 32)
                    STRec.StockCodeLen = Chr(Len(STRec.StockCode))
                End If
                
                STRec.Desc(1).Desc = Trim(Text_Desc(0).Text)
                STRec.Desc(1).DescLen = Chr(Len(STRec.Desc(1).Desc))
                STRec.Desc(2).Desc = Trim(Text_Desc(1).Text)
                STRec.Desc(2).DescLen = Chr(Len(STRec.Desc(2).Desc))
                STRec.Desc(3).Desc = Trim(Text_Desc(2).Text)
                STRec.Desc(3).DescLen = Chr(Len(STRec.Desc(3).Desc))
                STRec.Desc(4).Desc = Trim(Text_Desc(3).Text)
                STRec.Desc(4).DescLen = Chr(Len(STRec.Desc(4).Desc))
                STRec.Desc(5).Desc = Trim(Text_Desc(4).Text)
                STRec.Desc(5).DescLen = Chr(Len(STRec.Desc(5).Desc))
                STRec.Desc(6).Desc = Trim(Text_Desc(5).Text)
                STRec.Desc(6).DescLen = Chr(Len(STRec.Desc(6).Desc))
                         
                If Not Editing% Then
                    Select Case List_Type.ListIndex
                        Case 0  ' Product
                            STRec.StockType = "P"
                        Case 1  ' Description Only
                            STRec.StockType = "D"
                        Case 2  ' Group
                            STRec.StockType = "G"
                        Case 3  ' Discontinued
                            STRec.StockType = "X"
                        Case 4  ' Bill Of Materials
                            STRec.StockType = "M"
                    End Select
                End If

                ' update db
                RecLen% = Len(STRec)
                If Editing Then
                    Result% = EX_STORESTOCK(STRec, RecLen%, 0, B_Update%)
                Else
                    Result% = EX_STORESTOCK(STRec, RecLen%, 0, B_Insert%)
                End If

                If Result% <> 0 Then
                    lblResult.Caption = "An error " + Str(Result%) + " occurred when the customer was saved"
                End If

                SetEnabled (3)
            End If

        Case 1  ' Edit/Cancel
            If (Command2(1).Caption = Capt_Edit) Then
                ' edit
                Editing = True
                Command2(0).Caption = Capt_Save
                Command2(1).Caption = Capt_Cancel
                
                SetEnabled (2)

                Text_Desc(0).SetFocus
            Else
                ' cancel
                Command2(0).Caption = Capt_Add
                Command2(1).Caption = Capt_Edit

                SetEnabled (3)
                Text_Code.Text = OrigCode$

                Call Command1_Click(2)
            End If

    End Select

    Command1(0).Enabled = (Command2(0).Caption = Capt_Add)
    Command1(1).Enabled = Command1(0).Enabled
    Command1(2).Enabled = Command1(0).Enabled
    Command1(3).Enabled = Command1(0).Enabled
    Command1(4).Enabled = Command1(0).Enabled
End Sub

Private Sub Form_Activate()
    Command1_Click (0)
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
        ' load list with types
        List_Type.AddItem "Product"
        List_Type.AddItem "Description Only"
        List_Type.AddItem "Group"
        List_Type.AddItem "Discontinued"
        List_Type.AddItem "Bill Of Materials"

        ' load first stock item
        Command1_Click (0)
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

Private Sub NewStockRec(ST As TBatchSKRec)
    Dim I%
    
    ST.StockCode = String(16, 32)
    ST.StockCodeLen = Chr(Len(Trim(ST.StockCode)))
    
    For I% = LBound(ST.Desc) To UBound(ST.Desc)
        ST.Desc(I%).Desc = ""
        ST.Desc(I%).DescLen = Chr(Len(Trim(ST.Desc(I%).Desc)))
    Next I%

    ST.AltCode = ""
    ST.AltCodeLen = Chr(Len(Trim(ST.AltCode)))
    
    ST.SuppTemp = ""
    ST.SuppTempLen = Chr(Len(Trim(ST.SuppTemp)))
    
    For I% = LBound(ST.NomCodeS) To UBound(ST.NomCodeS)
        ST.NomCodeS(I%) = 51010
    Next I%
    
    ST.MinFlg = 0
    ST.StockFolio = 0
    
    ST.StockCat = String(16, 32)
    ST.StockCatLen = Chr(16)
    
    ST.StockType = "D"

    ST.UnitK = ""
    ST.UnitKLen = Chr(0)
    
    ST.UnitS = ""
    ST.UnitSLen = Chr(0)
    
    ST.UnitP = ""
    ST.UnitPLen = Chr(0)
    
    ST.PCurrency = 1
    ST.CostPrice = 0.65
                
    For I% = LBound(ST.SaleBands.Band) To UBound(ST.SaleBands.Band)
        ST.SaleBands.Band(I%).Currency = 1
        ST.SaleBands.Band(I%).SalesPrice = I% + (I% * 0.1)
    Next I%
    
    ST.SellUnit = 1
    ST.BuyUnit = 1
    
    ST.VATCode = "S"

    ST.CC = ""
    ST.CCLen = Chr(0)
    
    ST.Dep = ""
    ST.DepLen = Chr(0)
       
    ST.QtyInStock = 0#
    ST.QtyPosted = 0#
    ST.QtyAllocated = 0#
    ST.QtyOnOrder = 0#
    
    ST.QtyMin = 1
    ST.QtyMax = 10
    ST.ROQty = 5
    
    ST.CommodCode = ""
    ST.CommodCodeLen = Chr(0)
    
    ST.SWeight = 1
    ST.PWeight = 1
    
    ST.UnitSupp = ""
    ST.UnitSuppLen = Chr(0)
    
    ST.SuppSUnit = 1
    
    ST.BinLoc = ""
    ST.BinLocLen = Chr(0)
    
    ST.Supplier = ""
    ST.SupplierLen = Chr(0)
    
    ST.CovPr = 0
    ST.CovPrUnit = "D"
    ST.CovMinPr = 0
    ST.CovMinUnit = "D"
    ST.CovSold = 0
    ST.UseCover = DllFalse%
    ST.CovMaxPr = 0
    ST.CovMaxUnit = " "
    
    ST.ROCurrency = 1
    ST.ROCPrice = 0.76
    ST.RODate = ""
    ST.RODateLen = Chr(0)
    
    ST.StkValType = "C"
    
    ST.QtyPicked = 0#
    
    ST.LastUsed = ""
    ST.LastUsedLen = Chr(0)
    
    ST.StBarCode = ""
    ST.StBarCodeLen = Chr(0)
    
    ST.StRoCostCentre = ""
    ST.StRoCostCentreLen = Chr(0)
    
    ST.StRoDepartment = ""
    ST.StRoDepartmentLen = Chr(0)
    
    ST.StLocation = ""
    ST.StLocationLen = Chr(0)
    
    ST.StPricePack = DllFalse%
    ST.StDPackQty = DllFalse%
    ST.StKitPrice = DllFalse%
    ST.StKitOnPurch = DllFalse%
    
    ST.StStkUser1 = ""
    ST.StStkUser1Len = Chr(0)
    
    ST.StStkUser2 = ""
    ST.StStkUser2Len = Chr(0)
End Sub

' Enabled disables controls by mode 1 = add, 2 = edit, 3 = view
Private Sub SetEnabled(EnabMode%)
    Dim I%
    
    Text_Code.Enabled = (EnabMode% = 1) Or (EnabMode% = 3)
                
    For I% = 0 To 5
        Text_Desc(I%).Enabled = (EnabMode% = 1) Or (EnabMode% = 2)
    Next I%

    List_Type.Enabled = (EnabMode% = 1)
End Sub

Private Sub Text_Code_KeyPress(KeyAscii As Integer)
    If (KeyAscii >= Asc("a")) And (KeyAscii <= Asc("z")) Then
        KeyAscii = Asc("A") + (KeyAscii - Asc("a"))
    End If
End Sub


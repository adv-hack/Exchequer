VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmAcSINList 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Print Account SIN"
   ClientHeight    =   5040
   ClientLeft      =   1410
   ClientTop       =   1290
   ClientWidth     =   9045
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5040
   ScaleWidth      =   9045
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command2 
      Caption         =   "Mc's Bug"
      Height          =   315
      Left            =   4890
      TabIndex        =   15
      Top             =   120
      Width           =   1200
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Tim's Bug"
      Height          =   315
      Left            =   7485
      TabIndex        =   14
      Top             =   180
      Width           =   1200
   End
   Begin VB.CommandButton cmdLineSnoLabels 
      Caption         =   "Line Sno Label"
      Height          =   315
      Left            =   7695
      TabIndex        =   13
      Top             =   4230
      Width           =   1200
   End
   Begin VB.CommandButton cmdPrintLineLabel 
      Caption         =   "Line Label"
      Height          =   315
      Left            =   7695
      TabIndex        =   12
      Top             =   3840
      Width           =   1200
   End
   Begin VB.CommandButton cmdTransNotes 
      Caption         =   "TH + Notes"
      Height          =   315
      Left            =   7695
      TabIndex        =   11
      Top             =   3450
      Width           =   1200
   End
   Begin VB.CommandButton cmdCustomPickList 
      Caption         =   "Custom Pick"
      Height          =   315
      Left            =   7695
      TabIndex        =   10
      Top             =   3075
      Width           =   1200
   End
   Begin VB.CommandButton cmdPickingList 
      Caption         =   "Picking List"
      Height          =   315
      Left            =   7695
      TabIndex        =   9
      Top             =   2685
      Width           =   1200
   End
   Begin VB.CommandButton cdmConsignNote 
      Caption         =   "Consign Note"
      Height          =   315
      Left            =   7695
      TabIndex        =   8
      Top             =   2295
      Width           =   1200
   End
   Begin VB.CommandButton cmdIssueNote 
      Caption         =   "ADJ as WIN"
      Height          =   315
      Left            =   7695
      TabIndex        =   7
      Top             =   1905
      Width           =   1200
   End
   Begin VB.CommandButton cmdPrintTHSerial 
      Caption         =   "Serial Labels"
      Height          =   315
      Left            =   7695
      TabIndex        =   6
      Top             =   1515
      Width           =   1200
   End
   Begin VB.CommandButton cmdPrintTHLabel 
      Caption         =   "Stock Labels"
      Height          =   315
      Left            =   7695
      TabIndex        =   5
      Top             =   1125
      Width           =   1200
   End
   Begin MSComctlLib.ListView lvLedger 
      Height          =   4335
      Left            =   120
      TabIndex        =   4
      Top             =   555
      Width           =   7485
      _ExtentX        =   13203
      _ExtentY        =   7646
      View            =   3
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   5
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Text            =   "OurRef"
         Object.Width           =   1940
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   1
         Text            =   "Date"
         Object.Width           =   2117
      EndProperty
      BeginProperty ColumnHeader(3) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Alignment       =   1
         SubItemIndex    =   2
         Text            =   "Total Value"
         Object.Width           =   2822
      EndProperty
      BeginProperty ColumnHeader(4) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   3
         Text            =   "YourRef"
         Object.Width           =   2117
      EndProperty
      BeginProperty ColumnHeader(5) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   4
         Text            =   "Alt Ref"
         Object.Width           =   2999
      EndProperty
   End
   Begin VB.CommandButton cmdPrintTH 
      Caption         =   "Print Doc"
      Height          =   315
      Left            =   7665
      TabIndex        =   3
      Top             =   720
      Width           =   1200
   End
   Begin VB.CommandButton cdmLoadSINs 
      Caption         =   "Load SIN's"
      Height          =   315
      Left            =   3165
      TabIndex        =   2
      Top             =   120
      Width           =   1200
   End
   Begin VB.TextBox txtAcCode 
      Height          =   315
      Left            =   1800
      TabIndex        =   1
      Text            =   "ABAP01"
      Top             =   90
      Width           =   1245
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Customer A/C Code"
      Height          =   345
      Left            =   105
      TabIndex        =   0
      Top             =   135
      Width           =   1620
   End
End
Attribute VB_Name = "frmAcSINList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public oToolkit As Enterprise01.Toolkit

Private Sub cdmConsignNote_Click()
    PrintGenericTrans 4
End Sub

Private Sub cdmLoadSINs_Click()
    Dim lvItem As ListItem
    Dim FuncRes&
    
    ' empty list before reloading
    lvLedger.ListItems.Clear
                            
lvLedger.ListItems.Add , , "ADJ000102"
lvLedger.ListItems.Add , , "POR000254"
lvLedger.ListItems.Add , , "SDN000562"
lvLedger.ListItems.Add , , "SOR000418"
lvLedger.ListItems.Add , , "WOR000057"
    
    If (Trim(txtAcCode.Text) <> "") Then
        With oToolkit.Customer
            ' Find the specified customer
            .Index = acIdxCode
            FuncRes& = .GetEqual(.BuildCodeIndex(Trim(txtAcCode.Text)))
            If (FuncRes& = 0) Then
                ' Run through the transactions for the customer loading the list
                With oToolkit.Transaction
                    ' Using Account Code Index look for Transactions for Account Code
                    .Index = thIdxAccount
                    FuncRes& = .GetGreaterThanOrEqual(.BuildAccountIndex(oToolkit.Customer.acCode))
                    
                    ' Check we found something, and its for the correct account
                    While (FuncRes& = 0) And (.thAcCode = oToolkit.Customer.acCode)
                        ' Check transaction type
                        If (.thDocType = dtSIN) Then
                            ' Add Transaction into Listview
                            Set lvItem = lvLedger.ListItems.Add(, , .thOurRef)
                            lvItem.SubItems(1) = oToolkit.Functions.entFormatDate(.thTransDate, "")
                            lvItem.SubItems(2) = Format(.thTotals(TransTotInBase), "#,###,##0.00")
                            lvItem.SubItems(3) = .thYourRef
                            lvItem.SubItems(4) = .thLongYourRef
                        End If ' .thDocType = dtSIN
                        
                        FuncRes& = .GetNext
                    Wend ' (FuncRes& = 0) And (.thAcCode = AccDetail.acCode)
                End With ' oToolkit.Transaction
            Else
                MsgBox "No Customer with that Account Code was found"
            End If
        End With ' oToolkit.Customer
    Else
        MsgBox "A valid customer Account Code must be specified"
    End If
End Sub

' Find selected transaction and print it
Private Sub PrintGenericTrans(Mode%)
    Dim oTransaction2 As ITransaction2
    Dim oTransLine2 As ITransactionLine2
    Dim oTransLineSno2 As ITransactionLineSerialBatch2
    Dim oPrintJob As Enterprise01.IPrintJob
    Dim FuncRes&, I%
  
    With oToolkit.Transaction
        ' Change to OurRef index and load transacction
        .Index = thIdxOurRef
        FuncRes& = .GetEqual(.BuildOurRefIndex(lvLedger.SelectedItem.Text))
        
        If (FuncRes& = 0) Then
            ' Create and display the Print Dialog
            Load frmPrintDlg
            With frmPrintDlg
                ' Create the descendant transaction object and pass the PrintJob object into the Print dialog
                Set oTransaction2 = oToolkit.Transaction
                Select Case Mode%
                    ' Standard Document
                    Case 0
                        Set oPrintJob = oTransaction2.Print(thpmDefault)
                    ' Stock Labels
                    Case 1
                        Set oPrintJob = oTransaction2.Print(thpmStockLabels)
                    ' Serial Labels
                    Case 2
                        Set oPrintJob = oTransaction2.Print(thpmSerialLabels)
                    ' Works Issue Note
                    Case 3
                        Set oPrintJob = oTransaction2.Print(thpmWorksIssueNote)
                    ' Consignment Note
                    Case 4
                        Set oPrintJob = oTransaction2.Print(thpmConsignmentNote)
                    ' Picking List
                    Case 5
                        Set oPrintJob = oTransaction2.Print(thpmPickingList)
                    ' Custom Picking List
                    Case 6
                        Set oPrintJob = oTransaction2.Print(thpmCustomPickingList)
                        
                        ' Add some transaction lines into the print job
                        FuncRes& = oTransaction2.GetEqual("SOR000366")
                        If (FuncRes& = 0) Then
                            For I% = 1 To oTransaction2.thLines.thLineCount
                                With oTransaction2.thLines(I)
                                    If (Trim(.tlStockCode) <> "") Then
                                        oPrintJob.pjCustomData.Add oTransaction2.thLines(I), .tlStockCode, ""
                                    End If ' Trim(.tlStockCode) <> ""
                                End With ' oTransaction2.thLines(I)
                            Next I%
                        End If
                    ' Transaction with Notes
                    Case 7
                        Set oPrintJob = oTransaction2.Print(thpmNotes)
                    ' Transaction Line Label
                    Case 8
                        If (oTransaction2.thLines.thLineCount > 0) Then
                            Set oTransLine2 = oTransaction2.thLines(1)
                            Set oPrintJob = oTransLine2.Print(tlpmLabel)
                            Set oTransLine2 = Nothing
                        Else
                            MsgBox "No Transaction Lines Found"
                            Exit Sub
                        End If
                    ' Transaction Line Serial Labels
                    Case 9
                        If (oTransaction2.thLines.thLineCount > 0) Then
                            Set oTransLineSno2 = oTransaction2.thLines(1).tlSerialBatch
                            If oTransLineSno2.tlUsesSerialBatchNo And (oTransLineSno2.tlCount > 0) Then
                                Set oPrintJob = oTransLineSno2.Print(tspmLabel)
                            Else
                                Set oTransLineSno2 = Nothing
                                MsgBox "No Transaction Lines Serial Numbers Found"
                                Exit Sub
                            End If
                            Set oTransLineSno2 = Nothing
                        Else
                            MsgBox "No Transaction Lines Found"
                            Exit Sub
                        End If
                Case Else
                    MsgBox "Unsupported PrintGenericTrans Mode (" + Str(Mode%) + ")"
                    Exit Sub
                End Select
                        
                ' Import the default forms, email addresses, etc...
                'oPrintJob.pjUserId = "MARKd6"
                oPrintJob.ImportDefaults
                
                ' Setup the PrintTo dialog
                .SetupDlg oPrintJob
                           
                ' Display the dialog
                .Show 1, Me
                            
                ' Remove the references which aren't needed any more
                Set oPrintJob = Nothing
                Set oTransaction2 = Nothing
            End With ' frmPrintDlg
            Unload frmPrintDlg
        Else
            MsgBox "The following error occured loading the Transaction:-" + _
                   Chr(13) + Chr(13) + """" + .LastErrorString + """"
        End If ' FuncRes& = 0
    End With ' oToolkit.Transaction
End Sub

Private Sub cmdCustomPickList_Click()
    PrintGenericTrans 6
End Sub

Private Sub cmdIssueNote_Click()
    PrintGenericTrans 3
End Sub

Private Sub cmdLineSnoLabels_Click()
    PrintGenericTrans 9
End Sub

Private Sub cmdPickingList_Click()
    PrintGenericTrans 5
End Sub

Private Sub cmdPrintLineLabel_Click()
    PrintGenericTrans 8
End Sub

Private Sub cmdPrintTH_Click()
    PrintGenericTrans 0
End Sub

Private Sub cmdPrintTHLabel_Click()
    PrintGenericTrans 1
End Sub

Private Sub cmdPrintTHSerial_Click()
    PrintGenericTrans 2
End Sub

Private Sub cmdTransNotes_Click()
    PrintGenericTrans 7
End Sub

Private Sub Command1_Click()
    Dim oTransaction2 As ITransaction2
    Dim oPrintJob As Enterprise01.IPrintJob
    Dim oTempFile As IPrintTempFile
    Dim Res&
    
    Set oTransaction2 = oToolkit.Transaction
    With oTransaction2
        ' Change to OurRef index and load transacction
        .Index = thIdxOurRef
        Res& = .GetEqual(.BuildOurRefIndex(lvLedger.SelectedItem.Text))
        
        If (Res& = 0) Then
            Set oPrintJob = .Print(0)
            
            oPrintJob.ImportDefaults
            
Call oToolkit.Functions.entBrowseObject(oPrintJob, True)
            
            'Res& = oPrintJob.PrintToPrinter
            Set oTempFile = oPrintJob.PrintToTempFile(pdPrinter)
            If (oTempFile.pfStatus = 0) Then
                ' Preview using the EDF/EDZ Reader
                Res& = oTempFile.DisplayPreviewWindow(ptEDFReader)
            Else
                MsgBox "oPrintJob.PrintToTempFile: " + Str(oTempFile.pfStatus)
            End If ' oTempFile.pfStatus = 0
        
            MsgBox "Press OK to continue"
        
            Set oTempFile = Nothing
            Set oPrintJob = Nothing
        End If ' Res& = 0
    End With ' oTransaction2
    Set oTransaction2 = Nothing
End Sub

Private Sub Command2_Click()
    Dim Res&
    
    With oToolkit.GeneralLedger.Add
        .glType = glTypeHeading
        .glCode = "123456"
        .glAltCode = "TEST"
        .glName = "TEST HEADING"
        
        Res& = .Save
        If (Res& <> 0) Then MsgBox "Error " + Str(Res&)
    End With ' oToolkit.GeneralLedger.Add
End Sub

Private Sub Form_Load()
    Dim Res&
    
    ' Create Enterprise forms Toolkit object
    Set oToolkit = CreateObject("Enterprise01.Toolkit")
    With oToolkit
        Me.Caption = Me.Caption + "  (" + .Version + ")"
        With .Configuration
            '.DataDirectory = "C:\Develop\Dev500\"
            .DataDirectory = "C:\Exch63.SQL\"
        End With ' .Configuration
        
        Res& = .OpenToolkit
        If (Res& <> 0) Then MsgBox "OpenToolkit: " + Str(Res)
    End With ' oToolkit
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Set oToolkit = Nothing
End Sub

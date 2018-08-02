VERSION 5.00
Begin VB.Form frmPrinterList 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Form1"
   ClientHeight    =   5340
   ClientLeft      =   45
   ClientTop       =   615
   ClientWidth     =   5700
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5340
   ScaleWidth      =   5700
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command3 
      Caption         =   "Command1"
      Height          =   285
      Left            =   5055
      TabIndex        =   11
      Top             =   3525
      Width           =   555
   End
   Begin VB.TextBox Text3 
      Height          =   345
      Left            =   3135
      TabIndex        =   10
      Text            =   "Text1"
      Top             =   3480
      Width           =   1755
   End
   Begin VB.TextBox Text2 
      Height          =   345
      Left            =   3090
      TabIndex        =   9
      Text            =   "Text1"
      Top             =   1785
      Width           =   1755
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Command1"
      Height          =   285
      Left            =   5010
      TabIndex        =   8
      Top             =   1830
      Width           =   555
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   285
      Left            =   4830
      TabIndex        =   7
      Top             =   45
      Width           =   555
   End
   Begin VB.TextBox Text1 
      Height          =   345
      Left            =   2910
      TabIndex        =   6
      Text            =   "Text1"
      Top             =   0
      Width           =   1755
   End
   Begin VB.ListBox lstPapers 
      Height          =   1425
      Left            =   90
      TabIndex        =   4
      Top             =   3810
      Width           =   5505
   End
   Begin VB.ListBox lstBins 
      Height          =   1425
      Left            =   90
      TabIndex        =   2
      Top             =   2070
      Width           =   5505
   End
   Begin VB.ListBox lstPrinters 
      Height          =   1425
      Left            =   90
      TabIndex        =   0
      Top             =   330
      Width           =   5505
   End
   Begin VB.Label Label1 
      Caption         =   "Papers for the selected printer"
      Height          =   255
      Index           =   2
      Left            =   120
      TabIndex        =   5
      Top             =   3540
      Width           =   2895
   End
   Begin VB.Label Label1 
      Caption         =   "Bins for the selected printer"
      Height          =   255
      Index           =   1
      Left            =   120
      TabIndex        =   3
      Top             =   1800
      Width           =   2895
   End
   Begin VB.Label Label1 
      Caption         =   "Printers"
      Height          =   255
      Index           =   0
      Left            =   120
      TabIndex        =   1
      Top             =   60
      Width           =   1245
   End
   Begin VB.Menu mnuTest 
      Caption         =   "Test"
      Begin VB.Menu mnuSelPrinterInfo 
         Caption         =   "Selected Printer Info"
      End
   End
End
Attribute VB_Name = "frmPrinterList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim oFormsTK As EnterpriseForms.PrintingToolkit

Private Sub Command1_Click()
    Dim Res&
    
    With oFormsTK.Printers
        Res& = .IndexOf(Text1.Text)
        MsgBox Str(Res&)
    End With ' oFormsTK.Printers
End Sub

Private Sub Command2_Click()
    Dim Res&
    
    With oFormsTK.Printers(lstPrinters.ListIndex + 1).pdBins
        Res& = .IndexOf(Text2.Text)
        MsgBox Str(Res&)
    End With ' oFormsTK.Printers(lstPrinters.ListIndex + 1)
End Sub

Private Sub Command3_Click()
    Dim Res&
    
    With oFormsTK.Printers(lstPrinters.ListIndex + 1).pdPapers
        Res& = .IndexOf(Text3.Text)
        MsgBox Str(Res&)
    End With ' oFormsTK.Printers(lstPrinters.ListIndex + 1)
End Sub

Private Sub Form_Load()
    Dim Res&, PrinterNo%
    
    Set oFormsTK = CreateObject("EnterpriseForms.PrintingToolkit")

    ' Load Printers List
    With oFormsTK
        With .Configuration
            '.cfEnterpriseDirectory = "C:\DEVELOP\DEV500\"
            '.cfEnterpriseDirectory = "C:\Exch600\"
            '.cfDataDirectory = .cfEnterpriseDirectory
            
            .cfDataDirectory = "C:\DEVELOP\DEV500\COMPAN~1\APPSVALS\"
        End With ' .Configuration
        
        Res& = .OpenPrinting("FORMSTK Test App (VB)", "EXENTCTK-DTFEQC-NE9ND3")
        
        If (Res& = 0) Then
            With .Printers
                If (.prCount > 0) Then
                    For PrinterNo% = 1 To .prCount
                        With .prPrinters(PrinterNo%)
                            lstPrinters.AddItem .pdName
                        End With ' .prPrinter(I%)
                    Next PrinterNo%
        
                    If (.prDefaultPrinter >= 1) And (.prDefaultPrinter <= .prCount) Then
                        lstPrinters.ListIndex = .prDefaultPrinter - 1
                    Else
                        lstPrinters.ListIndex = 0
                    End If
                    
                    ' Load Papers/Bins for selected printer
                    LoadPrinter (lstPrinters.ListIndex + 1)
                End If
            End With ' .Printers
        Else
            MsgBox "OpenPrinting Error " + Str(Res&)
        End If
    End With ' oFormsTK
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Set oFormsTK = Nothing
End Sub

Private Sub LoadPrinter(PrinterNo%)
    Dim BinNo%, PaperNo%
    
    With oFormsTK
        ' Set Printer in Print Job
        .PrintJob.pjPrinterIndex = PrinterNo%
        
        ' Reload Paper/Bin lists for selected printer
        With .Printers(PrinterNo%)
            lstBins.Clear
            
            If .pdSupportsBins And (.pdBins.Count > 0) Then
                For BinNo% = 1 To .pdBins.Count
                    lstBins.AddItem .pdBins.Strings(BinNo%)
                Next BinNo%
                
                ' Set Default Bin (0 = No Default)
                If (.pdDefaultBin > 0) Then
                    lstBins.ListIndex = .pdDefaultBin - 1
                End If ' .pdDefaultBin > 0
            End If ' .pdBins.Count > 0
            
            lstPapers.Clear
            If .pdSupportsPapers And (.pdPapers.Count > 0) Then
                For PaperNo% = 1 To .pdPapers.Count
                    lstPapers.AddItem .pdPapers(PaperNo%)
                Next PaperNo%
                
                ' Set Default Paper (0 = No Default)
                If (.pdDefaultPaper > 0) Then
                    lstPapers.ListIndex = .pdDefaultPaper - 1
                End If ' .pdDefaultPaper > 0
            End If ' .pdPapers.Count > 0
        End With ' .Printers(PrinterNo%)
    End With ' oFormsTK
End Sub

Private Sub lstBins_DblClick()
    If (lstBins.ListIndex >= 0) Then
        oFormsTK.PrintJob.pjBinIndex = lstBins.ListIndex + 1
    End If ' lstBins.ListIndex >= 0
End Sub

Private Sub lstPapers_DblClick()
    If (lstPapers.ListIndex >= 0) Then
        oFormsTK.PrintJob.pjPaperIndex = lstPapers.ListIndex + 1
    End If ' lstPapers.ListIndex >= 0
End Sub

Private Sub lstPrinters_DblClick()
    If (lstPrinters.ListIndex >= 0) Then
        LoadPrinter (lstPrinters.ListIndex + 1)
    End If ' lstPrinters.ListIndex >= 0
End Sub

Private Sub mnuSelPrinterInfo_Click()
    Dim Msg$
    
    With oFormsTK
        With .Printers(.PrintJob.pjPrinterIndex)
            Msg$ = "Printer: " + .pdName
            
            If .pdSupportsPapers And (oFormsTK.PrintJob.pjPaperIndex > 0) Then
                Msg$ = Msg$ + Chr(13) + "Paper: " + .pdPapers(oFormsTK.PrintJob.pjPaperIndex)
            End If ' .pdSupportsPapers And (oFormsTK.PrintJob.pjPaperIndex > 0)
            
            If .pdSupportsBins And (oFormsTK.PrintJob.pjBinIndex > 0) Then
                Msg$ = Msg$ + Chr(13) + "Bin: " + .pdBins(oFormsTK.PrintJob.pjBinIndex)
            End If ' .pdSupportsBins And (oFormsTK.PrintJob.pjBinIndex > 0)
            
            MsgBox Msg$
        End With ' .Printers(.PrintJob.pjPrinterIndex)
    End With ' oFormsTK
End Sub


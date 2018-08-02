VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmPrintDlg 
   Caption         =   "Form1"
   ClientHeight    =   3405
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7545
   LinkTopic       =   "Form1"
   ScaleHeight     =   3405
   ScaleWidth      =   7545
   StartUpPosition =   3  'Windows Default
   Begin TabDlg.SSTab SSTab1 
      Height          =   2895
      Left            =   75
      TabIndex        =   0
      Top             =   75
      Width           =   7395
      _ExtentX        =   13044
      _ExtentY        =   5106
      _Version        =   393216
      Style           =   1
      Tabs            =   1
      TabHeight       =   520
      TabCaption(0)   =   "Printer"
      TabPicture(0)   =   "PrntDlgF.frx":0000
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "cmdPrinterCancel"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "cmdPrinterOK"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "Frame3"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "Frame2"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "Frame1"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).ControlCount=   5
      Begin VB.Frame Frame1 
         Caption         =   " Printer "
         Height          =   1125
         Left            =   150
         TabIndex        =   8
         Top             =   360
         Width           =   7095
         Begin VB.TextBox txtFormName 
            Height          =   315
            Left            =   4200
            TabIndex        =   13
            Text            =   "NEWINV"
            Top             =   660
            Width           =   1485
         End
         Begin VB.TextBox txtCopies 
            Height          =   315
            Left            =   960
            TabIndex        =   12
            Text            =   "1"
            Top             =   660
            Width           =   945
         End
         Begin VB.ComboBox lstPrinters 
            Height          =   315
            Left            =   960
            Style           =   2  'Dropdown List
            TabIndex        =   11
            Top             =   270
            Width           =   4725
         End
         Begin VB.CommandButton cmdPrinterSetup 
            Caption         =   "&Setup"
            Height          =   315
            Left            =   5730
            TabIndex        =   10
            Top             =   270
            Width           =   1200
         End
         Begin VB.CommandButton cmdBrowse 
            Caption         =   "&Browse"
            Enabled         =   0   'False
            Height          =   315
            Left            =   5730
            TabIndex        =   9
            Top             =   660
            Width           =   1200
         End
         Begin VB.Label Label3 
            Alignment       =   1  'Right Justify
            Caption         =   "Form"
            Height          =   315
            Left            =   3480
            TabIndex        =   16
            Top             =   705
            Width           =   615
         End
         Begin VB.Label Label2 
            Alignment       =   1  'Right Justify
            Caption         =   "Copies"
            Height          =   315
            Index           =   0
            Left            =   180
            TabIndex        =   15
            Top             =   705
            Width           =   615
         End
         Begin VB.Label Label1 
            Alignment       =   1  'Right Justify
            Caption         =   "Printer"
            Height          =   285
            Index           =   0
            Left            =   180
            TabIndex        =   14
            Top             =   330
            Width           =   675
         End
      End
      Begin VB.Frame Frame2 
         Caption         =   " Output To "
         Height          =   735
         Left            =   150
         TabIndex        =   5
         Top             =   1560
         Width           =   2655
         Begin VB.OptionButton optPrinter 
            Caption         =   "Printer"
            Height          =   345
            Left            =   180
            TabIndex        =   7
            Top             =   270
            Value           =   -1  'True
            Width           =   1035
         End
         Begin VB.OptionButton optScreen 
            Caption         =   "Screen"
            Height          =   345
            Left            =   1380
            TabIndex        =   6
            Top             =   270
            Width           =   975
         End
      End
      Begin VB.Frame Frame3 
         Height          =   735
         Left            =   2910
         TabIndex        =   3
         Top             =   1560
         Width           =   1635
         Begin VB.CheckBox chkTestMode 
            Caption         =   "Test Mode"
            Height          =   255
            Left            =   180
            TabIndex        =   4
            Top             =   300
            Width           =   1335
         End
      End
      Begin VB.CommandButton cmdPrinterOK 
         Caption         =   "&OK"
         Default         =   -1  'True
         Height          =   315
         Left            =   4740
         TabIndex        =   2
         Top             =   2430
         Width           =   1200
      End
      Begin VB.CommandButton cmdPrinterCancel 
         Cancel          =   -1  'True
         Caption         =   "&Cancel"
         Height          =   315
         Left            =   6060
         TabIndex        =   1
         Top             =   2430
         Width           =   1200
      End
   End
End
Attribute VB_Name = "frmPrintDlg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public oPrintJob As IPrintJob

Public Sub LoadPrinters()
    Dim PrinterNo%
    
    With oPrintJob.pjSystemPrinters
        ' Load Printers List
        If (.prCount > 0) Then
            For PrinterNo% = 1 To .prCount
                lstPrinters.AddItem .prPrinters(PrinterNo%).pdName
            Next PrinterNo%
            
            ' Select default printer from print job
            lstPrinters.ListIndex = .prDefaultPrinter - 1
        End If
   End With ' oPrintJob.pjSystemPrinters
End Sub

Private Sub cmdPrinterCancel_Click()
    Hide
End Sub

Private Sub cmdPrinterOK_Click()
    Dim Res&
    
    With oPrintJob
        ' Set form to print
        With .pjForms.Add
            .fdFormName = txtFormName.Text
            .Save
        End With ' .pjForms.Add
    
        ' Set Copies to be printed
        .pjCopies = CInt(txtCopies.Text)
    
        ' Test Mode
        .pjTestMode = chkTestMode.Value
                
        ' Print the Print Job
        If optPrinter.Value Then
            Res& = .PrintToPrinter
            MsgBox "PrintToPrinter: " + Str(Res&)
            Hide
        Else
            MsgBox "Preview Not Coded"
        End If
    End With ' oPrintJob
End Sub

Private Sub cmdPrinterSetup_Click()
    With oPrintJob.pjPrinterInfo
        ' Display Printer Setup dialog
        If .PrinterSetupDialog Then
            ' User has OK'd dialog - update this form with any changes made
            lstPrinters.ListIndex = .prPrinterIndex - 1
        End If
    End With ' oPrintJob.pjPrinterInfo
End Sub

Private Sub lstPrinters_Click()
    ' Update Print Job details with new printer index
    oPrintJob.pjPrinterIndex = lstPrinters.ListIndex + 1
End Sub

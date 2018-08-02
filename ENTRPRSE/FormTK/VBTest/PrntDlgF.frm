VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "tabctl32.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "Mscomctl.ocx"
Begin VB.Form Form1 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Form1"
   ClientHeight    =   7680
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7590
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7680
   ScaleWidth      =   7590
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame4 
      Caption         =   " Specify Data To Print "
      Height          =   1455
      Left            =   90
      TabIndex        =   15
      Top             =   90
      Width           =   7155
      Begin VB.TextBox txtJobTitle 
         Height          =   315
         Left            =   1020
         TabIndex        =   20
         Top             =   960
         Width           =   5940
      End
      Begin VB.OptionButton optNormalTrans 
         Caption         =   "Normal Transaction"
         Height          =   375
         Left            =   180
         TabIndex        =   18
         Top             =   270
         Value           =   -1  'True
         Width           =   1995
      End
      Begin VB.TextBox txtOurRef 
         Height          =   345
         Left            =   3135
         TabIndex        =   16
         Text            =   "SIN007637"
         Top             =   285
         Width           =   1095
      End
      Begin VB.Label Label2 
         Alignment       =   1  'Right Justify
         Caption         =   "Job Title"
         Height          =   315
         Index           =   2
         Left            =   240
         TabIndex        =   21
         Top             =   1005
         Width           =   615
      End
      Begin VB.Label Label2 
         Alignment       =   1  'Right Justify
         Caption         =   "OurRef"
         Height          =   315
         Index           =   1
         Left            =   2295
         TabIndex        =   17
         Top             =   345
         Width           =   765
      End
   End
   Begin TabDlg.SSTab SSTab1 
      Height          =   5970
      Left            =   135
      TabIndex        =   0
      Top             =   1635
      Width           =   7395
      _ExtentX        =   13044
      _ExtentY        =   10530
      _Version        =   393216
      Style           =   1
      TabHeight       =   520
      TabCaption(0)   =   "Printer"
      TabPicture(0)   =   "PrntDlgF.frx":0000
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Frame1(0)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "Frame2"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "Frame3"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "cmdPrnterOK"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "cmdPrinterCancel"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).ControlCount=   5
      TabCaption(1)   =   "Email"
      TabPicture(1)   =   "PrntDlgF.frx":001C
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "cmdEmailOK"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).Control(1)=   "cmdEmailCancel"
      Tab(1).Control(1).Enabled=   0   'False
      Tab(1).Control(2)=   "Frame8"
      Tab(1).Control(2).Enabled=   0   'False
      Tab(1).Control(3)=   "Frame7(0)"
      Tab(1).Control(3).Enabled=   0   'False
      Tab(1).Control(4)=   "Frame6"
      Tab(1).Control(4).Enabled=   0   'False
      Tab(1).Control(5)=   "Frame5(0)"
      Tab(1).Control(5).Enabled=   0   'False
      Tab(1).ControlCount=   6
      TabCaption(2)   =   "Fax"
      TabPicture(2)   =   "PrntDlgF.frx":0038
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "Frame1(1)"
      Tab(2).Control(0).Enabled=   0   'False
      Tab(2).Control(1)=   "cmdFaxCancel"
      Tab(2).Control(1).Enabled=   0   'False
      Tab(2).Control(2)=   "cmdFaxOK"
      Tab(2).Control(2).Enabled=   0   'False
      Tab(2).Control(3)=   "Frame9"
      Tab(2).Control(3).Enabled=   0   'False
      Tab(2).Control(4)=   "Frame7(1)"
      Tab(2).Control(4).Enabled=   0   'False
      Tab(2).Control(5)=   "Frame5(1)"
      Tab(2).Control(5).Enabled=   0   'False
      Tab(2).ControlCount=   6
      Begin VB.Frame Frame1 
         Caption         =   " MAPI Printer "
         Height          =   750
         Index           =   1
         Left            =   -74850
         TabIndex        =   80
         Top             =   360
         Width           =   7095
         Begin VB.ComboBox lstMAPIFaxPrinters 
            Height          =   315
            Left            =   960
            Style           =   2  'Dropdown List
            TabIndex        =   82
            Top             =   270
            Width           =   4725
         End
         Begin VB.CommandButton Command6 
            Caption         =   "&Setup"
            Enabled         =   0   'False
            Height          =   315
            Left            =   5730
            TabIndex        =   81
            Top             =   270
            Width           =   1200
         End
         Begin VB.Label Label10 
            Alignment       =   1  'Right Justify
            Caption         =   "Printer"
            Height          =   285
            Left            =   180
            TabIndex        =   83
            Top             =   330
            Width           =   675
         End
      End
      Begin VB.CommandButton cmdFaxCancel 
         Cancel          =   -1  'True
         Caption         =   "&Cancel"
         Height          =   315
         Left            =   -69060
         TabIndex        =   79
         Top             =   5175
         Width           =   1200
      End
      Begin VB.CommandButton cmdFaxOK 
         Caption         =   "&OK"
         Default         =   -1  'True
         Height          =   315
         Left            =   -70380
         TabIndex        =   78
         Top             =   5190
         Width           =   1200
      End
      Begin VB.Frame Frame9 
         Caption         =   " Email Information "
         Height          =   2685
         Left            =   -74865
         TabIndex        =   65
         Top             =   2415
         Width           =   7095
         Begin VB.TextBox txtFaxDesc 
            Height          =   315
            Left            =   705
            TabIndex        =   84
            Text            =   "SIN007637"
            Top             =   1020
            Width           =   6240
         End
         Begin VB.TextBox txtFaxRecipNumber 
            Height          =   315
            Left            =   3450
            TabIndex        =   75
            Text            =   "01202298001"
            Top             =   645
            Width           =   3495
         End
         Begin VB.TextBox txtFaxRecipName 
            Height          =   315
            Left            =   705
            TabIndex        =   74
            Text            =   "Cousin It"
            Top             =   645
            Width           =   1965
         End
         Begin VB.TextBox txtFaxMsg 
            Height          =   750
            Left            =   705
            MultiLine       =   -1  'True
            TabIndex        =   69
            Text            =   "PrntDlgF.frx":0054
            Top             =   1395
            Width           =   6255
         End
         Begin VB.ComboBox lstFaxPriority 
            Height          =   315
            ItemData        =   "PrntDlgF.frx":0067
            Left            =   705
            List            =   "PrntDlgF.frx":0074
            Style           =   2  'Dropdown List
            TabIndex        =   68
            Top             =   2220
            Width           =   1620
         End
         Begin VB.TextBox txtFaxSenderNumber 
            Height          =   315
            Left            =   3450
            TabIndex        =   67
            Text            =   "01202298001"
            Top             =   255
            Width           =   3495
         End
         Begin VB.TextBox txtFaxSenderName 
            Height          =   315
            Left            =   705
            TabIndex        =   66
            Text            =   "PaulR"
            Top             =   255
            Width           =   1965
         End
         Begin VB.Label Label17 
            Alignment       =   1  'Right Justify
            Caption         =   "Desc"
            Height          =   315
            Index           =   0
            Left            =   120
            TabIndex        =   85
            Top             =   1065
            Width           =   495
         End
         Begin VB.Label Label17 
            Alignment       =   1  'Right Justify
            Caption         =   "Number"
            Height          =   315
            Index           =   2
            Left            =   2715
            TabIndex        =   77
            Top             =   690
            Width           =   630
         End
         Begin VB.Label Label17 
            Alignment       =   1  'Right Justify
            Caption         =   "To"
            Height          =   315
            Index           =   12
            Left            =   120
            TabIndex        =   76
            Top             =   690
            Width           =   495
         End
         Begin VB.Label Label9 
            Alignment       =   1  'Right Justify
            Caption         =   "Note"
            Height          =   315
            Index           =   5
            Left            =   75
            TabIndex        =   73
            Top             =   1425
            Width           =   510
         End
         Begin VB.Label Label9 
            Alignment       =   1  'Right Justify
            Caption         =   "Priority"
            Height          =   315
            Index           =   6
            Left            =   150
            TabIndex        =   72
            Top             =   2280
            Width           =   495
         End
         Begin VB.Label Label17 
            Alignment       =   1  'Right Justify
            Caption         =   "Number"
            Height          =   315
            Index           =   1
            Left            =   2715
            TabIndex        =   71
            Top             =   300
            Width           =   630
         End
         Begin VB.Label Label17 
            Alignment       =   1  'Right Justify
            Caption         =   "From"
            Height          =   315
            Index           =   10
            Left            =   105
            TabIndex        =   70
            Top             =   300
            Width           =   495
         End
      End
      Begin VB.Frame Frame7 
         Caption         =   " Output To "
         Height          =   1080
         Index           =   1
         Left            =   -71205
         TabIndex        =   62
         Top             =   1185
         Width           =   1230
         Begin VB.OptionButton optFax 
            Caption         =   "Fax"
            Height          =   255
            Left            =   120
            TabIndex        =   64
            Top             =   300
            Value           =   -1  'True
            Width           =   1005
         End
         Begin VB.OptionButton optFaxPreview 
            Caption         =   "Screen"
            Height          =   255
            Left            =   135
            TabIndex        =   63
            Top             =   675
            Width           =   870
         End
      End
      Begin VB.Frame Frame5 
         Caption         =   " Print Forms "
         Height          =   1080
         Index           =   1
         Left            =   -74850
         TabIndex        =   55
         Top             =   1155
         Width           =   3405
         Begin VB.CommandButton Command4 
            Caption         =   "&Browse"
            Enabled         =   0   'False
            Height          =   315
            Left            =   2115
            TabIndex        =   59
            Top             =   240
            Width           =   1200
         End
         Begin VB.TextBox txtFaxForm 
            Height          =   315
            Left            =   660
            TabIndex        =   58
            Text            =   "NEWINV"
            Top             =   240
            Width           =   1410
         End
         Begin VB.CommandButton Command3 
            Caption         =   "&Browse"
            Enabled         =   0   'False
            Height          =   315
            Left            =   2100
            TabIndex        =   57
            Top             =   645
            Width           =   1200
         End
         Begin VB.TextBox txtFaxCoverSheet 
            Height          =   315
            Left            =   645
            TabIndex        =   56
            Text            =   "COVER"
            Top             =   645
            Width           =   1410
         End
         Begin VB.Label Label4 
            Alignment       =   1  'Right Justify
            Caption         =   "Form"
            Height          =   315
            Index           =   1
            Left            =   60
            TabIndex        =   61
            Top             =   285
            Width           =   495
         End
         Begin VB.Label Label5 
            Alignment       =   1  'Right Justify
            Caption         =   "Cover"
            Height          =   315
            Index           =   1
            Left            =   60
            TabIndex        =   60
            Top             =   690
            Width           =   480
         End
      End
      Begin VB.CommandButton cmdEmailOK 
         Caption         =   "&OK"
         Height          =   315
         Left            =   -70290
         TabIndex        =   54
         Top             =   5520
         Width           =   1200
      End
      Begin VB.CommandButton cmdEmailCancel 
         Caption         =   "&Cancel"
         Height          =   315
         Left            =   -68970
         TabIndex        =   53
         Top             =   5520
         Width           =   1200
      End
      Begin VB.Frame Frame8 
         Caption         =   " Email Options "
         Height          =   1080
         Left            =   -70020
         TabIndex        =   25
         Top             =   360
         Width           =   2265
         Begin VB.CheckBox chkSendReader 
            Caption         =   "Send Reader"
            Enabled         =   0   'False
            Height          =   255
            Left            =   135
            TabIndex        =   35
            Top             =   675
            Width           =   1335
         End
         Begin VB.ComboBox lstFormCompression 
            Height          =   315
            ItemData        =   "PrntDlgF.frx":0092
            Left            =   120
            List            =   "PrntDlgF.frx":009F
            Style           =   2  'Dropdown List
            TabIndex        =   34
            Top             =   270
            Width           =   2025
         End
      End
      Begin VB.Frame Frame7 
         Caption         =   " Output To "
         Height          =   1080
         Index           =   0
         Left            =   -71355
         TabIndex        =   24
         Top             =   360
         Width           =   1230
         Begin VB.OptionButton optPreviewEmail 
            Caption         =   "Screen"
            Height          =   255
            Left            =   135
            TabIndex        =   27
            Top             =   675
            Width           =   870
         End
         Begin VB.OptionButton optEmail 
            Caption         =   "Email"
            Height          =   255
            Left            =   120
            TabIndex        =   26
            Top             =   300
            Value           =   -1  'True
            Width           =   1005
         End
      End
      Begin VB.Frame Frame6 
         Caption         =   " Email Information "
         Height          =   3960
         Left            =   -74850
         TabIndex        =   23
         Top             =   1470
         Width           =   7095
         Begin VB.TextBox txtAttachments 
            Height          =   315
            Left            =   690
            TabIndex        =   51
            Top             =   3495
            Width           =   6255
         End
         Begin VB.TextBox txtEmailMessage 
            Height          =   750
            Left            =   705
            MultiLine       =   -1  'True
            TabIndex        =   49
            Text            =   "PrntDlgF.frx":00CE
            Top             =   2655
            Width           =   6240
         End
         Begin VB.ComboBox lstEmailPriority 
            Height          =   315
            ItemData        =   "PrntDlgF.frx":00E3
            Left            =   5340
            List            =   "PrntDlgF.frx":00F0
            Style           =   2  'Dropdown List
            TabIndex        =   48
            Top             =   2250
            Width           =   1620
         End
         Begin VB.TextBox txtEmailSubject 
            Height          =   315
            Left            =   705
            TabIndex        =   45
            Text            =   "Test Email"
            Top             =   2250
            Width           =   3915
         End
         Begin MSComctlLib.ListView lvRecipients 
            Height          =   1515
            Left            =   690
            TabIndex        =   43
            Top             =   645
            Width           =   4995
            _ExtentX        =   8811
            _ExtentY        =   2672
            View            =   3
            LabelWrap       =   -1  'True
            HideSelection   =   -1  'True
            FullRowSelect   =   -1  'True
            _Version        =   393217
            ForeColor       =   -2147483640
            BackColor       =   -2147483643
            BorderStyle     =   1
            Appearance      =   1
            NumItems        =   3
            BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
               Object.Width           =   706
            EndProperty
            BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
               SubItemIndex    =   1
               Text            =   "Name"
               Object.Width           =   3616
            EndProperty
            BeginProperty ColumnHeader(3) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
               SubItemIndex    =   2
               Text            =   "Email Address"
               Object.Width           =   6174
            EndProperty
         End
         Begin VB.CommandButton cmdDeleteEmail 
            Caption         =   "&Delete"
            Height          =   315
            Left            =   5730
            TabIndex        =   42
            Top             =   1815
            Width           =   1200
         End
         Begin VB.CommandButton cmdAddEmail 
            Caption         =   "&Add"
            Height          =   315
            Left            =   5730
            TabIndex        =   41
            Top             =   960
            Width           =   1200
         End
         Begin VB.CommandButton cmdEditEmail 
            Caption         =   "&Edit"
            Height          =   315
            Left            =   5730
            TabIndex        =   40
            Top             =   1395
            Width           =   1200
         End
         Begin VB.TextBox txtSenderEmail 
            Height          =   315
            Left            =   3450
            TabIndex        =   38
            Text            =   "prutherford@exchequer.com"
            Top             =   255
            Width           =   3495
         End
         Begin VB.TextBox txtSenderName 
            Height          =   315
            Left            =   705
            TabIndex        =   36
            Text            =   "PaulR"
            Top             =   255
            Width           =   1965
         End
         Begin VB.Label Label9 
            Alignment       =   1  'Right Justify
            Caption         =   "Attach."
            Height          =   315
            Index           =   3
            Left            =   60
            TabIndex        =   52
            Top             =   3540
            Width           =   525
         End
         Begin VB.Label Label9 
            Alignment       =   1  'Right Justify
            Caption         =   "Mess."
            Height          =   315
            Index           =   2
            Left            =   105
            TabIndex        =   50
            Top             =   2700
            Width           =   495
         End
         Begin VB.Label Label9 
            Alignment       =   1  'Right Justify
            Caption         =   "Priority"
            Height          =   315
            Index           =   1
            Left            =   4770
            TabIndex        =   47
            Top             =   2295
            Width           =   495
         End
         Begin VB.Label Label9 
            Alignment       =   1  'Right Justify
            Caption         =   "Subj."
            Height          =   315
            Index           =   0
            Left            =   105
            TabIndex        =   46
            Top             =   2295
            Width           =   495
         End
         Begin VB.Label Label8 
            Alignment       =   1  'Right Justify
            Caption         =   "To/CC"
            Height          =   315
            Index           =   0
            Left            =   105
            TabIndex        =   44
            Top             =   945
            Width           =   495
         End
         Begin VB.Label Label7 
            Alignment       =   1  'Right Justify
            Caption         =   "Email"
            Height          =   315
            Left            =   2715
            TabIndex        =   39
            Top             =   300
            Width           =   630
         End
         Begin VB.Label Label6 
            Alignment       =   1  'Right Justify
            Caption         =   "From"
            Height          =   315
            Left            =   105
            TabIndex        =   37
            Top             =   300
            Width           =   495
         End
      End
      Begin VB.Frame Frame5 
         Caption         =   " Print Forms "
         Height          =   1080
         Index           =   0
         Left            =   -74850
         TabIndex        =   22
         Top             =   360
         Width           =   3405
         Begin VB.TextBox txtEmailCoverForm 
            Height          =   315
            Left            =   645
            TabIndex        =   32
            Text            =   "EMLCOVER"
            Top             =   645
            Width           =   1410
         End
         Begin VB.CommandButton Command2 
            Caption         =   "&Browse"
            Enabled         =   0   'False
            Height          =   315
            Left            =   2100
            TabIndex        =   31
            Top             =   645
            Width           =   1200
         End
         Begin VB.TextBox txtEmailForm 
            Height          =   315
            Left            =   660
            TabIndex        =   29
            Text            =   "NEWINV"
            Top             =   240
            Width           =   1410
         End
         Begin VB.CommandButton Command1 
            Caption         =   "&Browse"
            Enabled         =   0   'False
            Height          =   315
            Left            =   2115
            TabIndex        =   28
            Top             =   240
            Width           =   1200
         End
         Begin VB.Label Label5 
            Alignment       =   1  'Right Justify
            Caption         =   "Cover"
            Height          =   315
            Index           =   0
            Left            =   60
            TabIndex        =   33
            Top             =   690
            Width           =   480
         End
         Begin VB.Label Label4 
            Alignment       =   1  'Right Justify
            Caption         =   "Form"
            Height          =   315
            Index           =   0
            Left            =   60
            TabIndex        =   30
            Top             =   285
            Width           =   495
         End
      End
      Begin VB.CommandButton cmdPrinterCancel 
         Caption         =   "&Cancel"
         Height          =   315
         Left            =   6060
         TabIndex        =   14
         Top             =   2430
         Width           =   1200
      End
      Begin VB.CommandButton cmdPrnterOK 
         Caption         =   "&OK"
         Height          =   315
         Left            =   4740
         TabIndex        =   13
         Top             =   2430
         Width           =   1200
      End
      Begin VB.Frame Frame3 
         Height          =   735
         Left            =   2910
         TabIndex        =   11
         Top             =   1560
         Width           =   1635
         Begin VB.CheckBox chkTestMode 
            Caption         =   "Test Mode"
            Height          =   255
            Left            =   180
            TabIndex        =   12
            Top             =   300
            Width           =   1335
         End
      End
      Begin VB.Frame Frame2 
         Caption         =   " Output To "
         Height          =   735
         Left            =   150
         TabIndex        =   10
         Top             =   1560
         Width           =   2655
         Begin VB.ComboBox lstOutputTo 
            Height          =   315
            ItemData        =   "PrntDlgF.frx":0107
            Left            =   120
            List            =   "PrntDlgF.frx":0117
            Style           =   2  'Dropdown List
            TabIndex        =   19
            Top             =   300
            Width           =   2415
         End
      End
      Begin VB.Frame Frame1 
         Caption         =   " Printer "
         Height          =   1125
         Index           =   0
         Left            =   150
         TabIndex        =   1
         Top             =   360
         Width           =   7095
         Begin VB.CommandButton cmdBrowse 
            Caption         =   "&Browse"
            Enabled         =   0   'False
            Height          =   315
            Left            =   5730
            TabIndex        =   9
            Top             =   660
            Width           =   1200
         End
         Begin VB.CommandButton cmdPrinterSetup 
            Caption         =   "&Setup"
            Enabled         =   0   'False
            Height          =   315
            Left            =   5730
            TabIndex        =   8
            Top             =   270
            Width           =   1200
         End
         Begin VB.ComboBox lstPrinters 
            Height          =   315
            Left            =   960
            Style           =   2  'Dropdown List
            TabIndex        =   4
            Top             =   270
            Width           =   4725
         End
         Begin VB.TextBox txtCopies 
            Height          =   315
            Left            =   960
            TabIndex        =   3
            Text            =   "1"
            Top             =   660
            Width           =   945
         End
         Begin VB.TextBox txtFormName 
            Height          =   315
            Left            =   4200
            TabIndex        =   2
            Text            =   "NEWINV"
            Top             =   660
            Width           =   1485
         End
         Begin VB.Label Label1 
            Alignment       =   1  'Right Justify
            Caption         =   "Printer"
            Height          =   285
            Left            =   180
            TabIndex        =   7
            Top             =   330
            Width           =   675
         End
         Begin VB.Label Label2 
            Alignment       =   1  'Right Justify
            Caption         =   "Copies"
            Height          =   315
            Index           =   0
            Left            =   180
            TabIndex        =   6
            Top             =   705
            Width           =   615
         End
         Begin VB.Label Label3 
            Alignment       =   1  'Right Justify
            Caption         =   "Form"
            Height          =   315
            Left            =   3495
            TabIndex        =   5
            Top             =   705
            Width           =   615
         End
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim oToolkit As Enterprise01.Toolkit
Dim oFormsTK As EnterpriseForms.PrintingToolkit

Dim FormMode As TEFPrintFormMode
Dim MainFileNo%
Dim MainIndexNo%
Dim MainKeyString$
Dim TableFileNo%
Dim TableIndexNo%
Dim TableKeyString$

Private Sub DispEmailDets(DlgMode%)
    Dim lvItem As ListItem
    Load frmEmailDetails
    With frmEmailDetails
        Select Case DlgMode%
        Case 1 ' Add
            .Caption = "Add Email Recipient"
            
        Case 2 ' Edit
            ' Load details from list
            .SetDetails lvRecipients.SelectedItem.Text, lvRecipients.SelectedItem.SubItems(1), lvRecipients.SelectedItem.SubItems(2)
            .Caption = "Edit Email Recipient"
            
        Case 3 ' Delete
            ' Load details from list nd change dlg to Confirm mode
            .Caption = "Confirm Email Recipient Deletion"
            .OKButton.Caption = "Delete"
            .SetDetails lvRecipients.SelectedItem.Text, lvRecipients.SelectedItem.SubItems(1), lvRecipients.SelectedItem.SubItems(2)
        End Select ' DlgMode%
            
        .Show 1, Me
        
        If .Result Then
            Select Case DlgMode%
            Case 1 ' Add
                Set lvItem = lvRecipients.ListItems.Add(, , .EmailStr)
                lvItem.SubItems(1) = .txtRecipName.Text
                lvItem.SubItems(2) = .txtRecipAddr.Text
                Set lvItem = Nothing
            Case 2 ' Add
                lvRecipients.SelectedItem.Text = .EmailStr
                lvRecipients.SelectedItem.SubItems(1) = .txtRecipName.Text
                lvRecipients.SelectedItem.SubItems(2) = .txtRecipAddr.Text
            Case 3 ' Delete
              lvRecipients.ListItems.Remove (lvRecipients.SelectedItem.Index)
            End Select ' DlgMode%
        End If ' .Result
    End With ' frmEmailDetails
    Unload frmEmailDetails
End Sub


Private Sub DisplayPreview(oTempFile As EnterpriseForms.IEFPrintTempFile, PrevMode%)
    Dim Res&
    
    If (PrevMode% = 1) Then
        ' Preview using the EDF/EDZ Reader
        Res& = oTempFile.DisplayPreviewWindow(ptEDFReader)
    ElseIf (PrevMode% = 2) Then
        ' Preview in a non-modal window
        Res& = oTempFile.DisplayPreviewWindow(ptNonModal)
        SetForegroundWindow Res&
    ElseIf (PrevMode% = 3) Then
        ' Preview in a VB window using the Active-X control
        Load frmPreviewAX
        With frmPreviewAX
            Set .oPreviewTempFile = oTempFile
            .entPreviewX1.FileName = oTempFile.pfFileName
            .entPreviewX1.Active = True
            .Show 1, Me
            .entPreviewX1.Active = False
            Set .oPreviewTempFile = Nothing
        End With ' frmPreviewAX
        Unload frmPreviewAX
    End If
        
    ' NOTE: oTempFile object is de-referenced after this finishes causing the
    '       temp file to be deleted.
    MsgBox "Click OK to continue"
End Sub


Private Sub cmdAddEmail_Click()
    DispEmailDets 1
End Sub

Private Sub cmdDeleteEmail_Click()
    DispEmailDets 3
End Sub

Private Sub cmdEditEmail_Click()
    DispEmailDets 2
End Sub

Private Sub cmdEmailCancel_Click()
    Unload Me
End Sub

Private Sub cmdEmailOK_Click()
    Dim oTempFile As EnterpriseForms.IEFPrintTempFile
    Dim oItem As ListItem
    Dim I%, Res&

    If GetPrintData Then
        ' Setup the print Job Details
        With oFormsTK.PrintJob
            ' Clear out any pre-existing details from previous print jobs
            .Initialise (FormMode)
            
            ' Add Form Details
            With .pjForms.Add
                .fdMode = FormMode
                .fdFormName = txtEmailForm.Text
                
                .fdMainFileNo = MainFileNo%
                .fdMainIndexNo = MainIndexNo%
                .fdMainKeyString = MainKeyString$
                
                .fdTableFileNo = TableFileNo%
                .fdTableIndexNo = TableIndexNo%
                .fdTableKeyString = TableKeyString$
                
                .Save
            End With ' .pjForms.Add
            
            ' Email Details
            With .pjEmailInfo
                .emSenderName = txtSenderName.Text
                .emSenderAddress = txtSenderEmail.Text
                                
                If (lvRecipients.ListItems.Count > 0) Then
                    For Each oItem In lvRecipients.ListItems
                        If oItem.Text = "To" Then
                            ' Add into To list
                            .emToRecipients.AddAddress oItem.SubItems(1), oItem.SubItems(2)
                        ElseIf oItem.Text = "CC" Then
                            ' Add into CC list
                            .emCCRecipients.AddAddress oItem.SubItems(1), oItem.SubItems(2)
                        Else
                            ' Add into BCC list
                            .emBCCRecipients.AddAddress oItem.SubItems(1), oItem.SubItems(2)
                        End If
                    Next
                Else
                    ' no recipients specified
                    MsgBox "At least one recipient must be specified"
                    Exit Sub
                End If
                
                .emSubject = txtEmailSubject.Text
                .emMessageText = txtEmailMessage.Text
                
                .emCoverSheet = txtEmailCoverForm.Text
                
                Select Case lstEmailPriority.ListIndex
                Case 0
                    .emPriority = empLow
                Case 1
                    .emPriority = empNormal
                Case 2
                    .emPriority = empHigh
                End Select
                
                Select Case lstFormCompression.ListIndex
                Case 0
                    .emFormCompression = fcNone
                Case 1
                    .emFormCompression = fcZIP
                Case 2
                    .emFormCompression = fcEDZ
                End Select
                
                If (Trim(txtAttachments.Text) <> "") Then
                    ' Only add attachments if set!
                    .emAttachments.Add txtAttachments.Text
                End If ' Trim(txtAttachments.Text) <> ""
            End With ' .pjEmailInfo
            
            '------------------------------------------------------------
            
            ' Print to temporary file
            Set oTempFile = .PrintToTempFile(tfdEmail)
            If optEmail.Value Then
                ' Send as email
                Res& = oTempFile.SendToDestination
                MsgBox "SendToDestination (Email): " + Str(Res&)
            Else
                ' Preview
                DisplayPreview oTempFile, 3
            End If
            Set oTempFile = Nothing
        End With ' oFormsTK.PrintJob
    End If
End Sub

Private Sub cmdFaxCancel_Click()
    Unload Me
End Sub

Private Sub cmdFaxOK_Click()
    Dim oTempFile As EnterpriseForms.IEFPrintTempFile
    Dim oItem As ListItem
    Dim I%, Res&

    If GetPrintData Then
        ' Setup the print Job Details
        With oFormsTK.PrintJob
            ' Clear out any pre-existing details from previous print jobs
            .Initialise (FormMode)
            
            ' Add Form Details
            With .pjForms.Add
                .fdMode = FormMode
                .fdFormName = txtFaxForm.Text
                
                .fdMainFileNo = MainFileNo%
                .fdMainIndexNo = MainIndexNo%
                .fdMainKeyString = MainKeyString$
                
                .fdTableFileNo = TableFileNo%
                .fdTableIndexNo = TableIndexNo%
                .fdTableKeyString = TableKeyString$
                
                .Save
            End With ' .pjForms.Add
            
            ' Fax Details
            With .pjFaxInfo
                .fxSenderName = txtFaxSenderName.Text
                .fxSenderFaxNumber = txtFaxSenderNumber.Text
                
                .fxRecipientName = txtFaxRecipName.Text
                .fxRecipientFaxNumber = txtFaxRecipNumber.Text
                
                .fxFaxDescription = txtFaxDesc.Text
                .fxMessageText = txtFaxMsg.Text
                
                .fxCoverSheet = txtFaxCoverSheet.Text
                
                Select Case lstFaxPriority.ListIndex
                Case 0
                    .fxPriority = fpOffPeak
                Case 1
                    .fxPriority = fpNormal
                Case 2
                    .fxPriority = fpUrgent
                End Select
            End With ' .pjEmailInfo
            
            '------------------------------------------------------------
            
            ' Print to temporary file
            Set oTempFile = .PrintToTempFile(tfdFax)
            If optFax.Value Then
                ' Send as fax
                Res& = oTempFile.SendToDestination
                MsgBox "SendToDestination (Fax): " + Str(Res&)
            Else
                ' Preview
                DisplayPreview oTempFile, 3
            End If
            Set oTempFile = Nothing
        End With ' oFormsTK.PrintJob
    End If
End Sub

Private Sub cmdPrinterCancel_Click()
    Unload Me
End Sub

Private Sub cmdPrnterOK_Click()
    Dim oTempFile As EnterpriseForms.IEFPrintTempFile
    Dim I%, Res&

    If (lstOutputTo.ListIndex >= 0) And GetPrintData Then
        ' Setup the print Job Details
        With oFormsTK.PrintJob
            ' Clear out any pre-existing details from previous print jobs
            .Initialise (FormMode)
            
            ' Printer Details
            .pjPrinterIndex = lstPrinters.ListIndex + 1
            .pjPaperIndex = oFormsTK.Printers(.pjPrinterIndex).pdDefaultPaper
            .pjBinIndex = oFormsTK.Printers(.pjPrinterIndex).pdDefaultBin
    
            ' Misc flags/settings
            .pjCopies = CInt(txtCopies.Text)
            .pjTitle = txtJobTitle.Text
            .pjTestMode = chkTestMode.Value
                
            ' Add Form Details
            With .pjForms.Add
                .fdMode = FormMode
                .fdFormName = txtFormName.Text
                
                .fdMainFileNo = MainFileNo%
                .fdMainIndexNo = MainIndexNo%
                .fdMainKeyString = MainKeyString$
                
                .fdTableFileNo = TableFileNo%
                .fdTableIndexNo = TableIndexNo%
                .fdTableKeyString = TableKeyString$
                
                .Save
            End With ' .pjForms.Add

                
            ' Output media - Printer/Preview/Email/Fax
            If (lstOutputTo.ListIndex = 0) Then
                ' Print Direct to Printer
                Res& = .PrintToPrinter
                MsgBox "PrintJob.PrintToPrinter: " + Str(Res&)
            Else
                ' Preview
                Set oTempFile = .PrintToTempFile(tfdPrinter)
                DisplayPreview oTempFile, lstOutputTo.ListIndex
                Set oTempFile = Nothing
            End If
        End With ' oFormsTK.PrintJob
    End If
End Sub


Private Sub Form_Load()
    Dim Res&, PrinterNo%
    
    ' Create Enterprise forms Toolkit object
    Set oToolkit = CreateObject("Enterprise01.Toolkit")
    
    With oToolkit
        ' Configure the Toolkit to use the required dataset
        .Configuration.DataDirectory = "C:\DEVELOP\Dev500\"
        
        Res& = .OpenToolkit
        
        If (Res& = 0) Then
            ' Create Enterprise forms Toolkit object
            Set oFormsTK = CreateObject("EnterpriseForms.PrintingToolkit")
    
            With oFormsTK
                Caption = Caption + " (" + oFormsTK.Version + ")"
                    
                ' Configure the Forms toolkit to use the required dataset
                With .Configuration
                    .cfDataDirectory = oToolkit.Configuration.DataDirectory
                    .cfEnterpriseDirectory = oToolkit.Configuration.EnterpriseDirectory
                End With ' .Configuration
                
                ' open the dataset and initialise the printing routines
                Res& = .OpenPrinting("Form Printing Toolkit Demo", "EXFPTDEM-QTFEQB-0FZND4")
                
                If (Res& = 0) Then
                    With .Printers
                        ' Load Printers List
                        If (.prCount > 0) Then
                            For PrinterNo% = 1 To .prCount
                                With .prPrinters(PrinterNo%)
                                    lstPrinters.AddItem .pdName
                                    lstMAPIFaxPrinters.AddItem .pdName
                                End With ' .prPrinter(I%)
                            Next PrinterNo%
                            
                            If (.prDefaultPrinter >= 0) And (.prDefaultPrinter <= .prCount) Then
                                lstPrinters.ListIndex = .prDefaultPrinter - 1
                            End If
                        End If
                    End With ' .Printers
                    
                    With .PrintJob
                        ' Setup misc details
                        txtJobTitle.Text = .pjTitle
                        
                        ' Setup Printer details
                        txtCopies.Text = Trim(Str(.pjCopies))
                        
                        ' Setup Email details
                        txtSenderName.Text = .pjEmailInfo.emSenderName
                        txtSenderEmail.Text = .pjEmailInfo.emSenderAddress
                        txtEmailSubject.Text = .pjEmailInfo.emSubject
                        Select Case .pjEmailInfo.emFormCompression
                            Case fcNone
                                lstFormCompression.ListIndex = 0
                            Case fcZIP
                                lstFormCompression.ListIndex = 1
                            Case fcEDZ
                                lstFormCompression.ListIndex = 2
                        End Select
                        Select Case .pjEmailInfo.emPriority
                            Case empLow
                                lstEmailPriority.ListIndex = 0
                            Case empNormal
                                lstEmailPriority.ListIndex = 1
                            Case empHigh
                                lstEmailPriority.ListIndex = 2
                        End Select
                        Select Case .pjFaxInfo.fxPriority
                            Case fpOffPeak
                                lstFaxPriority.ListIndex = 0
                            Case fpNormal
                                lstFaxPriority.ListIndex = 1
                            Case fpUrgent
                                lstFaxPriority.ListIndex = 2
                        End Select
                        
                        ' Only select a printer for MAPI
                        lstMAPIFaxPrinters.Enabled = (.pjFaxInfo.fxType = ftMAPI)
                        If Not lstMAPIFaxPrinters.Enabled Then
                            ' select Fax printer
                            If (.pjFaxInfo.fxFaxPrinterIndex >= 0) And (.pjFaxInfo.fxFaxPrinterIndex <= oFormsTK.Printers.prCount) Then
                                lstMAPIFaxPrinters.ListIndex = .pjFaxInfo.fxFaxPrinterIndex - 1
                            End If
                        Else
                            ' Select default printer
                            If (oFormsTK.Printers.prDefaultPrinter >= 0) And (oFormsTK.Printers.prDefaultPrinter <= oFormsTK.Printers.prCount) Then
                                lstMAPIFaxPrinters.ListIndex = oFormsTK.Printers.prDefaultPrinter - 1
                            End If
                        End If
                    End With ' .PrintJob
                Else
                    MsgBox "Error " + Str(Res&) + " opening the Form Printing toolkit"
                End If
            End With ' oFormsTK
        Else
            MsgBox "Error " + Str(Res&) + " opening the COM Toolkit"
        End If ' Res& = 0
    End With ' oToolkit
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Set oFormsTK = Nothing
    Set oToolkit = Nothing
End Sub

Private Function GetPrintData() As Boolean
    Dim Res&
    
    GetPrintData = False
    
    If optNormalTrans.Value Then
        ' Normal Transaction, e.g. SIN, SOR, etc...
        If (Trim(txtOurRef.Text) <> "") Then
            With oToolkit.Transaction
                Res& = .GetEqual(.BuildOurRefIndex(txtOurRef.Text))
                If (Res& = 0) Then
                    GetPrintData = True
                    
                    FormMode = fmNormalDocs
                    MainFileNo% = 2
                    MainIndexNo% = 2
                    MainKeyString$ = .BuildOurRefIndex(.thOurRef)
                    TableFileNo% = 3
                    TableIndexNo% = 0
                    TableKeyString$ = .BuildFolioIndex(.thFolioNum)
                Else
                    MsgBox txtOurRef.Text + " not found"
                End If
            End With ' oToolkit.Transaction
        Else
            MsgBox "Invalid OurRef"
        End If
    Else
        ' No valid options selected
        MsgBox "Select a valid Data Source before printing"
    End If
End Function

Private Sub Label3_Click()
    With oFormsTK.Functions.fnGetFormInfo(txtFormName)
        MsgBox .fiDescription
    End With
End Sub

Private Sub Label6_Click()
    txtSenderName.Text = "Higgi"
    txtSenderEmail.Text = "mhigginson@exchequer.com"
    txtEmailSubject = "Test Email"
End Sub

Private Sub Label7_Click()
    Dim lvItem As ListItem
    
    Set lvItem = lvRecipients.ListItems.Add(, , "To")
    lvItem.SubItems(1) = txtSenderName.Text
    lvItem.SubItems(2) = txtSenderEmail.Text
    Set lvItem = Nothing
End Sub


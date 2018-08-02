VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmPrintDlg 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Form1"
   ClientHeight    =   6135
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7590
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6135
   ScaleWidth      =   7590
   StartUpPosition =   2  'CenterScreen
   Begin TabDlg.SSTab SSTab1 
      Height          =   5970
      Left            =   105
      TabIndex        =   0
      Top             =   75
      Width           =   7395
      _ExtentX        =   13044
      _ExtentY        =   10530
      _Version        =   393216
      Style           =   1
      TabHeight       =   520
      TabCaption(0)   =   "Printer"
      TabPicture(0)   =   "PRNTDLGF.frx":0000
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
      Tab(0).Control(5)=   "CommonDialog1"
      Tab(0).Control(5).Enabled=   0   'False
      Tab(0).ControlCount=   6
      TabCaption(1)   =   "Email"
      TabPicture(1)   =   "PRNTDLGF.frx":001C
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "cmdEmailOK"
      Tab(1).Control(1)=   "cmdEmailCancel"
      Tab(1).Control(2)=   "Frame8"
      Tab(1).Control(3)=   "Frame7(0)"
      Tab(1).Control(4)=   "Frame6"
      Tab(1).Control(5)=   "Frame5(0)"
      Tab(1).ControlCount=   6
      TabCaption(2)   =   "Fax"
      TabPicture(2)   =   "PRNTDLGF.frx":0038
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "Frame5(1)"
      Tab(2).Control(1)=   "Frame7(1)"
      Tab(2).Control(2)=   "Frame9"
      Tab(2).Control(3)=   "cmdFaxOK"
      Tab(2).Control(4)=   "cmdFaxCancel"
      Tab(2).Control(5)=   "Frame1(1)"
      Tab(2).ControlCount=   6
      Begin MSComDlg.CommonDialog CommonDialog1 
         Left            =   225
         Top             =   4485
         _ExtentX        =   847
         _ExtentY        =   847
         _Version        =   393216
         CancelError     =   -1  'True
         DefaultExt      =   "*.EFD"
         DialogTitle     =   "Select Form"
         Filter          =   "Enterprise Forms|*.EFX|PCC Forms|*.DEF|All Files|*.*"
         Flags           =   6156
      End
      Begin VB.Frame Frame1 
         Caption         =   " MAPI Printer "
         Height          =   750
         Index           =   1
         Left            =   -74850
         TabIndex        =   74
         Top             =   360
         Width           =   7095
         Begin VB.ComboBox lstMAPIFaxPrinters 
            Height          =   315
            Left            =   960
            Style           =   2  'Dropdown List
            TabIndex        =   76
            Top             =   270
            Width           =   4725
         End
         Begin VB.CommandButton Command6 
            Caption         =   "&Setup"
            Enabled         =   0   'False
            Height          =   315
            Left            =   5730
            TabIndex        =   75
            Top             =   270
            Width           =   1200
         End
         Begin VB.Label Label10 
            Alignment       =   1  'Right Justify
            Caption         =   "Printer"
            Height          =   285
            Left            =   180
            TabIndex        =   77
            Top             =   330
            Width           =   675
         End
      End
      Begin VB.CommandButton cmdFaxCancel 
         Cancel          =   -1  'True
         Caption         =   "&Cancel"
         Height          =   315
         Left            =   -69060
         TabIndex        =   73
         Top             =   5175
         Width           =   1200
      End
      Begin VB.CommandButton cmdFaxOK 
         Caption         =   "&OK"
         Default         =   -1  'True
         Height          =   315
         Left            =   -70380
         TabIndex        =   72
         Top             =   5190
         Width           =   1200
      End
      Begin VB.Frame Frame9 
         Caption         =   " Email Information "
         Height          =   2685
         Left            =   -74865
         TabIndex        =   59
         Top             =   2415
         Width           =   7095
         Begin VB.TextBox txtFaxDesc 
            Height          =   315
            Left            =   705
            TabIndex        =   78
            Top             =   1020
            Width           =   6240
         End
         Begin VB.TextBox txtFaxRecipNumber 
            Height          =   315
            Left            =   3450
            TabIndex        =   69
            Top             =   645
            Width           =   3495
         End
         Begin VB.TextBox txtFaxRecipName 
            Height          =   315
            Left            =   705
            TabIndex        =   68
            Top             =   645
            Width           =   1965
         End
         Begin VB.TextBox txtFaxMsg 
            Height          =   750
            Left            =   705
            MultiLine       =   -1  'True
            TabIndex        =   63
            Top             =   1395
            Width           =   6255
         End
         Begin VB.ComboBox lstFaxPriority 
            Height          =   315
            ItemData        =   "PRNTDLGF.frx":0054
            Left            =   705
            List            =   "PRNTDLGF.frx":0061
            Style           =   2  'Dropdown List
            TabIndex        =   62
            Top             =   2220
            Width           =   1620
         End
         Begin VB.TextBox txtFaxSenderNumber 
            Height          =   315
            Left            =   3450
            TabIndex        =   61
            Top             =   255
            Width           =   3495
         End
         Begin VB.TextBox txtFaxSenderName 
            Height          =   315
            Left            =   705
            TabIndex        =   60
            Top             =   255
            Width           =   1965
         End
         Begin VB.Label Label17 
            Alignment       =   1  'Right Justify
            Caption         =   "Desc"
            Height          =   315
            Index           =   0
            Left            =   120
            TabIndex        =   79
            Top             =   1065
            Width           =   495
         End
         Begin VB.Label Label17 
            Alignment       =   1  'Right Justify
            Caption         =   "Number"
            Height          =   315
            Index           =   2
            Left            =   2715
            TabIndex        =   71
            Top             =   690
            Width           =   630
         End
         Begin VB.Label Label17 
            Alignment       =   1  'Right Justify
            Caption         =   "To"
            Height          =   315
            Index           =   12
            Left            =   120
            TabIndex        =   70
            Top             =   690
            Width           =   495
         End
         Begin VB.Label Label9 
            Alignment       =   1  'Right Justify
            Caption         =   "Note"
            Height          =   315
            Index           =   5
            Left            =   75
            TabIndex        =   67
            Top             =   1425
            Width           =   510
         End
         Begin VB.Label Label9 
            Alignment       =   1  'Right Justify
            Caption         =   "Priority"
            Height          =   315
            Index           =   6
            Left            =   150
            TabIndex        =   66
            Top             =   2280
            Width           =   495
         End
         Begin VB.Label Label17 
            Alignment       =   1  'Right Justify
            Caption         =   "Number"
            Height          =   315
            Index           =   1
            Left            =   2715
            TabIndex        =   65
            Top             =   300
            Width           =   630
         End
         Begin VB.Label Label17 
            Alignment       =   1  'Right Justify
            Caption         =   "From"
            Height          =   315
            Index           =   10
            Left            =   105
            TabIndex        =   64
            Top             =   300
            Width           =   495
         End
      End
      Begin VB.Frame Frame7 
         Caption         =   " Output To "
         Height          =   1080
         Index           =   1
         Left            =   -71205
         TabIndex        =   56
         Top             =   1185
         Width           =   1230
         Begin VB.OptionButton optFax 
            Caption         =   "Fax"
            Height          =   255
            Left            =   120
            TabIndex        =   58
            Top             =   300
            Value           =   -1  'True
            Width           =   1005
         End
         Begin VB.OptionButton optFaxPreview 
            Caption         =   "Screen"
            Height          =   255
            Left            =   135
            TabIndex        =   57
            Top             =   675
            Width           =   870
         End
      End
      Begin VB.Frame Frame5 
         Caption         =   " Print Forms "
         Height          =   1080
         Index           =   1
         Left            =   -74850
         TabIndex        =   49
         Top             =   1155
         Width           =   3405
         Begin VB.CommandButton cmdBrowseFaxForm 
            Caption         =   "&Browse"
            Height          =   315
            Left            =   2115
            TabIndex        =   53
            Top             =   240
            Width           =   1200
         End
         Begin VB.TextBox txtFaxForm 
            Enabled         =   0   'False
            Height          =   315
            Left            =   660
            TabIndex        =   52
            Top             =   240
            Width           =   1410
         End
         Begin VB.CommandButton cmdBrowseFaxCover 
            Caption         =   "&Browse"
            Height          =   315
            Left            =   2100
            TabIndex        =   51
            Top             =   645
            Width           =   1200
         End
         Begin VB.TextBox txtFaxCoverSheet 
            Enabled         =   0   'False
            Height          =   315
            Left            =   645
            TabIndex        =   50
            Top             =   645
            Width           =   1410
         End
         Begin VB.Label Label4 
            Alignment       =   1  'Right Justify
            Caption         =   "Form"
            Height          =   315
            Index           =   1
            Left            =   60
            TabIndex        =   55
            Top             =   285
            Width           =   495
         End
         Begin VB.Label lblFaxCover 
            Alignment       =   1  'Right Justify
            Caption         =   "Cover"
            Height          =   315
            Left            =   60
            TabIndex        =   54
            Top             =   690
            Width           =   480
         End
      End
      Begin VB.CommandButton cmdEmailOK 
         Caption         =   "&OK"
         Height          =   315
         Left            =   -70290
         TabIndex        =   48
         Top             =   5520
         Width           =   1200
      End
      Begin VB.CommandButton cmdEmailCancel 
         Caption         =   "&Cancel"
         Height          =   315
         Left            =   -68970
         TabIndex        =   47
         Top             =   5520
         Width           =   1200
      End
      Begin VB.Frame Frame8 
         Caption         =   " Email Options "
         Height          =   1080
         Left            =   -70020
         TabIndex        =   19
         Top             =   360
         Width           =   2265
         Begin VB.CheckBox chkSendReader 
            Caption         =   "Send Reader"
            Height          =   255
            Left            =   135
            TabIndex        =   29
            Top             =   675
            Width           =   1335
         End
         Begin VB.ComboBox lstFormCompression 
            Height          =   315
            ItemData        =   "PRNTDLGF.frx":007F
            Left            =   120
            List            =   "PRNTDLGF.frx":008C
            Style           =   2  'Dropdown List
            TabIndex        =   28
            Top             =   270
            Width           =   2025
         End
      End
      Begin VB.Frame Frame7 
         Caption         =   " Output To "
         Height          =   1080
         Index           =   0
         Left            =   -71355
         TabIndex        =   18
         Top             =   360
         Width           =   1230
         Begin VB.OptionButton optPreviewEmail 
            Caption         =   "Screen"
            Height          =   255
            Left            =   135
            TabIndex        =   21
            Top             =   675
            Width           =   870
         End
         Begin VB.OptionButton optEmail 
            Caption         =   "Email"
            Height          =   255
            Left            =   120
            TabIndex        =   20
            Top             =   300
            Value           =   -1  'True
            Width           =   1005
         End
      End
      Begin VB.Frame Frame6 
         Caption         =   " Email Information "
         Height          =   3960
         Left            =   -74850
         TabIndex        =   17
         Top             =   1470
         Width           =   7095
         Begin VB.TextBox txtAttachments 
            Height          =   315
            Left            =   690
            TabIndex        =   45
            Top             =   3495
            Width           =   6255
         End
         Begin VB.TextBox txtEmailMessage 
            Height          =   750
            Left            =   705
            MultiLine       =   -1  'True
            TabIndex        =   43
            Top             =   2655
            Width           =   6240
         End
         Begin VB.ComboBox lstEmailPriority 
            Height          =   315
            ItemData        =   "PRNTDLGF.frx":00BB
            Left            =   5340
            List            =   "PRNTDLGF.frx":00C8
            Style           =   2  'Dropdown List
            TabIndex        =   42
            Top             =   2250
            Width           =   1620
         End
         Begin VB.TextBox txtEmailSubject 
            Height          =   315
            Left            =   690
            TabIndex        =   39
            Top             =   2250
            Width           =   3915
         End
         Begin MSComctlLib.ListView lvRecipients 
            Height          =   1515
            Left            =   690
            TabIndex        =   37
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
            TabIndex        =   36
            Top             =   1815
            Width           =   1200
         End
         Begin VB.CommandButton cmdAddEmail 
            Caption         =   "&Add"
            Height          =   315
            Left            =   5730
            TabIndex        =   35
            Top             =   960
            Width           =   1200
         End
         Begin VB.CommandButton cmdEditEmail 
            Caption         =   "&Edit"
            Height          =   315
            Left            =   5730
            TabIndex        =   34
            Top             =   1395
            Width           =   1200
         End
         Begin VB.TextBox txtSenderEmail 
            Height          =   315
            Left            =   3450
            TabIndex        =   32
            Top             =   255
            Width           =   3495
         End
         Begin VB.TextBox txtSenderName 
            Height          =   315
            Left            =   705
            TabIndex        =   30
            Top             =   255
            Width           =   1965
         End
         Begin VB.Label Label9 
            Alignment       =   1  'Right Justify
            Caption         =   "Attach."
            Height          =   315
            Index           =   3
            Left            =   60
            TabIndex        =   46
            Top             =   3540
            Width           =   525
         End
         Begin VB.Label Label9 
            Alignment       =   1  'Right Justify
            Caption         =   "Mess."
            Height          =   315
            Index           =   2
            Left            =   105
            TabIndex        =   44
            Top             =   2700
            Width           =   495
         End
         Begin VB.Label Label9 
            Alignment       =   1  'Right Justify
            Caption         =   "Priority"
            Height          =   315
            Index           =   1
            Left            =   4770
            TabIndex        =   41
            Top             =   2295
            Width           =   495
         End
         Begin VB.Label Label9 
            Alignment       =   1  'Right Justify
            Caption         =   "Subj."
            Height          =   315
            Index           =   0
            Left            =   105
            TabIndex        =   40
            Top             =   2295
            Width           =   495
         End
         Begin VB.Label Label8 
            Alignment       =   1  'Right Justify
            Caption         =   "To/CC"
            Height          =   315
            Index           =   0
            Left            =   105
            TabIndex        =   38
            Top             =   945
            Width           =   495
         End
         Begin VB.Label Label7 
            Alignment       =   1  'Right Justify
            Caption         =   "Email"
            Height          =   315
            Left            =   2715
            TabIndex        =   33
            Top             =   300
            Width           =   630
         End
         Begin VB.Label Label6 
            Alignment       =   1  'Right Justify
            Caption         =   "From"
            Height          =   315
            Left            =   105
            TabIndex        =   31
            Top             =   300
            Width           =   495
         End
      End
      Begin VB.Frame Frame5 
         Caption         =   " Print Forms "
         Height          =   1080
         Index           =   0
         Left            =   -74850
         TabIndex        =   16
         Top             =   360
         Width           =   3405
         Begin VB.TextBox txtEmailCoverForm 
            Enabled         =   0   'False
            Height          =   315
            Left            =   645
            TabIndex        =   26
            Top             =   645
            Width           =   1410
         End
         Begin VB.CommandButton cmdBrowseEmailCover 
            Caption         =   "&Browse"
            Height          =   315
            Left            =   2100
            TabIndex        =   25
            Top             =   645
            Width           =   1200
         End
         Begin VB.TextBox txtEmailForm 
            Enabled         =   0   'False
            Height          =   315
            Left            =   660
            TabIndex        =   23
            Top             =   240
            Width           =   1410
         End
         Begin VB.CommandButton cmdBrowseEmailForm 
            Caption         =   "&Browse"
            Height          =   315
            Left            =   2115
            TabIndex        =   22
            Top             =   240
            Width           =   1200
         End
         Begin VB.Label lblEmailCover 
            Alignment       =   1  'Right Justify
            Caption         =   "Cover"
            Height          =   315
            Left            =   60
            TabIndex        =   27
            Top             =   690
            Width           =   480
         End
         Begin VB.Label Label4 
            Alignment       =   1  'Right Justify
            Caption         =   "Form"
            Height          =   315
            Index           =   0
            Left            =   60
            TabIndex        =   24
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
            ItemData        =   "PRNTDLGF.frx":00DF
            Left            =   120
            List            =   "PRNTDLGF.frx":00EF
            Style           =   2  'Dropdown List
            TabIndex        =   15
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
            Height          =   315
            Left            =   5730
            TabIndex        =   9
            Top             =   660
            Width           =   1200
         End
         Begin VB.CommandButton cmdPrinterSetup 
            Caption         =   "&Setup"
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
            Enabled         =   0   'False
            Height          =   315
            Left            =   4200
            TabIndex        =   2
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
            Left            =   3480
            TabIndex        =   5
            Top             =   705
            Width           =   615
         End
      End
   End
End
Attribute VB_Name = "frmPrintDlg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' Local reference to generic PrintJob object from COM Toolkit
Private oPrintJob As IPrintJob


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


Private Sub DisplayPreview(oTempFile As Enterprise01.IPrintTempFile, PrevMode%)
    Dim Res&
    
    If (PrevMode% = 1) Then
        ' Preview using the EDF/EDZ Reader
        Res& = oTempFile.DisplayPreviewWindow(ptEDFReader)
    ElseIf (PrevMode% = 2) Then
        ' Preview in a non-modal window
        Res& = oTempFile.DisplayPreviewWindow(ptNonModal)
        SetForegroundWindow Res&
        
        ' NOTE: due to the structure of this program continuing at this
        ' point would cause oTempFile and the Printjob to be de-referenced
        ' causing them to Destroy and closing the Preview window the PrintJob
        ' just created.  (EDF and modal ActiveX not affected)
        MsgBox "Press any key to continue"
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
End Sub


Private Sub cmdAddEmail_Click()
    DispEmailDets 1
End Sub

Private Function BrowseForForm(CurrForm$) As String
On Error GoTo BrowseForForm_Error
    
    Dim oFormInfo As IFormDetails
    Dim I&, FormName$
    
    With CommonDialog1
        .InitDir = frmAcSINList.oToolkit.Configuration.DataDirectory + "FORMS"
        .ShowOpen
    
        ' Remove the pathing information
        FormName$ = CommonDialog1.FileName
        I& = InStr(1, FormName$, "\")
        While (I& > 0)
            FormName$ = Mid$(FormName$, I& + 1)
            I& = InStr(1, FormName$, "\")
        Wend
        
        ' remove the extension
        I& = InStr(1, FormName$, ".")
        If (I& > 0) Then FormName$ = Mid$(FormName$, 1, I& - 1)
        
        ' get the form information and check the type is correct
        Set oFormInfo = oPrintJob.GetFormInfo(FormName$)
        If ((oPrintJob.pjType = jtLabel) Or (oPrintJob.pjType = jtLabelRun)) And (oFormInfo.fiType <> ftEFDLabel) Then
            MsgBox FormName$ + " is not a valid Label Form"
            FormName$ = CurrForm$
        ElseIf (oPrintJob.pjType = jtForm) And (oFormInfo.fiType = ftEFDLabel) Then
            MsgBox FormName$ + " is a Label Form and cannot be used for non-label Print Jobs"
            FormName$ = CurrForm$
        End If
        Set oFormInfo = Nothing
    End With ' CommonDialog1
    
    BrowseForForm = FormName$
    Exit Function
    
BrowseForForm_Error:
    BrowseForForm = CurrForm$
End Function

Private Sub cmdBrowse_Click()
    txtFormName.Text = BrowseForForm(txtFormName.Text)
End Sub

Private Sub cmdBrowseEmailCover_Click()
    txtEmailCoverForm.Text = BrowseForForm(txtEmailCoverForm.Text)
End Sub

Private Sub cmdBrowseEmailForm_Click()
    txtEmailForm.Text = BrowseForForm(txtEmailForm.Text)
End Sub

Private Sub cmdBrowseFaxCover_Click()
    txtFaxCoverSheet.Text = BrowseForForm(txtFaxCoverSheet.Text)
End Sub

Private Sub cmdBrowseFaxForm_Click()
    txtFaxForm.Text = BrowseForForm(txtFaxForm.Text)
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
    Dim oTempFile As IPrintTempFile
    Dim oItem As ListItem
    Dim I%, Res&

    ' Setup the print Job Details
    With oPrintJob
        Res& = 0
                
        ' Add Form Details
        .pjForms.Clear
        With .pjForms.Add
            .fdFormName = txtEmailForm.Text
            Res& = .Save
            If (Res& <> 0) Then
                MsgBox "Error " + Str(Res&) + " adding the form (" + txtEmailForm.Text + ")into the PrintJob"
            End If
        End With ' .pjForms.Add

        If (Res& = 0) Then
            ' Email Details
            With .pjEmailInfo
                .emSenderName = txtSenderName.Text
                .emSenderAddress = txtSenderEmail.Text
    
                ' Remove any pre-existing email addresses from PrintJob
                .emToRecipients.Clear
                .emCCRecipients.Clear
                .emBCCRecipients.Clear
                
                ' Add user-Defined Email Addresses
                If (lvRecipients.ListItems.Count > 0) Then
                    For Each oItem In lvRecipients.ListItems
                        If oItem.Text = "To" Then
                            ' Add into To list
                            Res& = .emToRecipients.AddAddress(oItem.SubItems(1), oItem.SubItems(2))
                        ElseIf oItem.Text = "CC" Then
                            ' Add into CC list
                            Res& = .emCCRecipients.AddAddress(oItem.SubItems(1), oItem.SubItems(2))
                        Else
                            ' Add into BCC list
                            Res& = .emBCCRecipients.AddAddress(oItem.SubItems(1), oItem.SubItems(2))
                        End If
                        
                        If (Res& <> 0) Then
                            MsgBox "Error " + Str(Res&) + " adding Email Address for " + oItem.SubItems(1) + " - " + oItem.SubItems(2)
                            Exit For
                        End If
                    Next
                Else
                    ' no recipients specified
                    MsgBox "At least one recipient must be specified"
                    Exit Sub
                End If
        
                If (Res& = 0) Then
                    .emSubject = txtEmailSubject.Text
                    .emMessageText = txtEmailMessage.Text
        
                    .emCoverSheet = txtEmailCoverForm.Text
        
                    .emSendReader = (chkSendReader.Value = 1)
        
                    Select Case lstEmailPriority.ListIndex
                    Case 0
                        .emPriority = epLow
                    Case 1
                        .emPriority = epNormal
                    Case 2
                        .emPriority = epHigh
                    End Select
        
                    Select Case lstFormCompression.ListIndex
                    Case 0
                        .emFormCompression = emZIPNone
                    Case 1
                        .emFormCompression = emZIPPKZIP
                    Case 2
                        .emFormCompression = emZIPEDZ
                    End Select
        
                    If (Trim(txtAttachments.Text) <> "") Then
                        ' Only add attachments if set!
                        Res& = .emAttachments.Add(txtAttachments.Text)
                        If (Res& <> 0) Then MsgBox "Error " + Str(Res&) + " adding Email Attachment " + txtAttachments.Text
                    End If ' Trim(txtAttachments.Text) <> ""
                End If ' Res& = 0
            End With ' .pjEmailInfo
        End If ' Res& = 0
        
        '------------------------------------------------------------

        If (Res& = 0) Then
            ' Print to temporary file
            Set oTempFile = .PrintToTempFile(pdEmail)
            If (oTempFile.pfStatus = 0) Then
                If optEmail.Value Then
                    ' Send as email
                    Res& = oTempFile.SendToDestination
                    MsgBox "SendToDestination (Email): " + Str(Res&)
                Else
                    ' Preview
                    DisplayPreview oTempFile, 2
                End If
               
                ' Close 'Print To' dialog
                Hide
            Else
                MsgBox "PrintToTempFile (Email): " + Str(oTempFile.pfStatus)
            End If
            Set oTempFile = Nothing
        End If ' Res& = 0
    End With ' oPrintJob
End Sub

Private Sub cmdFaxCancel_Click()
    Unload Me
End Sub

Private Sub cmdFaxOK_Click()
    Dim oTempFile As IPrintTempFile
    Dim oItem As ListItem
    Dim I%, Res&

    ' Setup the print Job Details
    With oPrintJob
        ' Add Form Details
        .pjForms.Clear
        With .pjForms.Add
            .fdFormName = txtFaxForm.Text
            Res& = .Save
            If (Res& <> 0) Then
                MsgBox "Error " + Str(Res&) + " adding the form (" + txtFaxForm.Text + ")into the PrintJob"
            End If
        End With ' .pjForms.Add

        If (Res& = 0) Then
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
            End With ' .pjFaxInfo
        End If ' Res& = 0

        '------------------------------------------------------------

        If (Res& = 0) Then
            ' Print to temporary file
            Set oTempFile = .PrintToTempFile(pdFax)
            If (oTempFile.pfStatus = 0) Then
                If optFax.Value Then
                    ' Send as fax
                    Res& = oTempFile.SendToDestination
                    MsgBox "SendToDestination (Fax): " + Str(Res&)
                Else
                    ' Preview
                    DisplayPreview oTempFile, 3
                End If
               
                ' Close 'Print To' dialog
                Hide
            Else
                MsgBox "PrintToTempFile (Fax): " + Str(oTempFile.pfStatus)
            End If
            Set oTempFile = Nothing
        End If ' Res& = 0
    End With ' oPrintJob
End Sub

Private Sub cmdPrinterCancel_Click()
    Unload Me
End Sub

Private Sub cmdPrinterSetup_Click()
    oPrintJob.PrinterSetupDialog
End Sub

Private Sub cmdPrnterOK_Click()
    Dim oTempFile As Enterprise01.IPrintTempFile
    Dim I%, Res&, iForm%

    If (lstOutputTo.ListIndex >= 0) Then
        ' Setup the print Job Details
        With oPrintJob
            ' Printer Details
            .pjPrinterIndex = lstPrinters.ListIndex + 1
            .pjPaperIndex = .pjSystemPrinters(.pjPrinterIndex).pdDefaultPaper
            .pjBinIndex = .pjSystemPrinters(.pjPrinterIndex).pdDefaultBin
    
            ' Misc flags/settings
            .pjCopies = CInt(txtCopies.Text)
            '.pjTitle = txtJobTitle.Text
            .pjTestMode = chkTestMode.Value
            .pjStartLabelNo = 1
            .pjUserId = "MISS"
                
            If (.pjType <> jtLabelRun) Then
                ' Label or Normal Form - Add Form Details
                .pjForms.Clear
                With .pjForms.Add
                    ' Set Form name for printing
                    .fdFormName = txtFormName.Text
                    
                    ' For Labels only set the number of labels to print
                    If (oPrintJob.pjType = jtLabel) Then
                        .fdLabelCopies = oPrintJob.pjCopies
                    End If
                    
                    ' Add the form details into the PrintJob
                    Res& = .Save
                    If (Res& <> 0) Then
                        MsgBox "Error " + Str(Res&) + " adding the form (" + txtFormName.Text + ")into the PrintJob"
                    End If
                End With ' .pjForms.Add
            Else
                ' Stock/Serial Labels - Cannot Clear/Add new forms as will lose the
                ' details automatically built up - just update the form name
                With .pjForms
                    For iForm% = 1 To .pfCount
                        .pfForms(iForm%).fdFormName = txtFormName.Text
                        .pfForms(iForm%).fdLabelCopies = 1
                    Next iForm%
                End With ' .pjForms
            End If
                
            ' Output media - Printer/Preview/Email/Fax
            If (lstOutputTo.ListIndex = 0) Then
                ' Print Direct to Printer
                Res& = .PrintToPrinter
                MsgBox "PrintJob.PrintToPrinter: " + Str(Res&)
            Else
                ' Preview
                Set oTempFile = .PrintToTempFile(pdPrinter)
                If (oTempFile.pfStatus = 0) Then
                    DisplayPreview oTempFile, lstOutputTo.ListIndex
                Else
                    MsgBox "PrintToTempFile (Printer): " + Str(oTempFile.pfStatus)
                End If
                Set oTempFile = Nothing
            End If
        End With ' oFormsTK.PrintJob
               
        ' Close 'Print To' dialog
        Hide
    End If
End Sub


Private Sub LoadEmRecips(EmailList As Enterprise01.IEmailAddressArray, EmType$)
    Dim I%, lvItem As ListItem
    
    With EmailList
        If (.eaCount > 0) Then
            For I% = 1 To .eaCount
                Set lvItem = lvRecipients.ListItems.Add(, , EmType$)
                lvItem.SubItems(1) = .eaItems(I%).emlName
                lvItem.SubItems(2) = .eaItems(I%).emlAddress
                Set lvItem = Nothing
            Next I%
        End If ' .eaCount > 0
    End With ' EmailList
End Sub



Public Sub SetupDlg(ByRef PrintJob As Enterprise01.IPrintJob)
    Dim PrinterNo%
      
    ' Take local copy of reference to PrintJob object
    Set oPrintJob = PrintJob
    
    With frmAcSINList.oToolkit
        ' Disable Email/Fax if no paperless module
        SSTab1.TabVisible(1) = (.SystemSetup.ssReleaseCodes.rcPaperless <> rcDisabled)
        SSTab1.TabVisible(2) = SSTab1.TabVisible(1)
    End With ' frmAcSINList.oToolkit
    
    With oPrintJob
        With .pjSystemPrinters
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
        
        ' Setup Default Printer - Check Print Job first then Windows Default Printer
        If (.pjPrinterIndex >= 0) And (.pjPrinterIndex <= .pjSystemPrinters.prCount) Then
            lstPrinters.ListIndex = .pjPrinterIndex - 1
        ElseIf (.pjSystemPrinters.prDefaultPrinter >= 0) And (.pjSystemPrinters.prDefaultPrinter <= .pjSystemPrinters.prCount) Then
            lstPrinters.ListIndex = .pjSystemPrinters.prDefaultPrinter - 1
        End If
                    
        ' Setup Form - Check for default
        If (.pjForms.pfCount > 0) Then
            txtFormName.Text = .pjForms(1).fdFormName
        End If
        
        ' Setup Printer details
        txtCopies.Text = Trim(Str(.pjCopies))
               
        If SSTab1.TabVisible(1) Then
            ' Setup Email details
            With .pjEmailInfo
                ' Forms
                txtEmailForm.Text = txtFormName.Text
                txtEmailCoverForm.Text = .emCoverSheet
                
                ' Sender Details
                txtSenderName.Text = .emSenderName
                txtSenderEmail.Text = .emSenderAddress
                    
                ' Load Recipients list
                LoadEmRecips .emToRecipients, "To"
                LoadEmRecips .emCCRecipients, "CC"
                LoadEmRecips .emBCCRecipients, "BCC"
                
                ' Email subject and text
                txtEmailSubject.Text = .emSubject
                txtEmailMessage.Text = .emMessageText
                Select Case .emFormCompression
                    Case emZIPNone
                        lstFormCompression.ListIndex = 0
                    Case emZIPPKZIP
                        lstFormCompression.ListIndex = 1
                    Case emZIPEDZ
                        lstFormCompression.ListIndex = 2
                End Select
                Select Case .emPriority
                    Case epLow
                        lstEmailPriority.ListIndex = 0
                    Case epNormal
                        lstEmailPriority.ListIndex = 1
                    Case epHigh
                        lstEmailPriority.ListIndex = 2
                End Select
                If .emSendReader Then
                    chkSendReader.Value = 1
                Else
                    chkSendReader.Value = 0
                End If
            End With ' .pjEmailInfo
        End If ' SSTab1.TabVisible(1)
        
        If SSTab1.TabVisible(2) Then
            ' Forms
            txtFaxForm.Text = txtFormName.Text
            txtFaxCoverSheet.Text = .pjFaxInfo.fxCoverSheet
            
            ' Sender Details
            txtFaxSenderName.Text = .pjFaxInfo.fxSenderName
            txtFaxSenderNumber.Text = .pjFaxInfo.fxSenderFaxNumber
            
            ' Recipient Details
            txtFaxRecipName.Text = .pjFaxInfo.fxRecipientName
            txtFaxRecipNumber.Text = .pjFaxInfo.fxRecipientFaxNumber
            
            ' Fax Description & Cover Sheet Message
            txtFaxDesc.Text = .pjFaxInfo.fxFaxDescription
            txtFaxMsg.Text = .pjFaxInfo.fxMessageText
            
            Select Case .pjFaxInfo.fxPriority
                ' Fax Details
                Case fpOffPeak
                    lstFaxPriority.ListIndex = 0
                Case fpNormal
                    lstFaxPriority.ListIndex = 1
                Case fpUrgent
                    lstFaxPriority.ListIndex = 2
            End Select
                            
            ' Only select a printer for MAPI
            lstMAPIFaxPrinters.Enabled = (.pjFaxInfo.fxType = fmMAPI)
            If Not lstMAPIFaxPrinters.Enabled Then
                ' select Fax printer
                If (.pjFaxInfo.fxFaxPrinterIndex >= 0) And (.pjFaxInfo.fxFaxPrinterIndex <= oPrintJob.pjSystemPrinters.prCount) Then
                    lstMAPIFaxPrinters.ListIndex = .pjFaxInfo.fxFaxPrinterIndex - 1
                End If
            Else
                ' Select default printer
                If (.pjSystemPrinters.prDefaultPrinter >= 0) And (.pjSystemPrinters.prDefaultPrinter <= .pjSystemPrinters.prCount) Then
                    lstMAPIFaxPrinters.ListIndex = .pjSystemPrinters.prDefaultPrinter - 1
                End If
            End If
        End If ' SSTab1.TabVisible(2)
    End With ' oPrintJob
End Sub

Private Sub Form_Unload(Cancel As Integer)
    ' Remove reference to Print Job object to allow it to be destroyed by COM
    Set oPrintJob = Nothing
End Sub

Private Sub Label1_Click()
    frmAcSINList.oToolkit.Functions.entBrowseObject oPrintJob, True
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

Private Sub lblEmailCover_Click()
    txtEmailCoverForm.Text = ""
End Sub

Private Sub lblFaxCover_Click()
    txtFaxCoverSheet.Text = ""
End Sub

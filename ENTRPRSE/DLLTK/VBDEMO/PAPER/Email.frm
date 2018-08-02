VERSION 5.00
Begin VB.Form frmPrintToEmail 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Toolkit Print To Email Demo"
   ClientHeight    =   7725
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6555
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7725
   ScaleWidth      =   6555
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame3 
      Height          =   780
      Left            =   90
      TabIndex        =   23
      Top             =   5535
      Width           =   6360
      Begin VB.TextBox txtDocRef 
         Height          =   375
         Left            =   4860
         TabIndex        =   28
         Top             =   240
         Width           =   1440
      End
      Begin VB.TextBox txtCover 
         Height          =   375
         Left            =   1080
         TabIndex        =   25
         Top             =   240
         Width           =   840
      End
      Begin VB.TextBox txtForm 
         Height          =   375
         Left            =   3000
         TabIndex        =   24
         Top             =   240
         Width           =   1035
      End
      Begin VB.Label Label2 
         Caption         =   "DocRef"
         Height          =   315
         Left            =   4095
         TabIndex        =   29
         Top             =   285
         Width           =   705
      End
      Begin VB.Label lblCover 
         Alignment       =   1  'Right Justify
         Caption         =   "Cover Sheet"
         Height          =   315
         Left            =   120
         TabIndex        =   27
         Top             =   285
         Width           =   885
      End
      Begin VB.Label lblForm 
         Caption         =   "Invoice Form"
         Height          =   315
         Left            =   2010
         TabIndex        =   26
         Top             =   285
         Width           =   1020
      End
   End
   Begin VB.Frame Frame2 
      Height          =   780
      Left            =   105
      TabIndex        =   20
      Top             =   6375
      Width           =   6360
      Begin VB.CheckBox chkPreview 
         Caption         =   "Print To Print Preview Window"
         Height          =   300
         Left            =   135
         TabIndex        =   22
         Top             =   270
         Value           =   1  'Checked
         Width           =   2700
      End
      Begin VB.CommandButton Command1 
         Caption         =   "Print Email"
         Height          =   435
         Left            =   4830
         TabIndex        =   21
         Top             =   210
         Width           =   1410
      End
   End
   Begin VB.Frame frmEmailDets 
      Caption         =   "Email Details"
      Height          =   4620
      Left            =   90
      TabIndex        =   6
      Top             =   885
      Width           =   6360
      Begin VB.CheckBox chkZIPForms 
         Alignment       =   1  'Right Justify
         Caption         =   "Compress Form Attachments"
         Height          =   315
         Left            =   1920
         TabIndex        =   19
         Top             =   4260
         Width           =   2355
      End
      Begin VB.CheckBox chkSendReader 
         Alignment       =   1  'Right Justify
         Caption         =   "Send Reader"
         Height          =   315
         Left            =   120
         TabIndex        =   18
         Top             =   4260
         Width           =   1515
      End
      Begin VB.TextBox txtAttachments 
         Height          =   375
         Left            =   1440
         TabIndex        =   16
         Top             =   3750
         Width           =   4770
      End
      Begin VB.TextBox txtMessage 
         Height          =   1605
         Left            =   135
         MultiLine       =   -1  'True
         TabIndex        =   15
         Text            =   "Email.frx":0000
         Top             =   2070
         Width           =   6075
      End
      Begin VB.TextBox txtSubject 
         Height          =   375
         Left            =   1440
         TabIndex        =   13
         Top             =   1605
         Width           =   4770
      End
      Begin VB.TextBox txtTo 
         Height          =   375
         Left            =   1440
         TabIndex        =   11
         Top             =   1170
         Width           =   4770
      End
      Begin VB.TextBox txtSenderAddr 
         Height          =   375
         Left            =   1440
         TabIndex        =   10
         Top             =   675
         Width           =   4770
      End
      Begin VB.TextBox txtSenderName 
         Height          =   375
         Left            =   1440
         TabIndex        =   8
         Top             =   255
         Width           =   4770
      End
      Begin VB.Label lblAttachments 
         Alignment       =   1  'Right Justify
         Caption         =   "Attachments"
         Height          =   315
         Left            =   150
         TabIndex        =   17
         Top             =   3795
         Width           =   1200
      End
      Begin VB.Label lblSubject 
         Alignment       =   1  'Right Justify
         Caption         =   "Subject"
         Height          =   315
         Left            =   150
         TabIndex        =   14
         Top             =   1650
         Width           =   1200
      End
      Begin VB.Label lblTo 
         Alignment       =   1  'Right Justify
         Caption         =   "To Recipient (s)"
         Height          =   315
         Left            =   150
         TabIndex        =   12
         Top             =   1215
         Width           =   1200
      End
      Begin VB.Label lblSenderAddr 
         Alignment       =   1  'Right Justify
         Caption         =   "Sender Address"
         Height          =   315
         Left            =   165
         TabIndex        =   9
         Top             =   720
         Width           =   1185
      End
      Begin VB.Label lblSenderName 
         Alignment       =   1  'Right Justify
         Caption         =   "Sender Name"
         Height          =   315
         Left            =   150
         TabIndex        =   7
         Top             =   300
         Width           =   1200
      End
   End
   Begin VB.Frame Frame1 
      Height          =   780
      Left            =   90
      TabIndex        =   0
      Top             =   60
      Width           =   6360
      Begin VB.CommandButton cmdDefaults 
         Caption         =   "Default Details"
         Height          =   435
         Left            =   4830
         TabIndex        =   5
         Top             =   210
         Width           =   1410
      End
      Begin VB.TextBox txtAcCode 
         Height          =   375
         Left            =   3480
         TabIndex        =   4
         Text            =   "A1HI01"
         Top             =   240
         Width           =   1215
      End
      Begin VB.TextBox txtUserCode 
         Height          =   375
         Left            =   1320
         TabIndex        =   2
         Text            =   "MISS"
         Top             =   240
         Width           =   855
      End
      Begin VB.Label lblAcCode 
         Caption         =   "Account Code"
         Height          =   315
         Left            =   2400
         TabIndex        =   3
         Top             =   285
         Width           =   1035
      End
      Begin VB.Label lblUserCode 
         Alignment       =   1  'Right Justify
         Caption         =   "Logged In User"
         Height          =   315
         Left            =   120
         TabIndex        =   1
         Top             =   285
         Width           =   1155
      End
   End
End
Attribute VB_Name = "frmPrintToEmail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim EmailInfo As EntForms.EmailPrintingInfoType

Private Sub cmdDefaults_Click()
    Dim FormInfo As EntForms.TDefaultFormRecType
    Dim UserCode As String * 255, AcCode As String * 255
    Dim Res%
    
    ' NOTE: Need to initialise the details here
    
    
    ' Extract user and Customer codes to generate defaults for Email Information
    UserCode = txtUserCode.Text + Chr(0)
    AcCode = txtAcCode.Text + Chr(0)
    
    With EmailInfo
        Res% = EX_DEFAULTEMAILDETS(.PrintInfo, _
                                   Len(.PrintInfo), _
                                   .ToRecip, _
                                   .CCRecip, _
                                   .BCCRecip, _
                                   .MsgText, _
                                   UserCode, _
                                   AcCode)
                                   
        If (Res% = 0) Then
            ' update screen
            txtSenderName.Text = Left(.PrintInfo.emSenderName, Asc(.PrintInfo.emSenderNameLen))
            txtSenderAddr.Text = Left(.PrintInfo.emSenderAddr, Asc(.PrintInfo.emSenderAddrLen))
            
            txtTo.Text = .ToRecip
            txtSubject.Text = Left(.PrintInfo.emSubject, Asc(.PrintInfo.emSubjectLen))
            txtMessage.Text = .MsgText
            txtAttachments.Text = .Attachments
            If (.PrintInfo.emSendReader > 0) Then chkSendReader.Value = 1 Else chkSendReader.Value = 0
            If (.PrintInfo.emCompress > 0) Then chkZIPForms.Value = 1 Else chkZIPForms.Value = 0
            
            txtCover.Text = Left(.PrintInfo.emCoverSheet, Asc(.PrintInfo.emCoverSheetLen))
        Else
            MsgBox "EX_DEFAULTEMAILDETS: " + Str(Res%)
        End If
    End With ' EmailInfo
    
    ' Also get default form name for a SIN
    Call EX_INITDEFAULTFORM(FormInfo, Len(FormInfo))
    With FormInfo
      ' Customer Code
      .dfAccount = txtUserCode.Text
      .dfAccountLen = Chr(Len(Trim(.dfAccount)))
      
      ' Form Number of requested form
      .dfFormNo = 6        ' Sales Invoice (SOR)
      
      ' Return Global if customer specific set is blank
      .dfCheckGlobal = DllTrue
    End With  ' FormInfo

    ' Request form name for customer (global if customer not defined)
    Res% = EX_DEFAULTFORM(FormInfo, Len(FormInfo))

    ' If successful display form name on screen
    If (Res% = 0) Then txtForm.Text = Left(FormInfo.dfFormName, Asc(FormInfo.dfFormNameLen))
End Sub

Private Sub Command1_Click()
    Dim RefNo As String * 255, FORMNAME As String * 255
    Dim Res%

    ' Add Item into the Print Batch
    RefNo = txtDocRef.Text + Chr(0)
    'RefNo = "C111111" + Chr(0)
    FORMNAME = txtForm.Text + Chr(0)
    
    Res% = EX_ADDTRANSFORM(RefNo, FORMNAME)
    'Res% = EX_ADDACSTATFORM(RefNo, FORMNAME)
    
    
    
    If (Res = 0) Then
        ' Now setup printing info and print the batch
        With EmailInfo
            .ToRecip = txtTo.Text
            .MsgText = txtMessage.Text
            .Attachments = txtAttachments.Text

            With .PrintInfo
                If (chkPreview.Value = 1) Then .emPreview = DllTrue Else .emPreview = DllFalse
                .emCoverSheet = Trim(txtCover.Text)
                .emCoverSheetLen = Chr(Len(Trim(.emCoverSheet)))
                .emSenderName = Trim(txtSenderName.Text)
                .emSenderNameLen = Chr(Len(Trim(.emSenderName)))
                .emSenderAddr = Trim(txtSenderAddr.Text)
                .emSenderAddrLen = Chr(Len(Trim(.emSenderAddr)))
                .emSubject = Trim(txtSubject.Text)
                .emSubjectLen = Chr(Len(Trim(.emSubject)))
                .emPriority = 1 ' Normal
                If (chkSendReader.Value = 1) Then .emSendReader = DllTrue Else .emSendReader = DllFalse
                If (chkZIPForms.Value = 1) Then .emCompress = DllTrue Else .emCompress = DllFalse
            End With ' .PrintInfo
        
            Res% = EX_PRINTTOEMAIL(.PrintInfo, _
                                   Len(.PrintInfo), _
                                   .ToRecip, _
                                   .CCRecip, _
                                   .BCCRecip, _
                                   .MsgText, _
                                .Attachments)
    
            If (Res <> 0) Then MsgBox "EX_PRINTTOEMAIL: " + Str(Res%)
        End With ' EmailInfo
    Else
        MsgBox "EX_ADDTRANSFORM: " + Str(Res)
    End If
End Sub

Private Sub Form_Load()
    Dim DataPath As String * 255
    Dim Res%
    
    ' Initialise Toolkit DLL
    Res% = EX_INITDLL%()
    If (Res% = 0) Then
        ' Initialise Form Designer DLL
        DataPath = "C:\DEVELOP\DEV500\" + Chr(0)
        
        Res% = EX_INITPRINTFORM(DataPath$)
        If (Res% = 0) Then
            Call DefaultDocRef
        Else
            MsgBox "EX_INITPRINTFORM: " + Str(Res%)
        End If
    Else
        MsgBox "EX_INITDLL: " + Str(Res%)
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call EX_ENDPRINTFORM
    Call EX_CLOSEDLL
End Sub

' Get first SIN and set DocRef field
Private Sub DefaultDocRef()
    Dim TH As TBatchTHRec
    Dim SKey As String * 255
    Dim Res%

    SKey = "SIN" + Chr(0)
    Res% = EX_GETTRANSHED(TH, Len(TH), SKey, 0, B_GetGEq, DllFalse)
    If (Res% = 0) Then
        txtDocRef.Text = Left(TH.OurRef, Asc(TH.OurRefLen))
    Else
        MsgBox "EX_GETTRANSHED: " + Str(Res%)
    End If
End Sub ' DefaultDocRef

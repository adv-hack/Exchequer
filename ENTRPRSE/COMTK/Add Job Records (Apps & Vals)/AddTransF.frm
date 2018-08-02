VERSION 5.00
Begin VB.Form frmAddTrans 
   AutoRedraw      =   -1  'True
   BackColor       =   &H80000013&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Applications and Valuations"
   ClientHeight    =   7530
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   10500
   Icon            =   "AddTransF.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   NegotiateMenus  =   0   'False
   ScaleHeight     =   7530
   ScaleWidth      =   10500
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame1 
      BackColor       =   &H80000013&
      Caption         =   "Details "
      Height          =   1545
      Index           =   1
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   10275
      Begin VB.CommandButton cmdOpenCOMTK 
         BackColor       =   &H80000013&
         Caption         =   "Open Toolkit"
         Height          =   1275
         Left            =   8640
         MaskColor       =   &H00808080&
         Style           =   1  'Graphical
         TabIndex        =   2
         Top             =   180
         UseMaskColor    =   -1  'True
         Width           =   1515
      End
      Begin VB.TextBox txtName 
         BackColor       =   &H80000004&
         Height          =   315
         Left            =   1200
         TabIndex        =   19
         Top             =   630
         Width           =   1755
      End
      Begin VB.TextBox txtCode 
         BackColor       =   &H8000000E&
         Height          =   315
         Left            =   1200
         Locked          =   -1  'True
         TabIndex        =   20
         Top             =   300
         Width           =   1755
      End
      Begin VB.DirListBox txtCompDir 
         Height          =   990
         Left            =   4680
         TabIndex        =   1
         Top             =   420
         Width           =   3855
      End
      Begin VB.Label lblDir 
         BackColor       =   &H80000013&
         Height          =   255
         Left            =   1200
         TabIndex        =   25
         Top             =   1260
         Width           =   2295
      End
      Begin VB.Label lblVer 
         BackColor       =   &H80000013&
         Height          =   255
         Left            =   1200
         TabIndex        =   24
         Top             =   960
         Width           =   2295
      End
      Begin VB.Label Label4 
         Alignment       =   1  'Right Justify
         BackColor       =   &H80000013&
         Caption         =   "Company Dir :"
         Height          =   195
         Left            =   60
         TabIndex        =   23
         Top             =   1260
         Width           =   1035
      End
      Begin VB.Label Label3 
         Alignment       =   1  'Right Justify
         BackColor       =   &H80000013&
         Caption         =   "Toolkit Ver :"
         Height          =   255
         Left            =   60
         TabIndex        =   22
         Top             =   960
         Width           =   1035
      End
      Begin VB.Label Label5 
         BackColor       =   &H80000013&
         Caption         =   "Select Company"
         Height          =   195
         Left            =   4680
         TabIndex        =   21
         Top             =   180
         Width           =   3855
      End
   End
   Begin VB.Frame Frame5 
      BackColor       =   &H80000013&
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   5835
      Left            =   120
      TabIndex        =   26
      Top             =   1620
      Width           =   10275
      Begin VB.Frame Frame7 
         BackColor       =   &H80000013&
         Caption         =   "JSAs"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1035
         Left            =   5160
         TabIndex        =   36
         Top             =   3600
         Width           =   4995
         Begin VB.CommandButton cmdCertJSA 
            BackColor       =   &H80000013&
            Caption         =   "Ceritfy JSA"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   38
            Top             =   600
            Width           =   4755
         End
         Begin VB.CommandButton AddJSA 
            BackColor       =   &H80000013&
            Caption         =   "Add JSA"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   37
            Top             =   240
            Width           =   4755
         End
      End
      Begin VB.Frame Frame6 
         BackColor       =   &H80000013&
         Caption         =   "Incremental JPAs"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1755
         Left            =   5160
         TabIndex        =   30
         Top             =   1800
         Width           =   4995
         Begin VB.CommandButton cmdAddIncJPA4 
            BackColor       =   &H80000013&
            Caption         =   "Add One Off JPA to AVT03"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   35
            Top             =   1320
            Width           =   2355
         End
         Begin VB.CommandButton cmdAddIncJPA 
            BackColor       =   &H80000013&
            Caption         =   "Add 1st Interim JPA to AVT03"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   34
            Top             =   240
            Width           =   2355
         End
         Begin VB.CommandButton cmdCertJPA3 
            BackColor       =   &H80000013&
            Caption         =   "Certify JPA"
            Height          =   1395
            Left            =   2520
            Style           =   1  'Graphical
            TabIndex        =   33
            Top             =   240
            Width           =   2355
         End
         Begin VB.CommandButton cmdAddIncJPA2 
            BackColor       =   &H80000013&
            Caption         =   "Add 2nd Interim JPA to AVT03"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   32
            Top             =   600
            Width           =   2355
         End
         Begin VB.CommandButton cmdAddIncJPA3 
            BackColor       =   &H80000013&
            Caption         =   "Add Interim JPA to AVT03"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   31
            Top             =   960
            Width           =   2355
         End
      End
      Begin VB.Frame Frame3 
         BackColor       =   &H80000013&
         Caption         =   "Gross Incremental JPAs"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   2115
         Left            =   120
         TabIndex        =   29
         Top             =   3600
         Width           =   4995
         Begin VB.CommandButton cmdAddGrossIncJPA4 
            BackColor       =   &H80000013&
            Caption         =   "Add Interim JPA to AVT02"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   16
            Top             =   1320
            Width           =   2355
         End
         Begin VB.CommandButton cmdAddGrossIncJPA5 
            BackColor       =   &H80000013&
            Caption         =   "Add Practical JPA to AVT02"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   18
            Top             =   1680
            Width           =   2355
         End
         Begin VB.CommandButton cmdAddGrossIncJPA3 
            BackColor       =   &H80000013&
            Caption         =   "Add Practical JPA to AVT02"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   15
            Top             =   960
            Width           =   2355
         End
         Begin VB.CommandButton cmdAddGrossIncJPA2 
            BackColor       =   &H80000013&
            Caption         =   "Add 2nd Interim JPA to AVT02"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   14
            Top             =   600
            Width           =   2355
         End
         Begin VB.CommandButton cmdCertJPA2 
            BackColor       =   &H80000013&
            Caption         =   "Certify JPA"
            Height          =   1755
            Left            =   2520
            Style           =   1  'Graphical
            TabIndex        =   17
            Top             =   240
            Width           =   2355
         End
         Begin VB.CommandButton cmdAddGrossIncJPA 
            BackColor       =   &H80000013&
            Caption         =   "Add 1st Interim JPA to AVT02"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   13
            Top             =   240
            Width           =   2355
         End
      End
      Begin VB.Frame Frame2 
         BackColor       =   &H80000013&
         Caption         =   "Gross JPAs"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1755
         Left            =   120
         TabIndex        =   28
         Top             =   1800
         Width           =   4995
         Begin VB.CommandButton cmdAddGrossJPA4 
            BackColor       =   &H80000013&
            Caption         =   "Add Final App JPA to AVT01"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   12
            Top             =   1320
            Width           =   2355
         End
         Begin VB.CommandButton cmdAddGrossJPA 
            BackColor       =   &H80000013&
            Caption         =   "Add 1st Interim JPA to AVT01"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   8
            Top             =   240
            Width           =   2355
         End
         Begin VB.CommandButton cmdCertJPA1 
            BackColor       =   &H80000013&
            Caption         =   "Certify JPA"
            Height          =   1395
            Left            =   2520
            Style           =   1  'Graphical
            TabIndex        =   11
            Top             =   240
            Width           =   2355
         End
         Begin VB.CommandButton cmdAddGrossJPA2 
            BackColor       =   &H80000013&
            Caption         =   "Add 2nd Interim JPA to AVT01"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   9
            Top             =   600
            Width           =   2355
         End
         Begin VB.CommandButton cmdAddGrossJPA3 
            BackColor       =   &H80000013&
            Caption         =   "Add Practical JPA to AVT01"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   10
            Top             =   960
            Width           =   2355
         End
      End
      Begin VB.CommandButton cmdAddJobBudgetTraining 
         BackColor       =   &H80000013&
         Caption         =   "Add Job Budgets for Apps and Vals Training"
         Height          =   495
         Left            =   5280
         Style           =   1  'Graphical
         TabIndex        =   4
         Top             =   240
         Width           =   4755
      End
      Begin VB.CommandButton cmdTrainAnalysis 
         BackColor       =   &H80000013&
         Caption         =   "Add Training Analysis Code for Apps and Vals"
         Height          =   495
         Left            =   180
         Style           =   1  'Graphical
         TabIndex        =   3
         Top             =   240
         Width           =   4755
      End
      Begin VB.Frame Frame4 
         BackColor       =   &H80000013&
         Height          =   975
         Left            =   60
         TabIndex        =   27
         Top             =   780
         Width           =   10095
         Begin VB.CommandButton cmdAddJCT 
            BackColor       =   &H80000013&
            Caption         =   "Add Job Contract Terms (JCT)"
            Height          =   315
            Left            =   5220
            Style           =   1  'Graphical
            TabIndex        =   7
            Top             =   180
            Width           =   4755
         End
         Begin VB.CommandButton cmdAddJPT 
            BackColor       =   &H80000013&
            Caption         =   "Add Job Purchase Terms (JPT)"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   5
            Top             =   180
            Width           =   4755
         End
         Begin VB.CommandButton cmdAddJST 
            BackColor       =   &H80000013&
            Caption         =   "Add Job Sales Terms (JST)"
            Height          =   315
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   6
            Top             =   540
            Width           =   4755
         End
      End
   End
End
Attribute VB_Name = "frmAddTrans"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim oToolkit As Enterprise01.Toolkit

Private Sub AddJSA_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim JPALinesO As ITransactionLine3
    Dim JPALineCount As Integer
    'Used for cloning JST for transferring budgets etc. to JPA
    Dim JSTHeadC As ITransaction3
    Dim JSTLinesC As ITransactionLine3
    Dim JSTLineCount As Integer ' No of Lines on JST
    Dim Res&

    ' Add JSA for AVT02I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT02I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JSTHeadC = JobO.jrApplications.jbaMasterSalesTerms

        If Left(JSTHeadC.thOurRef, 3) <> "JST" Then
            MsgBox "Incorrect transaction returned by MasterSalesTerms - " & JSTHeadC.thOurRef & " - Expected a JST"
            Res& = 999
        End If
        
        If Res& <> 0 Then
            If Res <> 999 Then MsgBox oToolkit.LastErrorString
        Else
            
            Set JPAHeadO = JobO.jrApplications.jbaSalesApplication.Add
            
'            Call oToolkit.Functions.entBrowseObject(JSTHeadC, True)
            
            With JPAHeadO
                .thAsApplication.tpParentTerms = JSTHeadC.thAsApplication.tpOurRef
                .thAcCode = "ABAP01"
                .ImportDefaults
                .thAsApplication.tpAppsInterimFlag = aifInterim
                
                'Add Budget Record Lines
                JSTLineCount = JSTHeadC.thLines.thLineCount
                
                For JPALineCount = 1 To JSTLineCount
                    
                    Set JSTLinesC = JSTHeadC.thLines.thLine(JPALineCount)
                    Set JPALinesO = JPAHeadO.thLines.Add
        
                    With JPALinesO
                        With .tlAsApplication
                            .tplAnalysisCode = JSTLinesC.tlAsApplication.tplAnalysisCode
                            .tplTermsLineNo = JSTLinesC.tlABSLineNo
                            JPALinesO.ImportDefaults
                            .tplQty = JSTLinesC.tlAsApplication.tplQty
                            If Trim(.tplAnalysisCode) = "CB-LABOUR" Then
                                .tplApplied = 1500
                                .tplCertifiedAmount = 1000
                            End If
                            If Trim(.tplAnalysisCode) = "CB-MATERIL" Then
                                .tplApplied = 2300
                                .tplCertifiedAmount = 2000
                            End If
                        End With
                        .tlVATCode = "S"
                        .CalcVATAmount
                        JPALinesO.Save
                    End With
                    
                Next JPALineCount
                
                'Add Deduction Record Lines
                JSTLineCount = JSTHeadC.thAsApplication.tpDeductionLines.thLineCount
                
                For JPALineCount = 1 To JSTLineCount
                    
                    Set JSTLinesC = JSTHeadC.thAsApplication.tpDeductionLines.thLine(JPALineCount)
                    Set JPALinesO = JPAHeadO.thAsApplication.tpDeductionLines.Add
        
                    With JPALinesO
                        With .tlAsApplication
                            .tplAnalysisCode = JSTLinesC.tlAsApplication.tplAnalysisCode
                            .tplTermsLineNo = JSTLinesC.tlABSLineNo
                            JPALinesO.ImportDefaults
                        End With
                        .CalcVATAmount
                        JPALinesO.Save
                    End With
                        
                Next JPALineCount
                
                'Add Retention Record Lines
                JSTLineCount = JSTHeadC.thAsApplication.tpRetentionLines.thLineCount
                
                For JPALineCount = 1 To JSTLineCount
                    
                    Set JSTLinesC = JSTHeadC.thAsApplication.tpRetentionLines.thLine(JPALineCount)
                    
                    If JSTLinesC.tlAsApplication.tplRetentionType = rtInterim Then
                        Set JPALinesO = JPAHeadO.thAsApplication.tpRetentionLines.Add
            
                        With JPALinesO
                            With .tlAsApplication
                                .tplAnalysisCode = JSTLinesC.tlAsApplication.tplAnalysisCode
                                .tplTermsLineNo = JSTLinesC.tlABSLineNo
                                JPALinesO.ImportDefaults
                            End With
                            .CalcVATAmount
                            JPALinesO.Save
                        End With
                    End If
                    
                Next JPALineCount
                
                Res& = .Save(True)
            End With
            If Res& = 0 Then
                MsgBox "JSA added successfully on AVT02I"
                txtName.Text = JPAHeadO.thOurRef
                txtName.Refresh
            Else
                MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
            End If
        End If
    End If
    
    Set JPAHeadO = Nothing
    Set JPALinesO = Nothing
    Set JSTHeadC = Nothing
    Set JSTLinesC = Nothing
End Sub

Private Sub cmdAddGrossIncJPA_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim JPALinesO As ITransactionLine3
    Dim JPALineCount As Integer
    'Used for cloning JCT for transferring budgets etc. to JPA
    Dim JCTHeadC As ITransaction3
    Dim JCTLinesC As ITransactionLine3
    Dim JCTLineCount As Integer ' No of Lines on JCT
    Dim Res&

    ' Add JPA for AVT02I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT02I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JCTHeadC = JobO.jrApplications.jbaContractTerms.Item
        
        Res& = JCTHeadC.GetFirst
        If Res& <> 0 Then MsgBox oToolkit.LastErrorString
        While Res& = 0
            
            While JCTHeadC.thAsApplication.tpEmployeeCode <> "PETE01" And Res& = 0
                Res& = JCTHeadC.GetNext
            Wend
            
            If JCTHeadC.thAsApplication.tpEmployeeCode = "PETE01" Then
            
                Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Add
        
                With JPAHeadO
                    .thAsApplication.tpParentTerms = JCTHeadC.thAsApplication.tpOurRef
                    .ImportDefaults
                    .thAsApplication.tpAppsInterimFlag = aifInterim
                    
                    'Add Budget Record Lines
                    JCTLineCount = JCTHeadC.thLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thLines.thLine(JPALineCount)
                        Set JPALinesO = JPAHeadO.thLines.Add
            
                        With JPALinesO
                            With .tlAsApplication
                                .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                JPALinesO.ImportDefaults
                                .tplQty = JCTLinesC.tlAsApplication.tplQty
                                If Trim(.tplAnalysisCode) = "CB-CABLER" Then
                                    .tplApplied = 1500
                                    .tplCertifiedAmount = 1000
                                End If
                                If Trim(.tplAnalysisCode) = "CB-SUB-MAT" Then
                                    .tplApplied = 2000
                                    .tplCertifiedAmount = 1800
                                End If
                            End With
                            .tlVATCode = "S"
                            .CalcVATAmount
                            JPALinesO.Save
                        End With
                        
                    Next JPALineCount
                    
                    'Add Deduction Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpDeductionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpDeductionLines.thLine(JPALineCount)
                        If Trim(JCTLinesC.tlAsApplication.tplAnalysisCode) = "CB-CITB" Then
                        
                            Set JPALinesO = JPAHeadO.thAsApplication.tpDeductionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                            
                        End If
                    Next JPALineCount
                    
                    'Add Retention Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpRetentionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpRetentionLines.thLine(JPALineCount)
                        
                        If JCTLinesC.tlAsApplication.tplRetentionType = rtInterim Then
                            Set JPALinesO = JPAHeadO.thAsApplication.tpRetentionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                        End If
                        
                    Next JPALineCount
                    
                    Res& = .Save(True)
                End With
                If Res& = 0 Then
                    MsgBox "JPA added successfully for PETE01 on AVT02I"
                    txtName.Text = JPAHeadO.thOurRef
                    txtName.Refresh
                Else
                    MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End If
            Res& = JobO.jrApplications.jbaContractTerms.Item.GetNext
        Wend
    End If
    
    Set JPAHeadO = Nothing
    Set JPALinesO = Nothing
    Set JCTHeadC = Nothing
    Set JCTLinesC = Nothing
End Sub

Private Sub cmdAddGrossIncJPA2_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim JPALinesO As ITransactionLine3
    Dim JPALineCount As Integer
    'Used for cloning JCT for transferring budgets etc. to JPA
    Dim JCTHeadC As ITransaction3
    Dim JCTLinesC As ITransactionLine3
    Dim JCTLineCount As Integer ' No of Lines on JCT
    Dim Res&

    ' Add JPA for AVT02I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT02I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JCTHeadC = JobO.jrApplications.jbaContractTerms.Item
        
        Res& = JCTHeadC.GetFirst
        If Res& <> 0 Then MsgBox oToolkit.LastErrorString
        While Res& = 0
            
            While JCTHeadC.thAsApplication.tpEmployeeCode <> "PETE01" And Res& = 0
                Res& = JCTHeadC.GetNext
            Wend
            
            If JCTHeadC.thAsApplication.tpEmployeeCode = "PETE01" Then
            
                Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Add
        
                With JPAHeadO
                    .thAsApplication.tpParentTerms = JCTHeadC.thAsApplication.tpOurRef
                    .ImportDefaults
                    .thAsApplication.tpAppsInterimFlag = aifInterim
                    
                    'Add Budget Record Lines
                    JCTLineCount = JCTHeadC.thLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thLines.thLine(JPALineCount)
                        Set JPALinesO = JPAHeadO.thLines.Add
            
                        With JPALinesO
                            With .tlAsApplication
                                .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                JPALinesO.ImportDefaults
                                .tplQty = JCTLinesC.tlAsApplication.tplQty
                                If Trim(.tplAnalysisCode) = "CB-CABLER" Then
                                    .tplApplied = 1500
                                    .tplCertifiedAmount = 1750
                                End If
                                If Trim(.tplAnalysisCode) = "CB-SUB-MAT" Then
                                    .tplApplied = 2000
                                    .tplCertifiedAmount = 2000
                                End If
                            End With
                            .tlVATCode = "S"
                            .CalcVATAmount
                            JPALinesO.Save
                        End With
                        
                    Next JPALineCount
                    
                    'Add Deduction Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpDeductionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpDeductionLines.thLine(JPALineCount)
                        If Trim(JCTLinesC.tlAsApplication.tplAnalysisCode) = "CB-CITB" Then
                        
                            Set JPALinesO = JPAHeadO.thAsApplication.tpDeductionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                            
                        End If
                    Next JPALineCount
                    
                    'Add Retention Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpRetentionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpRetentionLines.thLine(JPALineCount)
                        
                        If JCTLinesC.tlAsApplication.tplRetentionType = rtInterim Then
                            Set JPALinesO = JPAHeadO.thAsApplication.tpRetentionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                        End If
                        
                    Next JPALineCount
                    
                    Res& = .Save(True)
                End With
                If Res& = 0 Then
                    MsgBox "JPA added successfully for MARK02 on AVT01I"
                    txtName.Text = JPAHeadO.thOurRef
                    txtName.Refresh
                Else
                    MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End If
            Res& = JobO.jrApplications.jbaContractTerms.Item.GetNext
        Wend
    End If
    
    Set JPAHeadO = Nothing
    Set JPALinesO = Nothing
    Set JCTHeadC = Nothing
    Set JCTLinesC = Nothing
End Sub

Private Sub cmdAddGrossIncJPA3_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim JPALinesO As ITransactionLine3
    Dim JPALineCount As Integer
    'Used for cloning JCT for transferring budgets etc. to JPA
    Dim JCTHeadC As ITransaction3
    Dim JCTLinesC As ITransactionLine3
    Dim JCTLineCount As Integer ' No of Lines on JCT
    Dim Res&

    ' Add JPA for AVT02I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT02I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JCTHeadC = JobO.jrApplications.jbaContractTerms.Item
        
        Res& = JCTHeadC.GetFirst
        If Res& <> 0 Then MsgBox oToolkit.LastErrorString
        While Res& = 0
            
            While JCTHeadC.thAsApplication.tpEmployeeCode <> "PETE01" And Res& = 0
                Res& = JCTHeadC.GetNext
            Wend
            
            If JCTHeadC.thAsApplication.tpEmployeeCode = "PETE01" Then
            
                Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Add
        
                With JPAHeadO
                    .thAsApplication.tpParentTerms = JCTHeadC.thAsApplication.tpOurRef
                    .ImportDefaults
                    .thAsApplication.tpAppsInterimFlag = aifPractical
                    
                    'Add Budget Record Lines
                    JCTLineCount = JCTHeadC.thLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thLines.thLine(JPALineCount)
                        Set JPALinesO = JPAHeadO.thLines.Add
            
                        With JPALinesO
                            With .tlAsApplication
                                .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                JPALinesO.ImportDefaults
                                .tplQty = JCTLinesC.tlAsApplication.tplQty
                                If Trim(.tplAnalysisCode) = "CB-CABLER" Then
                                    .tplApplied = 500
                                    .tplCertifiedAmount = 750
                                End If
                                If Trim(.tplAnalysisCode) = "CB-SUB-MAT" Then
                                    .tplApplied = 2000
                                    .tplCertifiedAmount = 2200
                                End If
                            End With
                            .tlVATCode = "S"
                            .CalcVATAmount
                            JPALinesO.Save
                        End With
                        
                    Next JPALineCount
                    
                    'Add Deduction Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpDeductionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpDeductionLines.thLine(JPALineCount)
                        If Trim(JCTLinesC.tlAsApplication.tplAnalysisCode) = "CB-CITB" Then
                        
                            Set JPALinesO = JPAHeadO.thAsApplication.tpDeductionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                            
                        End If
                    Next JPALineCount
                    
                    'Add Retention Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpRetentionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpRetentionLines.thLine(JPALineCount)
                        
                        If JCTLinesC.tlAsApplication.tplRetentionType = rtInterim Or JCTLinesC.tlAsApplication.tplRetentionType = rtPractical Then
                            Set JPALinesO = JPAHeadO.thAsApplication.tpRetentionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                   .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                   .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                   JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                        End If
                        
                    Next JPALineCount
                    
                    Res& = .Save(True)
                End With
                If Res& = 0 Then
                    MsgBox "JPA added successfully for MARK02 on AVT01I"
                    txtName.Text = JPAHeadO.thOurRef
                    txtName.Refresh
                Else
                    MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End If
            Res& = JobO.jrApplications.jbaContractTerms.Item.GetNext
        Wend
    End If
    
    Set JPAHeadO = Nothing
    Set JPALinesO = Nothing
    Set JCTHeadC = Nothing
    Set JCTLinesC = Nothing
End Sub

Private Sub cmdAddGrossIncJPA4_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim JPALinesO As ITransactionLine3
    Dim JPALineCount As Integer
    'Used for cloning JCT for transferring budgets etc. to JPA
    Dim JCTHeadC As ITransaction3
    Dim JCTLinesC As ITransactionLine3
    Dim JCTLineCount As Integer ' No of Lines on JCT
    Dim Res&

    ' Add JPA for AVT02I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT02I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JCTHeadC = JobO.jrApplications.jbaContractTerms.Item
        
        Res& = JCTHeadC.GetFirst
        If Res& <> 0 Then MsgBox oToolkit.LastErrorString
        While Res& = 0
            
            While JCTHeadC.thAsApplication.tpEmployeeCode <> "MARK02" And Res& = 0
                Res& = JCTHeadC.GetNext
            Wend
            
            If JCTHeadC.thAsApplication.tpEmployeeCode = "MARK02" Then
            
                Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Add
        
                With JPAHeadO
                    .thAsApplication.tpParentTerms = JCTHeadC.thAsApplication.tpOurRef
                    .ImportDefaults
                    .thAsApplication.tpAppsInterimFlag = aifInterim
                    
                    'Add Budget Record Lines
                    JCTLineCount = JCTHeadC.thLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thLines.thLine(JPALineCount)
                        Set JPALinesO = JPAHeadO.thLines.Add
            
                        With JPALinesO
                            With .tlAsApplication
                                .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                JPALinesO.ImportDefaults
                                .tplQty = JCTLinesC.tlAsApplication.tplQty
                                If Trim(.tplAnalysisCode) = "CB-CABLER" Then
                                    .tplApplied = 3000
                                    .tplCertifiedAmount = 3000
                                End If
                                If Trim(.tplAnalysisCode) = "CB-SUB-MAT" Then
                                    .tplApplied = 5000
                                    .tplCertifiedAmount = 5000
                                End If
                            End With
                            .tlVATCode = "S"
                            .CalcVATAmount
                            JPALinesO.Save
                        End With
                        
                    Next JPALineCount
                    
                    'Add Deduction Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpDeductionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpDeductionLines.thLine(JPALineCount)
                        If Trim(JCTLinesC.tlAsApplication.tplAnalysisCode) = "CB-CITB" Then
                        
                            Set JPALinesO = JPAHeadO.thAsApplication.tpDeductionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                            
                        End If
                    Next JPALineCount
                    
                    'Add Retention Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpRetentionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpRetentionLines.thLine(JPALineCount)
                        
                        If JCTLinesC.tlAsApplication.tplRetentionType = rtInterim Then
                            Set JPALinesO = JPAHeadO.thAsApplication.tpRetentionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                        End If
                        
                    Next JPALineCount
                    
                    Res& = .Save(True)
                End With
                If Res& = 0 Then
                    MsgBox "JPA added successfully for MARK02 on AVT02I"
                    txtName.Text = JPAHeadO.thOurRef
                    txtName.Refresh
                Else
                    MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End If
            Res& = JobO.jrApplications.jbaContractTerms.Item.GetNext
        Wend
    End If
    
    Set JPAHeadO = Nothing
    Set JPALinesO = Nothing
    Set JCTHeadC = Nothing
    Set JCTLinesC = Nothing
End Sub

Private Sub cmdAddGrossIncJPA5_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim JPALinesO As ITransactionLine3
    Dim JPALineCount As Integer
    'Used for cloning JCT for transferring budgets etc. to JPA
    Dim JCTHeadC As ITransaction3
    Dim JCTLinesC As ITransactionLine3
    Dim JCTLineCount As Integer ' No of Lines on JCT
    Dim Res&

    ' Add JPA for AVT02I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT02I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JCTHeadC = JobO.jrApplications.jbaContractTerms.Item
        
        Res& = JCTHeadC.GetFirst
        If Res& <> 0 Then MsgBox oToolkit.LastErrorString
        While Res& = 0
            
            While JCTHeadC.thAsApplication.tpEmployeeCode <> "MARK02" And Res& = 0
                Res& = JCTHeadC.GetNext
            Wend
            
            If JCTHeadC.thAsApplication.tpEmployeeCode = "MARK02" Then
            
                Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Add
        
                With JPAHeadO
                    .thAsApplication.tpParentTerms = JCTHeadC.thAsApplication.tpOurRef
                    .ImportDefaults
                    .thAsApplication.tpAppsInterimFlag = aifPractical
                    
                    'Add Budget Record Lines
                    JCTLineCount = JCTHeadC.thLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thLines.thLine(JPALineCount)
                        Set JPALinesO = JPAHeadO.thLines.Add
            
                        With JPALinesO
                            With .tlAsApplication
                                .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                JPALinesO.ImportDefaults
                                .tplQty = JCTLinesC.tlAsApplication.tplQty
                                If Trim(.tplAnalysisCode) = "CB-CABLER" Then
                                    .tplApplied = 500
                                    .tplCertifiedAmount = 0
                                End If
                                If Trim(.tplAnalysisCode) = "CB-SUB-MAT" Then
                                    .tplApplied = 1000
                                    .tplCertifiedAmount = 0
                                End If
                            End With
                            .tlVATCode = "S"
                            .CalcVATAmount
                            JPALinesO.Save
                        End With
                        
                    Next JPALineCount
                    
                    'Add Deduction Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpDeductionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpDeductionLines.thLine(JPALineCount)
                        If Trim(JCTLinesC.tlAsApplication.tplAnalysisCode) = "CB-CITB" Then
                        
                            Set JPALinesO = JPAHeadO.thAsApplication.tpDeductionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                            
                        End If
                    Next JPALineCount
                    
                    'Add Deduction for Plant Hire
                    Set JPALinesO = JPAHeadO.thAsApplication.tpDeductionLines.Add
        
                    With JPALinesO
                        With .tlAsApplication
                            .tplAnalysisCode = "cb-contra"
                            JPALinesO.ImportDefaults
                            .tplOverrideValue = True
                            .tplDeductValue = 175.33
                            JPALinesO.tlDiscFlag = Chr(0)
                        End With
                       ' .CalcVATAmount
                        JPALinesO.Save
                    End With
                    
                    'Add Retention Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpRetentionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpRetentionLines.thLine(JPALineCount)
                        
                        If JCTLinesC.tlAsApplication.tplRetentionType = rtInterim Or JCTLinesC.tlAsApplication.tplRetentionType = rtPractical Then
                            Set JPALinesO = JPAHeadO.thAsApplication.tpRetentionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                        End If
                        
                    Next JPALineCount
                    
                    Res& = .Save(True)
                End With
                If Res& = 0 Then
                    MsgBox "JPA added successfully for MARK02 on AVT01I"
                    txtName.Text = JPAHeadO.thOurRef
                    txtName.Refresh
                Else
                    MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End If
            Res& = JobO.jrApplications.jbaContractTerms.Item.GetNext
        Wend
    End If
    
    Set JPAHeadO = Nothing
    Set JPALinesO = Nothing
    Set JCTHeadC = Nothing
    Set JCTLinesC = Nothing

End Sub

Private Sub cmdAddIncJPA_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim JPALinesO As ITransactionLine3
    Dim JPALineCount As Integer
    'Used for cloning JCT for transferring budgets etc. to JPA
    Dim JCTHeadC As ITransaction3
    Dim JCTLinesC As ITransactionLine3
    Dim JCTLineCount As Integer ' No of Lines on JCT
    Dim Res&

    ' Add JPA for AVT03I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT03I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JCTHeadC = JobO.jrApplications.jbaContractTerms.Item
        
        Res& = JCTHeadC.GetFirst
        If Res& <> 0 Then MsgBox oToolkit.LastErrorString
        While Res& = 0
            
            While JCTHeadC.thAsApplication.tpEmployeeCode <> "STEV01" And Res& = 0
                Res& = JCTHeadC.GetNext
            Wend
            
            If JCTHeadC.thAsApplication.tpEmployeeCode = "STEV01" Then
            
                Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Add
        
                With JPAHeadO
                    .thAsApplication.tpParentTerms = JCTHeadC.thAsApplication.tpOurRef
                    .ImportDefaults
                    .thAsApplication.tpAppsInterimFlag = aifInterim
                    .thAsApplication.tpDeferVAT = True
                    
                    'Add Budget Record Lines
                    JCTLineCount = JCTHeadC.thLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thLines.thLine(JPALineCount)
                        Set JPALinesO = JPAHeadO.thLines.Add
            
                        With JPALinesO
                            With .tlAsApplication
                                .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                JPALinesO.ImportDefaults
                                .tplQty = JCTLinesC.tlAsApplication.tplQty
                                If Trim(.tplAnalysisCode) = "CB-CABLER" Then
                                    .tplApplied = 1500
                                    .tplCertifiedAmount = 1000
                                End If
                                If Trim(.tplAnalysisCode) = "CB-SUB-MAT" Then
                                    .tplApplied = 2500
                                    .tplCertifiedAmount = 2000
                                End If
                            End With
                            .tlVATCode = "S"
                            .CalcVATAmount
                            JPALinesO.Save
                        End With
                        
                    Next JPALineCount
                    
                    'Add Deduction Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpDeductionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpDeductionLines.thLine(JPALineCount)
                        If Trim(JCTLinesC.tlAsApplication.tplAnalysisCode) = "CB-CITB" Then
                        
                            Set JPALinesO = JPAHeadO.thAsApplication.tpDeductionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                            
                        End If
                    Next JPALineCount
                    
                    'Add Retention Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpRetentionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpRetentionLines.thLine(JPALineCount)
                        
                        If JCTLinesC.tlAsApplication.tplRetentionType = rtInterim Then
                            Set JPALinesO = JPAHeadO.thAsApplication.tpRetentionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                    .tplRetention = 10
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                        End If
                        
                    Next JPALineCount
                    
                    Res& = .Save(True)
                End With
                If Res& = 0 Then
                    MsgBox "JPA added successfully for PETE01 on AVT03I"
                    txtName.Text = JPAHeadO.thOurRef
                    txtName.Refresh
                Else
                    MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End If
            Res& = JobO.jrApplications.jbaContractTerms.Item.GetNext
        Wend
    End If
    
    Set JPAHeadO = Nothing
    Set JPALinesO = Nothing
    Set JCTHeadC = Nothing
    Set JCTLinesC = Nothing
End Sub

Private Sub cmdAddIncJPA2_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim JPALinesO As ITransactionLine3
    Dim JPALineCount As Integer
    'Used for cloning JCT for transferring budgets etc. to JPA
    Dim JCTHeadC As ITransaction3
    Dim JCTLinesC As ITransactionLine3
    Dim JCTLineCount As Integer ' No of Lines on JCT
    Dim Res&

    ' Add JPA for AVT03I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT03I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JCTHeadC = JobO.jrApplications.jbaContractTerms.Item
        
        Res& = JCTHeadC.GetFirst
        If Res& <> 0 Then MsgBox oToolkit.LastErrorString
        While Res& = 0
            
            While JCTHeadC.thAsApplication.tpEmployeeCode <> "STEV01" And Res& = 0
                Res& = JCTHeadC.GetNext
            Wend
            
            If JCTHeadC.thAsApplication.tpEmployeeCode = "STEV01" Then
            
                Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Add
        
                With JPAHeadO
                    .thAsApplication.tpParentTerms = JCTHeadC.thAsApplication.tpOurRef
                    .ImportDefaults
                    .thAsApplication.tpAppsInterimFlag = aifInterim
                    .thAsApplication.tpDeferVAT = True
                    
                    'Add Budget Record Lines
                    JCTLineCount = JCTHeadC.thLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thLines.thLine(JPALineCount)
                        Set JPALinesO = JPAHeadO.thLines.Add
            
                        With JPALinesO
                            With .tlAsApplication
                                .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                JPALinesO.ImportDefaults
                                .tplQty = JCTLinesC.tlAsApplication.tplQty
                                If Trim(.tplAnalysisCode) = "CB-CABLER" Then
                                    .tplApplied = 1000
                                    .tplCertifiedAmount = 1500
                                End If
                                If Trim(.tplAnalysisCode) = "CB-SUB-MAT" Then
                                    .tplApplied = 2000
                                    .tplCertifiedAmount = 2500
                                End If
                            End With
                            .tlVATCode = "S"
                            .CalcVATAmount
                            JPALinesO.Save
                        End With
                        
                    Next JPALineCount
                    
                    'Add Deduction Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpDeductionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpDeductionLines.thLine(JPALineCount)
                        If Trim(JCTLinesC.tlAsApplication.tplAnalysisCode) = "CB-CITB" Then
                        
                            Set JPALinesO = JPAHeadO.thAsApplication.tpDeductionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                            
                        End If
                    Next JPALineCount
                    
                    'Add Retention Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpRetentionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpRetentionLines.thLine(JPALineCount)
                        
                        If JCTLinesC.tlAsApplication.tplRetentionType = rtInterim Then
                            Set JPALinesO = JPAHeadO.thAsApplication.tpRetentionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                        End If
                        
                    Next JPALineCount
                    
                    Res& = .Save(True)
                End With
                If Res& = 0 Then
                    MsgBox "JPA added successfully for PETE01 on AVT03I"
                    txtName.Text = JPAHeadO.thOurRef
                    txtName.Refresh
                Else
                    MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End If
            Res& = JobO.jrApplications.jbaContractTerms.Item.GetNext
        Wend
    End If
    
    Set JPAHeadO = Nothing
    Set JPALinesO = Nothing
    Set JCTHeadC = Nothing
    Set JCTLinesC = Nothing
End Sub

Private Sub cmdAddIncJPA3_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim JPALinesO As ITransactionLine3
    Dim JPALineCount As Integer
    'Used for cloning JCT for transferring budgets etc. to JPA
    Dim JCTHeadC As ITransaction3
    Dim JCTLinesC As ITransactionLine3
    Dim JCTLineCount As Integer ' No of Lines on JCT
    Dim Res&

    ' Add JPA for AVT03I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT03I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JCTHeadC = JobO.jrApplications.jbaContractTerms.Item
        
        Res& = JCTHeadC.GetFirst
        If Res& <> 0 Then MsgBox oToolkit.LastErrorString
        While Res& = 0
            
            While JCTHeadC.thAsApplication.tpEmployeeCode <> "MARK02" And Res& = 0
                Res& = JCTHeadC.GetNext
            Wend
            
            If JCTHeadC.thAsApplication.tpEmployeeCode = "MARK02" Then
            
                Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Add
        
                With JPAHeadO
                    .thAsApplication.tpParentTerms = JCTHeadC.thAsApplication.tpOurRef
                    .ImportDefaults
                    .thAsApplication.tpAppsInterimFlag = aifInterim
                    .thAsApplication.tpDeferVAT = True
                    
                    'Add Budget Record Lines
                    JCTLineCount = JCTHeadC.thLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thLines.thLine(JPALineCount)
                        Set JPALinesO = JPAHeadO.thLines.Add
            
                        With JPALinesO
                            With .tlAsApplication
                                .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                JPALinesO.ImportDefaults
                                .tplQty = JCTLinesC.tlAsApplication.tplQty
                                If Trim(.tplAnalysisCode) = "CB-CABLER" Then
                                    .tplApplied = 3500
                                    .tplCertifiedAmount = 3500
                                End If
                                If Trim(.tplAnalysisCode) = "CB-SUB-MAT" Then
                                    .tplApplied = 6000
                                    .tplCertifiedAmount = 6000
                                End If
                            End With
                            .tlVATCode = "S"
                            .CalcVATAmount
                            JPALinesO.Save
                        End With
                        
                    Next JPALineCount
                    
                    'Add Additional Labour
                    Set JPALinesO = JPAHeadO.thLines.Add
                    With JPALinesO
                        With .tlAsApplication
                            .tplAnalysisCode = "CB-CABLER"
                            JPALinesO.ImportDefaults
                            .tplQty = 1
                            .tplApplied = 500
                            .tplCertifiedAmount = 500
                        End With
                    .tlVATCode = "S"
                    .CalcVATAmount
                    JPALinesO.Save
                    End With
                    
                    
                    'Add Deduction Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpDeductionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpDeductionLines.thLine(JPALineCount)
                        If Trim(JCTLinesC.tlAsApplication.tplAnalysisCode) = "CB-CITB" Then
                        
                            Set JPALinesO = JPAHeadO.thAsApplication.tpDeductionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                            
                        End If
                    Next JPALineCount
                    
                    'Add Retention Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpRetentionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpRetentionLines.thLine(JPALineCount)
                        
                        If JCTLinesC.tlAsApplication.tplRetentionType = rtInterim Then
                            Set JPALinesO = JPAHeadO.thAsApplication.tpRetentionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                        End If
                        
                    Next JPALineCount
                    
                    Res& = .Save(True)
                End With
                If Res& = 0 Then
                    MsgBox "JPA added successfully for PETE01 on AVT03I"
                    txtName.Text = JPAHeadO.thOurRef
                    txtName.Refresh
                Else
                    MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End If
            Res& = JobO.jrApplications.jbaContractTerms.Item.GetNext
        Wend
    End If
    
    Set JPAHeadO = Nothing
    Set JPALinesO = Nothing
    Set JCTHeadC = Nothing
    Set JCTLinesC = Nothing
End Sub

Private Sub cmdAddIncJPA4_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim JPALinesO As ITransactionLine3
    Dim JPALineCount As Integer
    Dim Res&

    ' Add JPA for AVT03I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT03I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
            
        Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Add

        With JPAHeadO
            .ImportDefaults
            .thAsApplication.tpEmployeeCode = "pete01"
            .thAsApplication.tpAppsInterimFlag = aifStandAlone
            
            'Add Budget Record Lines
            Set JPALinesO = JPAHeadO.thLines.Add

            With JPALinesO
                With .tlAsApplication
                    .tplAnalysisCode = "CB-CABLER"
                    JPALinesO.ImportDefaults
                    .tplQty = 1
                    .tplApplied = 350
                    .tplCertifiedAmount = 350
                End With
                .tlVATCode = "S"
                .CalcVATAmount
                JPALinesO.Save
            End With
                
            Res& = .Save(True)
        End With
        If Res& = 0 Then
            MsgBox "JPA added successfully for PETE01 on AVT03I"
            txtName.Text = JPAHeadO.thOurRef
            txtName.Refresh
        Else
            MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
        End If
            
    End If
    
    Set JPAHeadO = Nothing
    Set JPALinesO = Nothing

End Sub

Private Sub cmdAddJCT_Click()
    Dim JobO As IJob3
    Dim JCTHeadO As ITransaction3
    Dim JCTLinesO As ITransactionLine3
    'Used for cloning JPT for transferring budgets etc. to JCT
    Dim JPTHeadC As ITransaction3
    Dim JPTLinesC As ITransactionLine3
    Dim JPTLineCount As Integer ' No of Lines on JPT
    Dim JCTLineCount As Integer
    Dim Res&

    ' Add JCT for AVT01I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT01I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JPTHeadC = JobO.jrApplications.jbaPurchaseTerms
        
        Res& = JobO.jrApplications.jbaContractTerms.Item.GetFirst

        Set JCTHeadO = JobO.jrApplications.jbaContractTerms.Add

        With JCTHeadO
            With .thAsApplication
                .tpEmployeeCode = "MARK02"
                .tpParentTerms = JPTHeadC.thAsApplication.tpOurRef
                .tpTermsInterimFlag = JPTHeadC.thAsApplication.tpTermsInterimFlag
                
            End With
            
            'Add Budget Record Lines
            JPTLineCount = JPTHeadC.thLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        .tplTermsLineNo = JPTLinesC.tlABSLineNo
                        .tplQty = JPTLinesC.tlAsApplication.tplQty
                        .tplBudgetJCT = JPTLinesC.tlAsApplication.tplBudgetJCT
                        JCTLinesO.ImportDefaults
                        
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            'Add Deduction Record Lines
            JPTLineCount = JPTHeadC.thAsApplication.tpDeductionLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thAsApplication.tpDeductionLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thAsApplication.tpDeductionLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        JCTLinesO.ImportDefaults
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            'Add Retention Record Lines
            JPTLineCount = JPTHeadC.thAsApplication.tpRetentionLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thAsApplication.tpRetentionLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thAsApplication.tpRetentionLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        JCTLinesO.ImportDefaults
                        .tplRetention = JPTLinesC.tlAsApplication.tplRetention
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            Res& = .Save(True)
        End With
        If Res& = 0 Then
            MsgBox "JCT added successfully on AVT01I for MARK02"
        Else
            MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
        End If
    End If
    
    Set JCTHeadO = Nothing
    Set JCTLinesO = Nothing
    Set JPTHeadC = Nothing
    Set JPTLinesC = Nothing

    ' Add JCT for AVT02I (Mark Subbie) ***********************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT02I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JPTHeadC = JobO.jrApplications.jbaPurchaseTerms
        
        Res& = JobO.jrApplications.jbaContractTerms.Item.GetFirst

        Set JCTHeadO = JobO.jrApplications.jbaContractTerms.Add

        With JCTHeadO
            With .thAsApplication
                .tpEmployeeCode = "mark02"
                .tpParentTerms = JPTHeadC.thAsApplication.tpOurRef
                .tpTermsInterimFlag = JPTHeadC.thAsApplication.tpTermsInterimFlag
                
            End With
            
            'Add Budget Record Lines
            JPTLineCount = JPTHeadC.thLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        .tplTermsLineNo = JPTLinesC.tlABSLineNo
                        JCTLinesO.ImportDefaults
                        .tplQty = JPTLinesC.tlAsApplication.tplQty / 2
                        .tplBudgetJCT = JPTLinesC.tlAsApplication.tplBudgetJCT / 2
                        
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            'Add Deduction Record Lines
            JPTLineCount = JPTHeadC.thAsApplication.tpDeductionLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thAsApplication.tpDeductionLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thAsApplication.tpDeductionLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        JCTLinesO.ImportDefaults
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            'Add Retention Record Lines
            JPTLineCount = JPTHeadC.thAsApplication.tpRetentionLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thAsApplication.tpRetentionLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thAsApplication.tpRetentionLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        JCTLinesO.ImportDefaults
                        .tplRetention = JPTLinesC.tlAsApplication.tplRetention
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            Res& = .Save(True)
        End With
        If Res& = 0 Then
            MsgBox "JCT added successfully on AVT02I for MARK02"
        Else
            MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
        End If
    End If
    
    Set JCTHeadO = Nothing
    Set JCTLinesO = Nothing
    Set JPTHeadC = Nothing
    Set JPTLinesC = Nothing
    
    ' Add JCT for AVT02I (Peter Arnold) **********************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT02I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JPTHeadC = JobO.jrApplications.jbaPurchaseTerms
        
        Res& = JobO.jrApplications.jbaContractTerms.Item.GetFirst

        Set JCTHeadO = JobO.jrApplications.jbaContractTerms.Add

        With JCTHeadO
            With .thAsApplication
                .tpEmployeeCode = "Pete01"
                .tpParentTerms = JPTHeadC.thAsApplication.tpOurRef
                .tpTermsInterimFlag = JPTHeadC.thAsApplication.tpTermsInterimFlag
                
            End With
            
            'Add Budget Record Lines
            JPTLineCount = JPTHeadC.thLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        .tplTermsLineNo = JPTLinesC.tlABSLineNo
                        JCTLinesO.ImportDefaults
                        .tplQty = JPTLinesC.tlAsApplication.tplQty / 2
                        .tplBudgetJCT = JPTLinesC.tlAsApplication.tplBudgetJCT / 2
                        
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            'Add Deduction Record Lines
            JPTLineCount = JPTHeadC.thAsApplication.tpDeductionLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thAsApplication.tpDeductionLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thAsApplication.tpDeductionLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        JCTLinesO.ImportDefaults
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            'Add Retention Record Lines
            JPTLineCount = JPTHeadC.thAsApplication.tpRetentionLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thAsApplication.tpRetentionLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thAsApplication.tpRetentionLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        JCTLinesO.ImportDefaults
                        .tplRetention = JPTLinesC.tlAsApplication.tplRetention
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            Res& = .Save(True)
        End With
        If Res& = 0 Then
            MsgBox "JCT added successfully on AVT02I for PETE01"
        Else
            MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
        End If
    End If
    
    Set JCTHeadO = Nothing
    Set JCTLinesO = Nothing
    Set JPTHeadC = Nothing
    Set JPTLinesC = Nothing

    ' Add JCT for AVT03I (Mark Subbie) ***********************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT03I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JPTHeadC = JobO.jrApplications.jbaPurchaseTerms
        
        Res& = JobO.jrApplications.jbaContractTerms.Item.GetFirst

        Set JCTHeadO = JobO.jrApplications.jbaContractTerms.Add

        With JCTHeadO
            With .thAsApplication
                .tpEmployeeCode = "mark02"
                .tpParentTerms = JPTHeadC.thAsApplication.tpOurRef
                .tpTermsInterimFlag = JPTHeadC.thAsApplication.tpTermsInterimFlag
                .tpDeferVAT = JPTHeadC.thAsApplication.tpDeferVAT
            End With
            
            'Add Budget Record Lines
            JPTLineCount = JPTHeadC.thLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        .tplTermsLineNo = JPTLinesC.tlABSLineNo
                        JCTLinesO.ImportDefaults
                        .tplQty = JPTLinesC.tlAsApplication.tplQty / 2
                        .tplBudgetJCT = JPTLinesC.tlAsApplication.tplBudgetJCT / 2
                        
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            'Add Deduction Record Lines
            JPTLineCount = JPTHeadC.thAsApplication.tpDeductionLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thAsApplication.tpDeductionLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thAsApplication.tpDeductionLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        JCTLinesO.ImportDefaults
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            'Add Retention Record Lines
            JPTLineCount = JPTHeadC.thAsApplication.tpRetentionLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thAsApplication.tpRetentionLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thAsApplication.tpRetentionLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        JCTLinesO.ImportDefaults
                        .tplRetention = JPTLinesC.tlAsApplication.tplRetention
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            Res& = .Save(True)
        End With
        If Res& = 0 Then
            MsgBox "JCT added successfully on AVT03I for MARK02"
        Else
            MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
        End If
    End If
    
    Set JCTHeadO = Nothing
    Set JCTLinesO = Nothing
    Set JPTHeadC = Nothing
    Set JPTLinesC = Nothing

    ' Add JCT for AVT03I (Stephen Saunders) ******************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT03I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JPTHeadC = JobO.jrApplications.jbaPurchaseTerms
        
        Res& = JobO.jrApplications.jbaContractTerms.Item.GetFirst

        Set JCTHeadO = JobO.jrApplications.jbaContractTerms.Add

        With JCTHeadO
            With .thAsApplication
                .tpEmployeeCode = "Stev01"
                .tpParentTerms = JPTHeadC.thAsApplication.tpOurRef
                .tpTermsInterimFlag = JPTHeadC.thAsApplication.tpTermsInterimFlag
                .tpDeferVAT = JPTHeadC.thAsApplication.tpDeferVAT
            End With
            
            'Add Budget Record Lines
            JPTLineCount = JPTHeadC.thLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        .tplTermsLineNo = JPTLinesC.tlABSLineNo
                        JCTLinesO.ImportDefaults
                        .tplQty = JPTLinesC.tlAsApplication.tplQty / 2
                        .tplBudgetJCT = JPTLinesC.tlAsApplication.tplBudgetJCT / 2
                        
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            'Add Deduction Record Lines
            JPTLineCount = JPTHeadC.thAsApplication.tpDeductionLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thAsApplication.tpDeductionLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thAsApplication.tpDeductionLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        JCTLinesO.ImportDefaults
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            'Add Retention Record Lines
            JPTLineCount = JPTHeadC.thAsApplication.tpRetentionLines.thLineCount
            
            For JCTLineCount = 1 To JPTLineCount
                
                Set JPTLinesC = JPTHeadC.thAsApplication.tpRetentionLines.thLine(JCTLineCount)
                Set JCTLinesO = JCTHeadO.thAsApplication.tpRetentionLines.Add
    
                With JCTLinesO
                    With .tlAsApplication
                        .tplAnalysisCode = JPTLinesC.tlAsApplication.tplAnalysisCode
                        JCTLinesO.ImportDefaults
                        .tplRetention = JPTLinesC.tlAsApplication.tplRetention
                    End With
                    JCTLinesO.Save
                End With
                
            Next JCTLineCount
            
            Res& = .Save(True)
        End With
        If Res& = 0 Then
            MsgBox "JCT added successfully on AVT03I for STEV02"
        Else
            MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
        End If
    End If
    
    Set JCTHeadO = Nothing
    Set JCTLinesO = Nothing
    Set JPTHeadC = Nothing
    Set JPTLinesC = Nothing
End Sub

Private Sub cmdAddGrossJPA_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim JPALinesO As ITransactionLine3
    Dim JPALineCount As Integer
    'Used for cloning JCT for transferring budgets etc. to JPA
    Dim JCTHeadC As ITransaction3
    Dim JCTLinesC As ITransactionLine3
    Dim JCTLineCount As Integer ' No of Lines on JCT
    Dim Res&

    ' Add JPA for AVT01I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT01I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JCTHeadC = JobO.jrApplications.jbaContractTerms.Item
        
        Res& = JCTHeadC.GetFirst
        If Res& <> 0 Then MsgBox oToolkit.LastErrorString
        While Res& = 0
            
            If JCTHeadC.thAsApplication.tpEmployeeCode = "MARK02" Then
            
                Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Add
        
                With JPAHeadO
                    .thAsApplication.tpParentTerms = JCTHeadC.thAsApplication.tpOurRef
                    .ImportDefaults
                    .thAsApplication.tpAppsInterimFlag = aifInterim
                    
                    'Add Budget Record Lines
                    JCTLineCount = JCTHeadC.thLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thLines.thLine(JPALineCount)
                        Set JPALinesO = JPAHeadO.thLines.Add
            
                        With JPALinesO
                            With .tlAsApplication
                                .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                JPALinesO.ImportDefaults
                                .tplQty = JCTLinesC.tlAsApplication.tplQty
                                If Trim(.tplAnalysisCode) = "CB-CABLER" Then
                                    .tplApplied = 3500
                                    .tplCertifiedAmount = 2500
                                End If
                                If Trim(.tplAnalysisCode) = "CB-SUB-MAT" Then
                                    .tplApplied = 6000
                                    .tplCertifiedAmount = 3500
                                End If
                            End With
                            .tlVATCode = "S"
                            .CalcVATAmount
                            JPALinesO.Save
                        End With
                        
                    Next JPALineCount
                    
                    'Add Deduction Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpDeductionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpDeductionLines.thLine(JPALineCount)
                        If Trim(JCTLinesC.tlAsApplication.tplAnalysisCode) = "CB-CITB" Then
                        
                            Set JPALinesO = JPAHeadO.thAsApplication.tpDeductionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                            
                        End If
                    Next JPALineCount
                    
                    'Add Retention Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpRetentionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpRetentionLines.thLine(JPALineCount)
                        
                        If JCTLinesC.tlAsApplication.tplRetentionType = rtInterim Then
                            Set JPALinesO = JPAHeadO.thAsApplication.tpRetentionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                        End If
                        
                    Next JPALineCount
                    'Call oToolkit.Functions.entBrowseObject(JPAHeadO, True)
                    Res& = .Save(True)
                End With
                If Res& = 0 Then
                    MsgBox "JPA added successfully for MARK02 on AVT01I"
                    txtName.Text = JPAHeadO.thOurRef
                    txtName.Refresh
                Else
                    MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End If
            Res& = JobO.jrApplications.jbaContractTerms.Item.GetNext
        Wend
    End If
    
    Set JPAHeadO = Nothing
    Set JPALinesO = Nothing
    Set JCTHeadC = Nothing
    Set JCTLinesC = Nothing
End Sub

Private Sub cmdAddGrossJPA2_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim JPALinesO As ITransactionLine3
    Dim JPALineCount As Integer
    'Used for cloning JCT for transferring budgets etc. to JPA
    Dim JCTHeadC As ITransaction3
    Dim JCTLinesC As ITransactionLine3
    Dim JCTLineCount As Integer ' No of Lines on JCT
    Dim Res&

    ' Add JPA for AVT01I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT01I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JCTHeadC = JobO.jrApplications.jbaContractTerms.Item
        
        Res& = JCTHeadC.GetFirst
        If Res& <> 0 Then MsgBox oToolkit.LastErrorString
        While Res& = 0
            
            If JCTHeadC.thAsApplication.tpEmployeeCode = "MARK02" Then
            
                Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Add
        
                With JPAHeadO
                    .thAsApplication.tpParentTerms = JCTHeadC.thAsApplication.tpOurRef
                    .ImportDefaults
                    .thAsApplication.tpAppsInterimFlag = aifInterim
                    
                    'Add Budget Record Lines
                    JCTLineCount = JCTHeadC.thLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thLines.thLine(JPALineCount)
                        Set JPALinesO = JPAHeadO.thLines.Add
            
                        With JPALinesO
                            With .tlAsApplication
                                .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                .tplQty = JCTLinesC.tlAsApplication.tplQty
                                If Trim(.tplAnalysisCode) = "CB-CABLER" Then
                                    .tplApplied = 3000
                                    .tplCertifiedAmount = 3500
                                    
                                End If
                                If Trim(.tplAnalysisCode) = "CB-SUB-MAT" Then
                                    .tplApplied = 5000
                                    .tplCertifiedAmount = 7500
                                End If
                            End With
                            .ImportDefaults
                            .tlVATCode = "S"
                            .CalcVATAmount
                            JPALinesO.Save
                        End With
                        
                    Next JPALineCount
                    
                    'Add Deduction Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpDeductionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpDeductionLines.thLine(JPALineCount)
                        If Trim(JCTLinesC.tlAsApplication.tplAnalysisCode) = "CB-CITB" Then
                        
                            Set JPALinesO = JPAHeadO.thAsApplication.tpDeductionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                            
                        End If
                    Next JPALineCount
                    
                    'Add Retention Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpRetentionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpRetentionLines.thLine(JPALineCount)
                        
                        If JCTLinesC.tlAsApplication.tplRetentionType = rtInterim Then
                            Set JPALinesO = JPAHeadO.thAsApplication.tpRetentionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                        End If
                        
                    Next JPALineCount
                    
                    Res& = .Save(True)
                End With
                If Res& = 0 Then
                    MsgBox "JPA added successfully for MARK02 on AVT01I"
                    txtName.Text = JPAHeadO.thOurRef
                    txtName.Refresh
                Else
                    MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End If
            Res& = JobO.jrApplications.jbaContractTerms.Item.GetNext
        Wend
    End If
    
    Set JPAHeadO = Nothing
    Set JPALinesO = Nothing
    Set JCTHeadC = Nothing
    Set JCTLinesC = Nothing
End Sub

Private Sub cmdAddGrossJPA3_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim JPALinesO As ITransactionLine3
    Dim JPALineCount As Integer
    'Used for cloning JCT for transferring budgets etc. to JPA
    Dim JCTHeadC As ITransaction3
    Dim JCTLinesC As ITransactionLine3
    Dim JCTLineCount As Integer ' No of Lines on JCT
    Dim Res&

    ' Add JPA for AVT01I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT01I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JCTHeadC = JobO.jrApplications.jbaContractTerms.Item
        
        Res& = JCTHeadC.GetFirst
        If Res& <> 0 Then MsgBox oToolkit.LastErrorString
        While Res& = 0
            
            If JCTHeadC.thAsApplication.tpEmployeeCode = "MARK02" Then
            
                Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Add
        
                With JPAHeadO
                    .thAsApplication.tpParentTerms = JCTHeadC.thAsApplication.tpOurRef
                    .ImportDefaults
                    .thAsApplication.tpAppsInterimFlag = aifPractical
                    
                    'Add Budget Record Lines
                    JCTLineCount = JCTHeadC.thLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thLines.thLine(JPALineCount)
                        Set JPALinesO = JPAHeadO.thLines.Add
            
                        With JPALinesO
                            With .tlAsApplication
                                .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                .tplQty = JCTLinesC.tlAsApplication.tplQty
                                If Trim(.tplAnalysisCode) = "CB-CABLER" Then
                                    .tplApplied = 500
                                    .tplCertifiedAmount = 1000
                                End If
                                If Trim(.tplAnalysisCode) = "CB-SUB-MAT" Then
                                    .tplApplied = 1000
                                    .tplCertifiedAmount = 1000
                                End If
                            End With
                            .ImportDefaults
                            .tlVATCode = "S"
                            .CalcVATAmount
                            JPALinesO.Save
                        End With
                        
                    Next JPALineCount
                    
                    'Add Deduction Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpDeductionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpDeductionLines.thLine(JPALineCount)
                        If Trim(JCTLinesC.tlAsApplication.tplAnalysisCode) = "CB-CITB" Then
                        
                            Set JPALinesO = JPAHeadO.thAsApplication.tpDeductionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                            
                        End If
                    Next JPALineCount
                    
                    'Add Retention Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpRetentionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpRetentionLines.thLine(JPALineCount)
                        
                        If JCTLinesC.tlAsApplication.tplRetentionType = rtInterim Or JCTLinesC.tlAsApplication.tplRetentionType = rtPractical Then
                            Set JPALinesO = JPAHeadO.thAsApplication.tpRetentionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                        End If
                        
                    Next JPALineCount
                    
                    Res& = .Save(True)
                End With
                If Res& = 0 Then
                    MsgBox "JPA added successfully for MARK02 on AVT01I"
                    txtName.Text = JPAHeadO.thOurRef
                    txtName.Refresh
                Else
                    MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End If
            Res& = JobO.jrApplications.jbaContractTerms.Item.GetNext
        Wend
    End If
    
    Set JPAHeadO = Nothing
    Set JPALinesO = Nothing
    Set JCTHeadC = Nothing
    Set JCTLinesC = Nothing
End Sub

Private Sub cmdAddGrossJPA4_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim JPALinesO As ITransactionLine3
    Dim JPALineCount As Integer
    'Used for cloning JCT for transferring budgets etc. to JPA
    Dim JCTHeadC As ITransaction3
    Dim JCTLinesC As ITransactionLine3
    Dim JCTLineCount As Integer ' No of Lines on JCT
    Dim Res&

    ' Add JPA for AVT01I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT01I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JCTHeadC = JobO.jrApplications.jbaContractTerms.Item
        
        Res& = JCTHeadC.GetFirst
        If Res& <> 0 Then MsgBox oToolkit.LastErrorString
        While Res& = 0
            
            If JCTHeadC.thAsApplication.tpEmployeeCode = "MARK02" Then
            
                Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Add
        
                With JPAHeadO
                    .thAsApplication.tpParentTerms = JCTHeadC.thAsApplication.tpOurRef
                    .ImportDefaults
                    .thAsApplication.tpAppsInterimFlag = aifFinal
                    
                    'Add Budget Record Lines
                    JCTLineCount = JCTHeadC.thLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thLines.thLine(JPALineCount)
                        Set JPALinesO = JPAHeadO.thLines.Add
            
                        With JPALinesO
                            With .tlAsApplication
                                .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                .tplQty = JCTLinesC.tlAsApplication.tplQty
                                If Trim(.tplAnalysisCode) = "CB-CABLER" Then
                                    .tplApplied = 0
                                    .tplCertifiedAmount = 0
                                    
                                End If
                                If Trim(.tplAnalysisCode) = "CB-SUB-MAT" Then
                                    .tplApplied = 0
                                    .tplCertifiedAmount = 0
                                End If
                            End With
                            .ImportDefaults
                            .tlVATCode = "S"
                            .CalcVATAmount
                            JPALinesO.Save
                        End With
                        
                    Next JPALineCount
                    
                    'Add Deduction Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpDeductionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpDeductionLines.thLine(JPALineCount)
                        If Trim(JCTLinesC.tlAsApplication.tplAnalysisCode) = "CB-CITB" Then
                        
                            Set JPALinesO = JPAHeadO.thAsApplication.tpDeductionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                            
                        End If
                    Next JPALineCount
                    
                    'Add Retention Record Lines
                    JCTLineCount = JCTHeadC.thAsApplication.tpRetentionLines.thLineCount
                    
                    For JPALineCount = 1 To JCTLineCount
                        
                        Set JCTLinesC = JCTHeadC.thAsApplication.tpRetentionLines.thLine(JPALineCount)
                        
                        If JCTLinesC.tlAsApplication.tplRetentionType = rtPractical Then
                            Set JPALinesO = JPAHeadO.thAsApplication.tpRetentionLines.Add
                
                            With JPALinesO
                                With .tlAsApplication
                                    .tplAnalysisCode = JCTLinesC.tlAsApplication.tplAnalysisCode
                                    .tplTermsLineNo = JCTLinesC.tlABSLineNo
                                    JPALinesO.ImportDefaults
                                End With
                                .CalcVATAmount
                                JPALinesO.Save
                            End With
                        End If
                        
                    Next JPALineCount
                    
                    Res& = .Save(True)
                End With
                If Res& = 0 Then
                    MsgBox "JPA added successfully for MARK02 on AVT01I"
                    txtName.Text = JPAHeadO.thOurRef
                    txtName.Refresh
                Else
                    MsgBox "Error Adding Transaction - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End If
            Res& = JobO.jrApplications.jbaContractTerms.Item.GetNext
        Wend
    End If
    
    Set JPAHeadO = Nothing
    Set JPALinesO = Nothing
    Set JCTHeadC = Nothing
    Set JCTLinesC = Nothing
End Sub

Private Sub cmdAddJPT_Click()
    Dim JobO As IJob3
    Dim JPTHeadO As ITransaction3
    Dim JPTLinesO As ITransactionLine3
    Dim Res&

    ' Add JPT for AVT01I
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT01I"))
    End With

    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        
        Set JPTHeadO = JobO.jrApplications.AddPurchaseTerms(True)
        
        With JPTHeadO
            .ImportDefaults
            .thAsApplication.tpTermsInterimFlag = tifGross
        
            Set JPTLinesO = JPTHeadO.thAsApplication.tpDeductionLines.Add

            With JPTLinesO
                .tlAsApplication.tplAnalysisCode = "CB-CITB"
                .ImportDefaults
                .Save
            End With

            Set JPTLinesO = JPTHeadO.thAsApplication.tpDeductionLines.Add

            With JPTLinesO
                .tlAsApplication.tplAnalysisCode = "CB-CONTRA"
                .ImportDefaults
                .Save
            End With

            Set JPTLinesO = JPTHeadO.thAsApplication.tpRetentionLines.Add

            With JPTLinesO
                .tlAsApplication.tplAnalysisCode = "interim-p"
                .ImportDefaults
                .tlAsApplication.tplRetention = 5
                .Save
            End With

            Set JPTLinesO = JPTHeadO.thAsApplication.tpRetentionLines.Add

            With JPTLinesO
                .tlAsApplication.tplAnalysisCode = "practic-p"
                .ImportDefaults
                .tlAsApplication.tplRetention = 2.5
                .Save
            End With

            Set JPTLinesO = JPTHeadO.thAsApplication.tpRetentionLines.Add

            With JPTLinesO
                .tlAsApplication.tplAnalysisCode = "xpurch-fr"
                .ImportDefaults
                .tlAsApplication.tplRetention = 1.25
                .Save
            End With

            Res& = .Save(True)
        End With
        
        If Res& = 0 Then
            MsgBox "JPT created successfully on AVT01I"
        Else
            MsgBox "Error Adding transaction - " & Res& & " - " & oToolkit.LastErrorString
        End If
    Else
        MsgBox "Error finding Job AVT01I - " & Res& & " - " & oToolkit.LastErrorString
    End If

    Set JobO = Nothing

    ' Add JPT for AVT02I
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT02I"))
    End With

    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        
        Set JPTHeadO = JobO.jrApplications.AddPurchaseTerms(True)
        
        With JPTHeadO
            .ImportDefaults
            .thAsApplication.tpTermsInterimFlag = tifGrossIncremental

            Set JPTLinesO = JPTHeadO.thAsApplication.tpDeductionLines.Add

            With JPTLinesO
                .tlAsApplication.tplAnalysisCode = "CB-CITB"
                .ImportDefaults
                .Save
            End With

            Set JPTLinesO = JPTHeadO.thAsApplication.tpRetentionLines.Add

            With JPTLinesO
                .tlAsApplication.tplAnalysisCode = "interim-p"
                .ImportDefaults
                .tlAsApplication.tplRetention = 5
                .Save
            End With

            Set JPTLinesO = JPTHeadO.thAsApplication.tpRetentionLines.Add

            With JPTLinesO
                .tlAsApplication.tplAnalysisCode = "practic-p"
                .ImportDefaults
                .tlAsApplication.tplRetention = 2.5
                .Save
            End With

            Set JPTLinesO = JPTHeadO.thAsApplication.tpRetentionLines.Add

            With JPTLinesO
                .tlAsApplication.tplAnalysisCode = "xpurch-fr"
                .ImportDefaults
                .tlAsApplication.tplRetention = 1.25
                .Save
            End With

            Res& = .Save(True)
        End With
        
        If Res& = 0 Then
            MsgBox "JPT created successfully on AVT02I"
        Else
            MsgBox "Error Adding transaction - " & Res& & " - " & oToolkit.LastErrorString
        End If
    Else
        MsgBox "Error finding Job AVT02I - " & Res& & " - " & oToolkit.LastErrorString
    End If

    Set JobO = Nothing

    ' Add JPT for AVT03I
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT03I"))
    End With

    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        
        Set JPTHeadO = JobO.jrApplications.AddPurchaseTerms(True)
        
        With JPTHeadO
            .ImportDefaults
            .thAsApplication.tpTermsInterimFlag = tifIncremental
            .thAsApplication.tpDeferVAT = True

            Set JPTLinesO = JPTHeadO.thAsApplication.tpDeductionLines.Add

            With JPTLinesO
                .tlAsApplication.tplAnalysisCode = "CB-CITB"
                .ImportDefaults
                .Save
            End With

            Set JPTLinesO = JPTHeadO.thAsApplication.tpRetentionLines.Add

            With JPTLinesO
                .tlAsApplication.tplAnalysisCode = "interim-p"
                .ImportDefaults
                .tlAsApplication.tplRetention = 5
                .Save
            End With

            Set JPTLinesO = JPTHeadO.thAsApplication.tpRetentionLines.Add

            With JPTLinesO
                .tlAsApplication.tplAnalysisCode = "practic-p"
                .ImportDefaults
                .tlAsApplication.tplRetention = 2.5
                .Save
            End With

            Set JPTLinesO = JPTHeadO.thAsApplication.tpRetentionLines.Add

            With JPTLinesO
                .tlAsApplication.tplAnalysisCode = "xpurch-fr"
                .ImportDefaults
                .tlAsApplication.tplRetention = 1.25
                .Save
            End With

            Res& = .Save(True)
        End With
        
        If Res& = 0 Then
            MsgBox "JPT created successfully on AVT03I"
        Else
            MsgBox "Error Adding transaction - " & Res& & " - " & oToolkit.LastErrorString
        End If
    Else
        MsgBox "Error finding Job AVT03I - " & Res& & " - " & oToolkit.LastErrorString
    End If

    Set JobO = Nothing

    ' Add JPT for AVTIMP
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("avtIMP"))
    End With

    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        
        Set JPTHeadO = JobO.jrApplications.AddPurchaseTerms(True)
        
        With JPTHeadO
            .ImportDefaults
            .thAsApplication.tpTermsInterimFlag = tifIncremental

            Res& = .Save(True)
        End With
        
        If Res& = 0 Then
            MsgBox "JPT created successfully on AVTIMP"
        Else
            MsgBox "Error Adding transaction - " & Res& & " - " & oToolkit.LastErrorString
        End If
    Else
        MsgBox "Error finding Contract AVT - " & Res& & " - " & oToolkit.LastErrorString
    End If

    Set JobO = Nothing
End Sub

Private Sub cmdAddJobBudgetTraining_Click()
    Dim JobO As IJob3
    Dim JobBudgetO As IAnalysisJobBudget
    Dim Res&
        
    ' Create a new Add Job Analysis object
    
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT01I"))
        
        If Res& = 0 Then
            Set JobO = oToolkit.JobCosting.Job
        
            Set JobBudgetO = JobO.jrAnalysisBudget.Add
            
            With JobBudgetO
                .jbAnalysisCode = "CB-LABOUR"
                .jbCategory = jbcRevenue
                .jbOriginalQty = 10
                .jbUnitPrice = 1000
                .jbRevisedQty = 10
                .jbRevisedValue = .jbRevisedQty * .jbUnitPrice
                .jbOriginalValue = .jbOriginalQty * .jbUnitPrice
                .jbAnalysisType = anTypeRevenue
                
                Res& = .Save
                If Res& = 0 Then
                    MsgBox "Job Budget Saved"
                Else
                    MsgBox "Error Saving Job Budget - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End With
            
            With JobBudgetO
                .jbAnalysisCode = "CB-MATERIL"
                .jbCategory = jbcRevenue
                .jbOriginalQty = 10
                .jbUnitPrice = 1500
                .jbRevisedQty = 10
                .jbRevisedValue = .jbRevisedQty * .jbUnitPrice
                .jbOriginalValue = .jbOriginalQty * .jbUnitPrice
                .jbAnalysisType = anTypeRevenue
                
                Res& = .Save
                If Res& = 0 Then
                    MsgBox "Job Budget Saved"
                Else
                    MsgBox "Error Saving Job Budget - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End With
            
            With JobBudgetO
                .jbAnalysisCode = "CB-CABLER"
                .jbCategory = jbcSubLabour
                .jbOriginalQty = 100
                .jbUnitPrice = 70
                .jbRevisedQty = 100
                .jbRevisedValue = .jbRevisedQty * .jbUnitPrice
                .jbOriginalValue = .jbOriginalQty * .jbUnitPrice
                .jbAnalysisType = anTypeLabour
                
                Res& = .Save
                If Res& = 0 Then
                    MsgBox "Job Budget Saved"
                Else
                    MsgBox "Error Saving Job Budget - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End With
            
            With JobBudgetO
                .jbAnalysisCode = "CB-SUB-MAT"
                .jbCategory = jbcMaterials2
                .jbOriginalQty = 10
                .jbUnitPrice = 1200
                .jbRevisedQty = 10
                .jbRevisedValue = .jbRevisedQty * .jbUnitPrice
                .jbOriginalValue = .jbOriginalQty * .jbUnitPrice
                .jbAnalysisType = anTypeMaterials
                
                Res& = .Save
                If Res& = 0 Then
                    MsgBox "Job Budget Saved"
                Else
                    MsgBox "Error Saving Job Budget - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End With
        Else
            MsgBox "Error finding Job AVT01I - " & Res& & " - " & oToolkit.LastErrorString
        End If
    End With
    
    Set JobO = Nothing
    Set JobBudgetO = Nothing
    
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT02I"))
        
        If Res& = 0 Then
        
            Set JobO = oToolkit.JobCosting.Job
        
            Set JobBudgetO = JobO.jrAnalysisBudget.Add
            
            With JobBudgetO
                .jbAnalysisCode = "CB-LABOUR"
                .jbCategory = jbcRevenue
                .jbOriginalQty = 10
                .jbUnitPrice = 1000
                .jbRevisedQty = 10
                .jbRevisedValue = .jbRevisedQty * .jbUnitPrice
                .jbOriginalValue = .jbOriginalQty * .jbUnitPrice
                .jbAnalysisType = anTypeRevenue
                
                Res& = .Save
                If Res& = 0 Then
                    MsgBox "Job Budget Saved"
                Else
                    MsgBox "Error Saving Job Budget - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End With
            
            With JobBudgetO
                .jbAnalysisCode = "CB-MATERIL"
                .jbCategory = jbcRevenue
                .jbOriginalQty = 10
                .jbUnitPrice = 1500
                .jbRevisedQty = 10
                .jbRevisedValue = .jbRevisedQty * .jbUnitPrice
                .jbOriginalValue = .jbOriginalQty * .jbUnitPrice
                .jbAnalysisType = anTypeRevenue
                
                Res& = .Save
                If Res& = 0 Then
                    MsgBox "Job Budget Saved"
                Else
                    MsgBox "Error Saving Job Budget - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End With
            
            With JobBudgetO
                .jbAnalysisCode = "CB-CABLER"
                .jbCategory = jbcSubLabour
                .jbOriginalQty = 100
                .jbUnitPrice = 70
                .jbRevisedQty = 100
                .jbRevisedValue = .jbRevisedQty * .jbUnitPrice
                .jbOriginalValue = .jbOriginalQty * .jbUnitPrice
                .jbAnalysisType = anTypeLabour
                
                Res& = .Save
                If Res& = 0 Then
                    MsgBox "Job Budget Saved"
                Else
                    MsgBox "Error Saving Job Budget - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End With
            
            With JobBudgetO
                .jbAnalysisCode = "CB-SUB-MAT"
                .jbCategory = jbcMaterials2
                .jbOriginalQty = 10
                .jbUnitPrice = 1200
                .jbRevisedQty = 10
                .jbRevisedValue = .jbRevisedQty * .jbUnitPrice
                .jbOriginalValue = .jbOriginalQty * .jbUnitPrice
                .jbAnalysisType = anTypeMaterials
                
                Res& = .Save
                If Res& = 0 Then
                    MsgBox "Job Budget Saved"
                Else
                    MsgBox "Error Saving Job Budget - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End With
        Else
            MsgBox "Error finding Job AVT02I - " & Res& & " - " & oToolkit.LastErrorString
        End If
    End With
    
    Set JobO = Nothing
    Set JobBudgetO = Nothing
    
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT03I"))
        
        If Res& = 0 Then
        
            Set JobO = oToolkit.JobCosting.Job
        
            Set JobBudgetO = JobO.jrAnalysisBudget.Add
            
            With JobBudgetO
                .jbAnalysisCode = "CB-LABOUR"
                .jbCategory = jbcRevenue
                .jbOriginalQty = 10
                .jbUnitPrice = 1000
                .jbRevisedQty = 10
                .jbRevisedValue = .jbRevisedQty * .jbUnitPrice
                .jbOriginalValue = .jbOriginalQty * .jbUnitPrice
                .jbAnalysisType = anTypeRevenue
                
                Res& = .Save
                If Res& = 0 Then
                    MsgBox "Job Budget Saved"
                Else
                    MsgBox "Error Saving Job Budget - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End With
            
            With JobBudgetO
                .jbAnalysisCode = "CB-MATERIL"
                .jbCategory = jbcRevenue
                .jbOriginalQty = 10
                .jbUnitPrice = 1500
                .jbRevisedQty = 10
                .jbRevisedValue = .jbRevisedQty * .jbUnitPrice
                .jbOriginalValue = .jbOriginalQty * .jbUnitPrice
                .jbAnalysisType = anTypeRevenue
                
                Res& = .Save
                If Res& = 0 Then
                    MsgBox "Job Budget Saved"
                Else
                    MsgBox "Error Saving Job Budget - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End With
            
            With JobBudgetO
                .jbAnalysisCode = "CB-CABLER"
                .jbCategory = jbcSubLabour
                .jbOriginalQty = 100
                .jbUnitPrice = 70
                .jbRevisedQty = 100
                .jbRevisedValue = .jbRevisedQty * .jbUnitPrice
                .jbOriginalValue = .jbOriginalQty * .jbUnitPrice
                .jbAnalysisType = anTypeLabour
                
                Res& = .Save
                If Res& = 0 Then
                    MsgBox "Job Budget Saved"
                Else
                    MsgBox "Error Saving Job Budget - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End With
            
            With JobBudgetO
                .jbAnalysisCode = "CB-SUB-MAT"
                .jbCategory = jbcMaterials2
                .jbOriginalQty = 10
                .jbUnitPrice = 1200
                .jbRevisedQty = 10
                .jbRevisedValue = .jbRevisedQty * .jbUnitPrice
                .jbOriginalValue = .jbOriginalQty * .jbUnitPrice
                .jbAnalysisType = anTypeMaterials
                
                Res& = .Save
                If Res& = 0 Then
                    MsgBox "Job Budget Saved"
                Else
                    MsgBox "Error Saving Job Budget - " & Res& & " - " & oToolkit.LastErrorString
                End If
            End With
        Else
            MsgBox "Error finding Job AVT03I - " & Res& & " - " & oToolkit.LastErrorString
        End If
    End With
End Sub

Private Sub cmdAddJST_Click()
    Dim JobO As IJob3
    Dim JSTHeadO As ITransaction3
    Dim JSTLinesO As ITransactionLine3
    Dim Res&

    ' Add JST for AVT01I
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT01I"))
    End With

    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        
        Set JSTHeadO = JobO.jrApplications.AddMasterSalesTerms(True)
        
        With JSTHeadO
            .thAsApplication.tpTermsInterimFlag = tifGross
                   
            Set JSTLinesO = JSTHeadO.thAsApplication.tpDeductionLines.Add
            
            With JSTLinesO
                .tlAsApplication.tplAnalysisCode = "CB-s-mcd"
                .ImportDefaults
                .Save
            End With
            
            Set JSTLinesO = JSTHeadO.thAsApplication.tpDeductionLines.Add
            
            With JSTLinesO
                .tlAsApplication.tplAnalysisCode = "CB-s-citb"
                .ImportDefaults
                .Save
            End With

            Set JSTLinesO = JSTHeadO.thAsApplication.tpRetentionLines.Add
            
            With JSTLinesO
                .tlAsApplication.tplAnalysisCode = "interim-s"
                .ImportDefaults
                .Save
            End With

            Set JSTLinesO = JSTHeadO.thAsApplication.tpRetentionLines.Add
            
            With JSTLinesO
                .tlAsApplication.tplAnalysisCode = "practic-s"
                .ImportDefaults
                .Save
            End With

            Res& = JSTHeadO.Save(True)
        End With
        
        If Res& = 0 Then
            MsgBox "JST created successfully on AVT01I"
        Else
            MsgBox "Error Adding JST - " & Res& & " - " & oToolkit.LastErrorString
        End If
    Else
        MsgBox "Error finding Job AVT01I - " & Res& & " - " & oToolkit.LastErrorString
    End If

    Set JobO = Nothing

    ' Add JST for AVT02I
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT02I"))
    End With

    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        
        Set JSTHeadO = JobO.jrApplications.AddMasterSalesTerms(True)
        
        With JSTHeadO
            .ImportDefaults
            .thAsApplication.tpTermsInterimFlag = tifGrossIncremental

            Set JSTLinesO = JSTHeadO.thAsApplication.tpDeductionLines.Add
            
            With JSTLinesO
                .tlAsApplication.tplAnalysisCode = "CB-s-mcd"
                .ImportDefaults
                .Save
            End With
            
            Set JSTLinesO = JSTHeadO.thAsApplication.tpDeductionLines.Add
            
            With JSTLinesO
                .tlAsApplication.tplAnalysisCode = "CB-s-citb"
                .ImportDefaults
                .Save
            End With

            Set JSTLinesO = JSTHeadO.thAsApplication.tpRetentionLines.Add
            
            With JSTLinesO
                .tlAsApplication.tplAnalysisCode = "interim-s"
                .ImportDefaults
                .Save
            End With

            Set JSTLinesO = JSTHeadO.thAsApplication.tpRetentionLines.Add
            
            With JSTLinesO
                .tlAsApplication.tplAnalysisCode = "practic-s"
                .ImportDefaults
                .Save
            End With
            
            Res& = .Save(True)
        End With
        
        If Res& = 0 Then
            MsgBox "JST created successfully on AVT02I"
        Else
            MsgBox "Error Adding transaction - " & Res& & " - " & oToolkit.LastErrorString
        End If
    Else
        MsgBox "Error finding Job AVT02I - " & Res& & " - " & oToolkit.LastErrorString
    End If

    Set JobO = Nothing

    ' Add JST for AVT03I
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT03I"))
    End With

    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        
        Set JSTHeadO = JobO.jrApplications.AddMasterSalesTerms(True)
        
        With JSTHeadO
            .ImportDefaults
            .thAsApplication.tpTermsInterimFlag = tifIncremental

            Set JSTLinesO = JSTHeadO.thAsApplication.tpDeductionLines.Add
            
            With JSTLinesO
                .tlAsApplication.tplAnalysisCode = "CB-s-mcd"
                .ImportDefaults
                .Save
            End With
            
            Set JSTLinesO = JSTHeadO.thAsApplication.tpDeductionLines.Add
            
            With JSTLinesO
                .tlAsApplication.tplAnalysisCode = "CB-s-citb"
                .ImportDefaults
                .Save
            End With

            Set JSTLinesO = JSTHeadO.thAsApplication.tpRetentionLines.Add
            
            With JSTLinesO
                .tlAsApplication.tplAnalysisCode = "interim-s"
                .ImportDefaults
                .Save
            End With

            Set JSTLinesO = JSTHeadO.thAsApplication.tpRetentionLines.Add
            
            With JSTLinesO
                .tlAsApplication.tplAnalysisCode = "practic-s"
                .ImportDefaults
                .tlAsApplication.tplRetention = 2.5
                .Save
            End With
            
            Res& = .Save(True)
        End With
        
        If Res& = 0 Then
            MsgBox "JST created successfully on AVT03I"
        Else
            MsgBox "Error Adding transaction - " & Res& & " - " & oToolkit.LastErrorString
        End If
    Else
        MsgBox "Error finding Job AVT03I - " & Res& & " - " & oToolkit.LastErrorString
    End If

    Set JobO = Nothing
End Sub

Private Sub cmdCertJPA1_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim Res&

    ' Add JPA for AVT01I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT01I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Item
        
        Res& = JPAHeadO.GetFirst
        
        While JPAHeadO.thOurRef <> Trim(txtName) And Res& = 0
            Res& = JPAHeadO.GetNext
        Wend
        
        If JPAHeadO.entCanUpdate = False Then
            MsgBox "Unable to Update " & JPAHeadO.thOurRef
        End If
        
        If Res& <> 0 Then
            MsgBox oToolkit.LastErrorString
        End If
        
        If Res& = 0 Then
            
            With JPAHeadO.Update
                .thAsApplication.tpCertified = True
                Res& = .Save(True)
            End With
            If Res& = 0 Then
                MsgBox "JPA updated successfully for MARK02 on AVT01I"
            Else
                MsgBox "Error Updating Transaction - " & Res& & " - " & oToolkit.LastErrorString
            End If
        End If
    End If
    
    Set JPAHeadO = Nothing
End Sub

Private Sub cmdCertJPA2_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim Res&

    ' Add JPA for AVT01I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT02I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Item
        
        Res& = JPAHeadO.GetFirst
        
        While JPAHeadO.thOurRef <> Trim(txtName) And Res& = 0
            Res& = JPAHeadO.GetNext
        Wend
        
        If JPAHeadO.entCanUpdate = False Then
            MsgBox "Unable to Update " & JPAHeadO.thOurRef
        End If
        
        If Res& <> 0 Then
            MsgBox oToolkit.LastErrorString
        End If
        
        If Res& = 0 Then
            
            With JPAHeadO.Update
                .thAsApplication.tpCertified = True
                Res& = .Save(True)
            End With
            If Res& = 0 Then
                MsgBox "JPA updated successfully for MARK02 on AVT01I"
            Else
                MsgBox "Error Updating Transaction - " & Res& & " - " & oToolkit.LastErrorString
            End If
        End If
    End If
    
    Set JPAHeadO = Nothing
End Sub

Private Sub cmdCertJPA3_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim Res&

    ' Add JPA for AVT01I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT03I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JPAHeadO = JobO.jrApplications.jbaPurchaseApplication.Item
        
        Res& = JPAHeadO.GetFirst
        
        While JPAHeadO.thOurRef <> Trim(txtName) And Res& = 0
            Res& = JPAHeadO.GetNext
        Wend
        
        If JPAHeadO.entCanUpdate = False Then
            MsgBox "Unable to Update " & JPAHeadO.thOurRef
        End If
        
        If Res& <> 0 Then
            MsgBox oToolkit.LastErrorString
        End If
        
        If Res& = 0 Then
            With JPAHeadO.Update
                .thAsApplication.tpCertified = True

                Res& = .Save(True)
            End With
            If Res& = 0 Then
                MsgBox "JPA updated successfully for MARK02 on AVT01I"
            Else
                MsgBox "Error Updating Transaction - " & Res& & " - " & oToolkit.LastErrorString
            End If
        End If
    End If
    
    Set JPAHeadO = Nothing
End Sub

Private Sub cmdCertJSA_Click()
    Dim JobO As IJob3
    Dim JPAHeadO As ITransaction3
    Dim Res&

    ' Add JPA for AVT01I *************************************************************
    With oToolkit.JobCosting.Job
        .Index = jrIdxCode
        Res& = .GetEqual(.BuildCodeIndex("AVT02I"))
    End With
    
    If Res& = 0 Then
                
        Set JobO = oToolkit.JobCosting.Job
        Set JPAHeadO = JobO.jrApplications.jbaSalesApplication.Item
        
        Res& = JPAHeadO.GetFirst
        
        While JPAHeadO.thOurRef <> Trim(txtName) And Res& = 0
            Res& = JPAHeadO.GetNext
        Wend
        
        If JPAHeadO.entCanUpdate = False Then
            MsgBox "Unable to Update " & JPAHeadO.thOurRef
        End If
        
        If Res& <> 0 Then
            MsgBox oToolkit.LastErrorString
        End If
        
        If Res& = 0 Then
            With JPAHeadO.Update
                .thAsApplication.tpCertified = True

                Res& = .Save(True)
            End With
            If Res& = 0 Then
                MsgBox "JSA updated successfully for ABAP01 on AVT02I"
            Else
                MsgBox "Error Updating Transaction - " & Res& & " - " & oToolkit.LastErrorString
            End If
        End If
    End If
    
    Set JPAHeadO = Nothing

End Sub

Private Sub cmdTrainAnalysis_Click()
    Dim JobAnalO As IJobAnalysis3
    Dim JobAnalAddO As IJobAnalysis3
    Dim Res&
        
    ' Create a new Add Job Analysis object
    Set JobAnalO = oToolkit.JobCosting.JobAnalysis
    
    Set JobAnalAddO = JobAnalO.Add
       
    With JobAnalAddO
        .anCode = "xinc-Lab"
        .anDescription = "Income - Labour"
        .anType = anTypeRevenue
        .anCategory = anCatSales
        .anRevenueType = rtLabour
        .anPandLGL = 56010
        .anWIPGL = 56010
        .anLineType = tlTypeLabour1
        
        ' Save Job Analysis Item
        Res& = .Save
        Call Res_Return(Res&, .anCode, .anDescription)
    End With ' JobAnalO
    
    Set JobAnalAddO = Nothing
    Set JobAnalAddO = JobAnalO.Add
       
    With JobAnalAddO
        .anCode = "xinc-mat"
        .anDescription = "Income - Materials"
        .anType = anTypeRevenue
        .anCategory = anCatSales
        .anRevenueType = rtMaterials2
        .anPandLGL = 56010
        .anWIPGL = 56010
        .anLineType = tlTypeMaterials2

        ' Save Job Analysis Item
        Res& = .Save
        Call Res_Return(Res&, .anCode, .anDescription)
    End With ' JobAnalO
    
    Set JobAnalAddO = Nothing
    Set JobAnalAddO = JobAnalO.Add
       
    With JobAnalAddO
        .anCode = "xsub-disc"
        .anDescription = "Subs Discount"
        .anType = anTypeRevenue
        .anCategory = anCatPurchaseDeductions
        .anPandLGL = 69100
        .anWIPGL = 69100
        .anLineType = tlTypeDeductions1

        ' new fields for Sales & Purchase Deductions
        .anApplyDeduction = datLabour
        .anDeductionBase = dbtPercentage
        .anDeduction = 5
        .anCalcDeductionAs = detNormal

        ' Save Job Analysis Item
        Res& = .Save
        Call Res_Return(Res&, .anCode, .anDescription)
    End With ' JobAnalO
    
    Set JobAnalAddO = Nothing
    Set JobAnalAddO = JobAnalO.Add
       
    With JobAnalAddO
        .anCode = "xsub-deds"
        .anDescription = "Subs Levy"
        .anType = anTypeRevenue
        .anCategory = anCatPurchaseDeductions
        .anPandLGL = 69100
        .anWIPGL = 69100
        .anLineType = tlTypeDeductions2

        ' new fields for Sales & Purchase Deductions
        .anApplyDeduction = datAll
        .anDeductionBase = dbtPercentage
        .anDeduction = 2.5
        .anCalcDeductionAs = detAfterAllOther

        ' Save Job Analysis Item
        Res& = .Save
        Call Res_Return(Res&, .anCode, .anDescription)
    End With ' JobAnalO
    
    Set JobAnalAddO = Nothing
    Set JobAnalAddO = JobAnalO.Add
       
    With JobAnalAddO
        .anCode = "xsub-rech"
        .anDescription = "Subs Recharge"
        .anType = anTypeRevenue
        .anCategory = anCatPurchaseDeductions
        .anPandLGL = 69100
        .anWIPGL = 69100
        .anLineType = tlTypeDeductions3

        ' new fields for Sales & Purchase Deductions
        .anApplyDeduction = datAll
        .anDeductionBase = dbtValue
        .anCalcDeductionAs = detContra

        ' Save Job Analysis Item
        Res& = .Save
        Call Res_Return(Res&, .anCode, .anDescription)
    End With ' JobAnalO
    
    Set JobAnalAddO = Nothing
    Set JobAnalAddO = JobAnalO.Add
       
    With JobAnalAddO
        .anCode = "xpurch-ir"
        .anDescription = "Interim Purchase Retention"
        .anType = anTypeRevenue
        .anCategory = anCatRetentionPL
        .anPandLGL = 38010
        .anWIPGL = 38010
        .anLineType = tlTypeRetentions1

        'new fields for Retention Analysis Codes
        .anRetentionType = aifInterim
        .anRetentionValue = 10
        .anRetentionExpiryType = reOnPractical

        ' Save Job Analysis Item
        Res& = .Save
        Call Res_Return(Res&, .anCode, .anDescription)
    End With ' JobAnalO
    
    Set JobAnalAddO = Nothing
    Set JobAnalAddO = JobAnalO.Add
       
    With JobAnalAddO
        .anCode = "xpurch-pr"
        .anDescription = "Practical Purchase Retention"
        .anType = anTypeRevenue
        .anCategory = anCatRetentionPL
        .anPandLGL = 38020
        .anWIPGL = 38020
        .anLineType = tlTypeRetentions2

        'new fields for Retention Analysis Codes
        .anRetentionType = aifPractical
        .anRetentionValue = 5
        .anRetentionExpiryType = reOnFinal

        ' Save Job Analysis Item
        Res& = .Save
        Call Res_Return(Res&, .anCode, .anDescription)
    End With ' JobAnalO
    
    Set JobAnalAddO = Nothing
    Set JobAnalAddO = JobAnalO.Add
       
    With JobAnalAddO
        .anCode = "xpurch-fr"
        .anDescription = "Final Purchase Retention"
        .anType = anTypeRevenue
        .anCategory = anCatRetentionPL
        .anPandLGL = 38020
        .anWIPGL = 38020
        .anLineType = tlTypeRetentions2

        'new fields for Retention Analysis Codes
        .anRetentionType = aifStandAlone
        .anRetentionValue = 2.5
        .anRetentionExpiryType = reMonths
        .anRetentionExpiryInterval = 3

        ' Save Job Analysis Item
        Res& = .Save
        Call Res_Return(Res&, .anCode, .anDescription)
    End With ' JobAnalO
    
    Set JobAnalAddO = Nothing
    Set JobAnalO = Nothing

End Sub

Private Sub cmdOpenCOMTK_Click()
    Dim Res&
    
    ' Create COM Toolkit object
    Set oToolkit = CreateObject("Enterprise01.Toolkit")
    
    With oToolkit
        With .Configuration
            .DataDirectory = txtCompDir.Path
        End With ' .Configuration
        
        ' Open Toolkit
        Res& = .OpenToolkit&
        
        If (Res& <> 0) Then
            MsgBox "The following error occured opening the Toolkit:-" + Chr(13) + Chr(13) + _
                   """" + oToolkit.LastErrorString + """"
        Else
            lblVer.Caption = .Version
            lblDir.Caption = oToolkit.Configuration.DataDirectory
            cmdOpenCOMTK.Caption = "Toolkit Opened Successfully"
            cmdOpenCOMTK.Enabled = False
            cmdOpenCOMTK.FontBold = True
            Frame5.Enabled = True
        End If
    End With ' oToolkit
End Sub

Private Sub Form_Load()
    txtCompDir.Path = "C:\571Beta"
    cmdOpenCOMTK_Click
End Sub

Private Sub Form_Unload(Cancel As Integer)
    If cmdOpenCOMTK.Enabled = False Then
        ' Close Company Data and remove reference to COM Toolkit
        oToolkit.CloseToolkit
        Set oToolkit = Nothing
    End If
End Sub

Public Sub Res_Return(Res&, Code As String, Desc As String)
    If Res& = 0 Then
        MsgBox Code & " - " & Desc & " Added Successfully"
    Else
        MsgBox "Error adding " & Code & " - " & Desc & " - " & Res& & " - " & oToolkit.LastErrorString
    End If
End Sub

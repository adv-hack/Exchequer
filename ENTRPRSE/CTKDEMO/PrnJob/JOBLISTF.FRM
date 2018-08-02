VERSION 5.00
Begin VB.Form frmJobList 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Job List - Print Job Test App"
   ClientHeight    =   3240
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7350
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3240
   ScaleWidth      =   7350
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdJCBackingSheet 
      Caption         =   "Print Backing Sheet"
      Height          =   435
      Left            =   5520
      TabIndex        =   2
      Top             =   825
      Width           =   1680
   End
   Begin VB.CommandButton cmdPrintJob 
      Caption         =   "Print Job"
      Height          =   435
      Left            =   5520
      TabIndex        =   1
      Top             =   240
      Width           =   1680
   End
   Begin VB.ListBox lstJobs 
      Height          =   2985
      Left            =   75
      TabIndex        =   0
      Top             =   150
      Width           =   5235
   End
End
Attribute VB_Name = "frmJobList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim oToolkit As Enterprise01.Toolkit

Private Sub cmdJCBackingSheet_Click()
    Dim oTrans2 As ITransaction2
    Dim oPrintJob As IPrintJob
    Dim FuncRes&
    
    ' Typecast standard Transaction object as the descendant that supports printing
    Set oTrans2 = oToolkit.Transaction
    With oTrans2
        ' Find the selected Transaction
        FuncRes& = .GetEqual(.BuildOurRefIndex("SIN007736"))
    
        If (FuncRes& = 0) Then
            ' print it
            Set oPrintJob = .Print(thpmJCBackingSheet)
            With oPrintJob
                .ImportDefaults
                FuncRes& = .PrintToPrinter
                If (FuncRes& <> 0) Then
                  MsgBox "PrintToPrinter: " + Str(FuncRes&)
                End If
            End With ' oPrintJob
            Set oPrintJob = Nothing
        Else
            MsgBox "ITransaction2.GetEqual: " + Str(FuncRes&)
        End If
    End With ' oTrans2
    ' Remove reference to allow it to be destroyed correctly at the appropriate time
    Set oTrans2 = Nothing
End Sub

Private Sub cmdPrintJob_Click()
    Dim oJob2 As IJob2
    Dim oPrintJob As IPrintJob
    Dim FuncRes&
    
    ' Typecast standard Job object as the descendant that supports printing
    Set oJob2 = oToolkit.JobCosting.Job
    With oJob2
        ' Find the selected job
        FuncRes& = .GetEqual(.BuildCodeIndex(lstJobs.Text))
    
        If (FuncRes& = 0) Then
            ' print it
            Set oPrintJob = .Print(jrpmJobWithNotes)
            With oPrintJob
                .ImportDefaults
                FuncRes& = .PrintToPrinter
                If (FuncRes& <> 0) Then
                  MsgBox "PrintToPrinter: " + Str(FuncRes&)
                End If
            End With ' oPrintJob
            Set oPrintJob = Nothing
        Else
            MsgBox "IJob2.GetEqual: " + Str(FuncRes&)
        End If
    End With ' oJob2
    ' Remove reference to allow it to be destroyed correctly at the appropriate time
    Set oJob2 = Nothing
End Sub

Private Sub Form_Load()
    Dim FuncRes&
    
    ' Create COM Toolkit
    Set oToolkit = CreateObject("Enterprise01.Toolkit")

    With oToolkit
        With .Configuration
            ' Force the COM Toolkit to automatically set currency exchange rates on new transactions
            .AutoSetTransCurrencyRates = True

            ' Change Path to data
            .DataDirectory = "C:\Develop\Dev500\"
        End With ' .Configuration
            
        FuncRes& = oToolkit.OpenToolkit
        If (FuncRes& = 0) Then
            ' Company Data opened successfully
            With .JobCosting.Job
                .Index = jrIdxCode
                FuncRes& = .GetFirst
                While (FuncRes& = 0)
                    If (.jrType = JTypeJob) Then
                        lstJobs.AddItem .jrCode
                    End If
                
                    FuncRes& = .GetNext
                Wend
            End With ' .JobCosting.Job
        Else
            MsgBox "The following error occured opening the Toolkit:-" + _
                   Chr(13) + Chr(13) + """" + .LastErrorString + """"
        End If
    End With ' oToolkit
End Sub

Private Sub Form_Unload(Cancel As Integer)
    ' Remove reference to COM Toolkit
    Set oToolkit = Nothing
End Sub

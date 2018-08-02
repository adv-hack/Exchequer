VERSION 5.00
Begin VB.Form frmMatch 
   Caption         =   "Matching Demo"
   ClientHeight    =   2655
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7200
   LinkTopic       =   "Form1"
   ScaleHeight     =   2655
   ScaleWidth      =   7200
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox lstSRC 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1740
      Left            =   3600
      TabIndex        =   3
      Top             =   120
      Width           =   3495
   End
   Begin VB.ListBox lstSIN 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1740
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   3375
   End
   Begin VB.CommandButton Match 
      Caption         =   "Match"
      Height          =   375
      Left            =   1200
      TabIndex        =   1
      Top             =   2160
      Width           =   975
   End
   Begin VB.CommandButton Start 
      Caption         =   "Start"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   2160
      Width           =   975
   End
End
Attribute VB_Name = "frmMatch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Dim iStatus As Integer, i As Integer
          
    iStatus = EX_INITDLL()
       
    If iStatus <> 0 Then
        MsgBox "Error initialising DLL = " + Str(iStatus)
    End If

End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim iStatus As Integer
    
    iStatus = EX_CLOSEDLL()
    
End Sub

Sub ReadTrans(sType As String, lstList As ListBox)
    Dim iStatus As Integer
    Dim TransRec As TBatchTHRec
    Dim sSearch As String
    
    lstList.Clear
    
    sSearch = sType + Chr(0)
    
    iStatus = EX_GETTRANSHED(TransRec, Len(TransRec), sSearch, 0, B_GetGEq, DllFalse)
    
    Do While (iStatus = 0) And (TransRec.TransDocHed = sType)
        lstList.AddItem Left$(TransRec.OurRef, Asc(TransRec.OurRefLen)) + _
          " " + Format(TransRec.InvNetVal + TransRec.InvVat, "###,##0.00")
        
        iStatus = EX_GETTRANSHED(TransRec, Len(TransRec), sSearch, 0, B_GetNext, DllFalse)
    Loop
End Sub

Private Sub Match_Click()
    Dim iStatus As Integer
    Dim MatchRec As TBatchMatchRec
    Dim CredAmt As Double
    
    If (lstSIN.ListIndex = -1) Or (lstSRC.ListIndex = -1) Then
        MsgBox "Select SIN & SRC"
    Else
        With MatchRec
            .DebitRef = Left(lstSIN, 9)
            .DebitRefLen = Chr(Len(Trim(.DebitRef)))
            .CreditRef = Left(lstSRC, 9)
            .CreditRefLen = Chr(Len(Trim(.CreditRef)))
            .DebitCr = 1
            .CreditCr = 1
            .DebitVal = Format(Mid$(lstSIN, 11), "0.00")
            .CreditVal = Format(Mid$(lstSRC, 11), "0.00")
            CredAmt = .CreditVal
            iStatus = EX_CONVERTAMOUNT(1, 0, CredAmt, 0)
            
            .BaseVal = CredAmt
        End With
        
        iStatus = EX_STOREMATCH(MatchRec, Len(MatchRec), 0, B_Insert)
        If iStatus <> 0 Then
            MsgBox "EX_STOREMATCH : " + Str(iStatus)
        Else
            MsgBox "OK"
        End If
    End If
End Sub

Private Sub Start_Click()
    ReadTrans "SIN", lstSIN
    ReadTrans "SRC", lstSRC

End Sub

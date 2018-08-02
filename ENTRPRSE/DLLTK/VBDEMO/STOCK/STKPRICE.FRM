VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   2925
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4470
   LinkTopic       =   "Form1"
   ScaleHeight     =   2925
   ScaleWidth      =   4470
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Get Stock Price"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2805
      Left            =   90
      TabIndex        =   0
      Top             =   60
      Width           =   4335
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
    Dim StkPrice As TBatchStkPriceRec
    Dim Res%, RecLen&
    
    ' Load toolkit DLL
    Res% = EX_INITDLL%()
    If (Res% = 0) Then
        ' Initialise the Stock Price structure
        Res% = EX_INITSTKPRICE(StkPrice, Len(StkPrice))
        If (Res% = 0) Then
            With StkPrice
                ' Stock Code
                .StockCode = "BLUE"
                .StockCodeLen = Chr(Len(Trim(.StockCode)))
    
                ' Customer Code
                .CustCode = "ABSC01"
                .CustCodeLen = Chr(Len(Trim(.CustCode)))
    
                ' Currency
                .Currency% = 1
                
                ' Quantity
                Qty = 1#
            End With ' StkPrice
                 
            Res% = EX_CALCSTOCKPRICE(StkPrice, Len(StkPrice))
        
            If (Res% = 0) Then
                ' AOK
                MsgBox "Price=" + Str(StkPrice.Price#)
            Else
                MsgBox "EX_CALCSTOCKPRICE: " + Str(Res%)
            End If
        Else
            MsgBox "EX_INITSTKPRICE: " + Str(Res%)
        End If
    
        Call EX_CLOSEDLL
    Else
        MsgBox "EX_INITDLL: " + Str(Res%)
    End If
End Sub

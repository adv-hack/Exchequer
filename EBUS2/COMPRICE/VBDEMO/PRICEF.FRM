VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Begin VB.Form frmCOMPrice 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Enterprise COM Pricing Demo"
   ClientHeight    =   5580
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6660
   Icon            =   "PriceF.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5580
   ScaleWidth      =   6660
   StartUpPosition =   2  'CenterScreen
   Begin VB.Frame Frame1 
      Caption         =   " Check Stock Prices "
      Height          =   2610
      Index           =   2
      Left            =   60
      TabIndex        =   5
      Top             =   2895
      Width           =   6525
      Begin VB.TextBox txtQty 
         Height          =   390
         Left            =   870
         TabIndex        =   14
         Text            =   "1"
         Top             =   1620
         Width           =   450
      End
      Begin VB.TextBox txtCcy 
         Height          =   390
         Left            =   870
         TabIndex        =   12
         Text            =   "1"
         Top             =   1170
         Width           =   450
      End
      Begin VB.TextBox txtStockCode 
         Height          =   375
         Left            =   870
         TabIndex        =   10
         Text            =   "ALARMSYS-DOM-1"
         Top             =   735
         Width           =   1950
      End
      Begin VB.TextBox txtAcCode 
         Height          =   390
         Left            =   870
         TabIndex        =   8
         Text            =   "ABAP01"
         Top             =   285
         Width           =   930
      End
      Begin VB.CommandButton cmdCalcPrice 
         Caption         =   "&Calc Price"
         Height          =   315
         Left            =   5190
         TabIndex        =   6
         Top             =   2190
         Width           =   1200
      End
      Begin VB.Label lblUnitPrice 
         Height          =   255
         Left            =   900
         TabIndex        =   16
         Top             =   2235
         Width           =   2025
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Unit Price"
         Height          =   285
         Index           =   4
         Left            =   60
         TabIndex        =   15
         Top             =   2250
         Width           =   750
      End
      Begin VB.Line Line1 
         BorderColor     =   &H80000010&
         Index           =   1
         X1              =   60
         X2              =   6470
         Y1              =   2085
         Y2              =   2085
      End
      Begin VB.Line Line1 
         BorderColor     =   &H80000014&
         Index           =   0
         X1              =   60
         X2              =   6470
         Y1              =   2100
         Y2              =   2100
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Quantity"
         Height          =   285
         Index           =   3
         Left            =   60
         TabIndex        =   13
         Top             =   1665
         Width           =   750
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Currency"
         Height          =   285
         Index           =   2
         Left            =   60
         TabIndex        =   11
         Top             =   1215
         Width           =   750
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "Stk Code"
         Height          =   285
         Index           =   1
         Left            =   60
         TabIndex        =   9
         Top             =   780
         Width           =   750
      End
      Begin VB.Label Label1 
         Alignment       =   1  'Right Justify
         Caption         =   "A/C"
         Height          =   285
         Index           =   0
         Left            =   60
         TabIndex        =   7
         Top             =   330
         Width           =   750
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   " Currency List "
      Height          =   1980
      Index           =   1
      Left            =   60
      TabIndex        =   2
      Top             =   855
      Width           =   6525
      Begin VB.CommandButton cmdLoadCcy 
         Caption         =   "&Load Ccy"
         Height          =   315
         Left            =   5205
         TabIndex        =   4
         Top             =   300
         Width           =   1200
      End
      Begin ComctlLib.ListView lvCcyTable 
         Height          =   1620
         Left            =   120
         TabIndex        =   3
         Top             =   240
         Width           =   5025
         _ExtentX        =   8864
         _ExtentY        =   2858
         View            =   3
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         _Version        =   327682
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   3
         BeginProperty ColumnHeader(1) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
            Key             =   ""
            Object.Tag             =   ""
            Text            =   ""
            Object.Width           =   529
         EndProperty
         BeginProperty ColumnHeader(2) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
            SubItemIndex    =   1
            Key             =   ""
            Object.Tag             =   ""
            Text            =   "Name"
            Object.Width           =   4939
         EndProperty
         BeginProperty ColumnHeader(3) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
            SubItemIndex    =   2
            Key             =   ""
            Object.Tag             =   ""
            Text            =   "Symbol"
            Object.Width           =   882
         EndProperty
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   " Enterprise Directory "
      Height          =   750
      Index           =   0
      Left            =   60
      TabIndex        =   0
      Top             =   60
      Width           =   6525
      Begin VB.TextBox txtEnterprise 
         Height          =   375
         Left            =   120
         TabIndex        =   1
         Text            =   "f:\431nov22\"
         Top             =   270
         Width           =   6270
      End
   End
End
Attribute VB_Name = "frmCOMPrice"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim oPricing As Enterprise02.COMPricing

Private Sub cmdCalcPrice_Click()
    Dim UnitPrice As Variant
    Dim Res%
    
    Res% = oPricing.CalcPrice(txtEnterprise.Text, _
                               txtAcCode.Text, _
                               txtStockCode.Text, _
                               CInt(txtCcy.Text), _
                               CDbl(txtQty.Text), _
                               UnitPrice)
                               
    If (Res% = 0) Then
        lblUnitPrice.Caption = Str(UnitPrice)
    Else
        MsgBox "CalcPrice Error " + Str(Res%)
    End If
End Sub

Private Sub cmdLoadCcy_Click()
    Dim CcyName As Variant, CcySymb As Variant
    Dim lvItem As ListItem
    Dim Res%, I%
    
    With lvCcyTable
        ' clear out any existing data
        .ListItems.Clear
        
        ' Load Currency Table - just basic 0-30 assuming Multi-Currency of course
        Res% = 0
        I% = 0
        While (Res% = 0) And (I% <= 30)
            ' Get currency details
            Res% = oPricing.GetCurrency(txtEnterprise.Text, I%, CcyName, CcySymb)
        
            If (Res% = 0) Then
                ' Add into Listview
                Set lvItem = lvCcyTable.ListItems.Add(, , Str(I%))
                lvItem.SubItems(1) = CcyName
                lvItem.SubItems(2) = CcySymb
            
                ' Move to next currency
                I% = I% + 1
            Else
                MsgBox "GetCurrency Error " + Str(Res%)
            End If ' Res% = 0
        Wend
    End With ' lvCcyTable
End Sub

Private Sub Form_Load()
    Dim Res%

    ' Create COM Pricing object
    Set oPricing = CreateObject("Enterprise02.COMPricing")
    
    ' Get path of currently installed Enterprise system
    txtEnterprise.Text = GetEnterpriseDir("")
End Sub


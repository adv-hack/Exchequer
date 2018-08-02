VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Enterprise Toolkit DLL - User Profile Demo "
   ClientHeight    =   7395
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6900
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7395
   ScaleWidth      =   6900
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox lstProfileDets 
      Height          =   4350
      Left            =   90
      TabIndex        =   1
      Top             =   2820
      Width           =   6705
   End
   Begin ComctlLib.ListView lvProfiles 
      Height          =   2655
      Left            =   90
      TabIndex        =   0
      Top             =   90
      Width           =   6705
      _ExtentX        =   11827
      _ExtentY        =   4683
      View            =   3
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      _Version        =   327682
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   3
      BeginProperty ColumnHeader(1) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "User Id"
         Object.Width           =   1589
      EndProperty
      BeginProperty ColumnHeader(2) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         SubItemIndex    =   1
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "Name"
         Object.Width           =   3704
      EndProperty
      BeginProperty ColumnHeader(3) {0713E8C7-850A-101B-AFC0-4210102A8DA7} 
         SubItemIndex    =   2
         Key             =   ""
         Object.Tag             =   ""
         Text            =   "Email Address"
         Object.Width           =   5080
      EndProperty
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Dim UserProf As TUserProfileType
    Dim LastErr As PascalString
    Dim lvItem As ListItem
    Dim SKey As String * 255
    Dim Res%
    
    Res% = EX_INITDLL()
    If (Res% = 0) Then
        SKey = String$(255, " ")
        Res% = EX_GETUSERPROFILE(UserProf, Len(UserProf), SKey$, B_GetFirst)
        While (Res% = 0)
            With UserProf
                Set lvItem = lvProfiles.ListItems.Add(, , .upUserId)
                lvItem.SubItems(1) = Trim(.upName)
                lvItem.SubItems(2) = Trim(.upEmail)
            End With ' UserProf
            
            Res% = EX_GETUSERPROFILE(UserProf, Len(UserProf), SKey$, B_GetNext)
        Wend
    Else
        ' Error opening Toolkit
        LastErr = EX_GETLASTERRORDESC()
        MsgBox "The following error occurred whilst initialising the Toolkit DLL:-" + _
               Chr(13) + Chr(13) + "Error " + Str(Res%) + ": " + Mid$(LastErr.Str, 1, LastErr.StrLen) + _
               Chr(13) + Chr(13) + "Please contact your technical support"
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call EX_CLOSEDATA
End Sub


Private Sub lvProfiles_DblClick()
    Dim UserProf As TUserProfileType
    Dim SKey As String * 255
    Dim Res%
    
    SKey = lvProfiles.SelectedItem.Text + String$(255, 0)
    Res% = EX_GETUSERPROFILE(UserProf, Len(UserProf), SKey$, B_GetEq)
    If (Res% = 0) Then
        lstProfileDets.Clear
        lstProfileDets.AddItem ("User Id: " + Trim(UserProf.upUserId))
        lstProfileDets.AddItem ("Name: " + Trim(UserProf.upName))
        lstProfileDets.AddItem ("Email: " + Trim(UserProf.upEmail))
        lstProfileDets.AddItem ("")
        lstProfileDets.AddItem ("Lock Out Mins: " + Str(UserProf.upLockOutMins))
        lstProfileDets.AddItem ("")
        lstProfileDets.AddItem ("SRI Customer: " + Trim(UserProf.upDefSRICust))
        lstProfileDets.AddItem ("PPI Supplier: " + Trim(UserProf.upDefPPISupp))
        lstProfileDets.AddItem ("")
        lstProfileDets.AddItem ("Cost Centre: " + Trim(UserProf.upDefCostCentre))
        lstProfileDets.AddItem ("Department: " + Trim(UserProf.upDefDepartment))
        Select Case UserProf.upDefCCDeptRule
        Case 0
            lstProfileDets.AddItem ("CC/Dept Rule: 0 - Stock, Account, Operator")
        Case 1
            lstProfileDets.AddItem ("CC/Dept Rule: 1 - Account, Stock, Operator")
        Case 2
            lstProfileDets.AddItem ("CC/Dept Rule: 2 - Operator, Account, Stock")
        Case 3
            lstProfileDets.AddItem ("CC/Dept Rule: 3 - Operator, Stock, Account")
        Case Else
            lstProfileDets.AddItem ("CC/Dept Rule: " + Str(UserProf.upDefCCDeptRule))
        End Select
        lstProfileDets.AddItem ("")
        lstProfileDets.AddItem ("Location: " + Trim(UserProf.upDefLocation))
        Select Case UserProf.upDefLocRule
        Case 0
            lstProfileDets.AddItem ("Location Rule: 0 - Account, Stock, Operator")
        Case 1
            lstProfileDets.AddItem ("Location Rule: 1 - Stock, Account, Operator")
        Case 2
            lstProfileDets.AddItem ("Location Rule: 2 - Operator, Account, Stock")
        Case 3
            lstProfileDets.AddItem ("Location Rule: 3 - Operator, Stock, Account")
        Case Else
            lstProfileDets.AddItem ("Location Rule: " + Str(UserProf.upDefLocRule))
        End Select
        
        
        
        lstProfileDets.AddItem ("")
        lstProfileDets.AddItem ("Sales Bank GL: " + Str(UserProf.upDefSalesBankGL))
        lstProfileDets.AddItem ("Purchase Bank GL: " + Str(UserProf.upDefPurchBankGL))
        lstProfileDets.AddItem ("")
        lstProfileDets.AddItem ("Max Sales Authorisation: " + Str(UserProf.upMaxSalesAuth))
        lstProfileDets.AddItem ("Max Purchase Authorisation: " + Str(UserProf.upMaxPurchAuth))
    Else
        MsgBox "An error " + Str(Res%) + " occurred whilst loading the User Profile for '" + lvProfiles.SelectedItem.Text + "'"
    End If
End Sub


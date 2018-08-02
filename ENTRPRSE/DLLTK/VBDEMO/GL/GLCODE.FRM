VERSION 5.00
Begin VB.Form Form_GL 
   Appearance      =   0  'Flat
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Exchequer Enterprise Toolkit DLL - General Ledger Demo"
   ClientHeight    =   4350
   ClientLeft      =   1155
   ClientTop       =   2040
   ClientWidth     =   7125
   BeginProperty Font 
      Name            =   "MS Sans Serif"
      Size            =   8.25
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H80000008&
   Icon            =   "GLCODE.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   4350
   ScaleWidth      =   7125
   Begin VB.CheckBox Chk_Revalue 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   300
      Left            =   1200
      TabIndex        =   8
      Top             =   3180
      Width           =   360
   End
   Begin VB.CheckBox Chk_PageBrk 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   300
      Left            =   1200
      TabIndex        =   7
      Top             =   2805
      Width           =   495
   End
   Begin VB.CommandButton btnFindCarryFwd 
      Appearance      =   0  'Flat
      Caption         =   "Find"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   2130
      TabIndex        =   6
      Top             =   2430
      Width           =   420
   End
   Begin VB.CommandButton btnFindParent 
      Appearance      =   0  'Flat
      Caption         =   "Find"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   2130
      TabIndex        =   3
      Top             =   1650
      Width           =   420
   End
   Begin VB.TextBox Text_CarryFwd 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   1185
      MaxLength       =   9
      TabIndex        =   5
      Top             =   2430
      Width           =   945
   End
   Begin VB.ComboBox List_Type 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   1185
      Style           =   2  'Dropdown List
      TabIndex        =   4
      Top             =   2040
      Width           =   3675
   End
   Begin VB.TextBox Text_Parent 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   1185
      MaxLength       =   9
      TabIndex        =   2
      Top             =   1650
      Width           =   945
   End
   Begin VB.TextBox Text_Name 
      Appearance      =   0  'Flat
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   1185
      TabIndex        =   1
      Top             =   1260
      Width           =   3690
   End
   Begin VB.TextBox Text_GLCode 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   1185
      MaxLength       =   9
      TabIndex        =   0
      Top             =   885
      Width           =   945
   End
   Begin VB.Frame Frame3 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   855
      Left            =   5745
      TabIndex        =   20
      Top             =   2955
      Width           =   1305
      Begin VB.CommandButton Command2 
         Appearance      =   0  'Flat
         Caption         =   "Edit"
         Height          =   315
         Index           =   1
         Left            =   60
         TabIndex        =   15
         Top             =   465
         Width           =   1170
      End
      Begin VB.CommandButton Command2 
         Appearance      =   0  'Flat
         Caption         =   "Add"
         Height          =   315
         Index           =   0
         Left            =   60
         TabIndex        =   14
         Top             =   150
         Width           =   1170
      End
   End
   Begin VB.Frame Frame2 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   2115
      Left            =   5745
      TabIndex        =   19
      Top             =   795
      Width           =   1305
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Last"
         Height          =   375
         Index           =   4
         Left            =   60
         TabIndex        =   13
         Top             =   1650
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Next"
         Height          =   375
         Index           =   3
         Left            =   60
         TabIndex        =   12
         Top             =   1275
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Find"
         Height          =   375
         Index           =   2
         Left            =   60
         TabIndex        =   11
         Top             =   900
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "Previous"
         Height          =   375
         Index           =   1
         Left            =   60
         TabIndex        =   10
         Top             =   525
         Width           =   1170
      End
      Begin VB.CommandButton Command1 
         Appearance      =   0  'Flat
         Caption         =   "First"
         Height          =   375
         Index           =   0
         Left            =   60
         TabIndex        =   9
         Top             =   150
         Width           =   1170
      End
   End
   Begin VB.Frame Frame1 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   30
      Index           =   0
      Left            =   60
      TabIndex        =   18
      Top             =   3900
      Width           =   7020
   End
   Begin VB.Frame Frame1 
      Appearance      =   0  'Flat
      Caption         =   " General Ledger Functions"
      ForeColor       =   &H80000008&
      Height          =   735
      Index           =   1
      Left            =   90
      TabIndex        =   16
      Top             =   15
      Width           =   6960
      Begin VB.Label Label2 
         Appearance      =   0  'Flat
         Caption         =   "These functions allow you to access and maintain the General Ledger Codes within an Exchequer or Exchequer Enterprise System."
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H80000008&
         Height          =   450
         Index           =   0
         Left            =   135
         TabIndex        =   17
         Top             =   240
         Width           =   6705
      End
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Page Break"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   270
      Index           =   6
      Left            =   120
      TabIndex        =   30
      Top             =   2835
      Width           =   1020
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Revalue"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   270
      Index           =   5
      Left            =   285
      TabIndex        =   29
      Top             =   3210
      Width           =   855
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Carry Fwd"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   270
      Index           =   4
      Left            =   285
      TabIndex        =   28
      Top             =   2460
      Width           =   855
   End
   Begin VB.Label lblCarryFwdName 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   270
      Left            =   2595
      TabIndex        =   27
      Top             =   2460
      Width           =   2940
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Type"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   270
      Index           =   3
      Left            =   285
      TabIndex        =   26
      Top             =   2085
      Width           =   855
   End
   Begin VB.Label lblParentName 
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   270
      Left            =   2610
      TabIndex        =   25
      Top             =   1680
      Width           =   2970
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Parent"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   270
      Index           =   2
      Left            =   285
      TabIndex        =   24
      Top             =   1680
      Width           =   855
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Description"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   270
      Index           =   1
      Left            =   195
      TabIndex        =   23
      Top             =   1290
      Width           =   945
   End
   Begin VB.Label Label3 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      Caption         =   "Code"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   270
      Index           =   0
      Left            =   285
      TabIndex        =   21
      Top             =   915
      Width           =   855
   End
   Begin VB.Label lblResult 
      Appearance      =   0  'Flat
      ForeColor       =   &H80000008&
      Height          =   240
      Left            =   75
      TabIndex        =   22
      Top             =   4005
      Width           =   6915
   End
End
Attribute VB_Name = "Form_GL"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const Capt_Add = "Add"
Const Capt_Save = "Save"
Const Capt_Edit = "Edit"
Const Capt_Cancel = "Cancel"

Dim GLRec As TBatchNomRec
Dim OrigCode$, Editing As Integer
Dim DLLLoaded%

Private Sub btnFindCarryFwd_Click()
    If (GLRec.NomType = "F") And (GLRec.CarryF > 0) Then
        ' Carry-Forward Code - Go to the parent code
        Text_GLCode.Text = Text_CarryFwd.Text
        Command1_Click (2)
    End If

End Sub

Private Sub btnFindParent_Click()
    If (GLRec.Cat > 0) Then
        ' Go to the parent code
        Text_GLCode.Text = Text_Parent.Text
        Command1_Click (2)
    End If
End Sub

Private Sub Command1_Click(Index As Integer)
    Dim PChar As String * 255
    Dim RecLen As Long, BtrMode%
    Dim ActStr$, Result%
    
    PChar = Text_GLCode.Text + String$(255, 0)
    
    Select Case Index%
        Case 0 ' First
            BtrMode% = B_GetFirst%
            ActStr$ = "First"
        Case 1 ' Previous
            BtrMode% = B_GetPrev%
            ActStr$ = "Previous"
        Case 2 ' Find
            BtrMode% = B_GetGEq%
            ActStr$ = "First"
        Case 3 ' Next
            BtrMode% = B_GetNext%
            ActStr$ = "Next"
        Case 4 ' Last
            BtrMode% = B_GetLast%
            ActStr$ = "Last"
    End Select

    RecLen = Len(GLRec)
    Result% = EX_GETGLACCOUNT%(GLRec, RecLen, PChar$, 0, BtrMode%, DllFalse%)
    
    lblResult.Caption = ""

    If Result% = 0 Then
        ' Got a record - display
        Call DisplayGL
        Call EnableForAdd(False)
    Else
        Select Case Result%
            Case 9 ' End Of File
                lblResult.Caption = "The End Of file has been reached"
            Case Else
                If (Index = 2) Then
                    lblResult.Caption = "An error " + Str(Result%) + " occurred trying to find '" + Text_GLCode.Text + "'"
                Else
                    lblResult.Caption = "An error " + Str(Result%) + " occurred reading the " + ActStr$ + " record"
                End If
        End Select
    End If
End Sub

Private Sub Command2_Click(Index As Integer)
    Dim RecLen%, Result%

    lblResult.Caption = ""
    
    Select Case Index%
        Case 0  ' Add/Save
            If (Command2(0).Caption = Capt_Add) Then
                ' Add
                Editing = False
                Command2(0).Caption = Capt_Save
                Command2(1).Caption = Capt_Cancel

                OrigCode$ = Text_GLCode.Text

                ' Initialise records to default values
                Call NewGL

                ' display record
                Call DisplayGL
                
                Call EnableForAdd(True)

                Text_GLCode.SetFocus
            Else
                ' save

                ' read fields into record
                GLRec.NomCode = Val(Text_GLCode.Text)
                If (GLRec.NomCode > 0) And (Editing Or (Not GLExists(GLRec.NomCode))) Then
                    GLRec.Desc = Trim(Text_Name.Text)
                    If (Trim(GLRec.Desc) <> "") Then
                        GLRec.DescLen = Chr(Len(Trim(GLRec.Desc)))
                    
                        GLRec.Cat = Val(Text_Parent.Text)
                        Select Case List_Type.ListIndex
                            Case 0
                                GLRec.NomType = "A"
                            Case 1
                                GLRec.NomType = "B"
                            Case 2
                                GLRec.NomType = "C"
                            Case 3
                                GLRec.NomType = "F"
                            Case 4
                                GLRec.NomType = "H"
                        End Select
                        If (Chk_PageBrk.value > 0) Then
                            GLRec.NomPage = DllTrue%
                        Else
                            GLRec.NomPage = DllFalse%
                        End If
                        GLRec.SubType = DllFalse%
                        GLRec.Total = DllFalse%
                        GLRec.CarryF = Val(Text_CarryFwd.Text)
                        If (Chk_Revalue.value > 0) Then
                            GLRec.ReValue = DllTrue%
                        Else
                            GLRec.ReValue = DllFalse%
                        End If

                        ' update db
                        RecLen% = Len(GLRec)
                        If Editing Then
                            Result% = Ex_STOREGLACCOUNT(GLRec, RecLen%, 0, B_Update%)
                        Else
                            Result% = Ex_STOREGLACCOUNT(GLRec, RecLen%, 0, B_Insert%)
                        End If

                        If Result% <> 0 Then
                            lblResult.Caption = "An error " + Str(Result%) + " occurred when the GL Code was saved"
                        Else
                            ' Saved AOK
                            Command2(0).Caption = Capt_Add
                            Command2(1).Caption = Capt_Edit

                            Call EnableForAdd(False)
                        End If
                    Else
                        MsgBox "The Description cannot be left blank"
                        Text_Name.SetFocus
                    End If
                Else
                    MsgBox "The Nominal Code must be > 0, and cannot already exist in the system"
                    Text_GLCode.SetFocus
                End If
            End If

        Case 1  ' Edit/Cancel
            If (Command2(1).Caption = Capt_Edit) Then
                ' Important Note: This demo does not lock the record when editing
                ' a GL Code, this can cause problems in a multi-user situation.
                
                ' edit
                Editing = True
                Command2(0).Caption = Capt_Save
                Command2(1).Caption = Capt_Cancel

                OrigCode$ = Text_GLCode.Text

                Call EnableForAdd(True)

                Text_Name.SetFocus
            Else
                ' cancel
                Command2(0).Caption = Capt_Add
                Command2(1).Caption = Capt_Edit

                Text_GLCode.Text = OrigCode$
                Call Command1_Click(2)
            End If

    End Select

    Command1(0).Enabled = (Command2(0).Caption = Capt_Add)
    Command1(1).Enabled = Command1(0).Enabled
    Command1(2).Enabled = Command1(0).Enabled
    Command1(3).Enabled = Command1(0).Enabled
    Command1(4).Enabled = Command1(0).Enabled
End Sub

' Displays the global GLRec
Private Sub DisplayGL()
    Text_GLCode.Text = Trim(Str(GLRec.NomCode))
    Text_Name.Text = Trim(GLRec.Desc)
        
    If (GLRec.Cat > 0) Or Text_GLCode.Enabled Then
        ' non-root item or editing
        Text_Parent.Text = Trim(Str(GLRec.Cat))
        lblParentName.Caption = GLName(GLRec.Cat)
    Else
        ' Root Item
        Text_Parent.Text = "Root"
        lblParentName.Caption = ""
    End If

    Select Case GLRec.NomType
        Case "A"
            List_Type.ListIndex = 0
        Case "B"
            List_Type.ListIndex = 1
        Case "C"
            List_Type.ListIndex = 2
        Case "F"
            List_Type.ListIndex = 3
        Case "H"
            List_Type.ListIndex = 4
    End Select

    If (GLRec.NomType = "F") And ((GLRec.CarryF > 0) Or Text_CarryFwd.Enabled) Then
        ' Carry-Forward Code or Editing
        Text_CarryFwd.Text = Trim(Str(GLRec.CarryF))
        lblCarryFwdName.Caption = GLName(GLRec.CarryF)
    Else
        ' Not a Carry-Forward Code - leave blank
        Text_CarryFwd.Text = ""
        lblCarryFwdName.Caption = ""
    End If
        
    Chk_PageBrk.value = GLRec.NomPage
    Chk_Revalue.value = GLRec.ReValue
End Sub

Private Sub EnableForAdd(WantAdd%)
    Text_GLCode.Enabled = (WantAdd% And (Not Editing%)) Or (Not WantAdd%)
    Text_Name.Enabled = WantAdd%
    Text_Parent.Enabled = WantAdd% And (Not Editing%)
    List_Type.Enabled = WantAdd% And (Not Editing%)
    Text_CarryFwd.Enabled = WantAdd% And (Not Editing%)
    Chk_PageBrk.Enabled = WantAdd%
    Chk_Revalue.Enabled = WantAdd% And (Not Editing%)
                   
    ' Setup Buttons
    btnFindParent.Enabled = (Not WantAdd%) And (GLRec.Cat > 0)
    btnFindCarryFwd.Enabled = (Not WantAdd%) And (GLRec.NomType = "F")
End Sub

Private Sub Form_Load()
    ' Position window centrally on the screen
    Left = (Screen.Width - Width) / 2
    Top = (Screen.Height - Height) / 2
    
    ' Initialise the Toolkit DLL
    DLLLoaded% = EX_INITDLL()
    
    If DLLLoaded% <> 0 Then
        ' failed to startup correctly
        MsgBox "An error " + Str(DLLLoaded%) + " occurred when calling EX_INITDLL.", 16
    Else
        ' Load Type List
        List_Type.AddItem "A - Profit & Loss"
        List_Type.AddItem "B - Balance Sheet"
        List_Type.AddItem "C - Control"
        List_Type.AddItem "F - Carry Forward"
        List_Type.AddItem "H - Heading"
                               
        ' Get first GL Code
        Text_GLCode.Text = "10"
        Command1_Click (2)
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim Result%

    ' Check the DLL Loaded OK
    If DLLLoaded% = 0 Then
        ' De-Initialise the Toolkit DLL
        Result% = EX_CLOSEDLL()
        
        If Result% <> 0 Then
            ' An error has occurred
            MsgBox "An error " + Str(Result%) + " occurred when calling EX_CLOSEDLL.", 16
        End If
    End If
End Sub

' Returns the name of the specified Cost Centre, if the
' code is invalid then a blank string is returned
Private Function GetCCName(TheCC As String) As String
    Dim LocalCCRec As TBatchCCDepRec
    Dim PChar As String * 255
    Dim RecLen As Long
    Dim Result%
                   
    ' check for record
    RecLen = Len(LocalCCRec)
    PChar = Trim(TheCC$) + String$(255, 0)
    Result% = EX_GETCCDEP(LocalCCRec, RecLen, PChar$, 0, B_GetGEq%, 0, DllFalse%)
    
    If (Result% = 0) And (Trim(LocalCCRec.CCDepCode) = TheCC) Then
        GetCCName = Trim(LocalCCRec.CCDepDesc)
    Else
        GetCCName = ""
    End If
End Function

Private Function GetVatRate(RateCode$) As Double
    Dim VATInfo As TBatchVATRec
    Dim Res%, RecLen As Long

    VATInfo.VATCode = RateCode$
    VATInfo.VATRate = 0#

    RecLen = Len(VATInfo)
    Res% = EX_GETVATRATE(VATInfo, RecLen)

    If (Res% = 0) Then
        ' AOK
        GetVatRate# = Val(Format$(VATInfo.VATRate * 100, "0.00"))
    Else
        ' an error has occured
        GetVatRate# = 0#
        MsgBox "Error " + Str(Res%) + " occured retrieving the VAT Rate."
    End If
End Function

' Returns True if the specified GL Code already exists
Private Function GLExists(Code&) As Integer
    Dim LocalGLRec As TBatchNomRec
    Dim PChar As String * 255
    Dim RecLen As Long
    Dim OrigCodePos$, Result%

    ' save current record pos
    If Text_Name.Enabled Then
        ' Adding or Editing
        OrigCodePos$ = OrigCode$
    Else
        ' viewing
        OrigCodePos$ = Text_GLCode.Text
    End If

    ' check for record
    RecLen = Len(LocalGLRec)
    PChar = Trim(Str(Code&)) + String$(255, 0)
    Result% = EX_GETGLACCOUNT%(LocalGLRec, RecLen, PChar$, 0, B_GetGEq%, DllFalse%)
    GLExists = (Result% = 0) And (LocalGLRec.NomCode = Code&)
                                                        
    ' restore position in database
    PChar = OrigCodePos$ + String$(255, 0)
    Result% = EX_GETGLACCOUNT%(LocalGLRec, RecLen, PChar$, 0, B_GetGEq%, DllFalse%)
End Function

' Returns the description for the specified GL Code
Private Function GLName(Code&) As String
    Dim LocalGLRec As TBatchNomRec
    Dim PChar As String * 255
    Dim RecLen As Long
    Dim OrigCodePos$, Result%

    ' save current record pos
    If Text_Name.Enabled Then
        ' Adding or Editing
        OrigCodePos$ = OrigCode$
    Else
        ' viewing
        OrigCodePos$ = Text_GLCode.Text
    End If

    ' check for record
    RecLen = Len(LocalGLRec)
    PChar = Trim(Str(Code&)) + String$(255, 0)
    Result% = EX_GETGLACCOUNT%(LocalGLRec, RecLen, PChar$, 0, B_GetGEq%, DllFalse%)
    If (Result% = 0) And (LocalGLRec.NomCode = Code&) Then
        GLName$ = Trim(LocalGLRec.Desc)
    Else
        GLName$ = ""
    End If
                                                        
    ' restore position in database
    PChar = OrigCodePos$ + String$(255, 0)
    Result% = EX_GETGLACCOUNT%(LocalGLRec, RecLen, PChar$, 0, B_GetGEq%, DllFalse%)
End Function

Private Sub List_Type_Click()
    If List_Type.Enabled Then
        Text_CarryFwd.Enabled = List_Type.ListIndex = 3

        If Text_CarryFwd.Enabled Then
            Text_CarryFwd.Text = "0"
        Else
            Text_CarryFwd.Text = ""
        End If
        lblCarryFwdName.Caption = ""
    End If
End Sub

' Initialises the GL Code record when adding
Private Sub NewGL()
    GLRec.NomCode = 0
    GLRec.Desc = ""
    GLRec.DescLen = Chr(Len(Trim(GLRec.Desc)))
    GLRec.Cat = 0
    GLRec.NomType = "H"
    GLRec.NomPage = DllFalse%
    GLRec.SubType = DllFalse%
    GLRec.Total = DllFalse%
    GLRec.CarryF = 0
    GLRec.ReValue = DllFalse%
End Sub


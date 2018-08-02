VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form Form1 
   Caption         =   "COM TK Open/Close Hammer"
   ClientHeight    =   1800
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5160
   LinkTopic       =   "Form1"
   ScaleHeight     =   1800
   ScaleWidth      =   5160
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ListView lvLog 
      Height          =   1230
      Left            =   45
      TabIndex        =   3
      Top             =   465
      Width           =   5055
      _ExtentX        =   8916
      _ExtentY        =   2170
      View            =   3
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   2
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Text            =   "Time"
         Object.Width           =   2540
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   1
         Text            =   "Error Desc"
         Object.Width           =   14111
      EndProperty
   End
   Begin VB.CheckBox chkRunning 
      Alignment       =   1  'Right Justify
      Caption         =   "Run Tests"
      Height          =   375
      Left            =   2820
      TabIndex        =   2
      Top             =   30
      Width           =   1155
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   4080
      Top             =   -15
   End
   Begin VB.Label lblInProgr 
      Alignment       =   1  'Right Justify
      Caption         =   "*"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   4635
      TabIndex        =   4
      Top             =   90
      Visible         =   0   'False
      Width           =   345
   End
   Begin VB.Label lblIterations 
      Caption         =   "0"
      Height          =   255
      Left            =   1200
      TabIndex        =   1
      Top             =   120
      Width           =   1275
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Iterations"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   855
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim oToolkit As Enterprise01.Toolkit
Dim ItCount&, OrigWidthDiff&, OrigHeightDiff&

Private Sub chkRunning_Click()
    Timer1.Enabled = (chkRunning.Value > 0)
End Sub

Private Sub Form_Load()
    ItCount& = 0
    
    Set oToolkit = CreateObject("Enterprise01.Toolkit")
    
    OrigWidthDiff& = Me.Width - lvLog.Width
    OrigHeightDiff& = Me.Height - lvLog.Height
    
    AddError ("Loaded " + oToolkit.Version)
End Sub

Private Sub AddError(ErrDesc$)
    Dim lvItem As ListItem
    
    Set lvItem = lvLog.ListItems.Add(, , Format(Time, "HH:MM.ss"))
    lvItem.SubItems(1) = Trim(ErrDesc$)
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    chkRunning.Value = 0
End Sub

Private Sub Form_Resize()
    lvLog.Width = Me.Width - OrigWidthDiff&
    lvLog.Height = Me.Height - OrigHeightDiff&
End Sub

Private Sub Timer1_Timer()
    Dim DupeTK As Enterprise01.IToolkit2
    Dim FuncRes&
    
    ' Disable timer whilst processing to avoid events overlapping
    Timer1.Enabled = False
    lblInProgr.Visible = True
    lblInProgr.Refresh
    
    With oToolkit
        If (.Status = tkClosed) Then
            ' Open the Toolkit
            FuncRes& = .OpenToolkit
            If (FuncRes& = 0) Then
                ' Do something to simulate use
                With .Customer
                    .GetFirst
                End With ' .Customer
                With .Transaction
                    .GetFirst
                End With ' .Transaction
                
                If ((ItCount Mod 5) = 0) Then
                    Set DupeTK = CreateObject("Enterprise01.Toolkit")
                    FuncRes& = DupeTK.OpenToolkit
                    AddError ("Dupe OpenToolkit: " + Str(FuncRes&) + " - " + DupeTK.LastErrorString)
                    FuncRes& = DupeTK.CloseToolkit
                    AddError ("Dupe CloseToolkit: " + Str(FuncRes&) + " - " + DupeTK.LastErrorString)
                    Set DupeTK = Nothing
                End If ' (ItCount Mod 10) = 0
            Else
                AddError ("OpenToolkit: " + Str(FuncRes&) + " - " + .LastErrorString)
                chkRunning.Value = 0
                GoTo Finito
            End If ' FuncRes& = 0
        Else
            ' Close the Toolkit
            FuncRes& = .CloseToolkit
            If (FuncRes& <> 0) Then
                AddError ("CloseToolkit: " + Str(FuncRes&) + " - " + .LastErrorString)
                chkRunning.Value = 0
                GoTo Finito
            End If ' FuncRes& <> 0
        End If
    End With ' oToolkit
    
    ' Update Screen
    ItCount = ItCount + 1
    lblIterations.Caption = Format(ItCount&, "#,###,###,##0")
    
    ' Do some background processing to pick up close messages, etc...
    DoEvents
    
    ' Exit once 2,147,000,000 tests done
    If (ItCount >= 2147000000) Then Exit Sub
    
    ' Adjust interval randomly and re-enable the timer
    Timer1.Interval = 111 + Int(200 * Rnd)
    chkRunning_Click
    
Finito:
    lblInProgr.Visible = False
End Sub

VERSION 5.00
Begin VB.Form frmAccNotes 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Enterprise Customer Notes Demo"
   ClientHeight    =   3750
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8970
   Icon            =   "Notes.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3750
   ScaleWidth      =   8970
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton btnLoad 
      Caption         =   "&Load Notes"
      Height          =   315
      Left            =   2685
      TabIndex        =   3
      Top             =   660
      Width           =   1200
   End
   Begin VB.ListBox lstNotes 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2580
      ItemData        =   "Notes.frx":030A
      Left            =   75
      List            =   "Notes.frx":0311
      TabIndex        =   2
      Top             =   1050
      Width           =   8790
   End
   Begin VB.TextBox edtAcCode 
      Height          =   345
      Left            =   1155
      MaxLength       =   6
      TabIndex        =   1
      Text            =   "A1HI01"
      Top             =   645
      Width           =   1380
   End
   Begin VB.Label Label2 
      Caption         =   $"Notes.frx":031F
      Height          =   465
      Left            =   60
      TabIndex        =   4
      Top             =   45
      Width           =   8850
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "A/C Code"
      Height          =   270
      Left            =   120
      TabIndex        =   0
      Top             =   690
      Width           =   930
   End
End
Attribute VB_Name = "frmAccNotes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub btnLoad_Click()
    Dim NoteRec As TBatchNotesRec
    Dim SearchKey As String * 255
    Dim Res%, StructSize&
    
    ' build key for note lookup
    SearchKey$ = edtAcCode.Text + Chr(0)
    
    ' initialise note record
    StructSize& = Len(NoteRec)
    Res% = EX_INITNOTE(NoteRec, PSIZE&)
    If (Res% = 0) Then
        ' Setup note record to request general account notes
        With NoteRec
            .NoteSort = "ACC"
            .NoteSortLen = Chr(Len(Trim(.NoteSort)))
            .NoteType = 1
            .NoteCode = Trim(edtAcCode.Text)
            .NoteCodeLen = Chr(Len(Trim(.NoteCode)))
        End With
    
        ' get first note line for account
        Res% = EX_GETNOTES(NoteRec, Len(NoteRec), SearchKey$, 0, B_GetGEq%, DllFalse%)
    
        lstNotes.Clear
        If (Res% = 0) Then
            ' check a note was found for the specified account
            While (Res% = 0) And (Left(NoteRec.NoteCode, Asc(NoteRec.NoteCodeLen)) = edtAcCode.Text)
                lstNotes.AddItem Left(NoteRec.NoteLine, Asc(NoteRec.NoteLineLen))
            
                ' get next note line for account
                Res% = EX_GETNOTES(NoteRec, Len(NoteRec), SearchKey$, 0, B_GetNext%, DllFalse%)
            Wend
        Else
            ' check it didn't return 'No Notes' code before displaying error
            If (Res% <> 30002) Then
                MsgBox "EX_GETNOTES: " + Str(Res%)
            End If
        End If
    Else
        MsgBox "EX_INITNOTE: " + Str(Res%)
    End If
End Sub

Private Sub Form_Load()
    Dim Res%
    
    Res% = EX_INITDLL%()
    If (Res% <> 0) Then
        MsgBox "EX_INITDLL: " + Str(Res%)
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Dim Res%
    
    Res% = EX_CLOSEDLL%()
    If (Res% <> 0) Then
        MsgBox "EX_CLOSEDLL: " + Str(Res%)
    End If
End Sub

unit NoteLstF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ComObj, Enterprise01_TLB;

type
  TfrmNotesList = class(TForm)
    PageControl1: TPageControl;
    tabshDated: TTabSheet;
    tabshGeneral: TTabSheet;
    lvDatedNotes: TListView;
    lvGenNotes: TListView;
    Panel1: TPanel;
    btnClose: TButton;
    btnAdd: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
    FNotesI   : INotes;
    FToolkitI : IToolkit;

    procedure LoadNotes(Const NoteType : TNotesType; Const ListV : TListView);
  protected
    Procedure SetObjects (Const ToolkitI : IToolkit; Const NotesI : INotes);
  public
    { Public declarations }
  end;

Procedure DisplayNotes (Const SourceCaption : ShortString;
                        Const iToolkit      : IToolkit;
                        Const iNotes        : INotes);

implementation

{$R *.DFM}

Procedure DisplayNotes (Const SourceCaption : ShortString;
                        Const iToolkit      : IToolkit;
                        Const iNotes        : INotes);
Begin { DisplayNotes }
  With TfrmNotesList.Create (Application.MainForm) Do
    Try
      Caption := SourceCaption;
      SetObjects (iToolkit, iNotes);

      ShowModal;

    Finally
      Free;
    End;
End; { DisplayNotes }

{-------------------------------------------------------------------------------------------------}

procedure TfrmNotesList.FormCreate(Sender: TObject);
begin
  FNotesI := NIL;
  FToolkitI := NIL;
end;

{----------------------------------------}

procedure TfrmNotesList.FormDestroy(Sender: TObject);
begin
  FNotesI := NIL;
  FToolkitI := NIL;
end;

{----------------------------------------}

procedure TfrmNotesList.SetObjects (Const ToolkitI : IToolkit; Const NotesI : INotes);
begin
  FToolkitI := ToolkitI;
  FNotesI := NotesI;

  If Assigned(FToolkitI) And Assigned(FNotesI) Then Begin
    // Load Dated Notes
    LoadNotes (ntTypeDated, lvDatedNotes);
  End; { If Assigned(FNotesI) }
end;

{----------------------------------------}

procedure TfrmNotesList.LoadNotes(Const NoteType : TNotesType; Const ListV : TListView);
Var
  Res : LongInt;
Begin { LoadNotes }
  With FToolkitI, FNotesI, ListV Do Begin
    // Clear out any pre-existing note lines
    Items.Clear;

    ntType := NoteType;
    Res := GetFirst;
    While (Res = 0) Do Begin
      With Items.Add Do Begin
        If (NoteType = ntTypeDated) Then Begin
          // Dated
          Caption := Functions.entFormatDate(ntDate, 'S');
          SubItems.Add (ntText);
          SubItems.Add (ntOperator);
        End { If (NoteType = lvDatedNotes)  }
        Else Begin
          // General
          Caption := ntText;
          SubItems.Add (ntOperator);
        End; { Else }

        // encode line number in ListView for easier editing later
        Data := Pointer(ntLineNo);
      End; { With Items.Add }

      Res := GetNext;
    End; { While (Res = 0) }
  end; { With ListV }
End; { LoadNotes }

{----------------------------------------}

procedure TfrmNotesList.PageControl1Change(Sender: TObject);
begin
  If (PageControl1.ActivePage = tabshGeneral) Then Begin
    FNotesI.ntType := ntTypeGeneral;
    LoadNotes (ntTypeGeneral, lvGenNotes);
  End { If }
  Else
    If (PageControl1.ActivePage = tabshDated) Then Begin
      FNotesI.ntType := ntTypeDated;
      LoadNotes (ntTypeDated, lvDatedNotes);
    End; { If }
end;

{----------------------------------------}

procedure TfrmNotesList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

{----------------------------------------}

procedure TfrmNotesList.btnAddClick(Sender: TObject);
Var
  AddO : INotes;
  Res  : LongInt;
begin
  With FNotesI Do Begin
    // Get last note for user in current category to get the last used line number
    GetLast;

    AddO := Add;
    If Assigned(AddO) Then Begin
      AddO.ntLineNo := ntLineNo + 1;
      AddO.ntOperator := 'COMTK';
      AddO.ntText := 'wibble';

      Res := AddO.Save;
      If (Res <> 0) Then ShowMessage (IntToStr(Res));
    End; { If Assigned(AddO) }
  End; { With }
end;

end.

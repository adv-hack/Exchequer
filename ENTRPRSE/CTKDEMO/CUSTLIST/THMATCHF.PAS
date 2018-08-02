unit THMatchF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ComObj, Enterprise01_TLB;

type
  TfrmMatchingList = class(TForm)
    lvMatching: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FMatchingI : IMatching;
    FToolkitI  : IToolkit;

    procedure LoadMatching;
  public
    { Public declarations }
    Procedure SetObjects (Const ToolkitI : IToolkit; Const MatchingI : IMatching);
  end;

Procedure DisplayTHMatching (Const SourceCaption : ShortString;
                             Const iToolkit      : IToolkit;
                             Const iMatching     : IMatching);

implementation

{$R *.DFM}


Procedure DisplayTHMatching (Const SourceCaption : ShortString;
                             Const iToolkit      : IToolkit;
                             Const iMatching     : IMatching);
Begin { DisplayTHMatching }
  With TfrmMatchingList.Create (Application.MainForm) Do
    Try
      Caption := SourceCaption;
      SetObjects (iToolkit, iMatching);

      ShowModal;

    Finally
      Free;
    End;
End; { DisplayTHMatching }

{-------------------------------------------------------------------------------------------------}

procedure TfrmMatchingList.FormCreate(Sender: TObject);
begin
  FMatchingI := NIL;
  FToolkitI  := NIL;
end;

{----------------------------------------}

procedure TfrmMatchingList.FormDestroy(Sender: TObject);
begin
  FMatchingI := NIL;
  FToolkitI  := NIL;
end;

{----------------------------------------}

procedure TfrmMatchingList.SetObjects (Const ToolkitI : IToolkit; Const MatchingI : IMatching);
begin
  FToolkitI := ToolkitI;
  FMatchingI := MatchingI;

  If Assigned(FToolkitI) And Assigned(FMatchingI) Then Begin
    // Load Matching info
    LoadMatching;
  End; { If Assigned(FToolkitI) And Assigned(FMatchingI) }
end;

{----------------------------------------}

procedure TfrmMatchingList.LoadMatching;
Var
  Res : LongInt;
Begin { LoadMatching }
  With FToolkitI, FMatchingI, lvMatching Do Begin
    // Clear out any pre-existing matching information
    Items.Clear;

    Res := GetFirst;
    While (Res = 0) Do Begin
      With Items.Add Do Begin
        Caption := maDocRef;
        SubItems.Add (maPayRef);

        If (maType = maTypeSPOP) then
          SubItems.Add ('O')
        Else
          SubItems.Add ('A');

        SubItems.Add (Format('%8.2f', [maBaseValue]));
        SubItems.Add (Format('(%d) %8.2f', [maDocCurrency, maDocValue]));
        SubItems.Add (Format('(%d) %8.2f', [maPayCurrency, maPayValue]));
      End; { With Items.Add }

      Res := GetNext;
    End; { While (Res = 0) }
  end; { With ListV }
end; { LoadMatching }

{----------------------------------------}

end.

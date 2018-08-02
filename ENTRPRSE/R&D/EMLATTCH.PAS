unit EmlAttch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TCustom;

type
  TfrmEmailAttachs = class(TForm)       
    AttachList: TListBox;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    btnBrowse: TSBSButton;
    OpenDialog1: TOpenDialog;
    SBSButton1: TSBSButton;
    procedure FormCreate(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure SBSButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OK : Boolean;
    procedure BuildAttachList (AttachStr : String);
    Function GetAttachList : String;
  end;

implementation

{$R *.DFM}

Uses CompUtil;

Var
  BrowseDir : String;

procedure TfrmEmailAttachs.FormCreate(Sender: TObject);
begin
  OK := False;
end;

Function TfrmEmailAttachs.GetAttachList : String;
Var
  I : SmallInt;
Begin { GetAttachList }
  Result := '';

  If (AttachList.Items.Count > 0) Then
    For I := 0 To Pred(AttachList.Items.Count) Do
      If (I = 0) Then
        Result := AttachList.Items[I]
      Else
        Result := Result + '; ' + AttachList.Items[I];
End; { GetAttachList }

procedure TfrmEmailAttachs.BuildAttachList (AttachStr : String);
  Var
    ColPos           : Integer;
    AttPath, RecAddr : ShortString;
Begin { BuildAttachList }
  { Clear out any existing crap }
  AttachList.Clear;

  AttachStr := Trim(AttachStr);
  While (AttachStr <> '') Do Begin
    { look for end of attachment }
    ColPos := Pos (';', AttachStr);
    If (ColPos > 0) Then Begin
      { Extract name from recipients string }
      AttPath := Copy (AttachStr, 1, Pred(ColPos));
      If FileExists (AttPath) Then
        AttachList.Items.Add (AttPath);

      { Remove Crud }
      Delete (AttachStr, 1, ColPos);
      AttachStr := Trim(AttachStr);
    End { If (ColPos > 0) }
    Else Begin
      If FileExists (AttachStr) Then
        AttachList.Items.Add (AttachStr);
      Break;
    End; { Else }
  End; { While }
End; { BuildAttachList }

procedure TfrmEmailAttachs.btnBrowseClick(Sender: TObject);
begin
  With OpenDialog1 Do Begin
    InitialDir := BrowseDir;

    If Execute Then Begin
      { Convert to short filename }
      AttachList.Items.Add (PathToShort (FileName));

      BrowseDir := ExtractFilePath(FileName);
    End; { If }
  End; { With OpenDialog1 }
end;

procedure TfrmEmailAttachs.btnOKClick(Sender: TObject);
begin
  OK := True;
  Close;
end;

procedure TfrmEmailAttachs.btnCancelClick(Sender: TObject);
begin
  OK := False;
  Close;
end;

procedure TfrmEmailAttachs.SBSButton1Click(Sender: TObject);
begin
  If (AttachList.ItemIndex >= 0) Then
    AttachList.Items.Delete (AttachList.ItemIndex);
end;

Initialization
  BrowseDir := ExtractFilePath(Application.ExeName);
end.

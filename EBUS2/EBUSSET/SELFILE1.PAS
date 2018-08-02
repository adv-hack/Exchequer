unit Selfile;

{ prutherford440 09:49 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, eBusBtrv,
  StdCtrls, FileCtrl, ComCtrls, strUtil;

type
  TFrmSelectFile = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lvFiles: TListView;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvFilesDblClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    procedure FillFileList;
  public
    sDirectory : string;
    sExtension : string3;
  end;

var
  FrmSelectFile: TFrmSelectFile;

implementation

{$R *.DFM}

procedure TFrmSelectFile.FillFileList;
var
  SearchRec : TSearchRec;
  bContinue : boolean;
  NewItem : TListItem;
begin
  bContinue := (FindFirst(IncludeTrailingBackslash(sDirectory) + '*.' + sExtension, faAnyFile, SearchRec) = 0);
  while bContinue do begin
    with NewItem do begin
      NewItem := lvFiles.Items.Add;
      Caption := SearchRec.Name;
    end;{with}
    bContinue := (FindNext(SearchRec) = 0);
  end;{while}
  FindClose(SearchRec);

  if lvFiles.Items.Count > 9 then lvFiles.Columns[0].Width := 133 - 16;
  if lvFiles.Items.Count > 0 then lvFiles.Selected := lvFiles.Items[0]
  else btnOK.Enabled := FALSE;
end;

procedure TFrmSelectFile.FormShow(Sender: TObject);
begin
  FillFileList;
end;

procedure TFrmSelectFile.FormDestroy(Sender: TObject);
begin
  lvFiles.Items.Clear;
end;

procedure TFrmSelectFile.lvFilesDblClick(Sender: TObject);
begin
  if lvFiles.SelCount > 0 then
    ModalResult := mrOK;
end;

procedure TFrmSelectFile.btnOKClick(Sender: TObject);
begin
  if lvFiles.SelCount > 0 then
    ModalResult := mrOK
  else
    ModalResult := mrCancel;
end;

end.

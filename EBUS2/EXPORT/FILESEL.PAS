unit FileSel;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, eBusBtrv,
  StdCtrls, FileCtrl, ComCtrls, CSVUtils, eBusCnst;

type
  TMapFileInfo = Class
    MapFileRec : TMapFileRec;
  end;

  TFrmSelectMapFile = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lvFiles: TListView;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure FillFileList;
  public
    MapFileRec : TMapFileRec;
    ExportType : TExportType;
    sDirectory : string;
  end;

var
  FrmSelectMapFile: TFrmSelectMapFile;

implementation
uses
  ExpMan;

{$R *.DFM}

procedure TFrmSelectMapFile.FillFileList;
var
  SearchRec : TSearchRec;
  bContinue : boolean;
  NewItem : TListItem;
  MapFileRec : TMapFileRec;
  MapFileInfo : TMapFileInfo;
begin
  bContinue := (FindFirst(IncludeTrailingBackslash(sDirectory) + '*.MAP', faAnyFile, SearchRec) = 0);
  while bContinue do begin
    MapFileRec := GetMapFileRec(sDirectory + SearchRec.Name);
    if (MapFileRec.ExportType = ExportType) or (ExportType = etError) then begin
      with NewItem do begin
        NewItem := lvFiles.Items.Add;
        Caption := SearchRec.Name;
        MapFileInfo := TMapFileInfo.Create;
        MapFileInfo.MapFileRec := MapFileRec;
        Data := MapFileInfo;
        SubItems.Add(MapFileRec.Description);
      end;{with}
    end;{if}
    bContinue := (FindNext(SearchRec) = 0);
  end;{while}
  FindClose(SearchRec);

  if lvFiles.Items.Count > 9 then lvFiles.Columns[1].Width := 201;

  if lvFiles.Items.Count > 0 then lvFiles.Selected := lvFiles.Items[0]
  else btnOK.Enabled := FALSE;
end;

procedure TFrmSelectMapFile.FormShow(Sender: TObject);
begin
  FillFileList;
end;

procedure TFrmSelectMapFile.btnOKClick(Sender: TObject);
begin
  if lvFiles.SelCount > 0 then
  begin
    MapFileRec := TMapFileInfo(lvFiles.Selected.Data).MapFileRec;
    ModalResult := mrOK;
  end
  else
    ModalResult := mrCancel;
end;

procedure TFrmSelectMapFile.FormDestroy(Sender: TObject);
begin
  lvFiles.Items.Clear;
end;

end.

unit logview;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmCommslogViewer = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    cmbLogFile: TComboBox;
    lDate: TLabel;
    lTime: TLabel;
    memo1: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure cmbLogFileChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    sLogDir : shortstring;
  public
    { Public declarations }
  end;

var
  frmCommslogViewer: TfrmCommslogViewer;

implementation
uses
  FileCtrl, Commsint, VarConst;

{$R *.DFM}

procedure TfrmCommslogViewer.FormCreate(Sender: TObject);
var
  SearchRec : TSearchRec;
  bContinue : boolean;
begin
  {get / create commslog dir}
  sLogDir := sEXEDir + 'CommsLog\';
  if DirectoryExists(sLogDir) then begin
    bContinue := (FindFirst(sLogDir + '*.ZIP', faAnyFile, SearchRec) = 0);
    while bContinue do begin
      cmbLogFile.Items.Add(SearchRec.Name);
      bContinue := (FindNext(SearchRec) = 0);
    end;{while}
    FindClose(SearchRec);
  end;

  if cmbLogFile.Items.Count > 0 then begin
    cmbLogFile.ItemIndex := 0;
    cmbLogFileChange(nil);
  end;{if}
end;

procedure TfrmCommslogViewer.cmbLogFileChange(Sender: TObject);
var
  oUnzipper : TUnzipper;
begin
  screen.Cursor := crHourglass;
  try
    oUnzipper := TUnzipper.Create(sLogDir + cmbLogFile.Items[cmbLogFile.ItemIndex]);
    oUnzipper.ExtractFiles('commslog.txt',sLogDir);
    Memo1.Lines.LoadFromFile(sLogDir + 'commslog.txt');
    lDate.Caption := Memo1.Lines[1];
    lTime.Caption := Memo1.Lines[2];
    oUnzipper.Free;
  finally
    screen.Cursor := crDefault;
  end;{try}
end;

procedure TfrmCommslogViewer.FormDestroy(Sender: TObject);
begin
  DeleteFile(sLogDir + 'commslog.txt');
end;

end.

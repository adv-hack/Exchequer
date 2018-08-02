unit ResultF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Grids, DBGrids, ComCtrls, ExtCtrls, Menus;

type
  TfrmShowResult = class(TForm)
    DataSource1: TDataSource;
    dsADO: TADODataSet;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    tsDB: TTabSheet;
    tsRes: TTabSheet;
    DBGrid1: TDBGrid;
    memResults: TMemo;
    Panel1: TPanel;
    btnShow: TButton;
    Button1: TButton;
    Button2: TButton;
    procedure btnShowClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FirstTime : Boolean;
    function GetResultDir: string;
    procedure SetResultDir(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property ResultDir : string read GetResultDir write SetResultDir;
  end;

var
  frmShowResult: TfrmShowResult;

implementation

uses
  RowCompare, ShowTableDiff;

{$R *.dfm}

{ TfrmShowResult }

function TfrmShowResult.GetResultDir: string;
begin
  Result := OpenDialog1.InitialDir;
end;

procedure TfrmShowResult.SetResultDir(const Value: string);
begin
  OpenDialog1.InitialDir := Value;
  OpenDialog1.FileName := Value + '*.*';
end;

procedure TfrmShowResult.btnShowClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    if UpperCase(ExtractFileExt(OpenDialog1.Filename)) = '.XML' then
    begin
      dsAdo.LoadFromFile(OpenDialog1.Filename);
      PageControl1.ActivePage := tsDB;
    end
    else
    begin
      memResults.Lines.LoadFromFile(OpenDialog1.Filename);
      PageControl1.ActivePage := tsRes;
    end;
    Caption := 'Results - ' + OpenDialog1.Filename;
  end
  else
    if FirstTime then
      PostMessage(Handle, WM_CLOSE, 0, 0);

  FirstTime := False;
end;

procedure TfrmShowResult.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmShowResult.FormCreate(Sender: TObject);
begin
  FirstTime := True;
end;

procedure TfrmShowResult.FormShow(Sender: TObject);
begin
  btnShowClick(nil);
end;

procedure TfrmShowResult.Button2Click(Sender: TObject);
begin
  with TCompareRows.Create do
  Try
    DBGrid := DBGrid1;
    if not Execute then
      ShowTableDifferences(TableName, CompanyCode[1], CompanyCode[2], ResultList);
  Finally
    Free;
  End;
end;

end.

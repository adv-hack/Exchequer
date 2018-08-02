unit dbfform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, Halcn6db;

type
  TfrmDbf = class(TForm)
    CH1: TCreateHalcyonDataSet;
    Table1: THalcyonDataSet;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    IndexFileName : string;
  public
    { Public declarations }
    function CreateDbfTable(const AName : string; AList : TStringList) : Boolean;
    procedure CloseTable;
    procedure AddIndex(const FieldName : string; IsDescending : Boolean = False);
    procedure AddRecord(AList : TStringList);
  end;

var
  frmDbf: TfrmDbf;

implementation

{$R *.dfm}
uses
  DateUtils;

procedure TfrmDbf.Button1Click(Sender: TObject);
var
  T : TStringList;

begin
  T := TStringList.Create;

  T.Add('NAME;C;20;0');
  T.Add('DESCR;C;10;0');
  T.Add('LOG;L;1;0');
  T.Add('BORN;D;8;0');
  T.Add('AMOUNT;N;18;2');

  if CreateDBFTable('c:\test5.dbf', T) then
    ShowMessage('Table created successfully')
  else
    ShowMessage('Unable to create table');

  T.Clear;
  T.Add('Paul');
  T.Add('Programmer');
  T.Add('T');
  T.Add('19550809');
  T.Add('127.95');

  AddRecord(T);
  T.Clear;

  T.Add('Brian');
  T.Add('Aardvark');
  T.Add('F');
  T.Add('20020317');
  T.Add('5347.95');

  AddRecord(T);
  T.Clear;

  T.Add('Clementine');
  T.Add('Marketeer');
  T.Add('T');
  T.Add('19601020');
  T.Add('147586.02');

  AddRecord(T);
  T.Clear;

  T.Add('Brian');
  T.Add('Albatross');
  T.Add('T');
  T.Add('19770309');
  T.Add('1774.50');

  AddRecord(T);
  T.Clear;


  AddIndex('Name');
  AddIndex('Descr');
  AddIndex('Born');
  AddIndex('Amount');

  CloseTable;

end;

function TfrmDbf.CreateDbfTable(const AName : string; AList : TStringList) : Boolean;
begin
  Table1.TableName := AName;
  IndexFileName := ChangeFileExt(ExtractFileName(AName), '.mdx');
  Ch1.DBFTable := Table1;
  Ch1.CreateFields := AList;
  Result := Ch1.Execute;
  Table1.Open;
end;


procedure TfrmDbf.CloseTable;
begin
  Table1.Close;
end;

procedure TfrmDbf.AddIndex(const FieldName : string; IsDescending : Boolean = False);
var
  ADirection : tgsSortStatus;
begin
  if IsDescending then
    ADirection := Descending
  else
    ADirection := Ascending;

  Table1.IndexOn(IndexFileName, FieldName, FieldName, '', Duplicates, ADirection);
end;

procedure TfrmDbf.AddRecord(AList : TStringList);
var
  i : integer;
begin
  Table1.Append;
  for i := 0 to AList.Count - 1 do
    Table1.FieldPutN(i + 1, AList[i]);
  Table1.Post;
end;




end.

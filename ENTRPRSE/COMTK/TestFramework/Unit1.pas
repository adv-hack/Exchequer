unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SQLCallerU, StdCtrls, DB, Grids, DBGrids, CompareIntf;

type
  TForm1 = class(TForm)
    Button2: TButton;
    cbTestDb: TComboBox;
    cbTestCo: TComboBox;
    cbRefDb: TComboBox;
    cbRefCo: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    Button1: TButton;
    edtResultsFolder: TEdit;
    Label5: TLabel;
    lblProgress: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbTestDbChange(Sender: TObject);
    procedure cbRefDbChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    SQLCaller : TSQLCaller;
    oCompare : ICompareTables;
    oCompareDB : ICompareDatabases;
    procedure LoadSQLDataBaseLists;
    procedure LoadSQLCompanyList(const AList : TComboBox; const sDb : string);
    procedure DoProgress(const sMessage : string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  SQLUtils, CompareSQLU, CompareSQLDb, FrameworkUtils;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if Assigned(SQLCaller) then
    SQLCaller.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  oCompare := GetCompareSQLTables;

  if Assigned(oCompare) then
  Try
    oCompare.ctPath1 := 'Ent67SQL2.ZZZZ01';
    oCompare.ctPath2 := 'Ent67SQL3.MAIN01';
    oCompare.ctTable := 'CustomerDiscount';
    oCompare.ctResultFile := 'c:\compare.xml';
    if oCompare.Execute then
    begin
      ShowMessage('Done');

    end
    else
      ShowMessage('Error');
  Finally
    oCompare := nil;
  End;
end;

procedure TForm1.LoadSQLDataBaseLists;
var
  sQuery : AnsiString;
begin
  sQuery := 'SELECT * FROM master.dbo.sysdatabases WHERE dbid > 6';
  SQLCaller.Select(sQuery);
  Try
    SQLCaller.Records.First;

    while not SQLCaller.Records.EOF do
    begin
      cbTestDb.Items.Add(SQLCaller.Records.FieldByName('name').AsString);
      cbRefDb.Items.Add(SQLCaller.Records.FieldByName('name').AsString);

      SQLCaller.Records.Next;
    end;
    cbTestDb.ItemIndex := 0;
    cbRefDb.ItemIndex := 0;
  Finally
    SQLCaller.Records.Close;
    cbRefDbChange(nil);
    cbTestDbChange(nil);
  End;
end;

procedure TForm1.LoadSQLCompanyList(const AList : TComboBox; const sDb : string);
var
  sQuery : AnsiString;
begin
  sQuery := 'Select DISTINCT TABLE_SCHEMA FROM ' + sDb + '.INFORMATION_SCHEMA.TABLES';
  sQuery := sQuery + ' WHERE TABLE_SCHEMA <> ''common''';

  SQLCaller.Select(sQuery);
  Try
    AList.Items.Clear;
    SQLCaller.Records.First;

    while not SQLCaller.Records.EOF do
    begin
      AList.Items.Add(SQLCaller.Records.FieldByName('TABLE_SCHEMA').AsString);

      SQLCaller.Records.Next;
    end;
    AList.ItemIndex := 0;
  Finally
    SQLCaller.Records.Close;
  End;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SQLCaller := TSQLCaller.Create;
  SetupSQLConnection(SQLCaller.Connection);
  LoadSQLDatabaseLists;
end;

procedure TForm1.cbTestDbChange(Sender: TObject);
begin
  LoadSQLCompanyList(cbTestCo,cbTestDb.Items[cbTestDb.ItemIndex]);
end;

procedure TForm1.cbRefDbChange(Sender: TObject);
begin
  LoadSQLCompanyList(cbRefCo,cbRefDb.Items[cbTestDb.ItemIndex]);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  oCompareDB := GetCompareSQLDatabases;
  oCompareDB.cdPath1 := cbTestDb.Items[cbTestDb.ItemIndex] + '.' +
                        cbTestCo.Items[cbTestCo.ItemIndex];

  oCompareDB.cdPath2 := cbRefDb.Items[cbRefDb.ItemIndex] + '.' +
                        cbRefCo.Items[cbRefCo.ItemIndex];

  oCompareDB.cdResultsFolder := edtResultsFolder.Text;
  oCompareDB.cdTestName := 'FirstTest';
  oCompareDB.OnProgress := DoProgress;

  if oCompareDB.Execute then
    ShowMessage('No differences found')
  else
    ShowMessage('There were differences');
end;

procedure TForm1.DoProgress(const sMessage: string);
begin
  lblProgress.Caption := sMessage;
  lblProgress.Refresh;
  Application.ProcessMessages;
end;

end.

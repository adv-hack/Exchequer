unit compareF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SQLCallerU, CompareIntf, CompareSQLU, FrameworkUtils, StdCtrls, CheckLst, ResultF;

const
  ExcludedTables : Array[1..3] of string = ('IRISDATASETCONNECTION', 'IRISXMLSCHEMA', 'SCHEMAVERSION');
  ImageTables : Array[1..6] of string = ('FAXES', 'SENTSYS', 'TILLNAME', 'REPORTS', 'SENTLINE', 'SETTINGS');

type
  TForm1 = class(TForm)
    Label3: TLabel;
    Label4: TLabel;
    cbTestCo: TComboBox;
    cbTestDb: TComboBox;
    cbRefDb: TComboBox;
    cbRefCo: TComboBox;
    lbTables: TCheckListBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    edtResultsFolder: TEdit;
    Label5: TLabel;
    lblProgress: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbTestDbChange(Sender: TObject);
    procedure cbRefDbChange(Sender: TObject);
    procedure cbTestCoChange(Sender: TObject);
    procedure lbTablesClickCheck(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    SQLCaller : TSQLCaller;
    oCompare : ICompareTables;
    oCompareDB : ICompareDatabases;
    DB1, DB2 : String;
    sCompany : string;
    procedure LoadSQLDataBaseLists;
    procedure LoadSQLCompanyList(const AList : TComboBox; const sDb : string);
    procedure LoadSQLTableNames;
    procedure SetAllChecks(Check : Boolean);
    function CompareDatabases(const TestName : string) : Boolean;
    procedure DoProgress(const s : string);
    function ExcludeCommonTable(const sName : string) : Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  SQLCaller := TSQLCaller.Create;
  SetupSQLConnection(SQLCaller.Connection);
  LoadSQLDatabaseLists;
  cbTestCoChange(nil);
end;

procedure TForm1.LoadSQLCompanyList(const AList: TComboBox;
  const sDb: string);
var
  sQuery : AnsiString;
begin
  sQuery := 'Select DISTINCT TABLE_SCHEMA FROM ' + sDb + '.INFORMATION_SCHEMA.TABLES';
//  sQuery := sQuery + ' WHERE TABLE_SCHEMA <> ''common''';

  SQLCaller.Select(sQuery);
  Try
    AList.Items.Clear;
//    AList.Items.Add('common');
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

procedure TForm1.LoadSQLTableNames;
var
  sDb, sName : string;
  i : Integer;
  sQuery : AnsiString;
begin
  sDb := DB1;

  sQuery := 'Select DISTINCT TABLE_SCHEMA, TABLE_NAME FROM ' +
            sDb + '.INFORMATION_SCHEMA.TABLES ' +
            'Where TABLE_TYPE = ''BASE TABLE''';

  SQLCaller.Select(sQuery);
  Try
    lbTables.Items.Clear;
    lbTables.Items.Add('< All >');
    SQLCaller.Records.First;

    while not SQLCaller.Records.EOF do
    begin
      sName := SQLCaller.Records.FieldByName('TABLE_NAME').AsString;
      if not ExcludeCommonTable(sName) and
        ((sCompany <> 'common') xor (SQLCaller.Records.FieldByName('TABLE_SCHEMA').AsString = 'common')) then
          lbTables.Items.Add(sName);

      SQLCaller.Records.Next;
    end;
  Finally
    SQLCaller.Records.Close;
  End;
end;

procedure TForm1.cbTestDbChange(Sender: TObject);
begin
  Db1 := cbTestDB.Items[cbTestDB.ItemIndex];
  LoadSQLCompanyList(cbTestCo, Db1);
end;

procedure TForm1.cbRefDbChange(Sender: TObject);
begin
  Db2 := cbRefDB.Items[cbRefDB.ItemIndex];
  LoadSQLCompanyList(cbRefCo, Db2);
end;

procedure TForm1.cbTestCoChange(Sender: TObject);
begin
  sCompany := cbTestCo.Items[cbTestCo.ItemIndex];
  LoadSQLTableNames;
end;

procedure TForm1.lbTablesClickCheck(Sender: TObject);
begin
  if lbTables.ItemIndex = 0 then
  begin
    SetAllChecks(lbTables.Checked[0]);
  end;
end;

procedure TForm1.SetAllChecks(Check: Boolean);
var
  i : integer;
begin
  if Check then
    lbTables.Items[0] := '< None >'
  else
    lbTables.Items[0] := '< All >';
  for i := 1 to lbTables.Items.Count - 1 do
    lbTables.Checked[i] := Check;
end;

function TForm1.CompareDatabases(const TestName: string): Boolean;
var
  Path1, Path2 : string;
  i : integer;
  FTableList : TStringList;
  FResultsFolder : string;
begin
  Result := True;
  FTableList := TStringList.Create;

  for i := 1 to lbTables.Count - 1 do
    if (lbTables.Checked[i]) then
      FTableList.Add(lbTables.Items[i]);

  Path1 := cbTestDb.Items[cbTestDb.ItemIndex] + '.' +
                        cbTestCo.Items[cbTestCo.ItemIndex];

  Path2 := cbRefDb.Items[cbRefDb.ItemIndex] + '.' +
                        cbTestCo.Items[cbTestCo.ItemIndex];

  FResultsFolder := IncludeTrailingBackslash(edtResultsFolder.Text);

  oCompare := GetCompareSQLTables;
  Try
    oCompare.ctPath1 := Path1;
    oCompare.ctPath2 := Path2;
    for i := 0 to FTableList.Count - 1 do
    begin
      DoProgress('Comparing ' + IntToStr(i) + ': ' + FTableList[i]);
      oCompare.ctTable := FTableList[i];
      oCompare.ctResultFile := FResultsFolder + TestName + '_' + FTableList[i] + '.xml';
      Try
     {$B+}
        Result := Result and oCompare.Execute;
     {$B-}
      Except
        on E:Exception do
        begin
          ShowMessage('Exception at ' + FTableList[i] + '. ' + E.Message);
//          raise;
        end;
      End;
    end;
  Finally
    if Result then
      DoProgress('Done. No differences were found')
    else
      DoProgress('Done. There were differences');
    oCompare := nil;
    FTableList.Free;
  End;
end;

procedure TForm1.DoProgress(const s: string);
begin
  lblProgress.Caption := s;
  lblProgress.Refresh;
  Application.ProcessMessages;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if CompareDatabases('Test') then
    ShowMessage('Done. No differences were found')
  else
  with TfrmShowResult.Create(nil) do
  Try
    ResultDir := IncludeTrailingBackslash(edtResultsFolder.Text);
    ShowModal;
  Finally
    Free;
  End;

end;

function TForm1.ExcludeCommonTable(const sName: string): Boolean;
var
  i : integer;
begin
  Result := False;
  for i := Low(ExcludedTables) to High(ExcludedTables) do
  begin
    if UpperCase(sName) = ExcludedTables[i] then
    begin
      Result := True;
      Break;
    end;
  end;

  if not Result then
  begin
    for i := Low(ImageTables) to High(ImageTables) do
    begin
      if UpperCase(sName) = ImageTables[i] then
      begin
        Result := True;
        Break;
      end;
    end;
  end;

end;

end.

unit CompareSQLU;

interface

uses
  CompareIntf;

function GetCompareSQLTables : ICompareTables;


implementation

uses
  SysUtils, CompareIniFile, Classes, SQLCallerU, SQLUtils, StrUtils, ADOdb, FrameworkUtils;



{ TTableCompare }
type
  TTableCompare = Class(TInterfacedObject, ICompareTables)
  private
    FPath1 : string;
    FPath2 : string;
    FTableName : string;
    FResultFileName : string;

    FCaller : TSQLCaller;
    FCompareIniFile : TCompareIniFile;

    FFieldList : TStringList;

    function Get_ctPath1 : string;
    procedure Set_ctPath1(const Value : string);

    function Get_ctPath2 : string;
    procedure Set_ctPath2(const Value : string);

    function Get_ctTable : string;
    procedure Set_ctTable(const Value : string);

    function Get_ctResultFile : string;
    procedure Set_ctResultFile(const Value : string);

    function ReadIniFile : Boolean;
    function BuildQuery : string;
    procedure SetupConnection;
    function FullPath(WhichPath : Byte) : string;
    function FieldList(const Prefix : string) : string;
    function GetDataBaseName : string;

    procedure LoadFieldList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SaveResultFile;

    function Execute : Boolean;

    property ctPath1 : string read Get_ctPath1 write Set_ctPath1;
    property ctPath2 : string read Get_ctPath2 write Set_ctPath2;
    property ctTable : string read Get_ctTable write Set_ctTable;
    property ctResultFile : string read Get_ctResultFile write Set_ctResultFile;

  end;

function GetCompareSQLTables : ICompareTables;
begin
  Result := TTableCompare.Create as ICompareTables;
end;


function TTableCompare.BuildQuery: string;
begin
  Result :=          'SELECT MIN(TableName) as TableName, ' + FieldList('');
  Result := Result + ' FROM ( ';
  Result := Result + 'SELECT ' + QuotedStr(FullPath(1)) + ' as TableName, ';
  Result := Result + FieldList('A');
  Result := Result + ' FROM ' + FullPath(1) + ' A ';
  Result := Result + ' UNION ALL';
  Result := Result + ' SELECT ' + QuotedStr(FullPath(2)) + ' as TableName, ';
  Result := Result + FieldList('B');
  Result := Result + ' FROM ' + FullPath(2) + ' B ';
  Result := Result + ' ) tmp';
  Result := Result + ' GROUP BY ' + FieldList('');
  Result := Result + ' HAVING COUNT(*) = 1';
  Result := Result + ' ORDER BY ' + FieldList('');
end;

constructor TTableCompare.Create;
begin
  inherited;
  FCaller := TSQLCaller.Create;
  FFieldList := TStringList.Create;
  FCompareIniFile := TCompareIniFile.Create;
  SetupConnection;
end;

destructor TTableCompare.Destroy;
begin
  if Assigned(FCaller) then
    FCaller.Free;
  if Assigned(FFieldList) then
    FFieldList.Free;
  if Assigned(FCompareIniFile) then
    FCompareIniFile.Free;
  inherited;
end;

function TTableCompare.Execute: Boolean;
var
  sQuery : AnsiString;
begin
  Result := True;

  ReadIniFile;
  LoadFieldList;

  sQuery := BuildQuery;

  Try
    FCaller.Select(sQuery);
    if Trim(FCaller.ErrorMsg) <> '' then
    begin
      with TStringList.Create do
      Try
        Add(sQuery);
        SaveToFile(ExtractFilePath(FResultFileName) + 'Query.txt');
      Finally
        Free;
      End;
      raise Exception.Create('Error in Select: ' + QuotedStr(FCaller.ErrorMsg));
    end;
    if FCaller.Records.RecordCount > 0 then
    begin
      Result := False;
      SaveResultFile;
      with TStringList.Create do
      Try
        Text := sQuery;
        SaveToFile(ExtractFilePath(FResultFileName) + FTableName + '.sql');
      Finally
        Free;
      End;
    end;
  Finally
    FCaller.Records.Close;
  End;

end;

function TTableCompare.FieldList(const Prefix: string): string;
begin
  Result := FFieldList.CommaText;
  if Prefix <> '' then
    Result := Prefix + '.' + AnsiReplaceStr(Result, ',', ',' + Prefix + '.');
end;

function TTableCompare.FullPath(WhichPath: Byte): string;
begin
  if WhichPath = 1 then
    Result := FPath1 + '.' + FTableName
  else
    Result := FPath2 + '.' + FTableName;
end;

function TTableCompare.GetDataBaseName: string;
var
  i : Integer;
begin
  i := Pos('.', FPath1);
  Result := Copy(FPath1, 1, i);
end;

function TTableCompare.Get_ctPath1: string;
begin
  Result := FPath1;
end;

function TTableCompare.Get_ctPath2: string;
begin
  Result := FPath2;
end;

function TTableCompare.Get_ctResultFile: string;
begin
  Result := FResultFilename;
end;

function TTableCompare.Get_ctTable: string;
begin
  Result := FTableName;
end;

procedure TTableCompare.LoadFieldList;
var
  sQuery : AnsiString;
  s : string;
begin
  FFieldList.Clear;
  sQuery := 'SELECT DISTINCT COLUMN_NAME, ORDINAL_POSITION FROM ' + GetDataBaseName +
            'INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ' + QuotedStr(FTableName) +
            ' ORDER BY ORDINAL_POSITION';
  FCaller.Select(sQuery);
  Try
    FCaller.Records.First;
    while not FCaller.Records.EOF do
    begin
      s := FCaller.Records.FieldByName('COLUMN_NAME').Value;
      if not FCompareIniFile.Ignore(s) then
        FFieldList.Add(s);

      FCaller.Records.Next;
    end;
  Finally
    FCaller.Records.Close;
  End;
end;

function TTableCompare.ReadIniFile : Boolean;
begin
  FCompareIniFile.TableName := FTableName;
  Result := FCompareIniFile.Read;
end;

procedure TTableCompare.SaveResultFile;
begin
  FCaller.Records.SaveToFile(FResultFileName, pfXML);
end;

procedure TTableCompare.SetupConnection;
begin
  SetupSQLConnection(FCaller.Connection);
end;

procedure TTableCompare.Set_ctPath1(const Value: string);
begin
  FPath1 := Value;
end;

procedure TTableCompare.Set_ctPath2(const Value: string);
begin
  FPath2 := Value;
end;

procedure TTableCompare.Set_ctResultFile(const Value: string);
begin
  FResultFilename := Value;
end;

procedure TTableCompare.Set_ctTable(const Value: string);
begin
  FTableName := Value;
end;

end.

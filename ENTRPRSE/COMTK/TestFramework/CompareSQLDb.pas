unit CompareSQLDb;

interface

uses
  CompareIntf;

function GetCompareSQLDatabases : ICompareDatabases;


implementation

uses
  SysUtils, Classes, CompareSQLU, SQLCallerU, FrameworkUtils, Dialogs;

type

  TCompareSQLDatabases = Class(TInterfacedObject, ICompareDatabases)
  private
    FPath1 : string;
    FPath2 : string;

    FTestName : string;
    FResultsFolder : string;

    FCaller : TSQLCaller;

    FTableList : TStringList;
    FOnProgress : TProgressProc;

    FExcludeList : TStringList;


    procedure LoadTableNames;
    procedure LoadExcludeList;
    procedure DoProgress(const sMessage : string);

    function Get_cdPath1 : string;
    procedure Set_cdPath1(const Value : string);
    property cdPath1 : string read Get_cdPath1 write Set_cdPath1;

    function Get_cdPath2 : string;
    procedure Set_cdPath2(const Value : string);
    property cdPath2 : string read Get_cdPath2 write Set_cdPath2;

    function Get_cdTestName : string;
    procedure Set_cdTestName(const Value : string);
    property cdTestName : string read Get_cdTestName write Set_cdTestName;

    function Get_cdResultsFolder : string;
    procedure Set_cdResultsFolder(const Value : string);
    property cdResultsFolder : string read Get_cdResultsFolder write Set_cdResultsFolder;

    function Get_OnProgress : TProgressProc;
    procedure Set_OnProgress(const Value : TProgressProc);
    property OnProgress : TProgressProc read Get_OnProgress write Set_OnProgress;

    function Execute : Boolean;
  public
    constructor Create;
    destructor Destroy; override;

  end;

function GetCompareSQLDatabases : ICompareDatabases;
begin
  Result := TCompareSQLDatabases.Create as ICompareDatabases;
end;


{ TCompareSQLDatabases }

constructor TCompareSQLDatabases.Create;
begin
  inherited;
  FCaller := TSQLCaller.Create;
  SetupSQLConnection(FCaller.Connection);
  FTableList := TStringList.Create;
  FExcludeList := TStringList.Create;
  LoadExcludeList;
end;

destructor TCompareSQLDatabases.Destroy;
begin
  if Assigned(FCaller) then
    FCaller.Free;
  if Assigned(FTableList) then
    FTableList.Free;
  if Assigned(FExcludeList) then
    FExcludeList.Free;
  inherited;
end;

procedure TCompareSQLDatabases.DoProgress(const sMessage: string);
begin
  if Assigned(FOnProgress) then
    FOnProgress(sMessage);
end;

function TCompareSQLDatabases.Execute: Boolean;
var
  oCompare : ICompareTables;
  i : integer;
begin
  Result := True;
  LoadTableNames;
  oCompare := GetCompareSQLTables;
  Try
    oCompare.ctPath1 := FPath1;
    oCompare.ctPath2 := FPath2;
    for i := 0 to FTableList.Count - 1 do
    begin
      DoProgress('Comparing ' + IntToStr(i) + ': ' + FTableList[i]);
      oCompare.ctTable := FTableList[i];
      oCompare.ctResultFile := FResultsFolder + FTestName + '_' + FTableList[i] + '.xml';
      Try
     {$B+}
        Result := Result and oCompare.Execute;
     {$B-}
      Except
        on E:Exception do
        begin
          ShowMessage('Exception at ' + FTableList[i] + '. ' + E.Message);
          raise;
        end;
      End;
    end;
  Finally
    if Result then
      DoProgress('Done. No differences were found')
    else
      DoProgress('Done. There were differences');
    oCompare := nil;
  End;
end;

function TCompareSQLDatabases.Get_cdPath1: string;
begin
  Result := FPath1;
end;

function TCompareSQLDatabases.Get_cdPath2: string;
begin
  Result := FPath2;
end;

function TCompareSQLDatabases.Get_cdResultsFolder: string;
begin
  Result := FResultsFolder;
end;

function TCompareSQLDatabases.Get_cdTestName: string;
begin
  Result := FTestName;
end;

function TCompareSQLDatabases.Get_OnProgress: TProgressProc;
begin
  Result := FOnProgress;
end;

procedure TCompareSQLDatabases.LoadExcludeList;
begin
  //Tables we don't need to compare
  FExcludeList.Add('SENT');
  FExcludeList.Add('SENTLINE');
  FExcludeList.Add('EBUS');
  FExcludeList.Add('EBUSDOC');
  FExcludeList.Add('EBUSDETL');
  FExcludeList.Add('EBUSLKUP');
  FExcludeList.Add('EBUSNOTE');
  FExcludeList.Add('SETTINGS');
  FExcludeList.Add('COLSET');
  FExcludeList.Add('PARSET');
  FExcludeList.Add('WINSET');
  FExcludeList.Add('LBIN');
  FExcludeList.Add('LHEADER');
  FExcludeList.Add('LLINES');
  FExcludeList.Add('LSERIAL');
  FExcludeList.Add('PAPRSIZE');
  FExcludeList.Add('SCHEMAVERSION');
  FExcludeList.Add('SCHEDULE');
  FExcludeList.Add('SORTVIEW');
  FExcludeList.Add('SVUSERDEF');
  FExcludeList.Add('VRWSEC');
  FExcludeList.Add('VRWTREE');
  FExcludeList.Add('VRWSEC');
  FExcludeList.Add('ALLOCWIZARDSESSION');
  FExcludeList.Add('EXCHQSS');
end;

procedure TCompareSQLDatabases.LoadTableNames;
var
  sDb, sName : string;
  i : Integer;
  sQuery : AnsiString;
begin
  i := Pos('.', FPath1);
  sDb := Copy(FPath1, 1, i);

  sQuery := 'Select DISTINCT TABLE_NAME FROM ' +
            sDb + 'INFORMATION_SCHEMA.TABLES ' +
            'Where TABLE_SCHEMA <> ''common'' and TABLE_TYPE = ''BASE TABLE''';

  FCaller.Select(sQuery);
  Try
    FCaller.Records.First;

    while not FCaller.Records.EOF do
    begin
      sName := FCaller.Records.FieldByName('TABLE_NAME').AsString;

      //Do we want it?
      if FExcludeList.IndexOf(UpperCase(Trim(sName))) = -1 then
        FTableList.Add(sName);

      FCaller.Records.Next;
    end;
  Finally
    FCaller.Records.Close;
  End;
end;

procedure TCompareSQLDatabases.Set_cdPath1(const Value: string);
begin
  FPath1 := Value;
end;

procedure TCompareSQLDatabases.Set_cdPath2(const Value: string);
begin
  FPath2 := Value;
end;

procedure TCompareSQLDatabases.Set_cdResultsFolder(const Value: string);
begin
  FResultsFolder := Value;
end;

procedure TCompareSQLDatabases.Set_cdTestName(const Value: string);
begin
  FTestName := Value;
end;

procedure TCompareSQLDatabases.Set_OnProgress(const Value: TProgressProc);
begin
  FOnProgress := Value;
end;

end.

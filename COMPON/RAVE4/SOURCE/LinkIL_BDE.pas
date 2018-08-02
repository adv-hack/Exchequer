unit LinkIL_BDE;

interface

uses
  Classes,
  Db, DBTables,
  LinkIL;

type
  TILLink_BDE = class(TILLink)
  protected
    FSession: TSession;
    FDatabase: TDatabase;
  public
    procedure DoClose; override;
    procedure DoOpen; override;
    function ExecSQL(const ASQL: string; const ARows: integer): integer; override;
    procedure FillTableList(ATableList: TStrings); override;
    function Generator(const AName: string; const ACount: integer = 1): integer; override;
    procedure GetTableList(ATableList: TStrings); override;
    function Query(const ASQL: string; const AOpen: Boolean = True;
     const AParams: TStrings = nil): TDataset; override;
    procedure TransBegin; override;
    procedure TransEnd; override;
    procedure TransRollback; override;
  end;

implementation

uses
  ILRegister, ILConfig_BDE,
  SysUtils, SyncObjs,
  Windows;

var
  ConnectNum: integer = 0;
  CS: TCriticalSection;

{ TILLink_BDE }

procedure TILLink_BDE.DoClose;
begin
  FreeAndNil(FDatabase);
  FreeAndNil(FSession);
end;

procedure TILLink_BDE.DoOpen;
var
  LParams: TStringList;
  s: string;
begin
  FSession := TSession.Create(Self);
  FSession.AutoSessionName := True;
  FDatabase := TDatabase.Create(Self);
  with FDatabase do begin
    LoginPrompt := False;
    CS.Enter;
    try
      Inc(ConnectNum);
      DatabaseName := 'Database' + IntToStr(ConnectNum);
    finally
      CS.Leave;
    end; { tryf }
    LParams := TStringList.Create; try
      LParams.CommaText := Datasource;
      s := LParams.Values['Alias'];
      if length(s) > 0 then begin
        AliasName := s;
        LParams.Values['Alias'] := '';
      end else begin
        DriverName := LParams.Values['Driver'];
        LParams.Values['Driver'] := '';
        Params.Assign(LParams);
      end;
    finally FreeAndNil(LParams); end;
    Params.Values['User Name'] := Username;
    Params.Values['Password'] := Password;
    SessionName := FSession.SessionName;
    Connected := True;
  end;
end;

function TILLink_BDE.ExecSQL(const ASQL: string; const ARows: integer): integer;
begin
  with TQuery(Query(ASQL, False)) do try
    ExecSQL;
    result := RowsAffected;
    if (ARows <> -1) and (result <> ARows) then begin
    	raise Exception.Create('Row count mismatch.');
    end;
  finally free; end;
end;

procedure TILLink_BDE.FillTableList(ATableList: TStrings);
begin
  FSession.GetTableNames(FDatabase.DatabaseName, '', false, false, ATableList);
end;

function TILLink_BDE.Generator(const AName: string; const ACount: integer): integer;
begin
  with Query('Select Gen_ID(' + AName + ', ' + IntToStr(ACount) + ') from Dual') do try
    Result := Fields[0].AsInteger;
  finally free; end;
end;


procedure TILLink_BDE.GetTableList(ATableList: TStrings);
begin
  FillTableList(ATableList);
  CheckTableNames(ATableList);
end;

function TILLink_BDE.Query(const ASQL: string; const AOpen: Boolean = true;
 const AParams: TStrings = nil): TDataset;
begin
  result := TQuery.Create(nil);
  with TQuery(result) do begin
    DatabaseName := FDatabase.DatabaseName;
    SessionName := FDatabase.SessionName;
    SQL.Text := ParamSQL(ASQL, AParams);
    if AOpen then begin
      Open;
    end;
  end;
end;

procedure TILLink_BDE.TransBegin;
begin
  FDatabase.StartTransaction;
  inherited;
end;

procedure TILLink_BDE.TransEnd;
begin
  FDatabase.Commit;
  inherited;
end;

procedure TILLink_BDE.TransRollback;
begin
  FDatabase.Rollback;
  inherited;
end;

initialization
  TILLinkRegistration.RegisterLink('BDE', TILLink_BDE, TformILConfigBDE);
  CS := TCriticalSection.Create;
finalization
  CS.Free;
  CS := nil;
end.

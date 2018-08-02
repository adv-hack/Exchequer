unit LinkIL_Oracle;

interface

uses
  Classes,
  Db,
  LinkIL,
  Oracle, OracleData,
  SyncObjs;

type
  TILLink_Oracle = class(TILLink)
  protected
    FSession: TOracleSession;
  public
    procedure DoClose; override;
    procedure DoOpen; override;
    function ExecSQL(const ASQL: string; const ARows: integer): integer; override;
    procedure FillTableList(ATableList: TStrings); override;
    function Generator(const AName: string; const ACount: integer = 1): integer; override;
    procedure GetTableList(ATableList: TStrings); override;
    procedure GetViewList(AViewList: TStrings); override;
    procedure GetStoredProcList(AStoredProcList: TStrings); override;
    function Query(const ASQL: string; const AOpen: Boolean = True;
     const AParams: TStrings = nil): TDataset; override;
    procedure TransBegin; override;
    procedure TransEnd; override;
    procedure TransRollback; override;
  end;

var
  SessionCS: TCriticalSection;

implementation

uses
  ILConfig_Oracle, ILRegister;

{ TILLink_Oracle }

procedure TILLink_Oracle.DoClose;
begin
  FSession.Free;
  FSession := nil;
end;

procedure TILLink_Oracle.DoOpen;
begin
  SessionCS.Enter;
  try
    FSession := TOracleSession.Create(nil);
    With FSession do begin
      LogonUsername := Username;
      LogonPassword := Password;
      LogonDatabase := DataSource;
      LogOn;
    end; { with }
  finally
    SessionCS.Leave;
  end; { tryf }
end;

function TILLink_Oracle.ExecSQL(const ASQL: string;
  const ARows: integer): integer;
begin
  Raise EDatabaseError.Create('undefined');
end;

procedure TILLink_Oracle.FillTableList(ATableList: TStrings);
begin
  With Query('select table_name from all_tables') do try
    First;
    While not EOF do begin
      ATableList.Add(Fields[0].AsString);
      Next;
    end; { while }
  finally
    Free;
  end; { with }
end;

function TILLink_Oracle.Generator(const AName: string;
  const ACount: integer): integer;
begin
  Raise EDatabaseError.Create('undefined');
end;

procedure TILLink_Oracle.GetStoredProcList(AStoredProcList: TStrings);
begin
  Raise EDatabaseError.Create('undefined');
end;

procedure TILLink_Oracle.GetTableList(ATableList: TStrings);
begin
  FillTableList(ATableList);
  CheckTableNames(ATableList);
end;

procedure TILLink_Oracle.GetViewList(AViewList: TStrings);
begin
  Raise EDatabaseError.Create('undefined');
end;

function TILLink_Oracle.Query(const ASQL: string; const AOpen: Boolean;
  const AParams: TStrings): TDataset;
begin
  Result := TOracleDataset.Create(nil);
  With TOracleDataset(Result) do begin
    Session := FSession;
    SQL.Text := ParamSQL(ASQL, AParams);
    If AOpen then begin
      Open;
    end; { if }
  end;
end;

procedure TILLink_Oracle.TransBegin;
begin
  Raise EDatabaseError.Create('undefined');
end;

procedure TILLink_Oracle.TransEnd;
begin
  Raise EDatabaseError.Create('undefined');
end;

procedure TILLink_Oracle.TransRollback;
begin
  Raise EDatabaseError.Create('undefined');
end;

initialization
  SessionCS := TCriticalSection.Create;
  TILLinkRegistration.RegisterLink('Oracle', TILLink_Oracle, TformILConfigOracle);
finalization
  SessionCS.Free;
  SessionCS := nil;
end.

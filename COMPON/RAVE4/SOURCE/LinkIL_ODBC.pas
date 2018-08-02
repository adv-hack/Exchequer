unit LinkIL_ODBC;

interface

uses
  Classes,
  Db, OCL, ODSI, OVCL,
  LinkIL;

type
  TILLink_ODBC = class(TILLink)
  protected
    FConnection: THdbc;
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

implementation

uses
  ILConfig_ODBC, ILRegister, SysUtils;

{ TILLink_ODBC }

procedure TILLink_ODBC.DoClose;
begin
  FConnection.Connected := False;
  FreeAndNil(FConnection);
end;

procedure TILLink_ODBC.DoOpen;
begin
  FConnection := THdbc.Create(Self);
  with FConnection do begin
    DataSource := Self.Datasource;
    Username := Self.Username;
    Password := Self.Password;
    Connected := True;
    // Attributes
  end;
end;

function TILLink_ODBC.ExecSQL(const ASQL: string;
  const ARows: integer): integer;
begin
  raise Exception.Create('EXECSQL: Not implemented');
(*
  with TOEQuery(Query(ASQL, False)) do try
    ExecSQL;
  finally
    Free;
  end;
*)
end;

procedure TILLink_ODBC.FillTableList(ATableList: TStrings);
var
  ACatalog: TOECatalog;
begin
  ACatalog := TOECatalog.Create(Self);
  try
    ATableList.Assign(ACatalog.TableNames);
  finally
    ACatalog.Free;
  end;
end;

function TILLink_ODBC.Generator(const AName: string;
  const ACount: integer): integer;
begin
  raise Exception.Create('GENERATOR: Not implemented');
end;

procedure TILLink_ODBC.GetStoredProcList(AStoredProcList: TStrings);
begin
  raise Exception.Create('GETSTOREDPROCLIST: Not implemented');
end;

procedure TILLink_ODBC.GetTableList(ATableList: TStrings);
begin
  FillTableList(ATableList);
  CheckTableNames(ATableList);
end;

procedure TILLink_ODBC.GetViewList(AViewList: TStrings);
begin
  raise Exception.Create('GETVIEWLIST: Not implemented');
end;

function TILLink_ODBC.Query(const ASQL: string; const AOpen: Boolean;
  const AParams: TStrings): TDataset;
begin
  Result := TOEQuery.Create(nil);
  with TOEQuery(Result) do begin
    hDbc := FConnection;
    SQL.Text := ParamSQL(ASQL, AParams);
    if AOpen then begin
      Open;
    end;
  end;
end;

procedure TILLink_ODBC.TransBegin;
begin
  FConnection.StartTransact;
  inherited;
end;

procedure TILLink_ODBC.TransEnd;
begin
  FConnection.EndTransact;
  inherited;
end;

procedure TILLink_ODBC.TransRollback;
begin
  FConnection.Rollback;
  inherited;
end;

initialization
  TILLinkRegistration.RegisterLink('ODBC', TILLink_ODBC, TformILConfigODBC);
end.

unit LinkIL_IBX;

interface

uses
  Classes,
  Db,
  IBDatabase, IBCustomDataSet, IBQuery,
  LinkIL;

type
  TILLink_IBX = class(TILLink)
  protected
    FDatabase: TIBDatabase;
    FTransaction: TIBTransaction;
  public
    procedure DoClose; override;
    procedure DoOpen; override;
    function ExecSQL(const ASQL: string; const ARows: integer): integer; override;
    procedure FillTableList(ATableList: TStrings); override;
    function Generator(const AName: string; const ACount: integer = 1): integer; override;
    procedure GetTableList(ATableList: TStrings); override;
    procedure GetViewList(AViewList: TStrings); override;
    function Query(const ASQL: string; const AOpen: Boolean = True;
     const AParams: TStrings = nil): TDataset; override;
    procedure TransBegin; override;
    procedure TransEnd; override;
    procedure TransRollback; override;
  end;

implementation

uses
  ILRegister, ILConfig_Interbase,
  SysUtils;

{ TILLink_IBXX }

procedure TILLink_IBX.DoClose;
begin
  FreeAndNil(FTransaction);
  FreeAndNil(FDatabase);
end;

procedure TILLink_IBX.DoOpen;
begin
  FDatabase := TIBDatabase.Create(nil);
  with FDatabase do begin
    DatabaseName := Datasource;
    LoginPrompt := False;
    Params.Values['user_name'] := Self.Username;
    Params.Values['password'] := Self.Password;
    Connected := True;
  end;
  FTransaction := TIBTransaction.Create(nil);
  with FTransaction do begin
    DefaultDatabase := FDatabase;
    Active := True;
  end;
end;

function TILLink_IBX.ExecSQL(const ASQL: string; const ARows: integer): integer;
begin
  with TIBQuery(Query(ASQL, False)) do try
    ExecSQL;
    result := RowsAffected;
    if (ARows <> -1) and (result <> ARows) then begin
    	raise Exception.Create('Row count mismatch.');
    end;
  finally free; end;
end;

procedure TILLink_IBX.FillTableList(ATableList: TStrings);
begin
  FDatabase.GetTableNames(ATableList);
end;

function TILLink_IBX.Generator(const AName: string; const ACount: integer): integer;
begin
  with Query('Select Gen_ID(' + AName + ', ' + IntToStr(ACount) + ') from Dual') do try
    Result := Fields[0].AsInteger;
  finally free; end;
end;

procedure TILLink_IBX.GetTableList(ATableList: TStrings);
begin
  FillTableList(ATableList);
  CheckTableNames(ATableList);
end;

procedure TILLink_IBX.GetViewList(AViewList: TStrings);
begin

end;

function TILLink_IBX.Query(const ASQL: string; const AOpen: Boolean = true;
 const AParams: TStrings = nil): TDataset;
begin
  result := TIBQuery.Create(nil);
  with TIBQuery(result) do begin
    Database := FDatabase;
    SQL.Text := ParamSQL(ASQL, AParams);
    if AOpen then begin
      Open;
    end;
  end;
end;

procedure TILLink_IBX.TransBegin;
begin
  FTransaction.StartTransaction;
  inherited;
end;

procedure TILLink_IBX.TransEnd;
begin
  FTransaction.Commit;
  inherited;
end;

procedure TILLink_IBX.TransRollback;
begin
  FTransaction.Rollback;
  inherited;
end;

initialization
  TILLinkRegistration.RegisterLink('IBX', TILLink_IBX, TformILConfigInterbase);
end.

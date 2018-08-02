unit LinkIL_IBO;

interface

uses
  Classes,
  Db,
  IBDataset, IB_Components,
  LinkIL;

type
  TILLink_IBO = class(TILLink)
  protected
    FDatabase: TIBODatabase;
    FSession: TIB_Session;
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
  IB_Schema, ILRegister, ILConfig_Interbase,
  SysUtils;

{ TILLink_IBOO }

procedure TILLink_IBO.DoClose;
begin
  // Must explicitly free databsae. IBOs .Notification otherwise can sometimes AV
  FreeAndNil(FDatabase);
  FreeAndNil(FSession);
end;

procedure TILLink_IBO.DoOpen;
begin
  FSession := TIB_Session.Create(Self);
  FDatabase := TIBODatabase.Create(FSession);
  with FDatabase do begin
    LoginPrompt := False;
    Database := Datasource;
    UserName := Self.Username;
    Password := Self.Password;
    Connected := True;
  end;
end;

function TILLink_IBO.ExecSQL(const ASQL: string; const ARows: integer): integer;
begin
  with TIBOQuery(Query(ASQL, False)) do try
    ExecSQL;
    result := RowsAffected;
    if (ARows <> -1) and (result <> ARows) then begin
    	raise Exception.Create('Row count mismatch.');
    end;
  finally free; end;
end;

procedure TILLink_IBO.FillTableList(ATableList: TStrings);
begin
  SchemaRelationNames(FDatabase,FDatabase.IB_Transaction,false,true,false,ATableList);
end;

function TILLink_IBO.Generator(const AName: string; const ACount: integer): integer;
begin
  with Query('Select Gen_ID(' + AName + ', ' + IntToStr(ACount) + ') from Dual') do try
    Result := Fields[0].AsInteger;
  finally free; end;
end;

procedure TILLink_IBO.GetTableList(ATableList: TStrings);
begin
  FillTableList(ATableList);
  CheckTableNames(ATableList);
end;

procedure TILLink_IBO.GetViewList(AViewList: TStrings);
begin
  SchemaRelationNames(FDatabase,FDatabase.IB_Transaction,false,false,true,AViewList);
end;

function TILLink_IBO.Query(const ASQL: string; const AOpen: Boolean = true;
 const AParams: TStrings = nil): TDataset;
begin
  result := TIBOQuery.Create(nil);
  with TIBOQuery(result) do begin
    IB_Connection := FDatabase;
    KeyLinksAutoDefine := False;
    SQL.Text := ParamSQL(ASQL, AParams);
    if AOpen then begin
	    ReadOnly := True;
      Open;
    end;
  end;
end;

procedure TILLink_IBO.TransBegin;
begin
  FDatabase.StartTransaction;
  inherited;
end;

procedure TILLink_IBO.TransEnd;
begin
  FDatabase.Commit;
  inherited;
end;

procedure TILLink_IBO.TransRollback;
begin
  FDatabase.Rollback;
  inherited;
end;

initialization
  TILLinkRegistration.RegisterLink('IBO', TILLink_IBO, TformILConfigInterbase);
end.

unit LinkIL_ADO;

interface

uses
  ADODB,
  Classes,
  Db,
  LinkIL;

type
  TILLink_ADO = class(TILLink)
  protected
    FConnection: TADOConnection;
  public
    procedure DoClose; override;
    procedure DoOpen; override;
    function ExecSQL(const ASQL: string; const ARows: integer): integer; override;
    function Generator(const AName: string; const ACount: integer = 1): integer; override;
    procedure FillTableList(ATableList: TStrings); override;
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
  ILConfig_ADO, ILRegister,
  SysUtils;

{ TILLink_ADO }

procedure TILLink_ADO.DoClose;
begin
  FreeAndNil(FConnection);
end;

procedure TILLink_ADO.DoOpen;
begin
  FConnection := TADOConnection.Create(Self);
  with FConnection do begin
    LoginPrompt := False;
    ConnectionString := Datasource;
    Connected := True;
  end;
end;

function TILLink_ADO.ExecSQL(const ASQL: string; const ARows: integer): integer;
begin
  with TADOQuery(Query(ASQL, False)) do try
    ExecSQL;
    result := RowsAffected;
    if (ARows <> -1) and (result <> ARows) then begin
    	raise Exception.Create('Row count mismatch.');
    end;
  finally free; end;
end;

function TILLink_ADO.Generator(const AName: string; const ACount: integer): integer;
begin
  with Query('Select Gen_ID(' + AName + ', ' + IntToStr(ACount) + ') from Dual') do try
    Result := Fields[0].AsInteger;
  finally free; end;
end;

procedure TILLink_ADO.GetTableList(ATableList: TStrings);
begin
  FillTableList(ATableList);
  CheckTableNames(ATableList);
end;

procedure TILLink_ADO.GetViewList(AViewList: TStrings);
var
  DataSet: TADODataSet;
begin
//!!!  FConnection.CheckActive;
  DataSet := TADODataSet.Create(nil);
  try
    FConnection.OpenSchema(siViews,EmptyParam,EmptyParam,DataSet);
    AViewList.BeginUpdate;
    try
      AViewList.Clear;
      While not DataSet.EOF do begin
        AViewList.Add(DataSet.FieldByName('TABLE_NAME').AsString);
        DataSet.Next;
      end; { while }
    finally
      AViewList.EndUpdate;
    end; { tryf }
  finally
    DataSet.Free;
  end; { tryf }
end;

procedure TILLink_ADO.GetStoredProcList(AStoredProcList: TStrings);
begin
  FConnection.GetProcedureNames(AStoredProcList);
end;

function TILLink_ADO.Query(const ASQL: string; const AOpen: Boolean = true;
 const AParams: TStrings = nil): TDataset;
begin
  result := TADOQuery.Create(nil);
  with TADOQuery(result) do begin
    Connection := FConnection;
    SQL.Text := ParamSQL(ASQL, AParams);
    if AOpen then begin
      Open;
    end;
  end;
end;

procedure TILLink_ADO.TransBegin;
begin
  FConnection.BeginTrans;
  inherited;
end;

procedure TILLink_ADO.TransEnd;
begin
  FConnection.CommitTrans;
  inherited;
end;

procedure TILLink_ADO.TransRollback;
begin
  FConnection.RollbackTrans;
  inherited;
end;

procedure TILLink_ADO.FillTableList(ATableList: TStrings);
begin
  FConnection.GetTableNames(ATableList, False);
end;

initialization
  TILLinkRegistration.RegisterLink('ADO', TILLink_ADO, TformILConfigADO);
end.

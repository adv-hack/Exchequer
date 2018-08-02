{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPConBDE;

interface

uses
  Windows, SysUtils, Classes, Forms, RPDefine, RPCon, RPConDS, DB, DBTables;

type
  TRPTableConnection = class(TRPCustomDataSetConnection)
  protected
    FTable: TTable;
    FUseSetRange: boolean;
    SaveMasterSource: TDataSource;
    SaveMasterFields: string;

    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure SetTable(Value: TTable);
    function GetDataSet: TDataSet; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoSetFilter; override;
    procedure DoGetSorts; override;
    procedure DoSetSort; override;
    procedure DoOpen; override;
    procedure DoRestore; override;
  published
    property LocalFilter default false;
    property Table: TTable read FTable write SetTable default nil;
    property UseSetRange: boolean read FUseSetRange write FUseSetRange default false;
  end; { TRPTableConnection }

  TRPQueryConnection = class(TRPCustomDataSetConnection)
  protected
    FQuery: TQuery;

    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure SetQuery(Value: TQuery);
    function GetDataSet: TDataSet; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoGetSorts; override;
    procedure DoSetSort; override;
  published
    property LocalFilter default false;
    property Query: TQuery read FQuery write SetQuery default nil;
  end; { TRPQueryConnection }

implementation

(*****************************************************************************}
( class TRPTableConnection
(*****************************************************************************)

  constructor TRPTableConnection.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    LocalFilter := false;
  end;  { Create }

  procedure TRPTableConnection.Notification(AComponent: TComponent;
                                            Operation: TOperation);

  begin { Notification }
    inherited Notification(AComponent,Operation);
    If (Operation = opRemove) and (AComponent = FTable) then begin
      FTable := nil;
    end; { if }
  end;  { Notification }

  procedure TRPTableConnection.SetTable(Value: TTable);

  begin { SetTable }
    FTable := Value;
    If Assigned(Value) then begin
      Value.FreeNotification(self);
    end; { if }
  end;  { SetTable }

  function TRPTableConnection.GetDataSet: TDataSet;

  begin { GetDataSet }
    Result := Table;
  end;  { GetDataSet }

  procedure TRPTableConnection.DoSetFilter;

  var
    FieldName: string;
    FieldOp: string;
    FieldData: string;

  begin { DoSetFilter }
    If UseSetRange then begin
      With Table do begin
        SetRangeStart;
        While ReadFilterItem(FieldName,FieldOp,FieldData) do begin
          FieldByName(FieldName).AsString := FieldData;
        end; { while }
        ApplyRange;
      end; { with }
    end else begin
      inherited DoSetFilter;
    end; { else }
  end;  { DoSetFilter }

  procedure TRPTableConnection.DoGetSorts;

  begin { DoGetSorts }
  end;  { DoGetSorts }

  procedure TRPTableConnection.DoSetSort;

  var
    CalcSort: string;
    SortName: string;

  begin { DoSetSort }
    CalcSort := '';
    Repeat
      SortName := ReadStr;
      If SortName <> '' then begin
        If CalcSort <> '' then begin
          CalcSort := CalcSort + ';';
        end; { if }
        CalcSort := CalcSort + SortName;
      end; { if }
    until SortName = '';
    Table.IndexFieldNames := CalcSort;
  end;  { DoSetSort }

  procedure TRPTableConnection.DoOpen;

  begin { DoOpen }
    inherited DoOpen;
    With Table do begin
      SaveMasterSource := MasterSource;
      SaveMasterFields := MasterFields;
      If Assigned(MasterSource) and (MasterFields <> '') then begin
        MasterSource := nil;
        MasterFields := '';
      end; { if }
    end; { with }
  end;  { DoOpen }

  procedure TRPTableConnection.DoRestore;

  begin { DoRestore }
    With Table do begin
      MasterSource := SaveMasterSource;
      MasterFields := SaveMasterFields;
    end; { with }
    inherited DoRestore;
  end;  { DoRestore }

(*****************************************************************************}
( class TRPQueryConnection
(*****************************************************************************)

  constructor TRPQueryConnection.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    LocalFilter := false;
  end;  { Create }

  procedure TRPQueryConnection.Notification(AComponent: TComponent;
                                            Operation: TOperation);

  begin { Notification }
    inherited Notification(AComponent,Operation);
    If (Operation = opRemove) and (AComponent = Query) then begin
      Query := nil;
    end; { if }
  end;  { Notification }

  procedure TRPQueryConnection.SetQuery(Value: TQuery);

  begin { SetQuery }
    FQuery := Value;
    If Assigned(Value) then begin
      Value.FreeNotification(self);
    end; { if }
  end;  { SetQuery }

  function TRPQueryConnection.GetDataSet: TDataSet;

  begin { GetDataSet }
    Result := Query;
  end;  { GetDataSet }

  procedure TRPQueryConnection.DoGetSorts;

  begin { DoGetSorts }
  end;  { DoGetSorts }

  procedure TRPQueryConnection.DoSetSort;

  begin { DoSetSort }
  end;  { DoSetSort }

end.
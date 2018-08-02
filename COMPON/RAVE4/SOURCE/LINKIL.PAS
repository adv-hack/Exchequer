unit LinkIL;

interface

uses
  Classes,
  DB,
  SysUtils;

Type
  TILLink = class(TComponent)
  protected
    FActive: boolean;
    FDatasource: string;
    FOptions: string;
    FPassword: string;
    FTransLevel: integer;
    FUsername: string;
  public
    procedure CheckTableNames(ATableList: TStrings); virtual;
    procedure Close;
    class function ConstructLink(AType: string; AOwner: TComponent = nil): TILLink;
    destructor Destroy; override;
    procedure DoClose; virtual; abstract;
    procedure DoOpen; virtual; abstract;
    function ExecSQL(const ASQL: string; const ARows: integer): integer; virtual; abstract;
    procedure GetTableList(ATableList: TStrings); virtual; abstract;
    procedure FillTableList(ATableList: TStrings); virtual; abstract;
    procedure GetFieldNames(ATableName: string; AFieldList: TStrings); virtual;
    procedure GetViewList(AViewList: TStrings); virtual;
    procedure GetStoredProcList(AStoredProcList: TStrings); virtual;
    function Generator(const AName: string; const ACount: integer = 1): integer; virtual; abstract;
    procedure Open;
    function ParamSQL(const ASQL: string; AParams: TStrings = nil): string;
    function Query(const ASQL: string; const AOpen: Boolean = True;
     const AParams: TStrings = nil): TDataset; virtual; abstract;
    procedure SetActive(const AValue: boolean);
    function TransIsActive: boolean;
    procedure TransBegin; virtual;
    procedure TransEnd; virtual;
    procedure TransRollback; virtual;
    //
    property Active: boolean read FActive write SetActive;
    property TransLevel: integer read FTransLevel;
  published
    property Datasource: string read FDatasource write FDatasource;
    property Options: string read FOptions write FOptions;
    property Password: string read FPassword write FPassword;
    property Username: string read FUsername write FUsername;
  end;

  TILLinkClass = class of TILLink;

implementation

uses
  {$IFDEF Linux}
  QForms,
  {$ELSE}
  Forms,
  Windows,
  {$ENDIF}
  ILRegister;

{ TILLink }

procedure TILLink.Close;
begin
  Active := False;
end;

class function TILLink.ConstructLink(AType: string; AOwner: TComponent = nil): TILLink;
begin
  Result := GILLinks.ByName(AType).LinkClass.Create(AOwner);
end;

procedure TILLink.Open;
begin
  Active := True;
end;

procedure TILLink.SetActive(const AValue: boolean);
begin
  if AValue <> FActive then begin
    if AValue then begin
      DoOpen;
    end else begin
      DoClose;
    end;
    FActive := AValue;
  end;
end;

procedure TILLink.TransBegin;
begin
  Inc(FTransLevel);
end;

procedure TILLink.TransEnd;
begin
  Dec(FTransLevel);
end;

function TILLink.TransIsActive: boolean;
begin
  result := FTransLevel > 0;
end;

procedure TILLink.TransRollback;
begin
  Dec(FTransLevel);
end;

procedure TILLink.GetViewList(AViewList: TStrings);
begin
  AViewList.Clear;
end;

procedure TILLink.GetStoredProcList(AStoredProcList: TStrings);
begin
  AStoredProcList.Clear;
end;

function TILLink.ParamSQL(const ASQL: string; AParams: TStrings): string;

  function ReplaceAllParam(AString: string; const AParam, AValue: string): string;
  var
    i, j: Integer;
    s: string;
  begin
    repeat
      i := Pos(':' + UpperCase(AParam), UpperCase(AString));
      if i > 0 then begin
        j := i + Length(AParam) + 1;
        while AString[j] in ['a'..'z', 'A'..'Z', '0'..'9', '_'] do begin
          inc(j);
        end;
        s := s + Copy(AString, 1, i-1) + AValue;
        Delete(AString, 1, j - 1);
      end else begin
        s := s + AString;
      end;
    until i = 0;
    Result := s;
  end;

var
  i: integer;
begin
  result := ASQL;
  if AParams <> nil then begin
    for i := 0 to AParams.Count - 1 do begin
      Result := ReplaceAllParam(Result, AParams.Names[i], AParams.Values[AParams.Names[i]]);
    end;
  end;
end;

destructor TILLink.Destroy;
begin
  Active := False;
  inherited;
end;

procedure TILLink.CheckTableNames(ATableList: TStrings);
var
  i: Integer;
begin
  for i := 0 to ATableList.Count - 1 do begin
    if Pos(' ', ATableList[i]) > 0 then begin
      ATableList[i] := '"' + ATableList[i] + '"';
    end;
  end;
end;

procedure TILLink.GetFieldNames(ATableName: string; AFieldList: TStrings);
var
  Dataset: TDataset;
  I1: integer;
begin
  DataSet := Query('select * from ' + ATableName + ' where 0=1');
  try
    AFieldList.Clear;
    AFieldList.Add('*');
    For I1 := 0 to DataSet.FieldCount - 1 do begin
      AFieldList.Add(DataSet.Fields[I1].FieldName);
    end; { for }
  finally
    Dataset.Free;
  end;
end;

end.

unit RowCompare;

interface

uses
  DB, DBGrids, Classes, Contnrs;

type
  TCompareFields = Class
  private
    FDataSize : longInt;
    function GetDataString(Index: Integer): string;
  public
    Data : Array[0..1] of Variant;
    function DataIsTheSame : Boolean;
    property DataSize : longint read FDataSize write FDataSize;
    property DataString[Index : Integer] : string read GetDataString;
  end;


  TCompareRows = Class
  private
    FResultList : TStringList;
    FDbGrid : TDbGrid;
    FCompareList : TObjectList;
    FTableName : string;
    FCompanyCode : Array[1..2] of string;
    procedure PopulateCompares(WhichRow : Integer);
    procedure SetDBGrid(const Value: TDBGrid);
    function GetCompanyCode(Index: Integer): string;
    function GetTableName: string;
    procedure SplitTableName;
  public
    constructor Create;
    destructor Destroy; override;
    function Execute : Boolean;

    property ResultList : TStringList read FResultList;
    property DBGrid : TDBGrid read FDBGrid write SetDBGrid;
    property TableName : string read GetTableName;
    property CompanyCode[Index : Integer] : string read GetCompanyCode;
  end;

implementation

uses
  SysUtils, Variants, StrUtils;

function StringToHexString(const s : String; Prefix : string = '0x') : string;
var
  pRes : PChar;
  iSize : Integer;
  sRes : AnsiString;
begin
  iSize := (2 * Length(s)) + 1;
  pRes := StrAlloc(iSize);
  FillChar(pRes^, iSize, 0);
  Try
    BinToHex(PChar(s), pRes, Length(s));
    sRes := AnsiString(pRes);
    Result := Prefix + sRes;
  Finally
    StrDispose(pRes);
  End;
end;

{ TCompareRows }

constructor TCompareRows.Create;
begin
  inherited;
  FResultList := TStringList.Create;
  FCompareList := TObjectList.Create;
  FTableName := '';
end;

destructor TCompareRows.Destroy;
begin
  if Assigned(FResultList) then
    FResultList.Free;
  if Assigned(FCompareList) then
    FCompareList.Free;
  inherited;
end;

function TCompareRows.Execute : Boolean;
var
  i : integer;

  function MakeSafeText(const s : string) : string;
  begin
    if (Pos(',', s) > 0) or
       (Pos(' ', s) > 0) then
      Result := '"' + s + '"'
    else
      Result := s;
  end;
begin
  if FDBGrid.SelectedRows.Count <> 2 then
    raise Exception.Create('2 rows must be selected for comparison.');

  with FDBGrid.DataSource.DataSet do
  begin
    for i:=0 to FDBGrid.SelectedRows.Count-1 do
    begin
      GotoBookmark(pointer(FDBGrid.SelectedRows.Items[i]));
      PopulateCompares(i);
    end;

    for i := 1 to FieldCount - 1 do
     with TCompareFields(FCompareList[i]) do
      if not DataIsTheSame then
      begin

        FResultList.Add(Fields[i].DisplayName + ',' + MakeSafeText(DataString[0]) + ',' + MakeSafeText(DataString[1]));
      end;

  end;

  Result := FResultList.Count = 0;
end;

function TCompareRows.GetCompanyCode(Index: Integer): string;
begin
  if FTableName = '' then
    SplitTableName;
  Result := FCompanyCode[Index];
end;

function TCompareRows.GetTableName: string;
begin
  if FTableName = '' then
    SplitTableName;
  Result := FTableName;
end;

procedure TCompareRows.PopulateCompares(WhichRow: Integer);
var
  i : integer;
  aString : AnsiString;
begin
  with FDBGrid.DataSource.DataSet do
  for i := 0 to FieldCount - 1 do
  begin
    if Assigned(FCompareList[i]) then
    with FCompareList[i] as TCompareFields do
    begin
      if Fields[i].DataType = ftVarBytes then
      begin
        aString := Fields[i].AsString;
        Data[WhichRow] := StringToHexString(aString);
      end
      else
        Data[WhichRow] := Fields[i].AsVariant;
    end;
  end;
end;

procedure TCompareRows.SetDBGrid(const Value: TDBGrid);
var
  i : integer;
  ACompare : TCompareFields;
begin
  FDBGrid := Value;
  with FDBGrid.DataSource.DataSet do
  begin
    for i := 0 to FieldCount - 1 do
    begin
      ACompare := TCompareFields.Create;
      ACompare.DataSize := Fields[i].DataSize;

      if ACompare.DataSize = 0 then
        raise Exception.Create('DataSize of 0: ' + Fields[i].DisplayName);
      FCompareList.Add(ACompare);
    end;
  end;
end;

procedure TCompareRows.SplitTableName;
var
  s1, s2 : string;
begin
  if FCompareList.Count > 0 then
  with TStringList.Create do
  Try
    CommaText := AnsiReplaceStr(TCompareFields(FCompareList[0]).DataString[0], '.', ',');
    FTableName := Strings[2];
    s1 := Strings[0];
    s2 := Strings[1];

    CommaText := AnsiReplaceStr(TCompareFields(FCompareList[0]).DataString[1], '.', ',');
    if s2 <> Strings[1] then
    begin
      FCompanyCode[1] := s2;
      FCompanyCode[2] := Strings[1];
    end
    else
    begin
      FCompanyCode[1] := s1;
      FCompanyCode[2] := Strings[0];
    end;
  Finally
    Free;
  End;
end;

{ TCompareFields }

function TCompareFields.DataIsTheSame: Boolean;
begin
  Result := VarCompareValue(Data[0], Data[1]) = vrEqual;
end;


function TCompareFields.GetDataString(Index: Integer): string;
begin
  Result := Data[Index];
end;

end.

unit oSQLLoadAnonymisationDiary;

interface

uses Classes, SysUtils, SQLUtils, Dialogs, DB, GlobVar, SQLCallerU, ADOConnect,
     oAnonymisationDiaryBtrieveFile;

type
  // Common class for reading AnonymisationDiary details - used by  TSQLAnonymisationDiaryDetail.LoadAnonDiaryData
  TSQLLoadAnonymisationDiary = Class(TObject)
  private
    FSQLCaller: TSQLCaller;
    FOwnsSQLCaller: Boolean;
    FCompanyCode: AnsiString;
    fldEntityType: TIntegerField;
    fldEntityCode: TStringField;
    fldAnonymisationDate: TStringField;

    function GetAnonymisationDiaryQuery(const AWhereClause: ANSIString = ''): string;
    procedure PrepareFields(ADataSet: TDataSet);
    function GetAnonymisationDiaryRec: AnonymisationDiaryRecType;
  public
    constructor Create(const ASQLCaller: TSQLCaller = NIL);
    destructor Destroy; override;

    function ReadData(const AWhereClause: ANSIString = ''): Integer;
    function GetFirst: Integer;
    function GetNext: Integer;
    property AnonymisationDiaryRec: AnonymisationDiaryRecType read GetAnonymisationDiaryRec;
  end; // TSQLLoadAnonymisationDiary

implementation

//------------------------------------------------------------------------------
{ TSQLLoadAnonymisationDiary }
//------------------------------------------------------------------------------

constructor TSQLLoadAnonymisationDiary.Create(const ASQLCaller: TSQLCaller);
begin
  inherited Create;
  FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);

  if Assigned(ASQLCaller) then
  begin
    FSQLCaller := ASQLCaller;
    FOwnsSQLCaller := False;
  end
  else
  begin
    FSQLCaller := TSQLCaller.Create(GlobalADOConnection);
    FOwnsSQLCaller := True;
  end;
end;

//------------------------------------------------------------------------------

destructor TSQLLoadAnonymisationDiary.Destroy;
begin
  if FSQLCaller.Records.Active then
    FSQLCaller.Records.Close;

  if FOwnsSQLCaller and Assigned(FSQLCaller) then
    FreeAndNil(FSQLCaller);
  inherited Destroy;
end;

//------------------------------------------------------------------------------

function TSQLLoadAnonymisationDiary.GetFirst: Integer;
begin
  if (FSQLCaller.ErrorMsg = '') and (FSQLCaller.Records.RecordCount > 0) and (FSQLCaller.Records.Active) then
  begin
    FSQLCaller.Records.First;
    if FSQLCaller.Records.EOF then
      Result := 9
    else
      Result := 0;
  end
  else
    Result := 4;
end;

//------------------------------------------------------------------------------

function TSQLLoadAnonymisationDiary.GetAnonymisationDiaryQuery(const AWhereClause: ANSIString): string;
var
  lWhereStr: String;
begin
  if (AWhereClause <> '') then
    lWhereStr := 'WHERE ' + AWhereClause + ' '
  else
    lWhereStr := '';

  Result := 'SELECT adEntityType, adEntityCode, adAnonymisationDate ' +
            'FROM [COMPANY].ANONYMISATIONDIARY ' +
            lWhereStr +
            'ORDER BY adAnonymisationDate';
end;

//------------------------------------------------------------------------------

function TSQLLoadAnonymisationDiary.GetNext: Integer;
begin
  if (FSQLCaller.ErrorMsg = '') and (FSQLCaller.Records.RecordCount > 0) and (FSQLCaller.Records.Active) then
  begin
    FSQLCaller.Records.Next;
    if FSQLCaller.Records.EOF then
      Result := 9
    else
      Result := 0;
  end
  else
    Result := 4;
end;

//------------------------------------------------------------------------------

function TSQLLoadAnonymisationDiary.GetAnonymisationDiaryRec: AnonymisationDiaryRecType;
begin
  FillChar(Result, SizeOf(Result), #0);
  with Result do
  begin
    adEntityType := TAnonymisationDiaryEntity(fldEntityType.Value);
    adEntityCode := fldEntityCode.Value;
    adAnonymisationDate := fldAnonymisationDate.Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TSQLLoadAnonymisationDiary.PrepareFields(ADataSet: TDataSet);
begin
  with ADataSet do
  begin
    fldEntityType := FieldByName('adEntityType') as TIntegerField;
    fldEntityCode := FieldByName('adEntityCode') as TStringField;
    fldAnonymisationDate := FieldByName('adAnonymisationDate') as TStringField;
  end;
end;

//------------------------------------------------------------------------------

function TSQLLoadAnonymisationDiary.ReadData(const AWhereClause: ANSIString): Integer;
var
  lSQLQuery: AnsiString;
begin
  Result := 9;
  lSQLQuery := GetAnonymisationDiaryQuery(AWhereClause);
  FSQLCaller.Select(lSQLQuery, FCompanyCode);
  if (FSQLCaller.ErrorMsg = '') And (FSQLCaller.Records.RecordCount > 0) then
  begin
    PrepareFields(FSQLCaller.Records);
    Result := 0;
  end;
end;

//------------------------------------------------------------------------------

end.

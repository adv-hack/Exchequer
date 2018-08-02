unit uSQLDatasets;

interface

uses
  Classes, SysUtils, uExDatasets, ADODB, DB, Variants, Dialogs;

type
  TGetFieldValueEvent = procedure(Sender: TObject; Dataset: TDataset; FieldName: string; var FieldValue: variant) of object;
  TGetDisplayValueEvent = procedure(Sender: TObject; Dataset: TDataset; FieldName: string; var FieldValue: variant) of object;

  TSQLDatasets = class(TExDatasets)
  private
    fDebugging: boolean;
    fDatabase: string;
    fFilter: string;
    fPassword: string;
    fReturnAllFields: boolean;
    fServerAlias: string;
    fTableName: string;
    fUserName: string;
    fOnSelectRecord: TNotifyEvent;
    fConnection: TADOConnection;
    fTable: TADOTable;
    fQuery: TADOQuery;
    fDataset: TDataset;
    fFieldList: TStringList;
    fOnGetFieldValue: TGetFieldValueEvent;
    fSelectFields: string;
    FUseWindowsAuthentication: Boolean;
    fConnectionString: string;
    fOnGetDisplayValue: TGetDisplayValueEvent;
    fPositionID: Integer;
    procedure SetCommand(DatasetID: integer; NewCommand: string);
    function PrepareTable: integer;
    function PrepareQuery: integer;
    function GetSQLConnection(SQLServerName, SQLDatabase, SQLUserName, SQLPassword: string): integer;
    function GetSearchWhere(DataType: TFieldType; SortKey, GreaterLess, SortValueStr, FilterStr: string): string;
    function GetCommand(DatasetID: integer): string;
    function ConvertVariant(FieldType: TFieldType; VariantValue: variant): string;
    procedure SetSelectFields(const Value: string);
    procedure InitFieldList(const FieldNames: string);
    procedure SetUseWindowsAuthentication(const Value: Boolean);
    procedure SetPassword(const Value: string);
    procedure SetUserName(const Value: string);
    procedure SetConnectionString(const Value: string);
    procedure ParseConnectionString;
  protected
    procedure SetSearchIndex(NewIndex: byte); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FreeDataset(DatasetID: integer): integer; override;
    procedure GetBlockFirst(DatasetID: integer); override;
    procedure GetBlockPrior(DatasetID: integer); override;
    procedure GetBlockNext(DatasetID: integer); override;
    procedure GetBlockLast(DatasetID: integer); override;
    procedure SelectRecord(SelectType: TSelectType; RecordNo: integer); override;
    function GetBlock(DatasetID: integer; BlockDetails: TBlockDetails): boolean; override;
    function Field(FieldName: string; ForDisplay: Boolean = False): variant; override;
    function OpenData: integer; override;
    procedure SetBounds; override;
    procedure GetRecord;
    property Command[DatasetID: integer]: string read GetCommand write SetCommand;
  published
    property ConnectionString: string read fConnectionString write SetConnectionString;
    property Database: string read fDatabase write fDatabase;
    property Filter: string read fFilter write fFilter;
    property Password: string read fPassword write SetPassword;
    property ReturnAllFields: boolean read fReturnAllFields write fReturnAllFields default false;
    property SelectFields: string read FSelectFields write SetSelectFields;
    property ServerAlias: string read fServerAlias write fServerAlias;
    property TableName: string read fTableName write fTableName;
    property UserName: string read fUserName write SetUserName;
    property OnGetDisplayValue: TGetDisplayValueEvent read fOnGetDisplayValue write fOnGetDisplayValue;
    property OnGetFieldValue: TGetFieldValueEvent read fOnGetFieldValue write fOnGetFieldValue;
    property OnSelectRecord: TNotifyEvent read fOnSelectRecord write fOnSelectRecord;
    property PrimaryKey;
    property UseWindowsAuthentication: Boolean read FUseWindowsAuthentication write SetUseWindowsAuthentication;
  end;

procedure Register;

implementation

type
  TWhereClause = record
    LeftSide: string;
    Operator: string;
    RightSide: string;
    Concatenator: string;
  end;

// -----------------------------------------------------------------------------

procedure Register;
begin
  RegisterComponents('SBS', [TSQLDatasets]);
end;

// -----------------------------------------------------------------------------

constructor TSQLDatasets.Create(AOwner: TComponent);
begin
  inherited;

  SetLength(fRecCount, 1);
  SetLength(fStatus, 1);

  fFieldList  := TStringList.Create;
  fConnection := TADOConnection.Create(nil);
  fTable      := TADOTable.Create(nil);
  fQuery      := TADOQuery.Create(nil);

  fPositionID := -1;
  fDebugging := False;
end;

// -----------------------------------------------------------------------------

function TSQLDatasets.FreeDataset(DatasetID: integer): integer;
begin
  Result := 0;
  if Assigned(fDataset) then
  try
    fDataset.Close;
  except
    Result := -1;
  end;
end;

// -----------------------------------------------------------------------------

destructor TSQLDatasets.Destroy;
begin
  FreeAndNil(fFieldList);
  fTable.Close;
  FreeAndNil(fTable);
  fQuery.Close;
  FreeAndNil(fQuery);
  fConnection.Close;
  FreeAndNil(fConnection);
  inherited;
end;

// -----------------------------------------------------------------------------

function TSQLDatasets.GetSQLConnection(SQLServerName, SQLDatabase, SQLUserName, SQLPassword: string): integer;
begin
  Result:= 0;
  if Assigned(fConnection) then
  try
    fConnection.Close;
    if UseWindowsAuthentication then
      fConnection.ConnectionString := Format('Provider=SQLOLEDB.1;' +
                                             'Integrated Security=SSPI;' +
                                             'Initial Catalog=%s;' +
                                             'Data Source=%s',
                                             [SQLDatabase,
                                              SQLServerName])
    else
      fConnection.ConnectionString := Format('Provider=SQLOLEDB.1;' +
                                             'Password=%s;' +
                                             'User ID=%s;' +
                                             'Initial Catalog=%s;' +
                                             'Data Source=%s',
                                             [SQLPassword,
                                              SQLUserName,
                                              SQLDatabase,
                                              SQLServerName]);
    fConnection.LoginPrompt:= false;
    fConnection.Open;
  except
    Result := -1;
  end;
end;

// -----------------------------------------------------------------------------

function TSQLDatasets.PrepareTable: integer;
var
  ConnectionIndex: integer;
begin
  Result := 0;
  if Assigned(fDataset) then
  begin
    fDataset.Close;
    fDataset := nil;
  end;
  if Assigned(fConnection) then
  try
    ConnectionIndex := GetSQLConnection(fServerAlias, fDatabase, fUserName, fPassword);
    if ConnectionIndex >= 0 then
    begin
      fTable.Connection := fConnection;
      fTable.TableName := fTableName;
      SetLength(fRecCount, 1);
      SetLength(fStatus, 1);
      SetRecCount(0, 0);
      SetStatus(0, 12);
      fTable.Open;
      fDataset := fTable;
    end;
  except
    Result := -2;
  end;
end;

// -----------------------------------------------------------------------------

function TSQLDatasets.PrepareQuery: integer;
var
  ConnectionIndex: integer;
begin
  Result := 0;
  if Assigned(fDataset) then
  begin
    fDataset.Close;
    fDataset := nil;
  end;
  if Assigned(fConnection) then
  try
    ConnectionIndex := GetSQLConnection(fServerAlias, fDatabase, fUserName, fPassword);
    if ConnectionIndex >= 0 then
    begin
      fQuery.Connection := fConnection;
      fQuery.Sql.Add('select top 1 ' + fPrimaryKey + ' from ' + fTableName + ' ');
      SetLength(fRecCount, 1);
      SetLength(fStatus, 1);
      SetRecCount(0, 0);
      SetStatus(0, 12);
      fQuery.Open;
      fDataset := fQuery;
    end;
  except
    Result := -2
  end;
end;

// -----------------------------------------------------------------------------

function TSQLDatasets.GetBlock(DatasetID: integer; BlockDetails: TBlockDetails): boolean;
var
  KeyValueStr, SortValueStr, FilterStr, WhereClause, GreaterLess, RefreshEquals, DESCer, OrderBy: string;
  PrimarySort: boolean;
  SortValueVar: Variant;
  SortQryKey: string;
begin
  {This function is used to prepare a relational resultset from its parameters;
   The individual records are then stepped through using the GetBlockNext/Prior
   commands and the data retrieved using the Field function;

   The result indicates to the caller whether the end of the resultset has been
   reached; If it has, the order is toggled to retrieve the necessary records
   using the TOP command; The caller will need to display the records in reverse;

   Sorting in this function is used solely to retrieve the correct resultset
   given the constraints using TOP; Because of this, the caller may need to
   traverse the resultset in reverse, or apply their own sorting mechanism;}

  Result:= false;

  with BlockDetails, fDataSet do
  try
    { Convert the key and sort value from their variant representation to a
      string for use in the SQL command }
    KeyValueStr := ConvertVariant(FieldByName(PrimaryKey).DataType, KeyValue);
    if Assigned(FOnGetFieldValue) then
    begin
      if Searching then
      begin
        if FieldByName(SortKey).DataType in [ftString, ftFixedChar, ftWideString] then
          SortValueStr := QuotedStr(SortValue)
        else
          SortValueStr := SortValue;
      end
      else
      begin
        SortValueVar := SortValue;
        if FieldByName(SortKey).DataType in [ftString, ftFixedChar, ftWideString] then
          SortValueStr := QuotedStr(SortValueVar)
        else
          SortValueStr := SortValueVar;
      end;
    end
    else
      SortValueStr:= ConvertVariant(FieldByName(SortKey).DataType, SortValue);

    {If we are scrolling down the resultset, we want records with key/sort values
     greater than the key/sort values passed in, so GreaterLess is set to >; And
     v.v.; If we are refreshing the dataset we append an equals to GreaterLess to
     return the same resultset instead of scrolling; Also, for the TOP command
     to work with key/sort values greater than those of the records we want to
     retrieve, we need to retrieve the top x values in reverse order, so DESCer
     is set to ' desc '; SQLServer does not like repetition of field names in the
     order by clause, so the clause must take into account whether the sortkey
     and the primary key are the same; Finally, the where clause is loaded with
     any filter conditions;}

    WhereClause:= '';
    PrimarySort:= SortKey = PrimaryKey;
    if fReturnAllFields then
      FieldNames:= '*'
    else if (SelectFields <> '') then
      FieldNames := SelectFields
    else
      FieldNames := BlockDetails.FieldNames;

    InitFieldList(FieldNames);

    if ScrollDown then
      GreaterLess:= ' >'
    else
      GreaterLess:= ' <';

    if Refreshing then
      RefreshEquals:= '= '
    else
      RefreshEquals:= ' ';

    if ScrollDown then
      DESCer:= ''
    else
      DESCer:= ' desc ';

    if (FieldByName(SortKey).DataType in [ftFloat]) then
      SortQryKey := '(ROUND(' + SortKey + ', 6))'
    else
      SortQryKey := SortKey;

    if PrimarySort then OrderBy:= ' order by ' + PrimaryKey + DESCer
    else OrderBy:= ' order by ' + SortQryKey + DESCer + ', ' + PrimaryKey + DESCer;
    if fFilter <> '' then
    begin
      WhereClause:= ' where (' + fFilter + ')';
    end;

    PrimarySort:= PrimarySort and not(Searching);

    {If no keyvalue has been provided, the first or last block of values is
     required by the caller so no extra conditions are added;}

    if VarIsClear(KeyValue) then
      Command[DatasetID]:= 'select top ' + IntToStr(RecCount) + ' ' + FieldNames + ' from ' + fTableName + ' ' + WhereClause + OrderBy
    else
    begin
      {Otherwise, build the where clause to obtain the correct block; We retrieve
       all the records with SortKey values greater (or less) than the SortValue;
       If we are searching retrieve all records satisfying the search criteria,
       but if we are scrolling, we use the KeyValue on a unique index in
       conjunction with the SortValue to ensure no duplicate records are returned;}

      WhereClause:= '';

      if Searching then
        WhereClause := GetSearchWhere(FieldByName(SortKey).DataType,
                                      SortKey, GreaterLess, SortValueStr,
                                      fFilter)
      else
      begin
        if fFilter <> '' then
          FilterStr:= ' and (' + fFilter + ') ';
        if PrimarySort then
          WhereClause := ' where (' + PrimaryKey + GreaterLess + RefreshEquals + KeyValueStr + ') ' + FilterStr
        else
          WhereClause := ' where ((' + SortQryKey + ' = ' + SortValueStr + ' and ' + PrimaryKey + GreaterLess + RefreshEquals + KeyValueStr + ') or ' + SortQryKey + GreaterLess + SortValueStr + ') ' + FilterStr;
      end;

      Command[DatasetID]:= 'select top ' + IntToStr(RecCount) + ' ' + FieldNames + ' from ' + fTableName + WhereClause + OrderBy;

      {If the number of records returned in RecordCount do not match the number
       requested in RecCount, the end (or beginning) of the resultset has been
       reached; Abandon the resultset, restore the filter conditions, and retrieve
       the last (or first) block; Doing this involves toggling the sort order,
       so the caller needs to be notified the recordset is being returned in
       reverse;}

      if RecordCount < RecCount then
      begin
        Result:= true;
        if DESCer = ' desc ' then DESCer:= '' else DESCer:= ' desc ';
        if SortKey = PrimaryKey then OrderBy:= ' order by ' + PrimaryKey + DESCer
        else OrderBy:= ' order by ' + SortQryKey + DESCer + ', ' + PrimaryKey + DESCer;
        if fFilter <> '' then WhereClause:= ' where (' + fFilter + ')' else WhereClause:= '';

        Command[DatasetID]:= 'select top ' + IntToStr(RecCount) + ' ' + FieldNames + ' from ' + fTableName + WhereClause + OrderBy;
      end;
    end;

    {Set the RecCount so that callers can iterate through the resultset;}
    SetRecCount(DatasetID, RecordCount);
  except

  end;
end;

// -----------------------------------------------------------------------------

function TSQLDatasets.ConvertVariant(FieldType: TFieldType; VariantValue: variant): string;
begin
  { Converts variant test values to strings suitable for insertion into SQL
    statements as predicates;}
  case VarType(VariantValue) of
    varString, varOleStr:
    begin
      if FieldType in [ftString, ftFixedChar, ftWideString] then Result:= QuotedStr(VariantValue)
      else if FieldType in [ftAutoInc, ftSmallint, ftInteger, ftWord, ftLargeint] then Result:= VariantValue
      else if FieldType in [ftDate, ftTime, ftDateTime, ftTimeStamp] then Result:= '''' + FormatDateTime('yyyy-mm-dd hh:nn:ss', VariantValue) + ''''
      else Result:= VariantValue;
    end;
    varNull:
    begin
      if FieldType in [ftString, ftFixedChar, ftWideString] then Result:= ''''''
      else if FieldType in [ftAutoInc, ftSmallint, ftInteger, ftWord, ftLargeint] then Result:= '0'
      else if FieldType in [ftDate, ftTime, ftDateTime, ftTimeStamp] then Result:= '''' + FormatDateTime('yyyy-mm-dd hh:nn:ss', 0) + ''''
      else Result:= VariantValue;
    end;
    varSmallInt, VarInteger, varShortInt, varWord, varLongWord, varInt64: Result:= IntToStr(VariantValue);
    varSingle, varDouble: Result:= FormatFloat('0.000000', VariantValue);
    varCurrency: Result:= CurrToStr(VariantValue);
    varDate: Result:= '''' + FormatDateTime('yyyy-mm-dd hh:nn:ss', VariantValue) + '''';
    varBoolean: Result:= BoolToStr(VariantValue);
  end;
end;

// -----------------------------------------------------------------------------

function TSQLDatasets.GetSearchWhere(DataType: TFieldType; SortKey, GreaterLess, SortValueStr, FilterStr: string): string;
type
  TFilterState = (fsLeftSide, fsOperator, fsRightSide, fsConcatenator);
var
  CharIndex, CharIndex2, KeyPos, BracketPos: integer;
  WhereClauses: array of TWhereClause;
  BuildStr, Bracket: string;
  SpaceFound, Greater, Proceed: boolean;
  FilterState: TFilterState;

  // ...........................................................................
  procedure EliminateSpaces(Beyond: boolean);
  begin
    {Eliminate the spaces after open brackets and before close brackets;}
    if Beyond then inc(BracketPos) else dec(BracketPos);
    if (BracketPos = 0) or (BracketPos > Length(FilterStr)) then Exit;
    while FilterStr[BracketPos] = ' ' do
    begin
      Delete(FilterStr, BracketPos, 1);
      if (BracketPos = 0) or (BracketPos > Length(FilterStr)) then Exit;
    end;
  end;
  // ...........................................................................
  procedure BuildWhereClauses;
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    procedure AddWhereWord(Finished: boolean);
    begin
      {Add a where word to the where record from using the BuildStr; Change the
       FilterState and ensure memory is allocated for WhereRecs if a record is
       complete;}
      case FilterState of
        fsLeftSide:
        begin
          WhereClauses[High(WhereClauses)].LeftSide:= BuildStr;
          FilterState:= fsOperator;
        end;
        fsOperator:
        begin
          WhereClauses[High(WhereClauses)].Operator:= BuildStr;
          FilterState:= fsRightSide;
        end;
        fsRightSide:
        begin
          WhereClauses[High(WhereClauses)].RightSide:= BuildStr;
          FilterState:= fsConcatenator;
        end;
        fsConcatenator:
        begin
          WhereClauses[High(WhereClauses)].Concatenator:= BuildStr;
          if not Finished then SetLength(WhereClauses, Length(WhereClauses) + 1);
          FilterState:= fsLeftSide;
        end;
      end;
    end;
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  begin
    SetLength(WhereClauses, 1);
    BuildStr:= '';
    CharIndex:= 1;
    SpaceFound:= false;

    {Move through the FilterString;}
    while CharIndex <= Length(FilterStr) do
    begin
      {The last character must cause a record write; Spaces indicate the need
       for a record write, ignore multiple spaces;}

      if CharIndex = Length(FilterStr) then
      begin
        BuildStr:= BuildStr + FilterStr[CharIndex];
        SpaceFound:= true;
        inc(CharIndex);
      end
      else while FilterStr[CharIndex] = ' ' do
      begin
        SpaceFound:= true;
        inc(CharIndex);
      end;

      {If we have a space, load the record array according to the current filter
       state, otherwise continue building the build string;}

      if SpaceFound then
      begin
        SpaceFound:= false;
        if CharIndex >= Length(FilterStr) then AddWhereWord(true) else AddWhereWord(false);
        BuildStr:= '';
      end
      else
      begin
        BuildStr:= BuildStr + FilterStr[CharIndex];
        inc(CharIndex);
      end;
    end;
  end;
  // ...........................................................................
  procedure ReconcileFilter;
  var
  ClauseIndex: integer;
  begin
    Greater:= Pos('>', GreaterLess) <> 0;

    { Find the SortKey on the left side of a filter clause. This left side may
      contain a single bracket at most }
    for ClauseIndex:= Low(WhereClauses) to High(WhereClauses) do with WhereClauses[ClauseIndex] do
    begin
      if (Pos(UpperCase(SortKey), UpperCase(LeftSide)) <> 0) and (Length(SortKey) >= Length(LeftSide) - 1) then
      begin
        if Pos(RightSide, ')') <> 0 then Bracket:= ')' else Bracket:= '';

        case DataType of
          ftString, ftWideString, ftFixedChar:
          begin
            if Greater and (SortValueStr > RightSide) then
            begin
              RightSide:= SortValueStr + Bracket;
              if Pos('=', Operator) = 0 then Operator:= Operator + '=';
            end
            else if not(Greater) and (SortValueStr < RightSide) then
            begin
              RightSide:= SortValueStr + Bracket;
              if Pos('=', Operator) = 0 then Operator:= Operator + '=';
            end;
          end
          else
          begin
            if Greater and (StrToFloat(SortValueStr) > StrToFloat(RightSide)) then
            begin
              RightSide:= SortValueStr + Bracket;
              if Pos('=', Operator) = 0 then Operator:= Operator + '=';
            end
            else if not(Greater) and (StrToFloat(SortValueStr) < StrToFloat(RightSide)) then
            begin
              RightSide:= SortValueStr + Bracket;
              if Pos('=', Operator) = 0 then Operator:= Operator + '=';
            end;
          end;
        end;

        Break;
      end;
    end;
  end;
  // ...........................................................................
  procedure ReconstituteFilter;
  var
  ClauseIndex: integer;
  begin
    FilterStr := '';
    for ClauseIndex:= Low(WhereClauses) to High(WhereClauses) do
    with WhereClauses[ClauseIndex] do
    begin
      FilterStr := FilterStr + LeftSide + ' ';
      FilterStr := FilterStr + Operator + ' ';
      FilterStr := FilterStr + RightSide + ' ';
      FilterStr := FilterStr + Concatenator + ' ';
    end;
  end;
  // ...........................................................................
begin
//  if DataType in [ftString, ftFixedChar, ftWideString] then
//    SortValueStr := QuotedStr(SortValueStr);

  if FilterStr <> '' then
    Result:= ' where (' + SortKey + ' ' + Trim(GreaterLess) + '= ' + SortValueStr + ') and (' + FilterStr + ')'
  else
    Result:= ' where (' + SortKey + ' ' + Trim(GreaterLess) + '= ' + SortValueStr + ')';

  {Exit conditions; Get out if there is no filter or the column we are searching
   on is not part of the filter, or there are brackets or an or clause;}
  if FilterStr = '' then
    Exit;

  KeyPos:= Pos(UpperCase(SortKey), UpperCase(FilterStr));
  if KeyPos = 0 then
    Exit;

  if (Pos(' OR ', UpperCase(FilterStr)) <> 0) or (Pos('(', FilterStr) <> 0) or (Pos(')', FilterStr) <> 0) then
    Exit;

  {Also get out if the filter does not restrict the resultset to those values
   greater than a certain value; In these cases, the where clause is already
   optimised;}
  Proceed:= false;
  for CharIndex:= KeyPos to Length(FilterStr) do
  begin
    if UpperCase(Copy(FilterStr, CharIndex, Length(SortKey))) = UpperCase(SortKey) then
    begin
      CharIndex2:= CharIndex;
      while FilterStr[CharIndex2] <> ' ' do inc(CharIndex2);
      while FilterStr[CharIndex2] = ' ' do inc(CharIndex2);
      if FilterStr[CharIndex2] = '>' then
      begin
        Proceed:= true;
        Break;
      end;
    end;
  end;
  if not Proceed then Exit;

  {Eliminate the spaces after open brackets and before close brackets;}
  for CharIndex:= 1 to Length(FilterStr) do
  begin
    BracketPos:= CharIndex;
    if (FilterStr[CharIndex] = '(') then EliminateSpaces(true)
    else if (FilterStr[CharIndex] = ')') then EliminateSpaces(false);
  end;

  BuildWhereClauses;
  ReconcileFilter;
  ReconstituteFilter;

  Result:= ' where (' + FilterStr + ') ';
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.GetBlockFirst(DatasetID: integer);
begin
  SetStatus(0, -1);
  if Assigned(fDataset) then
  try
    fDataset.First;
    if fDataset.BOF or fDataset.EOF then
      SetStatus(0, 9)
    else
      SetStatus(0, 0);
  except

  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.GetBlockPrior(DatasetID: integer);
begin
  SetStatus(0, -1);
  if Assigned(fDataset) then
  try
    fDataset.Prior;
    if fDataset.BOF or fDataset.EOF then
      SetStatus(0, 9)
    else
      SetStatus(0, 0);
  except

  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.GetBlockNext(DatasetID: integer);
begin
  SetStatus(0, -1);
  if Assigned(fDataset) then
  try
    fDataset.Next;
    if fDataset.BOF or fDataset.EOF then
      SetStatus(0, 9)
    else
      SetStatus(0, 0);
  except

  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.GetBlockLast(DatasetID: integer);
begin
  SetStatus(0, -1);
  if Assigned(fDataset) then
  try
    fDataset.Last;
    if fDataset.BOF or fDataset.EOF then
      SetStatus(0, 9)
    else
      SetStatus(0, 0);
  except

  end;
end;

// -----------------------------------------------------------------------------

function TSQLDatasets.Field(FieldName: string; ForDisplay: Boolean): variant;
var
  ColIndex: integer;
  Temp: string;
begin
  VarClear(Result);
  if Assigned(fDataset) then
  try
    if ForDisplay and Assigned(FOnGetDisplayValue) then
      OnGetDisplayValue(self, fDataset, FieldName, Result)
    else if Assigned(FOnGetFieldValue) then
      OnGetFieldValue(self, fDataset, FieldName, Result)
    else
      Result:= fDataset.FieldByName(FieldName).AsVariant;
  except

  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.SelectRecord(SelectType: TSelectType; RecordNo: integer);
begin
  fPositionID := RecordNo;
  if Assigned(OnSelectRecord) then OnSelectRecord(Self);
end;

// -----------------------------------------------------------------------------

function TSQLDatasets.GetCommand(DatasetID: integer): string;
var
  SQLIndex: integer;
begin
  Result:= '';
  try
    if Assigned(fDataSet) then
    try
      if fDataset is TADOTable then
        Result:= TADOTable(fDataset).TableName
      else if fDataset is TADOQuery then
      with TADOQuery(fDataset) do
      begin
        for SQLIndex:= 0 to Sql.Count - 1 do Result:= Result + Sql[SQLIndex];
      end;
    except

    end;
  except

  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.SetCommand(DatasetID: integer; NewCommand: string);
var
  DebugFile: TextFile;
begin
  if Assigned(fDataSet) then
  try
    if fDebugging then
    begin
      AssignFile(DebugFile, 'C:\Debug.txt');
      if FileExists('C:\Debug.txt') then System.Append(DebugFile) else Rewrite(DebugFile);
      WriteLn(DebugFile, FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + ',' + NewCommand + ',');
    end;

    fDataset.Close;

    if (fDataset is TADOTable) then
    begin
      TADOTable(fDataset).TableName := NewCommand;
    end
    else if (fDataset is TADOQuery) then
    begin
      TADOQuery(fDataset).Sql.Clear;
      TADOQuery(fDataset).Sql.Add(NewCommand);
    end;

    fDataset.Open;
    fDataset.First;

    if fDebugging then
    begin
      WriteLn(DebugFile, FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + ',' + NewCommand + ',');
      CloseFile(DebugFile);
    end;

  except
    Showmessage('Error processing "' + NewCommand + '"');
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.SetSearchIndex(NewIndex: byte);
begin
  { }
end;

// -----------------------------------------------------------------------------

function TSQLDatasets.OpenData: integer;
var
  DatasetType: TDatasetType;
  FuncRes: Integer;
begin
  Result := -2;
  DatasetType := dtResultSet;
  if (PrimaryKey = '') then
  begin
    PrimaryKey := 'PositionID';
    if (SelectFields <> '') and (Pos(PrimaryKey, SelectFields) = 0) then
      SelectFields := PrimaryKey + ', ' + SelectFields;
  end;
  FuncRes := Authenticate(Password);
  if FuncRes = 0 then
  try
    case DatasetType of
      dtCursor: FuncRes := PrepareTable;
      dtResultset: FuncRes := PrepareQuery;
    end;
    Result := FuncRes;
    Open := (Result = 0);
    Assert(Open, 'Failed to open data set');
  except
    Result := -2;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.SetBounds;
begin
  { }
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.SetSelectFields(const Value: string);
begin
  FSelectFields := Value;
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.InitFieldList(const FieldNames: string);
var
  CharIndex: integer;
  FieldName: string;
begin
  fFieldList.Clear;
  FieldName:= '';

  for CharIndex:= 1 to Length(FieldNames) do
  begin
    if FieldNames[CharIndex] = ',' then
    begin
      fFieldList.Add(FieldName);
      FieldName:= '';
    end
    else if FieldNames[CharIndex] <> #32 then FieldName:= FieldName + FieldNames[CharIndex];
  end;

  if (FieldName <> '') then
    fFieldList.Add(FieldName);
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.SetUseWindowsAuthentication(const Value: Boolean);
begin
  FUseWindowsAuthentication := Value;
  if FUseWindowsAuthentication then
  begin
    Username := '';
    Password := '';
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.SetPassword(const Value: string);
begin
  fPassword := Value;
  if (fPassword <> '') then
  begin
    UseWindowsAuthentication := False;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.SetUserName(const Value: string);
begin
  fUserName := Value;
  if (fUsername <> '') then
  begin
    UseWindowsAuthentication := False;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.SetConnectionString(const Value: string);
begin
  fConnectionString := Value;
  ParseConnectionString;
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.ParseConnectionString;
type
  TParseState = (psKey, psValue);
var
  Key, Value: string;
  i: Integer;
  ParseState: TParseState;
begin
  ParseState := psKey;
  for i := 1 to Length(fConnectionString) do
  begin
    if ((fConnectionString[i] = ';') or (i = Length(fConnectionString))) then
    begin
      if (i = Length(fConnectionString)) then
        Value := Value + fConnectionString[i];
      if (Key = '') then
        raise Exception.Create('Invalid connection string');
      Key := Lowercase(Key);
      if (Key = 'initial catalog') then
        fDatabase := Value
      else if (Key = 'user id') then
        fUserName := Value
      else if (Key = 'password') then
        fPassword := Value
      else if (Key = 'data source') then
        fServerAlias := Value;
      fUseWindowsAuthentication := (fUserName = '');
      // Reset ready for next key/value pair
      ParseState := psKey;
      Key := '';
      Value := '';
    end
    else if (fConnectionString[i] = '=') then
    begin
      ParseState := psValue;
    end
    else
    begin
      case ParseState of
        psKey: Key := Key + fConnectionString[i];
        psValue: Value := Value + fConnectionString[i];
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSQLDatasets.GetRecord;
var
  Qry: string;
begin
  if Assigned(fDataset) and (fPositionID <> -1) then
    fDataset.Locate('PositionID', fPositionID, []);
end;

end.

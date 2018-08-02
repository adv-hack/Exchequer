unit uSQLDatasets;

      {Nulls?

      if VarType(SortValue) = varNull then
      begin
        if WhereClause = '' then WhereClause:= ' where ' + '(' + SortKey + ' is null ' + notSearchingStr + ') or ' + SortKey + ' is not null '
        else WhereClause:= WhereClause + ' and ' + '((' + SortKey + ' is null ' + notSearchingStr + ') or ' + SortKey + ' is not null) ';
      end
      else
      begin}

interface

uses
  Classes, SysUtils, uExDatasets, MSAccess, pvsqltables, DB, pvtables, btvtables,
  sqldataset, Variants, Dialogs;

type
  TShapeList = (Rectangle, Triangle, Circle, Ellipse, Other);

  TFigure = record
  case TShapeList of
    Rectangle: (Height, Width: Real);
    Triangle: (Side1, Side2, Angle: Real);
    Circle: (Radius: Real);
    Ellipse, Other: ();
  end;

  TSQLDatasets = class(TExDatasets)
  private
    fConnxns: TStringList;
    fDebugging: boolean;

    fDBType: TDBType;
    fDatabase: string;
    fFilter: string;
    fPassword: string;
    fReturnAllFields: boolean;
    fServerAlias: string;
    fTableName: string;
    fUserName: string;

    fOnSelectRecord: TNotifyEvent;
    procedure SetCommand(DatasetID: integer; NewCommand: string);
    function FreeConnxn(ConnxnIndex: integer): integer;
    function CreatePVTable: integer;
    function CreatePVQuery: integer;
    function CreateMSTable: integer;
    function CreateMSQuery: integer;
    function GetPSQLConnxn1(PSQLAliasName, PSQLUserName, PSQLPassword: string): integer;
    function GetPSQLConnxn2(PSQLAliasName, PSQLUserName, PSQLPassword: string): integer;
    function GetSQLConnxn(SQLServerName, SQLDatabase, SQLUserName, SQLPassword: string): integer;
    function GetSearchWhere(DataType: TFieldType; SortKey, GreaterLess, SortValueStr, FilterStr: string): string;
    function GetCommand(DatasetID: integer): string;
    function ConvertVariant(FieldType: TFieldType; VariantValue: variant): string;
  protected
    function FreeDataset(DatasetID: integer): integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetBlockFirst(DatasetID: integer); override;
    procedure GetBlockPrior(DatasetID: integer); override;
    procedure GetBlockNext(DatasetID: integer); override;
    procedure GetBlockLast(DatasetID: integer); override;
    procedure SelectRecord(SelectType: TSelectType; RecordNo: integer); override;
    function Open: integer; override;
    function GetBlock(DatasetID: integer; BlockDetails: TBlockDetails): boolean; override;
    function Field(DatasetID: integer; FieldName: string): variant; override;
    property Command[DatasetID: integer]: string read GetCommand write SetCommand;
  published
    property Database: string read fDatabase write fDatabase;
    property DBType: TDBType read fDBType write fDBType default dbPervasive;
    property Filter: string read fFilter write fFilter;
    property Password: string read fPassword write fPassword;
    property PrimaryKey: string read fPrimaryKey write fPrimaryKey;
    property ReturnAllFields: boolean read fReturnAllFields write fReturnAllFields default false;
    property ServerAlias: string read fServerAlias write fServerAlias;
    property TableName: string read fTableName write fTableName;
    property UserName: string read fUserName write fUserName;
    property OnSelectRecord: TNotifyEvent read fOnSelectRecord write fOnSelectRecord;
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

procedure Register;
begin
  RegisterComponents('SBS', [TSQLDatasets]);
end;

//*** Startup and Shutdown *****************************************************

constructor TSQLDatasets.Create(AOwner: TComponent);
var
Figure: TFigure;
begin
  inherited;

  Figure.Height:= 9;
  Figure.Angle:= 5;

  fConnxns:= TStringList.Create;
end;

function TSQLDatasets.FreeDataset(DatasetID: integer): integer;
begin
  {Datasets are freed from their indexed location in the associated list;}

  Result:= -1;

  if Assigned(fDatasets) then with fDatasets do
  try
    if Assigned(Objects[DatasetID]) then
    try

      if Objects[DatasetID] is TPVTable then with TPVTable(Objects[DatasetID]) do
      begin
        Close;
        Free;
      end
      else if Objects[DatasetID] is TMSTable then with TMSTable(Objects[DatasetID]) do
      begin
        Close;
        Free;
      end
      else if Objects[DatasetID] is TPVQuery then with TPVQuery(Objects[DatasetID]) do
      begin
        Close;
        Free;
      end
      else if Objects[DatasetID] is TMSQuery then with TMSQuery(Objects[DatasetID]) do
      begin
        Close;
        Free;
      end;

      Result:= 0;

    except
    end;
  except
  end;
end;

destructor TSQLDatasets.Destroy;
var
ItemsIndex: integer;
begin
  {}

  try

    if Assigned(fConnxns) then
    begin
      for ItemsIndex:= 0 to fConnxns.Count - 1 do FreeConnxn(ItemsIndex);
      FreeAndNil(fConnxns);
    end;

  except
  end;

  inherited;
end;

//*** Connxn Startup and Shutdown **********************************************

function TSQLDatasets.GetPSQLConnxn1(PSQLAliasName, PSQLUserName, PSQLPassword: string): integer;
begin
  {}

  Result:= -1;
  if Assigned(fConnxns) then with fConnxns do
  try

    if IndexOf('PSQL1' + PSQLAliasName) < 0 then
    begin
      AddObject('PSQL1' + PSQLAliasName, TPVDatabase.Create(Self));
      with Objects[Count - 1] as TPVDatabase do
      begin
        Session.SQLHourGlass:= false;
        DatabaseName:= 'PSQL1' + PSQLAliasName;
        AliasName:= PSQLAliasName;
        if PSQLUserName <> '' then with Params do
        begin
          Clear;
          Add('USER NAME=' + PSQLUserName);
          Add('PASSWORD=' + PSQLPassword);
        end;
        LoginPrompt:= false;
        Open;
      end;
    end;
    Result:= IndexOf('PSQL1' + PSQLAliasName);

  except
  end;
end;

function TSQLDatasets.GetPSQLConnxn2(PSQLAliasName, PSQLUserName, PSQLPassword: string): integer;
begin
  {}

  Result:= -1;
  if Assigned(fConnxns) then with fConnxns do
  try

    if IndexOf('PSQL2' + PSQLAliasName) < 0 then
    begin
      AddObject('PSQL2' + PSQLAliasName, TPVSQLDatabase.Create(Self));
      if Assigned(Objects[Count - 1]) then with Objects[Count - 1] as TPVSQLDatabase do
      begin
        Session.SQLHourGlass:= false;
        DatabaseName:= 'PSQL2' + PSQLAliasName;
        AliasName:= PSQLAliasName;
        if PSQLUserName <> '' then with Params do
        begin
          Clear;
          Add('USER NAME=' + PSQLUserName);
          Add('PASSWORD=' + PSQLPassword);
        end;
        LoginPrompt:= false;
        Open;
      end;
    end;
    Result:= IndexOf('PSQL2' + PSQLAliasName);

  except
  end;
end;

function TSQLDatasets.GetSQLConnxn(SQLServerName, SQLDatabase, SQLUserName, SQLPassword: string): integer;
begin
  {}

  Result:= -1;
  if Assigned(fConnxns) then with fConnxns do
  try

    if IndexOf(SQLServerName) < 0 then
    begin
      AddObject(SQLServerName, TMSConnection.Create(Self));
      if Assigned(Objects[Count - 1]) then with Objects[Count - 1] as TMSConnection do
      begin
        Server:= SQLServerName;
        Database:= SQLDatabase;
        UserName:= SQLUserName;
        Password:= SQLPassword;
        LoginPrompt:= false;
        Open;
      end;
    end;
    Result:= IndexOf(SQLServerName);

  except
  end;
end;

function TSQLDatasets.FreeConnxn(ConnxnIndex: integer): integer;
begin
  Result:= -1;
  if Assigned(fConnxns) then with fConnxns do
  try

    if (ConnxnIndex < Count) and Assigned(Objects[ConnxnIndex]) then with Objects[ConnxnIndex] as TCustomConnection do
    begin
      Close;
      Free;
    end;
    Result:= 0;

  except
  end;
end;

//*** Dataset Startup **********************************************************

function TSQLDatasets.Open: integer;
var
DatasetType: TDatasetType;
begin
  {}

  DatasetType:= dtResultSet;

  Result:= Authenticate(Password);
  if Result = 0 then
  try

    case DBType of
      dbPervasive:
      case DatasetType of
        dtCursor: Result:= CreatePVTable;
        dtResultset: Result:= CreatePVQuery;
      end;
      dbMSSQL:
      case DatasetType of
        dtCursor: Result:= CreateMSTable;
        dtResultset: Result:= CreateMSQuery;
      end;
    end;

  except
    Result:= -2;
  end;
end;

function TSQLDatasets.CreatePVTable: integer;
var
ConnxnIndex: integer;
begin
  {}

  Result:= -2;
  if Assigned(fDatasets) then with fDatasets do
  try

    ConnxnIndex:= GetPSQLConnxn1(fServerAlias, fUserName, fPassword);
    if ConnxnIndex >= 0 then
    begin
      AddObject('', TPVTable.Create(Self));
      if Assigned(Objects[Count - 1]) then with Objects[Count - 1] as TPVTable do
      begin
        DatabaseName:= 'PSQL1' + fServerAlias;
        TableName:= fTableName;
        SetLength(fRecCount, Count);
        SetLength(fStatus, Count);
        SetRecCount(Count - 1, 0);
        SetStatus(Count - 1, 12);
        Open;
      end;
      Result:= Count - 1;
      SetStatus(Count - 1, 0);
    end;

  except
  end;
end;

function TSQLDatasets.CreatePVQuery: integer;
var
ConnxnIndex: integer;
begin
  {}

  Result:= -2;
  if Assigned(fDatasets) then with fDatasets do
  try

    ConnxnIndex:= GetPSQLConnxn2(fServerAlias, fUserName, fPassword);
    if ConnxnIndex >= 0 then
    begin
      AddObject('', TPVQuery.Create(Self));
      if Assigned(Objects[Count - 1]) then with Objects[Count - 1] as TPVQuery do
      begin
        CursorType:= ctCached;
        DatabaseName:= 'PSQL2' + fServerAlias;
        Sql.Add('select top 1 ' + fPrimaryKey + ' from ' + fTableName + ' ');
        SetLength(fRecCount, Count);
        SetLength(fStatus, Count);
        SetRecCount(Count - 1, 0);
        SetStatus(Count - 1, 12);
        Open;
      end;
      Result:= Count - 1;
      SetStatus(Count - 1, 0);
    end;

  except
  end;
end;

function TSQLDatasets.CreateMSTable: integer;
var
ConnxnIndex: integer;
begin
  {}

  Result:= -2;
  if Assigned(fDatasets) then with fDatasets do
  try

    ConnxnIndex:= GetSQLConnxn(fServerAlias, fDatabase, fUserName, fPassword);
    if ConnxnIndex >= 0 then
    begin
      AddObject('', TMSTable.Create(Self));
      if Assigned(Objects[Count - 1]) then with Objects[Count - 1] as TMSTable do
      begin
        Connection:= TMSConnection(fConnxns.Objects[ConnxnIndex]);
        TableName:= fTableName;
        SetLength(fRecCount, Count);
        SetLength(fStatus, Count);
        SetRecCount(Count - 1, 0);
        SetStatus(Count - 1, 12);
        Open;
      end;
      Result:= Count - 1;
      SetStatus(Count - 1, 0);
    end;

  except
  end;
end;

function TSQLDatasets.CreateMSQuery: integer;
var
ConnxnIndex: integer;
begin
  {}

  Result:= -2;
  if Assigned(fDatasets) then with fDatasets do
  try

    ConnxnIndex:= GetSQLConnxn(fServerAlias, fDatabase, fUserName, fPassword);
    if ConnxnIndex >= 0 then
    begin
      AddObject('', TMSQuery.Create(Self));
      if Assigned(Objects[Count - 1]) then with Objects[Count - 1] as TMSQuery do
      begin
        Connection:= TMSConnection(fConnxns.Objects[ConnxnIndex]);
        Sql.Add('select top 1 ' + fPrimaryKey + ' from ' + fTableName + ' ');
        SetLength(fRecCount, Count);
        SetLength(fStatus, Count);
        SetRecCount(Count - 1, 0);
        SetStatus(Count - 1, 12);
        Open;
      end;
      Result:= Count - 1;
      SetStatus(Count - 1, 0);
    end;

  except
  end;
end;

//*** Retrieval ****************************************************************

function TSQLDatasets.GetBlock(DatasetID: integer; BlockDetails: TBlockDetails): boolean;
var
KeyValueStr, SortValueStr, FilterStr, WhereClause, GreaterLess, RefreshEquals, DESCer, OrderBy: string;
PrimarySort: boolean;
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

  if Assigned(fDatasets) and Assigned(fDataSets.Objects[DatasetID]) then with BlockDetails, fDataSets, Objects[DatasetID] as TDataset do
  try
    {Convert the key and sort value from their variant representation to a string
     for use in the SQL command;}

    KeyValueStr:= ConvertVariant(FieldByName(PrimaryKey).DataType, KeyValue);
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
    if fReturnAllFields then FieldNames:= '*';

    if ScrollDown then GreaterLess:= ' >' else GreaterLess:= ' <';
    if Refreshing then RefreshEquals:= '= ' else RefreshEquals:= ' ';
    if ScrollDown then DESCer:= '' else DESCer:= ' desc ';

    if PrimarySort then OrderBy:= ' order by ' + PrimaryKey + DESCer
    else OrderBy:= ' order by ' + SortKey + DESCer + ', ' + PrimaryKey + DESCer;
    if fFilter <> '' then WhereClause:= ' where (' + fFilter + ')';

    PrimarySort:= PrimarySort and not(Searching);

    {If no keyvalue has been provided, the first or last block of values is
     required by the caller so no extra conditions are added;}

    if VarIsClear(KeyValue) then Command[DatasetID]:= 'select top ' + IntToStr(RecCount) + ' ' + FieldNames + ' from ' + fTableName + ' ' + WhereClause + OrderBy
    else
    begin
      {Otherwise, build the where clause to obtain the correct block; We retrieve
       all the records with SortKey values greater (or less) than the SortValue;
       If we are searching retrieve all records satisfying the search criteria,
       but if we are scrolling, we use the KeyValue on a unique index in
       conjunction with the SortValue to ensure no duplicate records are returned;}

      WhereClause:= '';

      if Searching then WhereClause:= GetSearchWhere(FieldByName(SortKey).DataType, SortKey, GreaterLess, SortValueStr, fFilter)
      else
      begin
        if fFilter <> '' then FilterStr:= ' and (' + fFilter + ') ';
        if PrimarySort then WhereClause:= ' where (' + PrimaryKey + GreaterLess + RefreshEquals + KeyValueStr + ') ' + FilterStr
        else WhereClause:= ' where ((' + SortKey + ' = ' + SortValueStr + ' and ' + PrimaryKey + GreaterLess + RefreshEquals + KeyValueStr + ') or ' + SortKey + GreaterLess + SortValueStr + ') ' + FilterStr;
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
        else OrderBy:= ' order by ' + SortKey + DESCer + ', ' + PrimaryKey + DESCer;
        if fFilter <> '' then WhereClause:= ' where (' + fFilter + ')' else WhereClause:= '';

        Command[DatasetID]:= 'select top ' + IntToStr(RecCount) + ' ' + FieldNames + ' from ' + fTableName + WhereClause + OrderBy;
      end;
    end;

    {Set the RecCount so that callers can iterate through the resultset;}

    SetRecCount(DatasetID, RecordCount);
  except
  end;
end;

function TSQLDatasets.ConvertVariant(FieldType: TFieldType; VariantValue: variant): string;
begin
  {Converts variant test values to strings suitable for insertion into SQL
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
    varSingle, varDouble: Result:= FloatToStr(VariantValue);
    varCurrency: Result:= CurrToStr(VariantValue);
    varDate: Result:= '''' + FormatDateTime('yyyy-mm-dd hh:nn:ss', VariantValue) + '''';
    varBoolean: Result:= BoolToStr(VariantValue);
  end;
end;

function TSQLDatasets.GetSearchWhere(DataType: TFieldType; SortKey, GreaterLess, SortValueStr, FilterStr: string): string;
type
TFilterState = (fsLeftSide, fsOperator, fsRightSide, fsConcatenator);
var
CharIndex, CharIndex2, KeyPos, BracketPos: integer;
WhereClauses: array of TWhereClause;
BuildStr, Bracket: string;
SpaceFound, Greater, Proceed: boolean;
FilterState: TFilterState;

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

  procedure BuildWhereClauses;

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

  procedure ReconcileFilter;
  var
  ClauseIndex: integer;
  begin
    Greater:= Pos('>', GreaterLess) <> 0;

    {Find the SortKey on the left side of a filter clause; This left side may
     contain a single bracket at most;}
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

  procedure ReconstituteFilter;
  var
  ClauseIndex: integer;
  begin
    FilterStr:= '';

    for ClauseIndex:= Low(WhereClauses) to High(WhereClauses) do with WhereClauses[ClauseIndex] do
    begin
      FilterStr:= FilterStr + LeftSide + ' ';
      FilterStr:= FilterStr + Operator + ' ';
      FilterStr:= FilterStr + RightSide + ' ';
      FilterStr:= FilterStr + Concatenator + ' ';
    end;
  end;

begin
  if FilterStr <> '' then Result:= ' where (' + SortKey + ' ' + Trim(GreaterLess) + '= ' + SortValueStr + ') and (' + FilterStr + ')'
  else Result:= ' where (' + SortKey + ' ' + Trim(GreaterLess) + '= ' + SortValueStr + ')';

  {Exit conditions; Get out if there is no filter or the column we are searching
   on is not part of the filter, or there are brackets or an or clause;}
  if FilterStr = '' then Exit;
  KeyPos:= Pos(UpperCase(SortKey), UpperCase(FilterStr));
  if KeyPos = 0 then Exit;
  if (Pos(' OR ', UpperCase(FilterStr)) <> 0) or (Pos('(', FilterStr) <> 0) or (Pos(')', FilterStr) <> 0) then Exit;
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

procedure TSQLDatasets.GetBlockFirst(DatasetID: integer);
begin
  {}

  SetStatus(DatasetID, -1);

  if Assigned(fDatasets) and Assigned(fDataSets.Objects[DatasetID]) then with fDataSets, Objects[DatasetID] as TDataset do
  try

    First;
    if BOF or EOF then SetStatus(DatasetID, 9) else SetStatus(DatasetID, 0);

  except
  end;
end;

procedure TSQLDatasets.GetBlockPrior(DatasetID: integer);
begin                                                                 
  {}

  SetStatus(DatasetID, -1);

  if Assigned(fDatasets) and Assigned(fDataSets.Objects[DatasetID]) then with fDataSets, Objects[DatasetID] as TDataset do
  try

    Prior;
    if BOF or EOF then SetStatus(DatasetID, 9) else SetStatus(DatasetID, 0);

  except
  end;
end;

procedure TSQLDatasets.GetBlockNext(DatasetID: integer);
begin
  {}

  SetStatus(DatasetID, -1);

  if Assigned(fDatasets) and Assigned(fDataSets.Objects[DatasetID]) then with fDataSets, Objects[DatasetID] as TDataset do
  try

    Next;
    if BOF or EOF then SetStatus(DatasetID, 9) else SetStatus(DatasetID, 0);

  except
  end;
end;

procedure TSQLDatasets.GetBlockLast(DatasetID: integer);
begin
  {}

  SetStatus(DatasetID, -1);

  if Assigned(fDatasets) and Assigned(fDataSets.Objects[DatasetID]) then with fDataSets, Objects[DatasetID] as TDataset do
  try

    Last;
    if BOF or EOF then SetStatus(DatasetID, 9) else SetStatus(DatasetID, 0);

  except
  end;
end;

function TSQLDatasets.Field(DatasetID: integer; FieldName: string): variant;
begin
  {}

  VarClear(Result);
  if Assigned(fDatasets) and Assigned(fDataSets.Objects[DatasetID]) then with fDataSets, Objects[DatasetID] as TDataset do
  try

    Result:= FieldByName(FieldName).AsVariant;

  except
  end;
end;
    
procedure TSQLDatasets.SelectRecord(SelectType: TSelectType; RecordNo: integer);
begin
  if Assigned(OnSelectRecord) then OnSelectRecord(Self);
end;

function TSQLDatasets.GetCommand(DatasetID: integer): string;
var
SQLIndex: integer;
begin
  Result:= '';
  try

    if Assigned(fDataSets.Objects[DatasetID]) then with fDatasets do
    try

      if Objects[DatasetID] is TPVTable then Result:= TPVTable(Objects[DatasetID]).TableName
      else if Objects[DatasetID] is TMSTable then Result:= TMSTable(Objects[DatasetID]).TableName
      else if Objects[DatasetID] is TPVQuery then with TPVQuery(Objects[DatasetID]) do
      begin
        for SQLIndex:= 0 to Sql.Count - 1 do Result:= Result + Sql[SQLIndex];
      end
      else if Objects[DatasetID] is TMSQuery then with TMSQuery(Objects[DatasetID]) do
      begin
        for SQLIndex:= 0 to Sql.Count - 1 do Result:= Result + Sql[SQLIndex];
      end;

    except
    end;

  except
  end;
end;

procedure TSQLDatasets.SetCommand(DatasetID: integer; NewCommand: string);
var
DebugFile: TextFile;
begin
  if Assigned(fDataSets.Objects[DatasetID]) then with fDatasets do
  try

    //fDebugging:= true;

    if fDebugging then
    begin
      AssignFile(DebugFile, 'C:\Debug.txt');
      if FileExists('C:\Debug.txt') then System.Append(DebugFile) else Rewrite(DebugFile);
      WriteLn(DebugFile, FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + ',' + NewCommand + ',');
    end;

    if Objects[DatasetID] is TPVTable then with TPVTable(Objects[DatasetID]) do
    begin
      Close;
      TableName:= NewCommand;
      Open;
      First;
    end
    else if Objects[DatasetID] is TMSTable then with TMSTable(Objects[DatasetID]) do
    begin
      Close;
      TableName:= NewCommand;
      Open;
      First;
    end
    else if Objects[DatasetID] is TPVQuery then with TPVQuery(Objects[DatasetID]) do
    begin
      Close;
      Sql.Clear;
      Sql.Add(NewCommand);
      Open;
      First;
    end
    else if Objects[DatasetID] is TMSQuery then with TMSQuery(Objects[DatasetID]) do
    begin
      Close;
      Sql.Clear;
      Sql.Add(NewCommand);
      Open;
      First;
    end;

    if fDebugging then
    begin
      WriteLn(DebugFile, FormatDateTime('dd/mm/yyyy hh:nn:ss', Now) + ',' + NewCommand + ',');
      CloseFile(DebugFile);
    end;

  except
    Showmessage(NewCommand);
  end;
end;

//******************************************************************************

end.

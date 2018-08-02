unit DataModule;

interface

uses
  ADOSQLUtil, Controls, Dialogs, SysUtils, APIUtil, Classes, DB, ADODB
  , MiscUtil, SQLUtils, VarConst;

type
  TSQLDataModule = class(TDataModule)
    ADOConnection_Common: TADOConnection;
    ADOConnection_Company: TADOConnection;
    qGetCompanyCode: TADOQuery;
    qCompanyQuery: TADOQuery;
    qCompanyQuery2: TADOQuery;
  private
    { Private declarations }
  public
    function Connect(sDataPath : string) : boolean;
    function SQLEntityExists(sDescription : String; var iEntityFolio : integer) : boolean;
    function SQLFieldExists(sLookupRef : String; var iFolio : integer) : boolean;
    function SQLAddEntity(cType : char; sFormat, sDesc : string; iFolioNo : integer) : integer;
    function SQLAddField(sDesc : string; iEntityFolio, iFieldNo, iMode : integer; sCaption, sLookup : string) : integer;
    function SQLGetFieldRecFromLookup(sLookUp : string) : TFieldRec;
    function SQLGetDateFormat : string;
    function SQLSetDateFormat(sFormat : string) : boolean;
    procedure SQLFillSLWithListItems(iFieldFolio : integer; Strings : TStrings);
    function SQLAddListItem(sDesc : string; iFieldFolio, iLineNo : integer; bShowErrors : boolean) : boolean;
    function SQLDeleteAllitemsForField(iFieldFolio : integer) : boolean;
    function SQLUpdateField(FieldRec : TFieldRec) : boolean;
    function SQLGetAllCategories : TADOQuery;
    function SQLGetAllFieldsForEntity(iEntityFolioNo : integer): TADOQuery;
    function SQLUpdateListItem(iFieldFolio : integer; sCurrentDesc, sNewDesc : string): boolean;
    function SQLListItemExists(iFolio: integer; sDesc : string): boolean;
    function SQLDeleteListItem(iFieldFolio : integer; sDesc : string): boolean;
    function SQLGetNoOfEntities : integer;
    function SQLTableExists(sTableName : String): boolean;
    function SQLCreateAllTablesForCompany : boolean;
    procedure Disconnect;
  end;

//  procedure SetColumnParameters(TheQuery : TADOQuery; NewDiscountRec : TDiscountRec);

var
  SQLDataModule : TSQLDataModule;
  asCompanyCode : ANSIString;
  sDateFormat : string;

implementation
{uses
  uSystemSetup;}

{$R *.dfm}
{
procedure SetColumnParameters(TheQuery : TADOQuery; NewDiscountRec : TDiscountRec);
begin
  TheQuery.Parameters.ParamByName('diCompanyCode').Value := NewDiscountRec.diCompanyCode;
  TheQuery.Parameters.ParamByName('diDiscountGroup').Value := NewDiscountRec.diDiscountGroup;
  TheQuery.Parameters.ParamByName('diBand').Value := NewDiscountRec.diBand;
  TheQuery.Parameters.ParamByName('diQtyFrom').Value := NewDiscountRec.diQtyFrom;
  TheQuery.Parameters.ParamByName('diDiscountPercent').Value := NewDiscountRec.diDiscountPercent;
end;
}
function TSQLDataModule.Connect(sDataPath : string) : boolean;

  function GetCompanyCodeForDataPath(sDataPath : string) : ANSIString;
  begin{GetCompanyCodeForDataPath}
    Result := '';
    qGetCompanyCode.Parameters.ParamByName('DIR').Value := Uppercase(WinGetShortPathName(sDataPath));
    if ExecuteSQL(qGetCompanyCode, TRUE, TRUE) then
    begin
      if qGetCompanyCode.RecordCount > 0 then
      begin
        qGetCompanyCode.First;
        Result := qGetCompanyCode.FieldByName('CompanyCode').AsString;
      end;{if}
    end;{if}
    qGetCompanyCode.Close;
  end;{GetCompanyCodeForDataPath}

var
  asConnectionString, lPassword: WideString;
  iStatus : integer;
begin
  Result := FALSE;
  iStatus := GetCommonConnectionStringWOPass(asConnectionString, lPassword);
  if iStatus = 0 then
  begin
    ADOConnection_Common.ConnectionString := asConnectionString;
    ADOConnection_Common.Open('', lPassword);
    //ADOConnection_Common.Connected := TRUE;

     // v6.30.050
//    asCompanyCode := GetCompanyCodeForDataPath(sDataPath);
    if Trim(asCompanyCode) = '' then asCompanyCode := GetCompanyCodeForDataPath(sDataPath);

    iStatus := GetConnectionStringWOPass(asCompanyCode, FALSE, asConnectionString, lPassword);
    if iStatus = 0 then
    begin
      ADOConnection_Company.ConnectionString := asConnectionString;
      // MH 22/02/2018 2018-R1 ABSEXCH-19807: Fixed typo - it was opening Common and not Company
      ADOConnection_Company.Open('', lPassword);
      //ADOConnection_Company.Connected := TRUE;

      Result := TRUE;
    end
    else
    begin
      MsgBox('TSQLDataModule.Connect GetConnectionString Error : ' + IntToStr(iStatus), mtError, [mbOK]
      , mbOK, 'GetConnectionString Error');
    end;{if}
  end
  else
  begin
    MsgBox('TSQLDataModule.Connect GetCommonConnectionString Error : ' + IntToStr(iStatus), mtError, [mbOK]
    , mbOK, 'GetCommonConnectionString Error');
  end;{if}
end;

procedure TSQLDataModule.Disconnect;
begin
  ADOConnection_Common.Connected := FALSE;
  ADOConnection_Company.Connected := FALSE;

  // v6.30.050
  asCompanyCode := '';
end;

function TSQLDataModule.SQLEntityExists(sDescription : String; var iEntityFolio : integer) : boolean;
begin{SQLEntityExists}
  Result := FALSE;
  iEntityFolio := -1;

  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('SELECT etFolioNo ');
  qCompanyQuery.SQL.Add('FROM ' + asCompanyCode + '.UDENTITY ');
  qCompanyQuery.SQL.Add('WHERE etDescription = ' + QuotedStr(sDescription));

//  qGetEntityFromDesc.Parameters.ParamByName('TABLENAME').Value := '[' + asCompanyCode + '].[UDENTITY] ';
  if ExecuteSQL(qCompanyQuery, TRUE, TRUE) then
  begin
    if qCompanyQuery.RecordCount > 0 then
    begin
      qCompanyQuery.First;
      iEntityFolio := qCompanyQuery.FieldByName('etFolioNo').AsInteger;
      Result := TRUE;
    end;{if}
  end;{if}
  qCompanyQuery.Close;
end;{SQLEntityExists}

function TSQLDataModule.SQLAddEntity(cType : char; sFormat, sDesc : string; iFolioNo : integer) : integer;

  function GetNextEntityFolioNo : integer;
  begin{GetNextEntityFolioNo}
    Result := -999;
    qCompanyQuery.SQL.Clear;
    qCompanyQuery.SQL.Add('SELECT MAX(etFolioNo) ');
    qCompanyQuery.SQL.Add('FROM ' + asCompanyCode + '.UDENTITY ');

    if ExecuteSQL(qCompanyQuery, TRUE, TRUE) then
    begin
      if qCompanyQuery.RecordCount > 0 then
      begin
        qCompanyQuery.First;
        if qCompanyQuery.Fields[0].isNull then Result := 1
        else Result := qCompanyQuery.Fields[0].Value + 1;
      end
      else
      begin
        Result := 1;
      end;{if}
    end;{if}
    qCompanyQuery.Close;
  end;{GetNextEntityFolioNo}

begin{SQLAddEntity}
  if iFolioNo = 0 then Result := GetNextEntityFolioNo
  else Result := iFolioNo;

  if Result <> -999 then
  begin
    qCompanyQuery.SQL.Clear;
    qCompanyQuery.SQL.Add('INSERT INTO ' + asCompanyCode + '.UDENTITY ');
    qCompanyQuery.SQL.Add('([etFolioNo],[etDescription],[etType],[etFormat],[etDummyChar]) ');
    qCompanyQuery.SQL.Add('VALUES ');
    qCompanyQuery.SQL.Add('(' + IntToStr(Result) + ', ' + QuotedStr(sDesc) + ', '
    + QuotedStr(cType) + ', ' + QuotedStr(sFormat) + ', 33)');

    if not ExecuteSQL(qCompanyQuery, FALSE, TRUE) then Result := -1;
    //qAddEntity.Close;
  end;{if}
end;{SQLAddEntity}

function TSQLDataModule.SQLAddField(sDesc : string; iEntityFolio, iFieldNo, iMode : integer; sCaption, sLookup : string) : integer;

  function GetNextFieldFolioNo : integer;
  begin{GetNextFieldFolioNo}
    Result := -1;
    qCompanyQuery.SQL.Clear;
    qCompanyQuery.SQL.Add('SELECT MAX(fiFolioNo) ');
    qCompanyQuery.SQL.Add('FROM ' + asCompanyCode + '.UDFIELD ');

    if ExecuteSQL(qCompanyQuery, TRUE, TRUE) then
    begin
      if qCompanyQuery.RecordCount > 0 then
      begin
        qCompanyQuery.First;
        if qCompanyQuery.Fields[0].isNull then Result := 1
        else Result := qCompanyQuery.Fields[0].Value + 1;
      end
      else
      begin
        Result := 1;
      end;{if}
    end;{if}
    qCompanyQuery.Close;
  end;{GetNextFieldFolioNo}

begin{SQLAddEntity}
  Result := GetNextFieldFolioNo;
  if Result <> -1 then
  begin
    qCompanyQuery.SQL.Clear;
    qCompanyQuery.SQL.Add('INSERT INTO ' + asCompanyCode + '.UDFIELD ');
    qCompanyQuery.SQL.Add('([fiFolioNo],[fiEntityFolio],[fiLineNo],[fiDescription]'
    +',[fiValidationMode],[fiWindowCaption],[fiLookupRef],[fiDummyChar])');
    qCompanyQuery.SQL.Add('VALUES ');
    qCompanyQuery.SQL.Add('(' + IntToStr(Result) + ', ' + IntToStr(iEntityFolio) + ', '
    + IntToStr(iFieldNo) + ', ' + QuotedStr(sDesc) + ', ' + IntToStr(iMode)
    + ', ' + QuotedStr(sCaption) + ', ' + QuotedStr(sLookup) + ', 33)');

    if not ExecuteSQL(qCompanyQuery, FALSE, TRUE) then Result := -1;
  end;{if}
end;{SQLAddEntity}

function TSQLDataModule.SQLFieldExists(sLookupRef: String; var iFolio: integer): boolean;
begin
  Result := FALSE;
  iFolio := -1;

  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('SELECT fiFolioNo');
  qCompanyQuery.SQL.Add('FROM ' + asCompanyCode + '.UDFIELD ');
  qCompanyQuery.SQL.Add('WHERE fiLookupRef = ' + QuotedStr(sLookupRef));

  if ExecuteSQL(qCompanyQuery, TRUE, TRUE) then
  begin
    if qCompanyQuery.RecordCount > 0 then
    begin
      qCompanyQuery.First;
      iFolio := qCompanyQuery.FieldByName('fiFolioNo').AsInteger;
      Result := TRUE;
    end;{if}
  end;{if}
  qCompanyQuery.Close;
end;

function TSQLDataModule.SQLListItemExists(iFolio: integer; sDesc : string): boolean;
begin
  Result := FALSE;
//  iFolio := -1;

  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('SELECT liFieldFolio');
  qCompanyQuery.SQL.Add('FROM ' + asCompanyCode + '.UDITEM ');
  qCompanyQuery.SQL.Add('WHERE liFieldFolio = ' + IntToStr(iFolio) + ' ');
  qCompanyQuery.SQL.Add('AND liDescription = ' + QuotedStr(sDesc));

  if ExecuteSQL(qCompanyQuery, TRUE, TRUE) then
  begin
    if qCompanyQuery.RecordCount > 0 then
    begin
//      qCompanyQuery.First;
      Result := TRUE;
    end;{if}
  end;{if}
  qCompanyQuery.Close;
end;

function TSQLDataModule.SQLGetFieldRecFromLookup(sLookUp : string) : TFieldRec;
begin
  FillChar(Result, SizeOf(Result), #0);

  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('SELECT * ');
  qCompanyQuery.SQL.Add('FROM ' + asCompanyCode + '.UDFIELD ');
  qCompanyQuery.SQL.Add('WHERE fiLookupRef = ' + QuotedStr(sLookUp));

  if ExecuteSQL(qCompanyQuery, TRUE, TRUE) then
  begin
    if qCompanyQuery.RecordCount > 0 then
    begin
      qCompanyQuery.First;
      Result.fiFolioNo := qCompanyQuery.FieldByName('fiFolioNo').AsInteger;
      Result.fiEntityFolio := qCompanyQuery.FieldByName('fiEntityFolio').AsInteger;
      Result.fiLineNo := qCompanyQuery.FieldByName('fiLineNo').AsInteger;
      Result.fiDescription := qCompanyQuery.FieldByName('fiDescription').AsString;
      Result.fiValidationMode := qCompanyQuery.FieldByName('fiValidationMode').AsInteger;
      Result.fiWindowCaption := qCompanyQuery.FieldByName('fiWindowCaption').AsString;
      Result.fiLookupRef := sLookUp;
      Result.fiDummyChar := IDX_DUMMY_CHAR;
    end;{if}
  end;{if}
  qCompanyQuery.Close;
end;

function TSQLDataModule.SQLGetDateFormat: string;
begin
  FillChar(Result, SizeOf(Result), #0);

  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('SELECT etFormat ');
  qCompanyQuery.SQL.Add('FROM ' + asCompanyCode + '.UDENTITY ');
  qCompanyQuery.SQL.Add('WHERE etType = ' + QuotedStr('D'));

  if ExecuteSQL(qCompanyQuery, TRUE, TRUE) then
  begin
    if qCompanyQuery.RecordCount > 0 then
    begin
      qCompanyQuery.First;
      Result := qCompanyQuery.FieldByName('etFormat').AsString;
    end;{if}
  end;{if}
  qCompanyQuery.Close;
end;

function TSQLDataModule.SQLSetDateFormat(sFormat : string) : boolean;
begin
  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('UPDATE ' + asCompanyCode + '.UDENTITY ');
  qCompanyQuery.SQL.Add('SET etFormat = ' + QuotedStr(sFormat) + ' ');
  qCompanyQuery.SQL.Add('FROM ' + asCompanyCode + '.UDENTITY ');
  qCompanyQuery.SQL.Add('WHERE etType = ' + QuotedStr('D'));

  Result := ExecuteSQL(qCompanyQuery, FALSE, TRUE);
end;

procedure TSQLDataModule.SQLFillSLWithListItems(iFieldFolio : integer; Strings : TStrings);
begin
  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('SELECT liDescription ');
  qCompanyQuery.SQL.Add('FROM ' + asCompanyCode + '.UDITEM ');
  qCompanyQuery.SQL.Add('WHERE liFieldFolio = ' + IntToStr(iFieldFolio));

  if ExecuteSQL(qCompanyQuery, TRUE, TRUE) then
  begin
    if qCompanyQuery.RecordCount > 0 then
    begin
      qCompanyQuery.First;
      while (not qCompanyQuery.Eof) do
      begin
        Strings.Add(qCompanyQuery.FieldByName('liDescription').AsString);
        qCompanyQuery.Next;
      end;{while}
    end;{if}
  end;{if}
  qCompanyQuery.Close;
end;

function TSQLDataModule.SQLAddListItem(sDesc: string; iFieldFolio, iLineNo: integer; bShowErrors: boolean) : boolean;
begin
  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('INSERT INTO ' + asCompanyCode + '.UDITEM ');
  qCompanyQuery.SQL.Add('([liDescription],[liFieldFolio],[liLineNo],[liDummyChar])');
  qCompanyQuery.SQL.Add('VALUES ');
  qCompanyQuery.SQL.Add('(' + QuotedStr(sDesc) + ', ' + IntToStr(iFieldFolio) + ', '
  + IntToStr(iLineNo) + ', 33)');

  Result := ExecuteSQL(qCompanyQuery, FALSE, bShowErrors);
end;

function TSQLDataModule.SQLDeleteAllitemsForField(iFieldFolio : integer) : boolean;
begin
  FillChar(Result, SizeOf(Result), #0);

  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('DELETE FROM ' + asCompanyCode + '.UDITEM ');
  qCompanyQuery.SQL.Add('WHERE liFieldFolio = ' + IntToStr(iFieldFolio));

  Result := ExecuteSQL(qCompanyQuery, FALSE, TRUE);
end;


function TSQLDataModule.SQLUpdateField(FieldRec: TFieldRec): boolean;
begin
  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('UPDATE ' + asCompanyCode + '.UDFIELD ');
  qCompanyQuery.SQL.Add('SET fiEntityFolio = ' + IntToStr(FieldRec.fiEntityFolio) + ' ');
  qCompanyQuery.SQL.Add(', fiLineNo = ' + IntToStr(FieldRec.fiLineNo) + ' ');
  qCompanyQuery.SQL.Add(', fiDescription = ' + QuotedStr(FieldRec.fiDescription) + ' ');
  qCompanyQuery.SQL.Add(', fiValidationMode = ' + IntToStr(FieldRec.fiValidationMode) + ' ');
  qCompanyQuery.SQL.Add(', fiWindowCaption = ' + QuotedStr(FieldRec.fiWindowCaption) + ' ');
  qCompanyQuery.SQL.Add(', fiLookupRef = ' + QuotedStr(FieldRec.fiLookupRef) + ' ');
  qCompanyQuery.SQL.Add('WHERE fiFolioNo = ' + IntToStr(FieldRec.fiFolioNo));

  Result := ExecuteSQL(qCompanyQuery, FALSE, TRUE);
end;

function TSQLDataModule.SQLGetAllCategories: TADOQuery;
begin
  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('SELECT etFolioNo, etDescription, etType, etFormat  ');
  qCompanyQuery.SQL.Add('FROM ' + asCompanyCode + '.UDENTITY ');
  qCompanyQuery.SQL.Add('WHERE etType = ' + QuotedStr('C'));

  ExecuteSQL(qCompanyQuery, TRUE, TRUE);
  Result := qCompanyQuery;
end;

function TSQLDataModule.SQLGetAllFieldsForEntity(iEntityFolioNo : integer): TADOQuery;
begin
  qCompanyQuery2.SQL.Clear;
  qCompanyQuery2.SQL.Add('SELECT fiFolioNo, fiEntityFolio, fiLineNo, fiDescription, fiValidationMode, fiWindowCaption, fiLookupRef ');
  qCompanyQuery2.SQL.Add('FROM ' + asCompanyCode + '.UDFIELD ');
  qCompanyQuery2.SQL.Add('WHERE fiEntityFolio = ' + IntToStr(iEntityFolioNo));
  //PR: 23/04/2015 ABSEXGENERIC-368 Add sorting clause to ensure correct order in admin module
  qCompanyQuery2.SQL.Add(' ORDER BY fiLineNo');

  ExecuteSQL(qCompanyQuery2, TRUE, TRUE);
  Result := qCompanyQuery2;
end;

function TSQLDataModule.SQLUpdateListItem(iFieldFolio : integer; sCurrentDesc, sNewDesc : string): boolean;
begin
  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('UPDATE ' + asCompanyCode + '.UDITEM ');
  qCompanyQuery.SQL.Add('SET liDescription = ' + QuotedStr(sNewDesc) + ' ');
  qCompanyQuery.SQL.Add('WHERE liDescription = ' + QuotedStr(sCurrentDesc) + ' ');
  qCompanyQuery.SQL.Add('AND liFieldFolio = ' + IntToStr(iFieldFolio));

  Result := ExecuteSQL(qCompanyQuery, FALSE, TRUE);
end;

function TSQLDataModule.SQLDeleteListItem(iFieldFolio : integer; sDesc : string): boolean;
begin
  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('DELETE FROM ' + asCompanyCode + '.UDITEM ');
  qCompanyQuery.SQL.Add('WHERE liDescription = ' + QuotedStr(sDesc) + ' ');
  qCompanyQuery.SQL.Add('AND iFieldFolio = ' + IntToStr(iFieldFolio));

  Result := ExecuteSQL(qCompanyQuery, FALSE, TRUE);
end;

function TSQLDataModule.SQLGetNoOfEntities: integer;
begin
  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('SELECT etFolioNo ');
  qCompanyQuery.SQL.Add('FROM ' + asCompanyCode + '.UDENTITY ');

  if ExecuteSQL(qCompanyQuery, TRUE, TRUE) then
  begin
    Result := qCompanyQuery.RecordCount;
  end;{if}
  qCompanyQuery.Close;
end;

function TSQLDataModule.SQLTableExists(sTableName : String): boolean;
begin
  // Build Query
  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('IF EXISTS (SELECT * FROM sys.objects ');
  qCompanyQuery.SQL.Add('WHERE object_id = OBJECT_ID(' + QuotedStr(sTableName) + ') AND type in (N''U'')) ');
  qCompanyQuery.SQL.Add('BEGIN ');
  qCompanyQuery.SQL.Add('  SELECT 1 ');
  qCompanyQuery.SQL.Add('END ');
  qCompanyQuery.SQL.Add('ELSE ');
  qCompanyQuery.SQL.Add('BEGIN ');
  qCompanyQuery.SQL.Add('  SELECT 0 ');
  qCompanyQuery.SQL.Add('END ');

  // Run Query
  if ExecuteSQL(qCompanyQuery, TRUE, TRUE) then
  begin
    // Get Result
    qCompanyQuery.First;
    Result := qCompanyQuery.Fields[0].Value = 1;
  end;{if}
  qCompanyQuery.Close;
end;

function TSQLDataModule.SQLCreateAllTablesForCompany: boolean;
var
  sTableName : string;
begin
  Result := TRUE;

  // Create UDENTITY
  sTableName := asCompanyCode + '.UDENTITY';
  if Result and (not SQLTableExists(sTableName)) then
  begin
    qCompanyQuery.SQL.Clear;
    qCompanyQuery.SQL.Add('CREATE TABLE ' + sTableName + '( ');
    qCompanyQuery.SQL.Add('[etFolioNo] [int] NOT NULL, ');
    qCompanyQuery.SQL.Add('[etDescription] [varchar](60) NOT NULL, ');
    qCompanyQuery.SQL.Add('[etType] [varchar](1) NOT NULL, ');
    qCompanyQuery.SQL.Add('[etFormat] [varchar](20) NOT NULL, ');
    qCompanyQuery.SQL.Add('[etDummyChar] [int] NOT NULL, ');
    qCompanyQuery.SQL.Add('[PositionId] [int] IDENTITY(1,1) NOT NULL ');
    qCompanyQuery.SQL.Add(') ON [PRIMARY]');

    Result := ExecuteSQL(qCompanyQuery, FALSE, TRUE);
  end;{if}

    // Create UDFIELD
  sTableName := asCompanyCode + '.UDFIELD';
  if Result and (not SQLTableExists(sTableName)) then
  begin
    qCompanyQuery.SQL.Clear;
    qCompanyQuery.SQL.Add('CREATE TABLE ' + sTableName + '( ');
    qCompanyQuery.SQL.Add('[fiFolioNo] [int] NOT NULL, ');
    qCompanyQuery.SQL.Add('[fiEntityFolio] [int] NOT NULL, ');
    qCompanyQuery.SQL.Add('[fiLineNo] [int] NOT NULL, ');
    qCompanyQuery.SQL.Add('[fiDescription] [varchar](60) NOT NULL, ');
    qCompanyQuery.SQL.Add('[fiValidationMode] [int] NOT NULL, ');
    qCompanyQuery.SQL.Add('[fiWindowCaption] [varchar](60) NOT NULL, ');
    qCompanyQuery.SQL.Add('[fiLookupRef] [varchar](20) NOT NULL, ');
    qCompanyQuery.SQL.Add('[fiDummyChar] [int] NOT NULL, ');
    qCompanyQuery.SQL.Add('[PositionId] [int] IDENTITY(1,1) NOT NULL ');
    qCompanyQuery.SQL.Add(') ON [PRIMARY]');

    Result := ExecuteSQL(qCompanyQuery, FALSE, TRUE);
  end;{if}

    // Create UDITEM
  sTableName := asCompanyCode + '.UDITEM';
  if Result and (not SQLTableExists(sTableName)) then
  begin
    qCompanyQuery.SQL.Clear;
    qCompanyQuery.SQL.Add('CREATE TABLE ' + sTableName + '( ');
    qCompanyQuery.SQL.Add('[liFieldFolio] [int] NOT NULL, ');
    qCompanyQuery.SQL.Add('[liLineNo] [int] NOT NULL, ');
    qCompanyQuery.SQL.Add('[liDescription] [varchar](60) NOT NULL, ');
    qCompanyQuery.SQL.Add('[liDummyChar] [int] NOT NULL, ');
    qCompanyQuery.SQL.Add('[PositionId] [int] IDENTITY(1,1) NOT NULL ');
    qCompanyQuery.SQL.Add(') ON [PRIMARY]');

    Result := ExecuteSQL(qCompanyQuery, FALSE, TRUE);
  end;{if}
end;

// v6.30.050
initialization
  SQLDataModule := nil;
  asCompanyCode := '';
  sDateFormat := '';

end.

unit DataModule;

interface

uses
  ADOSQLUtil, Controls, Dialogs, SysUtils, APIUtil, Classes, DB, ADODB
  , MiscUtil, SQLUtils, VarConst, ToolBTFiles;

type
  TSQLDataModule = class(TDataModule)
    ADOConnection_Common: TADOConnection;
    ADOConnection_Company: TADOConnection;
    qGetCompanyCode: TADOQuery;
    qCompanyQuery: TADOQuery;
    qCompanyQuery2: TADOQuery;
    qGetCompanies: TADOQuery;
    qTools: TADOQuery;
    qTools2: TADOQuery;
  private
    { Private declarations }
  public
    function Connect(sDataPath : string) : boolean;
    function SQLGetUserList : TADOQuery;
    function SQLGetMenuItems: TADOQuery;
    function SQLGetCompanyList : TADOQuery;
    function SQLMenuItemInCompany(iFolioNo : integer; sCompanyCode : string) : boolean;
    function SQLMenuItemForUser(iFolioNo : integer; sUserID : string) : boolean;
    function SQLGetMenuItemFromName(sMenuItemName : string; var TheToolRec : TToolRec) : integer;
    function QueryToMenuItem(qQuery : TADOQuery; var TheToolRec : TToolRec) : integer;
    procedure Disconnect;
  end;

var
  asCompanyCode, asCompanyPath : ANSIString;

implementation
{uses
  uSystemSetup;}

{$R *.dfm}

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

    // v6.30.142
//    asCompanyCode := GetCompanyCodeForDataPath(sDataPath);
    if Trim(asCompanyCode) = '' then asCompanyCode := GetCompanyCodeForDataPath(sDataPath);

    iStatus := GetConnectionStringWOPass(asCompanyCode, FALSE, asConnectionString, lPassword);
    if iStatus = 0 then
    begin
      ADOConnection_Company.ConnectionString := asConnectionString;
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

  // v6.30.142
  asCompanyCode := '';
end;

function TSQLDataModule.SQLGetUserList: TADOQuery;
begin
  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('SELECT Exchqchkcode1Trans1 as UserID');
  qCompanyQuery.SQL.Add(' FROM  ' + asCompanyCode + '.EXCHQCHK');
  qCompanyQuery.SQL.Add(' WHERE (RecPFix = ' + QuotedStr('P') + ') AND (SubType = 0)');

  ExecuteSQL(qCompanyQuery, TRUE, TRUE);
  Result := qCompanyQuery;
end;

function TSQLDataModule.SQLGetMenuItems: TADOQuery;
begin
  qTools.SQL.Clear;
  qTools.SQL.Add('SELECT miFolioNo, miAvailability, miCompany, miItemType,');
  qTools.SQL.Add(' miDescription, miFilename, miStartDir, miParameters,');
  qTools.SQL.Add(' miHelpText, miAllUsers, miAllCompanies, miComponentName,');
  qTools.SQL.Add(' miParentComponentName, miPosition');
  qTools.SQL.Add(' FROM common.tools');
  qTools.SQL.Add(' WHERE recordtype = ' + QuotedStr('M'));
  qTools.SQL.Add(' ORDER BY miParentComponentName, miPosition');

  ExecuteSQL(qTools, TRUE, TRUE);
  Result := qTools;
end;

function TSQLDataModule.SQLGetCompanyList : TADOQuery;
begin{SQLGetCompanyList}
  Result := nil;
  if ExecuteSQL(qGetCompanies, TRUE, TRUE) then
  begin
    Result := qGetCompanies;
  end;{if}
end;{SQLGetCompanyList}

function TSQLDataModule.SQLMenuItemInCompany(iFolioNo : integer; sCompanyCode : string) : boolean;
begin
  qTools2.SQL.Clear;
  qTools2.SQL.Add('SELECT cxItemFolio');
  qTools2.SQL.Add('FROM common.tools');
  qTools2.SQL.Add('WHERE (recordtype = ' + QuotedStr('C') + ')');
  qTools2.SQL.Add('and (cxItemFolio = ' + IntToStr(iFolioNo) + ')');
  qTools2.SQL.Add('and (cxCompanyCode = ' + QuotedStr(Trim(sCompanyCode)) + ')');

  ExecuteSQL(qTools2, TRUE, TRUE);
  qTools2.first;
  Result := not qTools2.Eof;
  qTools2.Close;
end;

function TSQLDataModule.SQLMenuItemForUser(iFolioNo : integer; sUserID : string) : boolean;
begin
  qTools2.SQL.Clear;
  qTools2.SQL.Add('SELECT uxitemfolio');
  qTools2.SQL.Add(' FROM common.tools');
  qTools2.SQL.Add(' WHERE (recordtype = ' + QuotedStr('U') + ')');
  qTools2.SQL.Add(' and (uxItemFolio = ' + IntToStr(iFolioNo) + ')');
  qTools2.SQL.Add(' and (uxUserName = ' + QuotedStr(sUserID) + ')');

  ExecuteSQL(qTools2, TRUE, TRUE);
  qTools2.first;
  Result := not qTools2.Eof;
  qTools2.Close;
end;

function TSQLDataModule.SQLGetMenuItemFromName(sMenuItemName : string; var TheToolRec : TToolRec) : integer;
begin
  FillChar(TheToolRec, SizeOf(TheToolRec), #0);
  qTools2.SQL.Clear;
  qTools2.SQL.Add('SELECT miFolioNo, miAvailability, miCompany, miItemType,');
  qTools2.SQL.Add(' miDescription, miFilename, miStartDir, miParameters,');
  qTools2.SQL.Add(' miHelpText, miAllUsers, miAllCompanies, miComponentName,');
  qTools2.SQL.Add(' miParentComponentName, miPosition');
  qTools2.SQL.Add(' FROM common.tools');
  qTools2.SQL.Add(' WHERE (recordtype = ' + QuotedStr('M') + ')');
  qTools2.SQL.Add(' and (miComponentName = ' + QuotedStr(sMenuItemName) + ')');

  ExecuteSQL(qTools2, TRUE, TRUE);
  qTools2.first;
  if not qTools2.Eof then QueryToMenuItem(qTools2, TheToolRec);
  qTools2.Close;
end;

function TSQLDataModule.QueryToMenuItem(qQuery : TADOQuery; var TheToolRec : TToolRec) : integer;

  function StringToChar(sString : string) : char;
  begin{StringToChar}
   if Length(sString) > 0 then Result := sString[1]
   else Result := #0;
  end;{StringToChar}

begin
  FillChar(TheToolRec, SizeOf(TheToolRec), #0);
  // Fill in the record structure
  TheToolRec.MenuItem.miFolioNo := qQuery.FieldByName('miFolioNo').AsInteger;
  TheToolRec.MenuItem.miAvailability := StringToChar(qQuery.FieldByName('miAvailability').AsString);
  TheToolRec.MenuItem.miCompany := qQuery.FieldByName('miCompany').AsString;
  TheToolRec.MenuItem.miItemType := StringToChar(qQuery.FieldByName('miItemType').AsString);
  TheToolRec.MenuItem.miDescription := qQuery.FieldByName('miDescription').AsString;
  TheToolRec.MenuItem.miFilename := qQuery.FieldByName('miFilename').AsString;
  TheToolRec.MenuItem.miStartDir := qQuery.FieldByName('miStartDir').AsString;
  TheToolRec.MenuItem.miParameters := qQuery.FieldByName('miParameters').AsString;
  TheToolRec.MenuItem.miHelpText := qQuery.FieldByName('miHelpText').AsString;
  TheToolRec.MenuItem.miAllUsers := qQuery.FieldByName('miAllUsers').AsBoolean;
  TheToolRec.MenuItem.miAllCompanies := qQuery.FieldByName('miAllCompanies').AsBoolean;
  TheToolRec.MenuItem.miComponentName := qQuery.FieldByName('miComponentName').AsString;
  TheToolRec.MenuItem.miParentComponentName := qQuery.FieldByName('miParentComponentName').AsString;
  TheToolRec.MenuItem.miPosition := qQuery.FieldByName('miPosition').AsInteger;
end;

// v6.30.142
initialization
  asCompanyCode := '';

end.


unit DataModule;

interface

uses
  ADOSQLUtil, Controls, Dialogs, SysUtils, APIUtil, Classes, DB, ADODB
  , MiscUtil, StrUtil, SQLUtils, VarConst;

type
  TSQLDataModule = class(TDataModule)
    ADOConnection_Common: TADOConnection;
    ADOConnection_Company: TADOConnection;
    qGetCompanyCode: TADOQuery;
    qCompanyQuery: TADOQuery;
    qCompanyQuery2: TADOQuery;
    qCommonQuery: TADOQuery;
  private
    { Private declarations }
  public
    function Connect{(sDataPath : string)} : boolean;
//    procedure SQLFillSLWithCombinations(cType : char; iGL : integer; Strings : TStringList);
//    function SQLUsingGLCodes : boolean;
//    function SQLUsingVATCodes : boolean;
    function SQLGetContacts(sAccountCode : string): TADOQuery;
    function SQLGetContact(sAccountCode, sContactCode : string): TADOQuery;
    procedure SQLChangeAccountCode(sOldCode, sNewCode : string);
    procedure SQLDeleteAccountCode(sAccCode : string);
    function SQLContactExists(sContactCode : string) : boolean;
    function SQLGetNextContactCode(sSurname : string) : string;
    procedure SQLDeleteContact(sContactCode : string);
    procedure SQLAddContact(ContactRec : TContactRecType);
    procedure SQLUpdateContact(sOrigCode : string; ContactRec : TContactRecType);
    procedure Disconnect;
  end;

//  procedure SetColumnParameters(TheQuery : TADOQuery; NewDiscountRec : TDiscountRec);

var
  bSQL : boolean;
  asCompanyPath, asCompanyCode : ANSIString;
  SQLDataModule : TSQLDataModule;

implementation

{$R *.dfm}

function TSQLDataModule.Connect{(sDataPath : string)} : boolean;

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
begin{Connect}
  Result := FALSE;
  iStatus := GetCommonConnectionStringWOPass(asConnectionString, lPassword);
  if iStatus = 0 then
  begin
    ADOConnection_Common.ConnectionString := asConnectionString;
    ADOConnection_Common.Open('', lPassword);
    //ADOConnection_Common.Connected := TRUE;

     // v6.30.040
//    asCompanyCode := GetCompanyCodeForDataPath(asCompanyPath);
    if Trim(asCompanyCode) = '' then asCompanyCode := GetCompanyCodeForDataPath(asCompanyPath);

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
end;{Connect}

procedure TSQLDataModule.Disconnect;
begin
  ADOConnection_Common.Connected := FALSE;
  ADOConnection_Company.Connected := FALSE;

  // v6.30.040
  asCompanyCode := '';
end;
(*
procedure TSQLDataModule.SQLFillSLWithCombinations(cType : char; iGL : integer; Strings : TStringList);
begin
  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('SELECT cdCostCentre, cdDepartment, cdVATCode');
  qCompanyQuery.SQL.Add(' FROM ' + asCompanyCode + '.CCDEPTV');
  qCompanyQuery.SQL.Add(' WHERE cdType = ' + QuotedStr(cType));
  qCompanyQuery.SQL.Add(' AND cdglcode = ' + IntToStr(iGL));

  if ExecuteSQL(qCompanyQuery, TRUE, TRUE) then
  begin
    if qCompanyQuery.RecordCount > 0 then
    begin
      qCompanyQuery.First;
      while (not qCompanyQuery.Eof) do
      begin
        Strings.Add(qCompanyQuery.FieldByName('cdCostCentre').AsString
        + ',' + qCompanyQuery.FieldByName('cdDepartment').AsString
        + '/' + Char(qCompanyQuery.FieldByName('cdVATCode').AsInteger));

        qCompanyQuery.Next;
      end;{while}
    end;{if}
  end;{if}
  qCompanyQuery.Close;
end;

function TSQLDataModule.SQLUsingGLCodes : boolean;
begin
  Result := FALSE;
  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('SELECT cdGLCode');
  qCompanyQuery.SQL.Add(' FROM ' + asCompanyCode + '.CCDEPTV');
  qCompanyQuery.SQL.Add(' ORDER BY cdType, cdGLCode, cdCostCentre, cdDepartment');

  if ExecuteSQL(qCompanyQuery, TRUE, TRUE) then
  begin
    if qCompanyQuery.RecordCount > 0 then
    begin
      qCompanyQuery.First;
//      Result := qCompanyQuery.FieldByName('cdGLCode').AsInteger <> iNO_GL;
    end;{if}
  end;{if}
  qCompanyQuery.Close;
end;

function TSQLDataModule.SQLUsingVATCodes : boolean;
begin
  Result := FALSE;
  qCompanyQuery.SQL.Clear;
  qCompanyQuery.SQL.Add('SELECT cdVATCode');
  qCompanyQuery.SQL.Add(' FROM ' + asCompanyCode + '.CCDEPTV');
  qCompanyQuery.SQL.Add(' ORDER BY cdType, cdGLCode, cdCostCentre, cdDepartment');

  if ExecuteSQL(qCompanyQuery, TRUE, TRUE) then
  begin
    if qCompanyQuery.RecordCount > 0 then
    begin
      qCompanyQuery.First;
      Result := qCompanyQuery.FieldByName('cdVATCode').AsInteger <> 0;
    end;{if}
  end;{if}
  qCompanyQuery.Close;
end;
*)

procedure TSQLDataModule.SQLChangeAccountCode(sOldCode, sNewCode : string);
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('UPDATE COMMON.CONTACT');
  qCommonQuery.SQL.Add(' SET coAccount = ' + QuotedStr(sNewCode));
//  qCommonQuery.SQL.Add(' FROM COMMON.CONTACT');
  qCommonQuery.SQL.Add(' WHERE coAccount = ' + QuotedStr(sOldCode));

  ExecuteSQL(qCommonQuery, FALSE, TRUE, FALSE);
end;

procedure TSQLDataModule.SQLDeleteAccountCode(sAccCode : string);
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('DELETE FROM COMMON.CONTACT');
  qCommonQuery.SQL.Add(' WHERE coAccount = ' + QuotedStr(sAccCode));

  ExecuteSQL(qCommonQuery, FALSE, TRUE, FALSE);
end;

procedure TSQLDataModule.SQLDeleteContact(sContactCode : string);
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('DELETE FROM COMMON.CONTACT');
  qCommonQuery.SQL.Add(' WHERE coCode = ' + QuotedStr(sContactCode));

  ExecuteSQL(qCommonQuery, FALSE, TRUE, FALSE);
end;

function TSQLDataModule.SQLContactExists(sContactCode : string) : boolean;
begin
  Result := FALSE;
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('SELECT coCode FROM COMMON.CONTACT');
  qCommonQuery.SQL.Add(' WHERE coCode = ' + QuotedStr(sContactCode));

  if ExecuteSQL(qCommonQuery, TRUE, TRUE, FALSE) then
  begin
    Result := qCommonQuery.RecordCount > 0;
  end;{if}
end;

function TSQLDataModule.SQLGetNextContactCode(sSurname : string) : string;
var
  iNextNo, iPos : integer;
begin
  sSurname := uppercase(sSurname);
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('SELECT top 1 cocode');
  qCommonQuery.SQL.Add(' FROM COMMON.CONTACT');
  qCommonQuery.SQL.Add(' WHERE SUBSTRING(coCode,1,' + IntToStr(Length(sSurname))
  + ') = ' + QuotedStr(sSurname) + ' and SUBSTRING(coCode,' + IntToStr(Length(sSurname) + 1)
  + ',1) in (');
  For iPos := 0 to 9 do
  begin
    qCommonQuery.SQL.Add(QuotedStr(IntToStr(iPos)));
    if iPos <> 9 then qCommonQuery.SQL.Add(',');
  end;{for}
  qCommonQuery.SQL.Add(')');
  qCommonQuery.SQL.Add(' ORDER BY coCode desc');

  if ExecuteSQL(qCommonQuery, TRUE, TRUE) then
  begin
    if qCommonQuery.RecordCount = 0 then
    begin
      Result := sSurname + '001';
    end
    else
    begin
      qCommonQuery.First;
      iNextNo := StrToIntDef(Copy(qCommonQuery.FieldByName('coCode').AsString, Length(sSurname)+1, 3), 0) + 1;
      Result := sSurname + PadString(psLeft, IntToStr(iNextNo), '0', 3);
    end;{if}
  end;{if}
end;

function TSQLDataModule.SQLGetContacts(sAccountCode : string): TADOQuery;
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('SELECT *');
  qCommonQuery.SQL.Add(' FROM COMMON.CONTACT');
  qCommonQuery.SQL.Add(' WHERE coCompany = ' + QuotedStr(asCompanyCode));

  if Trim(sAccountCode) <> ''
  then qCommonQuery.SQL.Add(' AND coAccount = ' + QuotedStr(sAccountCode));
  //HV 05/02/2016 2016-R1 ABSEXGENERIC-336: Set account code default order of in the "All Contacts" screen 
  qCommonQuery.SQL.Add(' Order by coAccount, coCode ');

  ExecuteSQL(qCommonQuery, TRUE, TRUE);
  Result := qCommonQuery;
end;

function TSQLDataModule.SQLGetContact(sAccountCode, sContactCode : string): TADOQuery;
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('SELECT *');
  qCommonQuery.SQL.Add(' FROM COMMON.CONTACT');
  qCommonQuery.SQL.Add(' WHERE coCompany = ' + QuotedStr(asCompanyCode));


  if Trim(sAccountCode) <> ''
  then qCommonQuery.SQL.Add(' AND coAccount = ' + QuotedStr(sAccountCode));

  qCommonQuery.SQL.Add(' AND coCode = ' + QuotedStr(sContactCode));

  ExecuteSQL(qCommonQuery, TRUE, TRUE);
  Result := qCommonQuery;
end;

procedure TSQLDataModule.SQLAddContact(ContactRec : TContactRecType);
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add(' INSERT INTO COMMON.CONTACT');
  qCommonQuery.SQL.Add(' ([coCompany],[coAccount],[coCode],[coTitle],[coFirstName],[coSurname],[coPosition],[coSalutation],[coContactNo],[coDate],[coFaxNumber],[coEmailAddr],[coAddress1],[coAddress2],[coAddress3],[coAddress4],[coPostCode])');
  qCommonQuery.SQL.Add(' VALUES (');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coCompany) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coAccount) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coCode) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coTitle) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coFirstName) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coSurname) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coPosition) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coSalutation) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coContactNo) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coDate) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coFaxNumber) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coEmailAddr) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coAddress1) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coAddress2) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coAddress3) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coAddress4) + ',');
  qCommonQuery.SQL.Add(QuotedStr(ContactRec.coPostCode));
  qCommonQuery.SQL.Add(')');

  ExecuteSQL(qCommonQuery, FALSE, TRUE);
end;

procedure TSQLDataModule.SQLUpdateContact(sOrigCode : string; ContactRec : TContactRecType);
begin
  qCommonQuery.SQL.Clear;
  qCommonQuery.SQL.Add('UPDATE COMMON.CONTACT');
  qCommonQuery.SQL.Add(' SET ');
  qCommonQuery.SQL.Add('coCode = ' + QuotedStr(ContactRec.coCode) + ',');
  qCommonQuery.SQL.Add('coTitle = ' + QuotedStr(ContactRec.coTitle) + ',');
  qCommonQuery.SQL.Add('coFirstName = ' + QuotedStr(ContactRec.coFirstName) + ',');
  qCommonQuery.SQL.Add('coSurname = ' + QuotedStr(ContactRec.coSurname) + ',');
  qCommonQuery.SQL.Add('coPosition = ' + QuotedStr(ContactRec.coPosition) + ',');
  qCommonQuery.SQL.Add('coSalutation = ' + QuotedStr(ContactRec.coSalutation) + ',');
  qCommonQuery.SQL.Add('coContactNo = ' + QuotedStr(ContactRec.coContactNo) + ',');
  qCommonQuery.SQL.Add('coDate = ' + QuotedStr(ContactRec.coDate) + ',');
  qCommonQuery.SQL.Add('coFaxNumber = ' + QuotedStr(ContactRec.coFaxNumber) + ',');
  qCommonQuery.SQL.Add('coEmailAddr = ' + QuotedStr(ContactRec.coEmailAddr) + ',');
  qCommonQuery.SQL.Add('coAddress1 = ' + QuotedStr(ContactRec.coAddress1) + ',');
  qCommonQuery.SQL.Add('coAddress2 = ' + QuotedStr(ContactRec.coAddress2) + ',');
  qCommonQuery.SQL.Add('coAddress3 = ' + QuotedStr(ContactRec.coAddress3) + ',');
  qCommonQuery.SQL.Add('coAddress4 = ' + QuotedStr(ContactRec.coAddress4) + ',');
  qCommonQuery.SQL.Add('coPostCode = ' + QuotedStr(ContactRec.coPostCode));
  qCommonQuery.SQL.Add(' WHERE coCode = ' + QuotedStr(sOrigCode));

  ExecuteSQL(qCommonQuery, FALSE, TRUE, FALSE);
end;

// v6.30.040
initialization
  asCompanyCode := '';


end.



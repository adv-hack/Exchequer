unit DataModule;

interface

uses
  ADOSQLUtil, Controls, Dialogs, SysUtils, APIUtil, Classes, DB, ADODB
  , MiscUtil, SQLUtils, BTFile;

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
    procedure SQLFillSLWithCombinations(cType : char; iGL : integer; Strings : TStringList);
    function SQLUsingGLCodes : boolean;
    function SQLUsingVATCodes : boolean;
    procedure Disconnect;
  end;

//  procedure SetColumnParameters(TheQuery : TADOQuery; NewDiscountRec : TDiscountRec);

var
  SQLDataModule : TSQLDataModule; // v6.30.141 - ABSEXCH-9495
  asCompanyCode : ANSIString;

implementation

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
  asConnectionString,
  lPassword : WideString;
  iStatus : integer;
begin
  Result := FALSE;
  //iStatus := GetCommonConnectionString(asConnectionString);
  iStatus := GetCommonConnectionStringWOPass(asConnectionString, lPassword); //SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  if iStatus = 0 then
  begin
    ADOConnection_Common.ConnectionString := asConnectionString;
    ADOConnection_Common.Open('', lPassword);   //SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    //ADOConnection_Common.Connected := TRUE;

    // v6.30.140
//    asCompanyCode := GetCompanyCodeForDataPath(sDataPath);
    if Trim(asCompanyCode) = '' then asCompanyCode := GetCompanyCodeForDataPath(sDataPath);

    //iStatus := GetConnectionString(asCompanyCode, FALSE, asConnectionString);
    iStatus := GetConnectionStringWOPass(asCompanyCode, FALSE, asConnectionString, lPassword);   //SS:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
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

  // v6.30.140
//  asCompanyCode := '';
end;

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
      Result := qCompanyQuery.FieldByName('cdGLCode').AsInteger <> iNO_GL;
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

// v6.30.140
initialization
  asCompanyCode := '';
  SQLDataModule := nil; // v6.30.141 - ABSEXCH-9495


end.

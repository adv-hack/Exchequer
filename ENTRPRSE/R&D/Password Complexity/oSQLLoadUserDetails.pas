unit oSQLLoadUserDetails;

interface

uses Classes, SysUtils, SQLUtils, Dialogs, DB, GlobVar, VarRec2U, SQLCallerU,
     ADOConnect, VarConst, VAOUtil;

type
  // Common class for reading UserDetails - used by TTaxRegionsSQL.LoadRegions and TTaxRegionSQL.LoadData
  TSQLLoadUserDetails = Class(TObject)
  private
    FSQLCaller: TSQLCaller;
    FOwnsSQLCaller: Boolean;
    FCompanyCode: AnsiString;

    fldUserName: TField;
    fldPWExpMode: TIntegerField;
    fldPWExPDays: TIntegerField;
    fldPWExpDate: TStringField;
    fldDirCust: TStringField;
    fldDirSupp: TStringField;
    fldMaxSalesA: TFloatField;
    fldMaxPurchA: TFloatField;
    fldDepartment: TStringField;
    fldCostCentre: TStringField;
    fldLoc: TStringField;
    fldSalesBank: TIntegerField;
    fldPurchBank: TIntegerField;
    fldReportPrn: TStringField;
    fldFormPrn: TStringField;
    fldOrPrns1: TBooleanField;
    fldOrPrns2: TBooleanField;
    fldCCDepRule: TIntegerField;
    fldLocRule: TIntegerField;
    fldEmailAddr: TStringField;
    fldPWTimeOut: TIntegerField;
    fldLoaded: TBooleanField;
    fldFullName: TStringField;
    fldUCPr: TIntegerField;
    fldUCYr: TIntegerField;
    fldUDispPrMnth: TBooleanField;
    fldShowGLCodes: TBooleanField;
    fldShowStockCode: TBooleanField;
    fldShowProductType: TBooleanField;
    fldUserStatus: TIntegerField;
    fldPasswordSalt: TStringField;
    fldPasswordHash: TStringField;
    fldWindowUserId: TStringField;
    fldSecurityQuestionId: TIntegerField;
    fldSecurityAnswer: TStringField;
    fldForcePasswordChange: TBooleanField;
    fldLoginFailureCount: TIntegerField;
    {HV 17/10/2017 2017 R2 ABSEXCH-19284: User Profile Highlight PII fields flag}
    fldHighlightPIIFields: TBooleanField;
    fldHighlightPIIColour: TIntegerField;

    function GetMLocStkQuery(const AWhereClause: ANSIString = ''): string;
    procedure PrepareFields(ADataSet: TDataSet);
    function GetUserDetailRec: tPassDefType;
  protected
    //
  public
    constructor Create(const ASQLCaller: TSQLCaller = NIL);
    destructor Destroy; override;

    function ReadData(const AWhereClause: ANSIString = ''): Integer;
    function GetFirst: Integer;
    function GetNext: Integer;
    property UserDetailRec: tPassDefType read GetUserDetailRec;
  end; // TSQLLoadUserDetail
  
implementation

{ TSQLLoadUserDetails }
//------------------------------------------------------------------------------

constructor TSQLLoadUserDetails.Create(const ASQLCaller: TSQLCaller);
var
  lConnection: AnsiString;
begin
  inherited Create;
  {$IFDEF IMPV6}
    FCompanyCode := SQLUtils.GetCompanyCode(VAOInfo.vaoCompanyDir);
  {$ELSE}
    FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);
  {$ENDIF}

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

destructor TSQLLoadUserDetails.Destroy;
begin
  if FSQLCaller.Records.Active then
    FSQLCaller.Records.Close;

  if FOwnsSQLCaller and Assigned(FSQLCaller) then
    FreeAndNil(FSQLCaller);
  inherited Destroy;
end;

//------------------------------------------------------------------------------

function TSQLLoadUserDetails.GetFirst: Integer;
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

function TSQLLoadUserDetails.GetMLocStkQuery(const AWhereClause: ANSIString): string;
var
  lWhereStr: String;
begin
  if (AWhereClause <> '') then
    lWhereStr := 'AND ' + AWhereClause + ' '
  else
    lWhereStr := '';
    
  Result := 'SELECT varCode1Trans1, PWExpMode, PWExPDays, PWExpDate, DirCust, '+
                    'DirSupp, MaxSalesA, MaxPurchA, Department, CostCentre, Loc, SalesBank, ' +
                    'PurchBank, ReportPrn, FormPrn, OrPrns1, OrPrns2, CCDepRule, LocRule, ' +
                    'EmailAddr, PWTimeOut, Loaded, UserName, UCPr, UCYr, UDispPrMnth, ShowGLCodes, ' +
                    'ShowStockCode, ShowProductType, UserStatus, PasswordSalt, PasswordHash, WindowUserId, ' +
                    'SecurityQuestionId, SecurityAnswer, ForcePasswordChange, LoginFailureCount, ' +
                    'HighlightPIIFields, HighlightPIIColour ' +
            'FROM [COMPANY].MLOCSTK ' +
            'WHERE RecPfix = ' + QuotedStr(PassUCode) + ' '+
                   'AND SubType = ' + QuotedStr('D') + ' ' +
                   lWhereStr +
            'ORDER BY varCode1Trans1';
end;

//------------------------------------------------------------------------------

function TSQLLoadUserDetails.GetNext: Integer;
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

function TSQLLoadUserDetails.GetUserDetailRec: tPassDefType;
begin
  FillChar(Result, SizeOf(Result), #0);
  with Result do
  begin
    Login := fldUserName.Value;
    PWExpMode := fldPWExpMode.Value;
    PWExPDays := fldPWExPDays.Value;
    PWExpDate := fldPWExpDate.Value;
    DirCust := fldDirCust.Value;
    DirSupp := fldDirSupp.Value;
    MaxSalesA := fldMaxSalesA.Value;
    MaxPurchA := fldMaxPurchA.Value;
    CCDep[BOn] := fldCostCentre.Value;
    CCDep[BOff] := fldDepartment.Value;
    Loc :=  fldLoc.Value;
    SalesBank := fldSalesBank.Value;
    PurchBank := fldPurchBank.Value;
    ReportPrn := fldReportPrn.Value;
    FormPrn := fldFormPrn.Value;
    OrPrns[1] := fldOrPrns1.Value;
    OrPrns[2] := fldOrPrns2.Value;
    CCDepRule := fldCCDepRule.Value;
    LocRule := fldLocRule.Value;
    emailAddr := fldEmailAddr.Value;
    PWTimeOut := fldPWTimeOut.Value;
    Loaded := fldLoaded.Value;
    UserName := fldFullName.Value;
    UCPr := fldUCPr.Value;
    UCYr := fldUCYr.Value;
    UDispPrMnth := fldUDispPrMnth.Value;
    ShowGLCodes := fldShowGLCodes.Value;
    ShowStockCode := fldShowStockCode.Value;
    ShowProductType := fldShowProductType.Value;
    UserStatus := TUserStatus(fldUserStatus.Value);
    PasswordSalt := fldPasswordSalt.Value;
    PasswordHash := fldPasswordHash.Value;
    WindowUserId := fldWindowUserId.Value;
    SecurityQuestionId := fldSecurityQuestionId.Value;
    SecurityAnswer := fldSecurityAnswer.Value;
    ForcePasswordChange := fldForcePasswordChange.Value;
    LoginFailureCount := fldLoginFailureCount.Value;
    {HV 17/10/2017 2017 R2 ABSEXCH-19284: User Profile Highlight PII fields flag}
    HighlightPIIFields := fldHighlightPIIFields.Value;
    HighlightPIIColour := fldHighlightPIIColour.Value;
  end;
end;

//------------------------------------------------------------------------------

procedure TSQLLoadUserDetails.PrepareFields(ADataSet: TDataSet);
begin
  with ADataSet do
  begin
    fldUserName := FieldByName('varCode1Trans1');
    fldPWExpMode := FieldByName('PWExpMode') as TIntegerField;
    fldPWExPDays := FieldByName('PWExPDays') as TIntegerField;
    fldPWExpDate := FieldByName('PWExpDate') as TStringField;
    fldDirCust := FieldByName('DirCust') as TStringField;
    fldDirSupp := FieldByName('DirSupp') as TStringField;
    fldMaxSalesA := FieldByName('MaxSalesA') as TFloatField;
    fldMaxPurchA := FieldByName('MaxPurchA') as TFloatField;
    fldDepartment := FieldByName('Department') as TStringField;
    fldCostCentre := FieldByName('CostCentre') as TStringField;
    fldLoc := FieldByName('Loc') as TStringField;
    fldSalesBank := FieldByName('SalesBank') as TIntegerField;
    fldPurchBank := FieldByName('PurchBank') as TIntegerField;
    fldReportPrn := FieldByName('ReportPrn') as TStringField;
    fldFormPrn := FieldByName('FormPrn') as TStringField;
    fldOrPrns1 := FieldByName('OrPrns1') as TBooleanField;
    fldOrPrns2 := FieldByName('OrPrns2') as TBooleanField;
    fldCCDepRule := FieldByName('CCDepRule') as TIntegerField;
    fldLocRule := FieldByName('LocRule') as TIntegerField;
    fldEmailAddr := FieldByName('EmailAddr') as TStringField;
    fldPWTimeOut := FieldByName('PWTimeOut') as TIntegerField;
    fldLoaded := FieldByName('Loaded') as TBooleanField;
    fldFullName := FieldByName('UserName') as TStringField;
    fldUCPr := FieldByName('UCPr') as TIntegerField;
    fldUCYr := FieldByName('UCYr') as TIntegerField;
    fldUDispPrMnth := FieldByName('UDispPrMnth') as TBooleanField;
    fldShowGLCodes := FieldByName('ShowGLCodes') as TBooleanField;
    fldShowStockCode := FieldByName('ShowStockCode') as TBooleanField;
    fldShowProductType := FieldByName('ShowProductType') as TBooleanField;
    fldUserStatus := FieldByName('UserStatus') as TIntegerField;
    fldPasswordSalt := FieldByName('PasswordSalt') as TStringField;
    fldPasswordHash := FieldByName('PasswordHash') as TStringField;
    fldWindowUserId := FieldByName('WindowUserId') as TStringField;
    fldSecurityQuestionId := FieldByName('SecurityQuestionId') as TIntegerField;
    fldSecurityAnswer := FieldByName('SecurityAnswer') as TStringField;
    fldForcePasswordChange := FieldByName('ForcePasswordChange') as TBooleanField;
    fldLoginFailureCount := FieldByName('LoginFailureCount') as TIntegerField;

    {HV 17/10/2017 2017 R2 ABSEXCH-19284: User Profile Highlight PII fields flag}
    fldHighlightPIIFields := FieldByName('HighlightPIIFields') as TBooleanField;
    fldHighlightPIIColour := FieldByName('HighlightPIIColour') as TIntegerField;
  end;
end;

//------------------------------------------------------------------------------

function TSQLLoadUserDetails.ReadData(const AWhereClause: ANSIString): Integer;
var
  lSQLQuery: AnsiString;
begin
  Result := 9;
  lSQLQuery := GetMLocStkQuery(AWhereClause);
  FSQLCaller.Select(lSQLQuery, FCompanyCode);
  if (FSQLCaller.ErrorMsg = '') And (FSQLCaller.Records.RecordCount > 0) then
  begin
    PrepareFields(FSQLCaller.Records);
    Result := 0;
  end;
end;

//------------------------------------------------------------------------------

end.

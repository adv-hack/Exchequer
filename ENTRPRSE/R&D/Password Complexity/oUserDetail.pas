unit oUserDetail;

interface


{$IFDEF IMPV6}
  {$DEFINE ISYS}
{$ENDIF}

uses
  Dialogs, SysUtils, Classes, oUserIntf, VarConst, VarRec2U, GlobVar, InvListU,
  oUserList, oSQLLoadUserDetails, SQLCallerU, PasswordComplexityConst, SQLUtils,
  oSystemSetup, WinAuthUtil, PWarnU, SHA3HashUtil, PasswordUtil, {$IFNDEF EXDLL}
  CommsInt, {$ENDIF} ADOConnect, SysU1, Sysu2, BTSupU1, BtKeys1U, ETStrU, Btrvu2,
  {$IFDEF ISYS} TBtrvFileClass, {$ENDIF}
  ExWrap1U, EncryptionUtils, ETDateU, VaoUtil; 


type
  TUserDetail = class(TInterfacedObject, IUserDetails)
  private
    FIndex: Integer;
    FUserPassDetailRec: tPassDefType;
    FUserAccessRec: EntryRecType;
    FMode: TUserObjectMode;
    FResetPasswordErrorStr: String;
    FCopyUserName: String30;
    function GetIndex: Integer;
    function GetCopyUserName: String30;
    function GetMode: TUserObjectMode;
    function GetUserPassDetailRec: tPassDefType;
    function GetUserAccessRec: EntryRecType;
    procedure SetUserAccessRec(AUserAccessRec: EntryRecType);
    function GetUserName: String30;
    procedure SetUserName(AValue: String30);
    function GetPwdExpMode: Byte;
    procedure SetPwdExpMode(AValue: Byte);
    function GetPwdExpDays: SmallInt;
    procedure SetPwdExpDays(AValue: SmallInt);
    function GetPwdExpDate: LongDate;
    procedure SetPwdExpDate(AValue: LongDate);
    function GetDirCust: String10;
    procedure SetDirCust(AValue: String10);
    function GetDirSupp: String10;
    procedure SetDirSupp(AValue: String10);
    function GetMaxSalesAuth: Double;
    procedure SetMaxSalesAuth(AValue: Double);
    function GetMaxPurchAuth: Double;
    procedure SetMaxPurchAuth(AValue: Double);
    function GetCCDept: CCDepType;
    procedure SetCCDept(AValue: CCDepType);
    function GetLocation: String10;
    procedure SetLocation(AValue: String10);
    function GetSalesBank: LongInt;
    procedure SetSalesBank(AValue: LongInt);
    function GetPurchBank: LongInt;
    procedure SetPurchBank(AValue: LongInt);
    function GetRepPrint: String50;
    procedure SetRepPrint(AValue: String50);
    function GetFormPrint: String50;
    procedure SetFormPrint(AValue: String50);
    function GetOrPRNS1: Boolean;
    procedure SetOrPRNS1(AValue: Boolean);
    function GetOrPRNS2: Boolean;
    procedure SetOrPRNS2(AValue: Boolean);
    function GetCCDepRules: Byte;
    procedure SetCCDepRules(AValue: Byte);
    function GetLocRules: Byte;
    procedure SetLocRules(AValue: Byte);
    function GetEmailAddr: String100;
    procedure SetEmailAddr(AValue: String100);
    function GetPwdTimeOut: SmallInt;
    procedure SetPwdTimeOut(AValue: SmallInt);
    function GetLoaded: Boolean;
    procedure SetLoaded(AValue: Boolean);
    function GetFullName: String50;
    procedure SetFullName(AValue: String50);          //UserName
    function GetUcPr: Byte;
    procedure SetUcPr(AValue: Byte);
    function GetUcYr: Byte;
    procedure SetUcYr(AValue: Byte);
    function GetUDispPrMonth: Boolean;
    procedure SetUDispPrMonth(AValue: Boolean);
    function GetShowGlCodes: Boolean;
    procedure SetShowGlCodes(AValue: Boolean);
    function GetShowStockCodes: Boolean;
    procedure SetShowStockCodes(AValue: Boolean);
    function GetShowProductType: Boolean;
    procedure SetShowProductType(AValue: Boolean);
    function GetUserStatus: TUserStatus;
    procedure SetUserStatus(AValue: TUserStatus);
    function GetPwdSalt: String16;
    procedure SetPwdSalt(AValue: String16);
    function GetPwdHash: String64;
    procedure SetPwdHash(AValue: String64);
    function GetWindowUserId: String100;
    procedure SetWindowUserId(AValue: String100);
    function GetSecurityQuesId: LongInt;
    procedure SetSecurityQuesId(AValue: LongInt);
    function GetSecurityQuesAns: String139;
    procedure SetSecurityQuesAns(AValue: String139);
    function GetForcePwdChange: Boolean;
    procedure SetForcePwdChange(AValue: Boolean);
    function GetLoginFailCount: LongInt;
    procedure SetLoginFailCount(AValue: LongInt);
    function GetUserStatusDescription: String;

    {HV 17/10/2017 2018-R1 ABSEXCH-19284: User Profile Highlight PII fields flag (GDPR)}
    function GetHighlightPIIFields: Boolean;
    procedure SetHighlightPIIFields(AValue: Boolean);
    function GetHighlightPIIColour: LongInt;
    procedure SetHighlightPIIColour(AValue: LongInt);

    // Validation routine - runs through the list of fields validating the current value, FieldSet
    // allows the validation of a specific field, e.g. during OnExit, or pass in Empty for all
    // fields to be validated
    function Validate(AOwner: TComponent; const AFieldSet: TUserFieldsSet = []): Integer;
    // Returns an error description for an error code returned by Validate
    function ValidationErrorDescription(const AValidationError: Integer): String;
    //Edit User
    function EditUser: IUserDetails;
    // Cancels an update freeing the record lock
    function LoadUserData: Boolean; virtual; abstract;
    procedure SetDefaultFieldValue;
    function IsValidDomain(AWinUserID: string): Boolean;
    function IsValidEmail(const AValue: string): Boolean;
    //save access settings
    function InitSetEntryRec: EntryRecType;
    function SaveAccessSetting: Integer;
    procedure SetAccessSettingsYes(APermission : Boolean);
    //User Authetication
    function AuthenticateUser(const AUserName, APassword: String): Integer;
    function AuthenticationErrorDescription(const AAuthError: Integer): String;
    function Get_PWDefaults: tPassDefType;
    procedure UpdateGlobalUserProfile(const AUserName: String);

    {$IFDEF ISYS}
      procedure OpenSyssEDI2;
    {$ENDIF}

  protected
    function Save: Integer; virtual; abstract;
    function SaveErrorDescription(const AStatus: Integer): String; virtual; abstract;
    function ResetPassword(ASendEmail, AUpdateInDB: Boolean; AMsgType: Integer = 1): Integer; virtual; abstract;
    function ResetPasswordErrorDescription(const AStatus: Integer): String; virtual; abstract;
  public
    constructor Create(const AIndex: Integer;
                       const AMode : TUserObjectMode;
                       const AUserPassDetailRec: tPassDefType);

    property udMode : TUserObjectMode Read FMode;
  end; //TUserDetail

  TPervasiveUserDetail = class(TUserDetail)
  private
    function LoadUserDataByWinID(const AWinID: String): Boolean;
    function LoadUserData: Boolean; override;
    // Impo
    {$IFDEF IMPV6}
      function LoadUserDataForImpoter: Boolean;
      function ChangePasswordForImporter: Integer;
    {$ENDIF}
    Function SaveNewUser: Integer;
    Function SaveExistingUser: Integer;
  protected
    function Save: Integer; override;
    function SaveErrorDescription(const AStatus: Integer): String; override;
    function ResetPassword(ASendEmail, AUpdateInDB: Boolean; AMsgType: Integer = 1): Integer; override;
    function ResetPasswordErrorDescription(const AStatus: Integer): String; override;
  public
    constructor Create(const AIndex: Integer;
                       const AMode: TUserObjectMode;
                       const AUserPassDetailRec: tPassDefType);
    destructor Destroy; override;
  end;

  TSQLUserDetail = class(TUserDetail)
  private
    FSQLCaller: TSQLCaller;
    FCompanyCode: AnsiString;
    FSaveError: String;
    function LoadUserData: Boolean; override;
    function SaveNewUser: Integer;
    function SaveExistingUser: Integer;
  protected
    function Save: Integer; override;
    function SaveErrorDescription(const AStatus: Integer): String; override;
    function ResetPassword(ASendEmail, AUpdateInDB: Boolean; AMsgType: Integer = 1): Integer; override;
    function ResetPasswordErrorDescription(const AStatus: Integer): String; override;
  public
    constructor Create(const AIndex: Integer;
                       const AMode: TUserObjectMode;
                       const AUserPassDetailRec: tPassDefType);
    destructor Destroy; override;
  end;

//Create Single User
function CreateUser(const AIndex: Integer;
                    const AMode: TUserObjectMode;
                    const AUserPassDetailRec: tPassDefType): TUserDetail;

implementation

//------------------------------------------------------------------------------
{ TUserDetail }
//------------------------------------------------------------------------------

function CreateUser(const AIndex: Integer;
                    const AMode: TUserObjectMode;
                    const AUserPassDetailRec: tPassDefType): TUserDetail;
begin
  if SQLUtils.UsingSQL then
    Result := TSQLUserDetail.Create(AIndex, AMode, AUserPassDetailRec)
  else
    Result := TPervasiveUserDetail.Create(AIndex, AMode, AUserPassDetailRec);
end;

//------------------------------------------------------------------------------

constructor TUserDetail.Create(const AIndex: Integer;
                               const AMode: TUserObjectMode;
                               const AUserPassDetailRec: tPassDefType);
begin
  inherited Create;
  FIndex := AIndex;
  FMode := AMode;
  FUserPassDetailRec := AUserPassDetailRec;
  //Load Access setting from Database
  if AMode <> umReadOnly then
    FUserAccessRec := InitSetEntryRec;

  if AMode In [umInsert, umCopy] then
  begin
    // used for While useing Copy option, need to copy data
    FCopyUserName := AUserPassDetailRec.Login;
    SetDefaultFieldValue;
  end;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetCCDept: CCDepType;
begin
  Result := FUserPassDetailRec.CCDep;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetCCDepRules: Byte;
begin
  Result := FUserPassDetailRec.CCDepRule;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetDirCust: String10;
begin
  Result := FUserPassDetailRec.DirCust;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetDirSupp: String10;
begin
  Result := FUserPassDetailRec.DirSupp;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetEmailAddr: String100;
begin
  Result := FUserPassDetailRec.emailAddr;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetForcePwdChange: Boolean;
begin
  Result := FUserPassDetailRec.ForcePasswordChange;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetFormPrint: String50;
begin
  Result := FUserPassDetailRec.FormPrn;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetFullName: String50;
begin
  Result := FUserPassDetailRec.UserName;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetIndex: Integer;
begin
  Result := FIndex;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetLoaded: Boolean;
begin
  Result := FUserPassDetailRec.Loaded;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetLocation: String10;
begin
  Result := FUserPassDetailRec.Loc;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetLocRules: Byte;
begin
  Result := FUserPassDetailRec.LocRule;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetLoginFailCount: LongInt;
begin
  Result := FUserPassDetailRec.LoginFailureCount
end;

//------------------------------------------------------------------------------

function TUserDetail.GetMaxPurchAuth: Double;
begin
  Result := FUserPassDetailRec.MaxPurchA;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetMaxSalesAuth: Double;
begin
  Result := FUserPassDetailRec.MaxSalesA;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetMode: TUserObjectMode;
begin
  Result := FMode;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetOrPRNS1: Boolean;
begin
  Result := FUserPassDetailRec.OrPrns[1];
end;

//------------------------------------------------------------------------------

function TUserDetail.GetPurchBank: LongInt;
begin
  Result := FUserPassDetailRec.PurchBank;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetPwdExpDate: LongDate;
begin
  Result := FUserPassDetailRec.PWExpDate;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetPwdExpDays: SmallInt;
begin
  Result := FUserPassDetailRec.PWExPDays;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetPwdExpMode: Byte;
begin
  Result := FUserPassDetailRec.PWExpMode;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetPwdHash: String64;
begin
  Result := FUserPassDetailRec.PasswordHash;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetPwdSalt: String16;
begin
  Result := FUserPassDetailRec.PasswordSalt;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetPwdTimeOut: SmallInt;
begin
  Result := FUserPassDetailRec.PWTimeOut;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetRepPrint: String50;
begin
  Result := FUserPassDetailRec.ReportPrn;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetSalesBank: LongInt;
begin
  Result := FUserPassDetailRec.SalesBank;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetSecurityQuesAns: String139;
begin
  Result := DecryptUserSecurityAnswer(FUserPassDetailRec.SecurityAnswer);
end;

//------------------------------------------------------------------------------

function TUserDetail.GetSecurityQuesId: LongInt;
begin
  Result := FUserPassDetailRec.SecurityQuestionId;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetShowGlCodes: Boolean;
begin
  Result := FUserPassDetailRec.ShowGLCodes;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetShowProductType: Boolean;
begin
  Result := FUserPassDetailRec.ShowProductType;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetShowStockCodes: Boolean;
begin
  Result := FUserPassDetailRec.ShowStockCode;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetUcPr: Byte;
begin
  Result := FUserPassDetailRec.UCPr;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetUcYr: Byte;
begin
  Result := FUserPassDetailRec.UCYr;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetUDispPrMonth: Boolean;
begin
  Result := FUserPassDetailRec.UDispPrMnth;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetUserName: String30;
begin
  Result := FUserPassDetailRec.Login;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetUserStatus: TUserStatus;
begin
  Result := FUserPassDetailRec.UserStatus;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetUserStatusDescription: String;
begin
  Result := UserStatusDescription[FUserPassDetailRec.UserStatus];
end;

//------------------------------------------------------------------------------

function TUserDetail.GetWindowUserId: String100;
begin
  Result := FUserPassDetailRec.WindowUserId;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetCCDept(AValue: CCDepType);
begin
  FUserPassDetailRec.CCDep := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetCCDepRules(AValue: Byte);
begin
  if AValue > 0 then
    FUserPassDetailRec.CCDepRule := AValue
  else
    FUserPassDetailRec.CCDepRule := 0;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetDirCust(AValue: String10);
begin
  if AValue <> '' then
    FUserPassDetailRec.DirCust := FullCustCode(AValue)
  else
    Blank(FUserPassDetailRec.DirCust, Sizeof(FUserPassDetailRec.DirCust));
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetDirSupp(AValue: String10);
begin
  if AValue <> '' then
    FUserPassDetailRec.DirSupp := AValue
  else
    Blank(FUserPassDetailRec.DirSupp, sizeOf(FUserPassDetailRec.DirSupp));
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetEmailAddr(AValue: String100);
begin
  FUserPassDetailRec.emailAddr := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetForcePwdChange(AValue: Boolean);
begin
  FUserPassDetailRec.ForcePasswordChange := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetFormPrint(AValue: String50);
begin
  if AValue <> '' then
    FUserPassDetailRec.FormPrn := Copy(AValue, 1, 50)
  else
    Blank(FUserPassDetailRec.FormPrn, sizeof(FUserPassDetailRec.FormPrn));
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetFullName(AValue: String50);
begin
  FUserPassDetailRec.UserName := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetLoaded(AValue: Boolean);
begin
  FUserPassDetailRec.Loaded := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetLocation(AValue: String10);
begin
  if AValue <> '' then
    FUserPassDetailRec.Loc := AValue
  else
    Blank(FUserPassDetailRec.Loc, Sizeof(FUserPassDetailRec.Loc));
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetLocRules(AValue: Byte);
begin
  if AValue > 0 then
    FUserPassDetailRec.LocRule := AValue
  else
    FUserPassDetailRec.LocRule := 0;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetLoginFailCount(AValue: Integer);
begin
  FUserPassDetailRec.LoginFailureCount := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetMaxPurchAuth(AValue: Double);
begin
  FUserPassDetailRec.MaxPurchA := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetMaxSalesAuth(AValue: Double);
begin
  FUserPassDetailRec.MaxSalesA := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetOrPRNS1(AValue: Boolean);
begin
  FUserPassDetailRec.OrPrns[1] := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetPurchBank(AValue: Integer);
begin
  FUserPassDetailRec.PurchBank := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetPwdExpDate(AValue: LongDate);
begin
  FUserPassDetailRec.PWExpDate := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetPwdExpDays(AValue: SmallInt);
begin
  FUserPassDetailRec.PWExPDays := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetPwdExpMode(AValue: Byte);
begin
  if AValue > 0 then
    FUserPassDetailRec.PWExpMode := AValue
  else
    FUserPassDetailRec.PWExpMode := 0;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetPwdHash(AValue: String64);
begin
  FUserPassDetailRec.PasswordHash :=  StrToSHA3Hase(FUserPassDetailRec.PasswordSalt + AValue)
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetPwdSalt(AValue: String16);
begin
  FUserPassDetailRec.PasswordSalt := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetPwdTimeOut(AValue: SmallInt);
begin
  FUserPassDetailRec.PWTimeOut := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetRepPrint(AValue: String50);
begin
  if AValue <> '' then
    FUserPassDetailRec.ReportPrn := Copy(AValue, 1, 50)
  else
    Blank(FUserPassDetailRec.ReportPrn, SizeOf(FUserPassDetailRec.ReportPrn));
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetSalesBank(AValue: Integer);
begin
  FUserPassDetailRec.SalesBank := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetSecurityQuesAns(AValue: String139);
begin
  FUserPassDetailRec.SecurityAnswer := EncryptUserSecurityAnswer(Copy(AValue, 1, 100));
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetSecurityQuesId(AValue: Integer);
begin
  FUserPassDetailRec.SecurityQuestionId := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetShowGlCodes(AValue: Boolean);
begin
  FUserPassDetailRec.ShowGLCodes := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetShowProductType(AValue: Boolean);
begin
  FUserPassDetailRec.ShowProductType := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetShowStockCodes(AValue: Boolean);
begin
  FUserPassDetailRec.ShowStockCode := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetUcPr(AValue: Byte);
begin
  FUserPassDetailRec.UCPr := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetUcYr(AValue: Byte);
begin
  FUserPassDetailRec.UCYr := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetUDispPrMonth(AValue: Boolean);
begin
  FUserPassDetailRec.UDispPrMnth := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetUserName(AValue: String30);
begin
  if FUserPassDetailRec.Login <> LJVar(AValue, LoginKeyLen) then
    FUserPassDetailRec.Login := UpperCase(LJVar(AValue, LoginKeyLen));
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetUserStatus(AValue: TUserStatus);
begin
  FUserPassDetailRec.UserStatus := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetWindowUserId(AValue: String100);
begin
  FUserPassDetailRec.WindowUserId := AValue;
end;

//------------------------------------------------------------------------------

function TUserDetail.Validate(AOwner: TComponent; const AFieldSet: TUserFieldsSet): Integer;
var
  liField: TUserFieldsEnum;
  lUserDetailList: IUserDetailList;
  lFoundCode: Str20;
begin
  Result := 0;

  for liField := Low(liField) to High(liField) do
  begin
    if (liField In AFieldSet) or (AFieldSet = []) then
    begin
      case liField of
        udfUserName       : begin //User name field should not be left blank
                              if (trim(FUserPassDetailRec.Login) = EmptyStr) then
                                Result := 1001
                              else
                              begin
                                if FMode in [umInsert, umCopy] then
                                begin
                                  if (UpperCase(trim(FUserPassDetailRec.Login)) = 'SYSTEM') then
                                    Result := 1008
                                  else
                                  begin
                                    lUserDetailList := UserDetailList(True);
                                    if Assigned(lUserDetailList) then   //If user name matches with existing User give Error
                                    begin
                                      if Assigned(lUserDetailList.FindUserByUserName(FUserPassDetailRec.Login)) then
                                        Result := 1002;
                                    end;
                                  end;
                                end;
                              end; // Else
                            end; //udfUserName
        udfWindowUserId   : begin //Windows User ID field should not be left blank
                              // MH 22/02/2018 2018-R1 ABSEXCH-19810: Ignore Windows User ID if User is suspended
                              If (FUserPassDetailRec.UserStatus <> usSuspendedAdmin) Then
                              Begin
                                if SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Windows then
                                begin
                                  if (FUserPassDetailRec.WindowUserId <> EmptyStr) then
                                  begin
                                    if not IsValidDomain(FUserPassDetailRec.WindowUserId) then
                                      Result := 1003
                                    else
                                    begin
                                      // Check Duplicate Windows User ID
                                      if not assigned(lUserDetailList) then
                                        lUserDetailList := UserDetailList;
                                      if Assigned(lUserDetailList.FindUserByWinUserID(FUserPassDetailRec.Login, FUserPassDetailRec.WindowUserId)) then
                                        Result := 1005;
                                    end;
                                  end
                                  else
                                    Result := 1003;
                                end //if SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Windows then
                                else
                                begin
                                  if (FUserPassDetailRec.WindowUserId <> EmptyStr) then
                                  begin
                                    if not IsValidDomain(FUserPassDetailRec.WindowUserId) then
                                      Result := 1003
                                    else
                                    begin
                                      // Check Duplicate Windows User ID
                                      if not assigned(lUserDetailList) then
                                        lUserDetailList := UserDetailList;
                                      if Assigned(lUserDetailList.FindUserByWinUserID(FUserPassDetailRec.Login, FUserPassDetailRec.WindowUserId)) then
                                        Result := 1005;
                                    end;
                                  end;
                                end;
                              End; // If (FUserPassDetailRec.UserStatus <> usSuspendedAdmin)
                            end; //udfWindowUserId
        udfEmailAddr      : begin
                              if FUserPassDetailRec.emailAddr <> EmptyStr then
                              begin
                                if not IsValidEmail(FUserPassDetailRec.emailAddr) then
                                  Result := 1004;
                              end;
                            end; //udfEmailAddr
        udfSecurityAnswer : begin
                              if (Fmode = umUpdate) and (SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Exchequer) then
                              begin
                                if (Trim(FUserPassDetailRec.Login) = trim(EntryRec^.Login)) then
                                  if (FUserPassDetailRec.SecurityAnswer = EmptyStr) then
                                    Result := 1006;
                              end;
                            end; //udfSecurityAnswer;
        udfPwdExpiryDate : begin
                             if (SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Exchequer) and (FUserPassDetailRec.PWExpMode = PWExpModeExpDays) then
                             begin
                               //SSK 14/10/2017 ABSEXCH-19379 : date difference from current date should be between 1 - 999
                               if not((FUserPassDetailRec.PWExpDate > today) and (NoDays(today, FUserPassDetailRec.PWExpDate) <= 999)) then
                                 Result := 1009;
                             end;
                           end;
        udfCC            : begin
                             if Syss.UseCCDep and (not EmptyKeyS(FUserPassDetailRec.CCDep[True], CCKeyLen, BOff)) then
                             begin
                               if not GetCCDep(AOwner, FUserPassDetailRec.CCDep[True], lFoundCode, True, -1) then
                                 Result := 1010;
                             end;
                           end;
        udfDep           : begin
                             if Syss.UseCCDep and (not EmptyKeyS(FUserPassDetailRec.CCDep[False], CCKeyLen, BOff)) then
                             begin
                               if not GetCCDep(AOwner, FUserPassDetailRec.CCDep[False], lFoundCode, False, -1) then
                                 Result := 1011;
                             end;
                           end;
      else
        raise Exception.Create ('TUserDetail.Validate: Unhandled field validation (' + IntToStr(Ord(liField)) + ')');
      end; //case liField of
      // Error - drop out of loop and return current Error Code
      if (Result <> 0) Then
        Break;
    end; //if (Result In AFieldSet) or (AFieldSet = []) then
  end; //for liField := Low(liField) to High(liField) do
end;

//------------------------------------------------------------------------------

function TUserDetail.ValidationErrorDescription(const AValidationError: Integer): String;
begin
  case AValidationError of
    0     : Result := 'OK';
    1001  : Result := 'Please enter a valid User name.';
    1002  : Result := Format('User Name (%s) already exists.', [trim(FUserPassDetailRec.Login)]);
    1003  : Result := 'Please enter a valid Windows ID (Domain\UserID).';
    1004  : Result := 'An invalid email address was entered.';
    1005  : Result := Format('Windows ID (%s) already exists.', [trim(FUserPassDetailRec.WindowUserId)]);
    1006  : Result := 'Please complete a ''Security Question'' answer.';
    1007  : Result := 'Failed to generate a new Password.';
    1008  : Result := '''SYSTEM'' is a reserved User name. Please enter a new User name.';
    //SSK 14/10/2017 ABSEXCH-19379 : this message changes as per QA's Comment in the Jira
    1009  : Result := Format('You have entered an invalid date (%s). Please enter a date between %s - %s.', [trim(POutDate(FUserPassDetailRec.PWExpDate)),
                                                                                                             trim(POutDate(CalcDueDatexDays(today,1))),
                                                                                                             trim(POutDate(CalcDueDatexDays(today,999)))]);
    1010  : Result := 'The default Cost Centre Code is not valid.';
    1011  : Result := 'The default Department Code is not valid.';
  else
    Result := msgUnknownError + IntToStr(AValidationError);
  end;
end;

//------------------------------------------------------------------------------
{ TSQLUserDetail }
//------------------------------------------------------------------------------

constructor TSQLUserDetail.Create(const AIndex: Integer;
                                  const AMode: TUserObjectMode;
                                  const AUserPassDetailRec: tPassDefType);

var
  lUserPassDetailRec: tPassDefType;
begin
  lUserPassDetailRec := AUserPassDetailRec;
  {$IFDEF IMPV6}
    //this check is done to handle Multi-Company Scenario
    if SetDrive = EmptyStr then
      FCompanyCode := SQLUtils.GetCompanyCode(VAOInfo.vaoCompanyDir)
    else
      FCompanyCode := SetDrive;
  {$ELSE}
    FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);
  {$ENDIF}

  FMode := AMode;
  if AMode <> umReadOnly then
  begin
    FSQLCaller := TSQLCaller.Create(GlobalAdoConnection);
    // Create and configure a SQL Query instance
    if (AMode = umLogin) or ((AMode = umUpdate) and ((not ChkAllowed_In(92)) or
       (ChkAllowed_In(92) and (Trim(AUserPassDetailRec.Login) = trim(EntryRec^.Login)))))
    then
    begin
      FUserPassDetailRec := AUserPassDetailRec;
      if LoadUserData then
        lUserPassDetailRec := FUserPassDetailRec
      else
        FillChar(lUserPassDetailRec, SizeOf(lUserPassDetailRec), #0);
    end;
  end;
  inherited Create(AIndex, AMode, lUserPassDetailRec);
end;

//------------------------------------------------------------------------------

destructor TSQLUserDetail.Destroy;
begin
  FreeAndNIL(FSQLCaller);
  inherited Destroy;
end;

//------------------------------------------------------------------------------
{ TPervasiveUserDetail }
//------------------------------------------------------------------------------

{$IFDEF IMPV6}
function TPervasiveUserDetail.ChangePasswordForImporter: Integer;
var
  lMLocStkFile: TBtrvFile;
  lMLocRec: MLocRec;
  lKeyS: Str255;
  lStatus: Integer;
  lLoginWinId: String;
begin
  Result := 0;
  FillChar(lMLocRec, SizeOf(lMLocRec), #0);
  lMLocStkFile := TBtrvFile.Create;
  try
    lMLocStkFile.FileIx := MLocF;
    lMLocStkFile.FileName := IncludeTrailingPathDelimiter(VAOInfo.vaoCompanyDir) + 'STOCK\MLocStk.dat';
    lMLocStkFile.RecordLength := SizeOf(MLocRec);
    lMLocStkFile.KeySegs      := 6;
    lMLocStkFile.DefineKey(1, 1, 32, DupModSeg + DupMod);

    lKeyS := FullPWordKey(PassUCode, 'D', FUserPassDetailRec.Login);
    lStatus := lMLocStkFile.FindRecord(lMLocRec, lKeyS);
    if lStatus = 0 then
    begin
      lMLocRec.RecPfix := 'P';
      lMLocRec.SubType := 'D';
      lMLocRec.PassDefRec := FUserPassDetailRec;
      Result := lMLocStkFile.UpdateRecord;
    end
    else
      Result := 1;
  finally
    lMLocStkFile.CloseFile;
    FreeAndNil(lMLocStkFile);
  end;
end;
{$ENDIF}

//------------------------------------------------------------------------------

constructor TPervasiveUserDetail.Create(const AIndex: Integer;
  const AMode: TUserObjectMode; const AUserPassDetailRec: tPassDefType);
var
  lUserPassDetailRec: tPassDefType;
begin
  lUserPassDetailRec := AUserPassDetailRec;
  FMode := AMode;
  if AMode <> umReadOnly then
  begin
    if (AMode = umLogin) or ((AMode = umUpdate) and ((not ChkAllowed_In(92)) or
       (ChkAllowed_In(92) and (Trim(AUserPassDetailRec.Login) = trim(EntryRec^.Login)))))
    then
    begin
      FUserPassDetailRec := AUserPassDetailRec;
      if LoadUserData then
        lUserPassDetailRec := FUserPassDetailRec
      else
        FillChar(lUserPassDetailRec, SizeOf(lUserPassDetailRec), #0);
    end;
  end;
  inherited Create(AIndex, AMode, lUserPassDetailRec);
end;

//------------------------------------------------------------------------------

destructor TPervasiveUserDetail.Destroy;
begin
  inherited Destroy;
end;

//------------------------------------------------------------------------------

function TUserDetail.EditUser: IUserDetails;
var
  loUser: TUserDetail;
begin
  // Create a new 'Edit' object for the current User
  loUser := CreateUser(0, umUpdate, FUserPassDetailRec);

  if loUser.LoadUserData then // Re-reads the User details and applies a record lock in the Pervasive
  begin
    loUser.SetDefaultFieldValue;
    Result := loUser      // Success
  end
  else
  begin // Failed to read details / open file / Record Lock Failed / etc...
    loUser.Free;
    Result := nil
  end;
end;

//------------------------------------------------------------------------------

function TPervasiveUserDetail.LoadUserData: Boolean;
var
  lStatus: Integer;
  lKeyS: Str255;
begin
  Result := False;
  {$IFDEF IMPV6}
    if FMode = umLogin then
      Result := LoadUserDataForImpoter;
    Exit;
  {$ENDIF}

  if (FMode = umLogin) and (SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Windows) and (FUserPassDetailRec.WindowUserId <> EmptyStr) then
    Result := LoadUserDataByWinID(Trim(FUserPassDetailRec.WindowUserId))
  else
  begin
    lKeyS := FullPWordKey(PassUCode, 'D', FUserPassDetailRec.Login);
    lStatus := Find_Rec(B_GetEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, lKeyS);
    if lStatus = 0 then
    begin
      with MLocCtrl^.PassDefRec do
      begin
        if (MLocCtrl^.RecPfix = PassUCode) and (MLocCtrl^.SubType = 'D') then
        begin
          FUserPassDetailRec := MLocCtrl^.PassDefRec;
          Result := True;
        end;
      end;
    end;
  end;

  {$IFDEF ISYS}
    if FMode = umLogin then
      OpenSyssEDI2;
  {$ENDIF}
end;

//------------------------------------------------------------------------------

function TSQLUserDetail.LoadUserData: Boolean;
var
  loLoadUserDetails: TSQLLoadUserDetails;
  lRes : Integer;
begin
  Result := False;
  if Assigned(FSQLCaller) then
  begin
    // Refresh the User details and Update call to check for changes
    loLoadUserDetails := TSQLLoadUserDetails.Create(FSQLCaller);
    try
      if (FMode = umLogin) and (SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Windows) then
        lRes := loLoadUserDetails.ReadData('(Upper(WindowUserId) = ' + QuotedStr(Trim(FUserPassDetailRec.WindowUserId)) + ')')
      else
        lRes := loLoadUserDetails.ReadData('(varCode1Trans1 = ' + QuotedStr(Trim(FUserPassDetailRec.Login)) + ')');

      if lRes = 0 then
      begin
        {$IFDEF ISYS}
          OpenSyssEDI2;
        {$ENDIF}
        lRes := loLoadUserDetails.GetFirst;
        if lRes = 0 then
        begin
          // Update Tax Region fields
          FUserPassDetailRec := loLoadUserDetails.UserDetailRec;
          Result := True;
        end;
      end;
    finally
      loLoadUserDetails.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetUserPassDetailRec: tPassDefType;
begin
  Result := FUserPassDetailRec;
end;

//------------------------------------------------------------------------------

function TPervasiveUserDetail.LoadUserDataByWinID(const AWinID: String): Boolean;
var
  lStatus: Integer;
  lKeyS: Str255;
begin
  Result := False;
  lKeyS := FullPWordKey(PassUCode, 'D', EmptyStr);
  //HV 04/07/2018 2018 R1.1 ABSEXCH-20893: Kevin Nash Performance Issues Since Upgrading (User Management List)
  // SSK 04/07/2018 2018-R1.1 ABSEXCH-20940: B_GetFirst replaced with B_GetGEq to address performance issue for Windows Authentication
  lStatus := Find_Rec(B_GetGEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, lKeyS);
  while (lStatus = 0) And (MLocCtrl^.RecPfix = PassUCode) And (MLocCtrl^.SubType = 'D') Do
  begin
    if (UpperCase(MLocCtrl^.PassDefRec.WindowUserId) = UpperCase(AWinID)) then
    begin
      FUserPassDetailRec := MLocCtrl^.PassDefRec;
      Result := True;
      Break;
    end;
    lStatus := Find_Rec(B_GetNext, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, lKeyS);
  end;
end;

//------------------------------------------------------------------------------

{$IFDEF IMPV6}
function TPervasiveUserDetail.LoadUserDataForImpoter: Boolean;
var
  lMLocStkFile: TBtrvFile;
  lMLocRec: MLocRec;
  lKeyS: Str255;
  lStatus: Integer;
  lLoginWinId: String;
begin
  Result := False;
  lLoginWinId := Trim(FUserPassDetailRec.WindowUserId);
  FillChar(lMLocRec, SizeOf(lMLocRec), #0);
  lMLocStkFile := TBtrvFile.Create;
  try
    lMLocStkFile.FileIx := MLocF;
    lMLocStkFile.FileName := IncludeTrailingPathDelimiter(VAOInfo.vaoCompanyDir) + 'STOCK\MLocStk.dat';
    lMLocStkFile.RecordLength := SizeOf(MLocRec);
    lMLocStkFile.KeySegs      := 6;
    lMLocStkFile.DefineKey(1, 1, 32, DupModSeg + DupMod);

    if (SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Windows) and (lLoginWinId <> EmptyStr) then
    begin
      lKeyS := FullPWordKey(PassUCode, 'D', EmptyStr);
      //HV 10/07/2018 2018R1.1 ABSEXCH-20940: changes made to address performance issue for Windows Authentication
      lStatus := lMLocStkFile.FindGEq(lMLocRec, lKeyS);
      while (lStatus = 0) and (lMLocRec.RecPfix = PassUCode) and (lMLocRec.SubType = 'D') do
      begin
        with lMLocRec.PassDefRec do
        begin
          if (UpperCase(WindowUserId) = UpperCase(lLoginWinId)) then
          begin
            FUserPassDetailRec := lMLocRec.PassDefRec;
            Result := True;
            Break;
          end;
        end;
        lStatus := lMLocStkFile.FindNext(lMLocRec);
      end;
    end
    else
    begin
      lKeyS := FullPWordKey(PassUCode, 'D', FUserPassDetailRec.Login);
      lStatus := lMLocStkFile.FindRecord(lMLocRec, lKeyS, MLK);
      if lStatus = 0 then
      begin
        with lMLocRec.PassDefRec do
        begin
          if (lMLocRec.RecPfix = PassUCode) and (lMLocRec.SubType = 'D') then
          begin
            FUserPassDetailRec := lMLocRec.PassDefRec;
            Result := True;
          end;
        end;
      end;
    end
  finally
    lMLocStkFile.CloseFile;
    FreeAndNil(lMLocStkFile);
  end;
  OpenSyssEDI2;
end;
{$ENDIF}

//------------------------------------------------------------------------------
{$IFDEF ISYS}
procedure TUserDetail.OpenSyssEDI2;
var
  lSyssEDI2File: TBtrvFile;
  lSyssEDI2: EDI2Rec;
  lKeyS: Str255;
  lStatus: Integer;
begin
  if (SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Windows) then
    Exit;
  FillChar(lSyssEDI2, SizeOf(lSyssEDI2), #0);
  //HV 11/07/2018 2018R1.1 ABSEXCH-21002: Importer > Importing after Re-login to another company with same job gives access violation.
  New(SyssEDI2);

  lSyssEDI2File := TBtrvFile.Create;
  try
    lSyssEDI2File.FileIx := SysF;
    {$IFDEF IMPV6}
      lSyssEDI2File.FileName := IncludeTrailingPathDelimiter(VAOInfo.vaoCompanyDir) + 'ExchqSS.dat';
    {$ELSE}
      lSyssEDI2File.FileName := IncludeTrailingPathDelimiter(SetDrive) + 'ExchqSS.dat';
    {$ENDIF}
    lSyssEDI2File.RecordLength := SizeOf(lSyssEDI2);
    lSyssEDI2File.KeySegs      := 1;
    lSyssEDI2File.DefineKey(1, 1, 5, DupModSeg + DupMod);
    lKeyS := SysNames[EDI2R];
    lStatus := lSyssEDI2File.FindRecord(lSyssEDI2, lKeyS);
    if (lStatus = 0) and Assigned(SyssEDI2) then
      SyssEDI2^ := lSyssEDI2;
  finally
    lSyssEDI2File.CloseFile;
    FreeAndNil(lSyssEDI2File);
  end;
end;
{$ENDIF}

//------------------------------------------------------------------------------

function TPervasiveUserDetail.ResetPassword(ASendEmail, AUpdateInDB: Boolean; AMsgType: Integer = 1): Integer;
var
  lPassStr,
  lUserID: String;
  lRes: Integer;
  lDaysLeft: Longint;
begin
  lRes := 0;
  FResetPasswordErrorStr := EmptyStr;
  if ASendEmail then
  begin
    if (SystemSetup(True).PasswordAuthentication.AuthenticationMode = AuthMode_Exchequer) then
      lUserID := FUserPassDetailRec.Login
    else
      lUserID := FUserPassDetailRec.WindowUserId;
    lRes := SendResetPwrdEmail(lPassStr, lUserID, FUserPassDetailRec.emailAddr, AMsgType);
    if lRes = 0 then
    begin
      //Called from User Management List
      if FUserPassDetailRec.PasswordSalt = EmptyStr then
        FUserPassDetailRec.PasswordSalt := GenerateRandomPwdSalt;
      if lPassStr <> '' then
        FUserPassDetailRec.PasswordHash := StrToSHA3Hase(FUserPassDetailRec.PasswordSalt + lPassStr);
      FUserPassDetailRec.ForcePasswordChange := True;
    end
    else
      FResetPasswordErrorStr := msgEmailError {$IFNDEF EXDLL} + EmailErr(lRes) {$ENDIF EXDLL};
  end;

  if (AUpdateInDB) and (lRes = 0) then
  begin
    {AP 02/11/2017 ABSEXCH-19411 : Status of the User whose Password has Expired does not change when System User updates password using 'Change Password' & 'Reset Password'}
    if (FUserPassDetailRec.PWExpMode = PWExpModeExpired) then
      FUserPassDetailRec.PWExpMode := PWExpModeExpDays;

    {SSK 30/10/2017 ABSEXCH-19353 : When Password Changes, the Expiry Date field should be reset in User Profile}
    if (FUserPassDetailRec.PWExpMode = PWExpModeExpDays) then
      FUserPassDetailRec.PWExpDate := CalcDueDate(Today, FUserPassDetailRec.PWExPDays);

    lRes := SaveExistingUser;
  end;
  Result := lRes;
end;

//------------------------------------------------------------------------------

function TPervasiveUserDetail.ResetPasswordErrorDescription(
  const AStatus: Integer): String;
begin
  if Trim(FResetPasswordErrorStr) <> EmptyStr then
    Result := FResetPasswordErrorStr
  else
    Result := msgUnknownError + IntToStr(AStatus);
end;

//------------------------------------------------------------------------------

function TPervasiveUserDetail.Save: Integer;
begin
  if FMode = umInsert then
    Result := SaveNewUser
  else if FMode In [umUpdate, umLogin] then
    Result := SaveExistingUser
  else
    raise Exception.Create('TPervasiveUserDetail.Save: Unsupported Mode (' + IntToStr(Ord(FMode)) + ')');
end;

//------------------------------------------------------------------------------

function TPervasiveUserDetail.SaveErrorDescription(
  const AStatus: Integer): String;
begin
  Report_BError(MLocF, AStatus);
end;

//------------------------------------------------------------------------------

function TSQLUserDetail.ResetPassword(ASendEmail, AUpdateInDB: Boolean; AMsgType: Integer = 1): Integer;
var
  lPassStr,
  lUserID,
  lQuery: String;
  lRes: Integer;
  lSQLCaller: TSQLCaller;
  lDaysLeft: Longint;
begin
  FResetPasswordErrorStr := EmptyStr;
  lRes := 0;

  if ASendEmail then
  begin
    if (SystemSetup(True).PasswordAuthentication.AuthenticationMode = AuthMode_Exchequer) then
      lUserID := FUserPassDetailRec.Login
    else
      lUserID := FUserPassDetailRec.WindowUserId;
    lRes := SendResetPwrdEmail(lPassStr, lUserID, FUserPassDetailRec.emailAddr, AMsgType);
    if lRes = 0 then
    begin
      //Called from User Management List
      if FUserPassDetailRec.PasswordSalt = EmptyStr then
        FUserPassDetailRec.PasswordSalt := GenerateRandomPwdSalt;
      if lPassStr <> '' then
        FUserPassDetailRec.PasswordHash := StrToSHA3Hase(FUserPassDetailRec.PasswordSalt + lPassStr);
      FUserPassDetailRec.ForcePasswordChange := True;
    end
    else
      FResetPasswordErrorStr := msgEmailError {$IFNDEF EXDLL} + EmailErr(lRes) {$ENDIF EXDLL};
  end;

  if (AUpdateInDB) and (lRes = 0) then
  begin
    lSQLCaller := TSQLCaller.Create(GlobalAdoConnection);
    try
      {AP 02/11/2017 ABSEXCH-19411 : Status of the User whose Password has Expired does not change when System User updates password using 'Change Password' & 'Reset Password'}
      if (FUserPassDetailRec.PWExpMode = PWExpModeExpired) then
        FUserPassDetailRec.PWExpMode := PWExpModeExpDays;

      {SSK 30/10/2017 ABSEXCH-19353 : When Password Changes, the Expiry Date field should be reset in User Profile}
      if (FUserPassDetailRec.PWExpMode = PWExpModeExpDays) then
        FUserPassDetailRec.PWExpDate := CalcDueDate(Today, FUserPassDetailRec.PWExPDays);

      lQuery := 'UPDATE [COMPANY].MLOCSTK SET ' +
            'PWExpMode=' + IntToStr(FUserPassDetailRec.PWExpMode) + ', ' +
            'PWExpDate=' + QuotedStr(FUserPassDetailRec.PWExpDate) + ', ' +
            'PasswordHash='+ QuotedStr(FUserPassDetailRec.PasswordHash) + ', ' +
            'ForcePasswordChange=' + IntToStr(Ord(FUserPassDetailRec.ForcePasswordChange)) + ' ' +
            'WHERE RecPfix = ' + QuotedStr(PassUCode) + ' '+
                   'AND SubType = ' + QuotedStr('D') + ' ' +
                   'AND (varCode1Trans1=' + QuotedStr(FUserPassDetailRec.Login) +')';

      lRes := lSQLCaller.ExecSQL(lQuery, FCompanyCode);
      if lRes <> 0 then
        FResetPasswordErrorStr := lSQLCaller.ErrorMsg;
    finally
      FreeandNil(lSQLCaller)
    end;
  end;
  Result := lRes;

end;

//------------------------------------------------------------------------------

function TSQLUserDetail.ResetPasswordErrorDescription(const AStatus: Integer): String;
begin
  if Trim(FResetPasswordErrorStr) <> EmptyStr then
    Result := FResetPasswordErrorStr
  else
    Result := msgUnknownError + IntToStr(AStatus);
end;

//------------------------------------------------------------------------------

function TSQLUserDetail.Save: Integer;
begin
  FSaveError := EmptyStr;
  if FMode = umInsert then
    Result := SaveNewUser
  else if FMode In [umUpdate, umLogin] then
    Result := SaveExistingUser
  else
    raise Exception.Create('TSQLUserDetail.Save: Unsupported Mode (' + IntToStr(Ord(FMode)) + ')');
end;

//------------------------------------------------------------------------------

function TSQLUserDetail.SaveErrorDescription(const AStatus: Integer): String;
begin
  if (Trim(FSaveError) <> '') then
    Result := 'Error ' + IntToStr(AStatus) + ': ' + FSaveError
  else
    Result := msgUnknownError + IntToStr(AStatus);
end;

//------------------------------------------------------------------------------

function TSQLUserDetail.SaveExistingUser: Integer;
var
  lQuery: AnsiString;
  lRes: Integer;
begin
  // Begin Transaction
  lRes := FSQLCaller.ExecSQL('BEGIN TRANSACTION', FCompanyCode);
  if lRes = 0 then
  begin
    try
      lQuery := 'UPDATE [COMPANY].MLOCSTK ' +
                'SET ' +
                //  'varCode1=' + 'CONVERT(VARBINARY, '+ QuotedStr(' ' + FUserPassDetailRec.Login) + '), ' +
                  'UserName=' +  QuotedStr(FUserPassDetailRec.UserName) + ', ' +
                  'UserStatus=' + IntToStr(ord(FUserPassDetailRec.UserStatus)) + ', ' +
                  'WindowUserId=' + QuotedStr(FUserPassDetailRec.WindowUserId) + ', ' +
                  'EmailAddr=' + QuotedStr(FUserPassDetailRec.emailAddr) + ', ' +
                  'PWExpMode=' + IntToStr(FUserPassDetailRec.PWExpMode) + ', ' +
                  'PWExPDays=' + IntToStr(FUserPassDetailRec.PWExPDays) + ', ' +
                  'PWExpDate=' + QuotedStr(FUserPassDetailRec.PWExpDate) + ', ' +
                  'PWTimeOut=' + IntToStr(FUserPassDetailRec.PWTimeOut) + ', ' +
                  'SecurityQuestionId=' + IntToStr(FUserPassDetailRec.SecurityQuestionId) + ', ' +
                  'SecurityAnswer=' + QuotedStr(FUserPassDetailRec.SecurityAnswer) + ', ' +
                  'ReportPrn=' + QuotedStr(FUserPassDetailRec.ReportPrn) + ', ' +
                  'FormPrn=' + QuotedStr(FUserPassDetailRec.FormPrn) + ', ' +
                  'ShowGLCodes=' + BoolToStr(FUserPassDetailRec.ShowGLCodes) + ', ' +
                  'ShowStockCode=' + BoolToStr(FUserPassDetailRec.ShowStockCode) + ', ' +
                  'ShowProductType=' + BoolToStr(FUserPassDetailRec.ShowProductType) + ', ' +
                  'DirCust=' + QuotedStr(FUserPassDetailRec.DirCust) + ', ' +
                  'DirSupp=' + QuotedStr(FUserPassDetailRec.DirSupp) + ', ' +
                  'MaxSalesA=' + FloatToStr(FUserPassDetailRec.MaxSalesA) + ', ' +
                  'MaxPurchA=' + FloatToStr(FUserPassDetailRec.MaxPurchA) + ', ' +
                  'SalesBank=' + IntToStr(FUserPassDetailRec.SalesBank) + ', ' +
                  'PurchBank=' + IntToStr(FUserPassDetailRec.PurchBank) + ', ' +
                  'CostCentre=' + QuotedStr(FUserPassDetailRec.CCDep[Bon]) + ', ' +
                  'Department=' + QuotedStr(FUserPassDetailRec.CCDep[BOff]) + ', ' +
                  'CCDepRule=' + IntToStr(FUserPassDetailRec.CCDepRule) + ', ' +
                  'LocRule=' + IntToStr(FUserPassDetailRec.LocRule) + ', ' +
                  'Loc=' + QuotedStr(FUserPassDetailRec.Loc) + ', ' +
                  'HighlightPIIFields=' + BoolToStr(FUserPassDetailRec.HighlightPIIFields) + ', ' +
                  'HighlightPIIColour=' + IntToStr(FUserPassDetailRec.HighlightPIIColour) + ', ' +
                  'PasswordSalt=' + QuotedStr(FUserPassDetailRec.PasswordSalt) +
                'WHERE RecPfix = ' + QuotedStr(PassUCode) + ' '+
                'AND SubType = ' + QuotedStr('D') + ' ' +
                'AND (varCode1Trans1=' + QuotedStr(FUserPassDetailRec.Login) +')';
      lRes := FSQLCaller.ExecSQL(lQuery, FCompanyCode);
      if lRes = 0 then
      begin
        // Access setting;
        lRes := SaveAccessSetting;
        Result := lRes;
      end
      else
      begin
        Result := 40000 + lRes;  // Error updating User Details
        FSaveError := FSQLCaller.ErrorMsg;
      end;
    finally
      if lRes = 0 then
      begin
        lRes := FSQLCaller.ExecSQL('COMMIT TRANSACTION', FCompanyCode);
        if lRes <> 0 then
          Result := 30000 + lRes;  // Error Committing Database Transaction
      end // If (Res = 0)
      else
        // Don't record/return error as it would overwrite the original cause
        // of the abort
        FSQLCaller.ExecSQL('ROLLBACK TRANSACTION', FCompanyCode);
    end; //finally
  end
  else
  begin
    Result := 10000 + lRes;  // Error Starting Database Transaction
    FSaveError := FSQLCaller.ErrorMsg;
  end; // Else
end;

//------------------------------------------------------------------------------

function TSQLUserDetail.SaveNewUser: Integer;
var
  lQuery: ANSIString;
  lRes: Integer;
begin
  //Begin Transaction
  lRes := FSQLCaller.ExecSQL('BEGIN TRANSACTION', FCompanyCode);
  if (lRes = 0) then
  begin
    try
      //First Inser Access settings
      //if successfull (lRes = 0 ) then carry forward
      lQuery := 'INSERT INTO [COMPANY].MLOCSTK ' +
                  '(' +
                    'RecPfix, ' +
                    'SubType, ' +
                    'varCode1, ' +
                    'varCode2, ' +
                    'varCode3, ' +
                    'UserName, ' +
                    'UserStatus, ' +
                    'WindowUserId, ' +
                    'EmailAddr, ' +
                    'PWExpMode, ' +
                    'PWExPDays, ' +
                    'PWExpDate, ' +
                    'PWTimeOut, ' +
                    'SecurityQuestionId, ' +
                    'SecurityAnswer, ' +
                    'ReportPrn, ' +
                    'FormPrn, ' +
                    'ShowGLCodes, ' +
                    'ShowStockCode, ' +
                    'ShowProductType, ' +
                    'DirCust, ' +
                    'DirSupp, ' +
                    'MaxSalesA, ' +
                    'MaxPurchA, ' +
                    'SalesBank, ' +
                    'PurchBank, ' +
                    'CostCentre, ' +
                    'Department, ' +
                    'CCDepRule, ' +
                    'LocRule, ' +
                    'Loc, ' +
                    'PasswordSalt, ' +
                    'PasswordHash, ' +
                    'ForcePasswordChange, ' +
                    'LoginFailureCount, ' +
                    'HighlightPIIFields, ' +
                    'HighlightPIIColour ' +
                  ') ' +
              'VALUES ' +
                  '(' +
                    QuotedStr(PassUCode) + ', ' +
                    QuotedStr('D') + ', ' +
                    'CONVERT(BINARY(31), '+ 'SUBSTRING (' + QuotedStr(cSQLNullChar + FUserPassDetailRec.Login) + ', 2, 11)' + '), ' +
                    'CONVERT(VARBINARY, 0), ' +
                    'CONVERT(VARBINARY, 0), ' +
                    QuotedStr(FUserPassDetailRec.UserName) + ', ' +
                    IntToStr(ord(FUserPassDetailRec.UserStatus)) + ', ' +
                    QuotedStr(FUserPassDetailRec.WindowUserId) + ', ' +
                    QuotedStr(FUserPassDetailRec.emailAddr) + ', ' +
                    IntToStr(FUserPassDetailRec.PWExpMode) + ', ' +
                    IntToStr(FUserPassDetailRec.PWExPDays) + ', ' +
                    QuotedStr(FUserPassDetailRec.PWExpDate) + ', ' +
                    IntToStr(FUserPassDetailRec.PWTimeOut) + ', ' +
                    IntToStr(FUserPassDetailRec.SecurityQuestionId) + ', ' +
                    QuotedStr(FUserPassDetailRec.SecurityAnswer) + ', ' +
                    QuotedStr(FUserPassDetailRec.ReportPrn) + ', ' +
                    QuotedStr(FUserPassDetailRec.FormPrn) + ', ' +
                    BoolToStr(FUserPassDetailRec.ShowGLCodes) + ', ' +
                    BoolToStr(FUserPassDetailRec.ShowStockCode) + ', ' +
                    BoolToStr(FUserPassDetailRec.ShowProductType) + ', ' +
                    QuotedStr(FUserPassDetailRec.DirCust) + ', ' +
                    QuotedStr(FUserPassDetailRec.DirSupp) + ', ' +
                    FloatToStr(FUserPassDetailRec.MaxSalesA) + ', ' +
                    FloatToStr(FUserPassDetailRec.MaxPurchA) + ', ' +
                    IntToStr(FUserPassDetailRec.SalesBank) + ', ' +
                    IntToStr(FUserPassDetailRec.PurchBank) + ', ' +
                    QuotedStr(FUserPassDetailRec.CCDep[Bon]) + ', ' +
                    QuotedStr(FUserPassDetailRec.CCDep[BOff]) + ', ' +
                    IntToStr(FUserPassDetailRec.CCDepRule) + ', ' +
                    IntToStr(FUserPassDetailRec.LocRule) + ', ' +
                    QuotedStr(FUserPassDetailRec.Loc) + ', ' +
                    QuotedStr(FUserPassDetailRec.PasswordSalt) + ', ' +
                    QuotedStr(FUserPassDetailRec.PasswordHash) + ', ' +
                    BoolToStr(FUserPassDetailRec.ForcePasswordChange) + ', ' +
                    IntToStr(FUserPassDetailRec.LoginFailureCount) + ', '+
                    BoolToStr(FUserPassDetailRec.HighlightPIIFields) + ', ' +
                    IntToStr(FUserPassDetailRec.HighlightPIIColour) +  
                  ')';
      lRes := FSQLCaller.ExecSQL(lQuery, FCompanyCode);
      if lRes = 0 then
      begin
        // Access setting;
        lRes := SaveAccessSetting;
        Result := lRes;
      end
      else
      begin
        Result := 20000 + lRes;  // Error inserting User
        FSaveError := FSQLCaller.ErrorMsg;
      end;
    finally
      // Commit / Abort Transaction
      if lRes = 0 then
      begin
        lRes := FSQLCaller.ExecSQL('COMMIT TRANSACTION', FCompanyCode);
        if lRes <> 0 then
          Result := 30000 + lRes  // Error Committing Database Transaction
        else
          Result := 0;
      end // If (Res = 0)
      else
        // Don't record/return error as it would overwrite the original cause
        // of the abort
        FSQLCaller.ExecSQL('ROLLBACK TRANSACTION', FCompanyCode);
    end;
  end
  else
  begin
    Result := 10000 + lRes;  // Error Starting Database Transaction
    FSaveError := FSQLCaller.ErrorMsg;
  end;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetOrPRNS2: Boolean;
begin
  Result := FUserPassDetailRec.OrPrns[2];
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetOrPRNS2(AValue: Boolean);
begin
  FUserPassDetailRec.OrPrns[1] := AValue;
end;

//------------------------------------------------------------------------------

function TUserDetail.IsValidDomain(AWinUserID: string): Boolean;
var
 lPos,
 lDomLen,
 I: Smallint;
 lDomainPart,
 lWinDomain: String;
 lIsDomainCorrect: Boolean;

begin
  Result := BOn;
  lWinDomain := Trim(GetWindowDomainName);

  // extract domain part from Windows User ID
  lPos := Pos('\', AWinUserID);
  if lPos > 0 then
  begin
    lDomainPart := Copy(AWinUserID, 1, lPos-1);
    lDomLen := Length(lDomainPart);
    if (lDomLen > 0) then
      lIsDomainCorrect := True
    else
      lIsDomainCorrect := False;

    //validate the domain part
    for I := 1 to Length(lDomainPart) do
    begin

      //1st character shouldn't be hyphen or periods
      if (I = 1) and (lDomainPart[I] in ['-', '.']) then
      begin
        lIsDomainCorrect := False;
        break;
      end
      else
      begin
        //the domain part should contain only these valid characters
        if not (lDomainPart[I] in ['a'..'z',
                       'A'..'Z',
                       '0'..'9',
                       '_',
                       '-',
                       '.']) then begin

          lIsDomainCorrect := False;
          break;
        end;
      end;
    end;

    if not lIsDomainCorrect then
      Result := BOff
    else
      if not (length(trim(AWinUserID)) > (Length(lDomainPart)+1)) then
        Result := BOff;
  end
  else
    Result := BOff;
end;

//------------------------------------------------------------------------------

function TUserDetail.IsValidEmail(const AValue: string): Boolean;
var
  i: Integer;
  lNamePart,
  lServerPart: String;
  function CheckAllowed(const AStr: String): Boolean;
  var
    K: Integer;
  begin
    Result:= False;
    for K := 1 to Length(AStr) do
      if not (AStr[K] in ['a'..'z',
                       'A'..'Z',
                       '0'..'9',
                       '_',
                       '-',
                       '.']) then Exit;
    Result := True;
  end;
begin
  Result := False;

  i := Pos('@', AValue);
  if i = 0 then Exit;

  lNamePart := Copy(AValue, 1, i-1);
  lServerPart := Copy(AValue, i+1, Length(AValue));

  if (Length(lNamePart)=0) or ((Length(lServerPart)<5)) then Exit;
    i := Pos('.', lServerPart);

  if (i=0) or (i>(Length(lserverPart)-2)) then Exit;

  Result:= CheckAllowed(lNamePart) and CheckAllowed(lServerPart);
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetDefaultFieldValue;
begin
  if FMode In [umInsert, umCopy] then   //ADD, COPY
  begin
    FUserPassDetailRec.Login := EmptyStr;
    FUserPassDetailRec.UserName := EmptyStr;
    FUserPassDetailRec.emailAddr := EmptyStr;
    FUserPassDetailRec.WindowUserId := EmptyStr;
    FUserPassDetailRec.SecurityQuestionId := 0;
    FUserPassDetailRec.SecurityAnswer := EmptyStr;
    //default to current system domain
    if SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Windows then
      FUserPassDetailRec.WindowUserId := Trim(GetWindowDomainName) + '\';
  end;
  if FMode = umUpdate then             //EDIT
  begin
    if SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Windows then
      if Trim(FUserPassDetailRec.WindowUserId) = '' then
        FUserPassDetailRec.WindowUserId := Trim(GetWindowDomainName) + '\';
  end;
  if FUserPassDetailRec.PasswordSalt = '' then
    FUserPassDetailRec.PasswordSalt := GenerateRandomPwdSalt;
end;

//------------------------------------------------------------------------------

function TPervasiveUserDetail.SaveExistingUser: Integer;
var
  lExLocal: TdExLocal;
  lKeyS: Str255;
  LOk,
  LLocked: Boolean;
begin
  Result := 0;
  {$IFDEF IMPV6}
    Result := ChangePasswordForImporter;
    Exit;
  {$ENDIF}
  lExLocal.Create;
  try
    with lExLocal do
    begin
      lKeyS := FullPWordKey(PassUCode, 'D', FUserPassDetailRec.Login);
      Status := Find_Rec(B_GetEq, F[MLocF], MLocF, LRecPtr[MLocF]^, MLK, lKeyS);
      if StatusOk then
      begin
        AssignFromGlobal(MLocF);
        LOk := LGetMultiRec(B_GetDirect, B_MultLock, lKeyS, MLK, MLocF, BOff, LLocked);
        if (LOK) and (LLocked) then
        begin
          LMLocCtrl^.RecPfix := 'P';
          LMLocCtrl^.SubType := 'D';
          LMLocCtrl^.PassDefRec := FUserPassDetailRec;
          Status := Put_Rec(F[MLocF], MLocF, LRecPtr[MLocF]^, MLK);
          // Add Access Setting in to Database
          if (StatusOK) and (FMode <> umReadOnly) then
            Status := SaveAccessSetting;
          Result := Status;
        end
        else
          Result := 1;
      end;
      //else show message
    end;
  finally
    //Result := Status;
    lExLocal.UnLockMLock(MLocF,lExLocal.LastRecAddr[MLocF]);
    lExLocal.Destroy;
  end;
end;

//------------------------------------------------------------------------------

function TPervasiveUserDetail.SaveNewUser: Integer;
begin
  MLocCtrl^.PassDefRec := FUserPassDetailRec;
  with MLocCtrl^, PassDefRec do
  begin
    RecPfix := PassUCode;
    SubType := 'D';
    Status := Add_Rec(F[MLocF], MLocF, RecPtr[MLocF]^, MLK);
    // Add Access Setting in to Database
    if StatusOK then
      Status := SaveAccessSetting;
    Result := Status;
  end;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetUserAccessRec: EntryRecType;
begin
  Result := FUserAccessRec;
end;

//------------------------------------------------------------------------------

function TUserDetail.InitSetEntryRec: EntryRecType;
var
  i: Integer;
begin
  FillChar(Result, SizeOf(Result), #0);
  if FUserPassDetailRec.Login <> EmptyStr then
  begin
    for i:=0 to 3 do {* Get any password settings + additional page settings *}
      SetEntryRecVar(i, FUserPassDetailRec.Login, True, True, Result);
  end;
end;

//------------------------------------------------------------------------------

function TUserDetail.SaveAccessSetting: Integer;
var
  lKeyS: Str255;
  n: Byte;
  lIndex: Longint;
  lNewRecord: Boolean;
  lPgNo: Integer;
  lUser: Str10;
begin
  if FMode = umLogin then
  begin
    Result := 0;
    Exit;
  end;

  for lPgNo := 0 to 3 do
  begin
    lUser := FUserPassDetailRec.Login;
    lNewRecord := False;
    lKeyS := PassUCode+Chr(lPgNo)+lUser;
    Status := Find_Rec(B_GetEq, F[PWrdF], PWrdF, RecPtr[PWrdF]^, PWK, lKeyS);
    if not StatusOk then
    begin
      ResetRec(PWrdF);
      lNewRecord:= True;
    end;
    lIndex := 256 * lPgNo;
    with PassWord,PassEntryRec do
    begin
      for n := Low(Access) to High(Access) do
        Access[n]:= FUserAccessRec.Access[n+lIndex];  //add global entry rec of classs

      if lNewRecord then
      begin
        RecPfix := PassUCode;
        SubType := Chr(lPgNo);
        Login := lUser;
        Status := Add_Rec(F[PWrdF], PWrdF, RecPtr[PWrdF]^, PWK);
      end
      else
        Status := Put_Rec(F[PWrdF], PWrdF, RecPtr[PWrdF]^, PWK);
    end;
  end;
  Result := Status;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetAccessSettingsYes(APermission : Boolean);
begin
  if APermission then
    FillChar(FUserAccessRec.Access, SizeOf(FUserAccessRec.Access), #1);
end;

//------------------------------------------------------------------------------

function TUserDetail.GetCopyUserName: String30;
begin
  Result := FCopyUserName;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetUserAccessRec(AUserAccessRec: EntryRecType);
begin
  FUserAccessRec := AUserAccessRec;
end;

//------------------------------------------------------------------------------

function TUserDetail.AuthenticateUser(const AUserName, APassword: String): Integer;
var
  lLoginPwd,
  lLoginUser,
  lDomainName: string;
  lPos: Smallint;
  lExpired: Boolean;
  lDaysLeft: Longint;
begin
  Result := -1;

  if SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Exchequer then
  begin
    lLoginPwd := StrToSHA3Hase(FUserPassDetailRec.PasswordSalt + Trim(APassword));
    if (Trim(FUserPassDetailRec.Login) = AUserName) and (FUserPassDetailRec.PasswordHash = lLoginPwd) then
    begin
      if FUserPassDetailRec.UserStatus = usActive then
      begin
        // Password Never Expired
        if FUserPassDetailRec.PWExpMode = PWExpModeNeverExp then
          Result := 0;
        // Password Expired after Some Days
        if FUserPassDetailRec.PWExpMode = PWExpModeExpDays then
        begin
          lDaysLeft := NoDays(Today, FUserPassDetailRec.PWExpDate);
          lExpired := lDaysLeft < 0;
          if (not lExpired) and (lDaysLeft <= 10) and (lDaysLeft <> 0) then
          begin
            Result := 0;
            MessageDlg(format(msgPwdExpireWarning, [Form_Int(lDaysLeft,0), PoutDate(FUserPassDetailRec.PWExpDate)]), mtWarning, [mbOk], 0);
          end
          else
          begin
            if not lExpired then
              Result := 0
            else
            begin
              {AP:07/11/2017 ABSEXCH-19419:User Management List > Pwd Expired User Status is shown as "Suspended, Pwd Expired" instead of "Active, Pwd Expired"}
              //FUserPassDetailRec.UserStatus := usPasswordExpired;
              FUserPassDetailRec.PWExpMode := PWExpModeExpired;
              if Self.Save <> 0 then
                Result := 2004;
            end;
          end;
        end; {PWExpModeExpDays}
        // Password Expired
        if FUserPassDetailRec.PWExpMode = PWExpModeExpired then
          Result := 2003;
      end {if FUserPassDetailRec.UserStatus = usActive then}
      else if (FUserPassDetailRec.UserStatus = usPasswordExpired) and (FUserPassDetailRec.PWExpMode = PWExpModeExpired) then
        Result := 2003
      else
        Result := 2002; //suspended user
    end
    else
      Result := 2001;
  end {AuthMode_Exchequer}
  else if SystemSetup.PasswordAuthentication.AuthenticationMode = AuthMode_Windows then
  begin
    if AnsiCompareText(trim(FUserPassDetailRec.WindowUserId), AUserName) = 0 then
    begin
      if FUserPassDetailRec.UserStatus = usActive then   //Active User
      begin
        // extract User ID excluding the Domain
        lPos := Pos('\', AUserName);
        if lPos > 0 then
        begin
          lDomainName := Copy(AUserName, 1, lPos-1);
          lLoginUser := Copy(AUserName, lPos+1, length(AUserName));
          if WindowAuthenticate(lLoginUser, APassword, lDomainName) then
            Result := 0
          else
            Result := 2001;
        end; {if lPos > 0 then}
      end {if FUserPassDetailRec.UserStatus = usActive then}
      else
        Result := 2002;  //suspended user
    end
    else
      Result := 2001;
  end; {AuthMode_Windows}

  //Update Global User Profile

  if Result = 0 then
  begin
    {$B-}
      UpdateGlobalUserProfile(Trim(FUserPassDetailRec.Login));
    {$B+}
  end;
end;

//------------------------------------------------------------------------------

function TUserDetail.AuthenticationErrorDescription(const AAuthError: integer): string;
begin
  case AAuthError of
    2001  : Result := msgInvalidUser;
    2002  : Result := msgSuspendedUser;
    2003  : Result := msgPwdExpired;
    2004  : Result := Self.SaveErrorDescription(AAuthError);
  else
    Result := msgUnknownError + IntToStr(AAuthError);
  end;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.UpdateGlobalUserProfile(const AUserName: String);
begin
  if GetLoginRec(AUserName) then
  begin
    UserProfile^ := Get_PWDefaults;
    GetLocalPr(1); {Synchronise local with global}
  end;
end;

//------------------------------------------------------------------------------

function TUserDetail.Get_PWDefaults: tPassDefType;
begin
  Result := FUserPassDetailRec;
  {$IFDEF LTE}
    Result.PWExpMode:=0;
  {$ENDIF}
  Result.Loaded := FUserPassDetailRec.Login <> EmptyStr;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
{HV 17/10/2017 2017 R2 ABSEXCH-19284: User Profile Highlight PII fields flag}
//------------------------------------------------------------------------------

function TUserDetail.GetHighlightPIIColour: LongInt;
begin
  Result := FUserPassDetailRec.HighlightPIIColour;
end;

//------------------------------------------------------------------------------

function TUserDetail.GetHighlightPIIFields: Boolean;
begin
  Result := FUserPassDetailRec.HighlightPIIFields;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetHighlightPIIColour(AValue: LongInt);
begin
  FUserPassDetailRec.HighlightPIIColour := AValue;
end;

//------------------------------------------------------------------------------

procedure TUserDetail.SetHighlightPIIFields(AValue: Boolean);
begin
  FUserPassDetailRec.HighlightPIIFields := AValue;
end;

//------------------------------------------------------------------------------

end.

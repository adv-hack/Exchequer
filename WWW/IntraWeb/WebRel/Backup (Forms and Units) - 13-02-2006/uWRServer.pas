unit uWRServer;

{Do not set SessionTrackingMethod to tmCookie; The UserSession object has behaved
 mysteriously when multiple sessions are open, perhaps referencing the same
 cookie; Ensure COMInitialisation is set to ciNone when deployed or random files
 will fail to load under ISAPI in user browsers; COMInitialisation is best set to
 ciNormal in standalone mode and during debugging;}

interface

uses
  Classes, uWRData, IWServerControllerBase, IWAppForm, IWApplication, IWCompListBox,
  Controls, SysUtils, WebSec_TLB, uCodeGen;

type
  TWRServer = class(TIWServerControllerBase)
    procedure IWServerControllerBaseNewSession(ASession: TIWApplication; var VMainForm: TIWAppForm);
  end;

  TEmailRecipient = record
    Address: string;
    Name: string;
    Active: boolean;
  end;

  TImageClickProc = procedure(Sender: TObject) of object;

  TDealerCode = (dcNil, dcPlugIn, dcPlugInRel, dcMCM, dcDaily, dcDirectors, dcSystem, dcSystemUC, dcToolkit, dcToolkitUC,
                        dcModules, dcModulesUC, dcResync, dcResetEnt, dcVectronRel, dcVectronDaily );
  TIDType = (itNil, itDealer, itUser, itCustomer, itESN, itModule, itThreshold, itLogin);
  TModuleType = (mtNil, mtModule, mtModuleUC, mtPlugIn, mtPlugInUC);
  TNotePages = (npEnterprise, npModules, npPlugIns, npVectron, npOther);
  TSendType = (stSMS, stEmail);
  TSendSet = set of TSendType;
  TThresholdEffect = (teApplied, teOverridden, teCodeUnavailable);

  TUserSession = class(TComponent)
  private
    fStoreCodes: TStringlist;
    procedure EmailCodeLog(AllowGet: boolean; DealerCode: TDealerCode; ThirtyDay: boolean; Module: string);
    procedure EmailESNLog(Email: string; UserName: string);
    procedure EmailPasswordLog(Email, UserName: string);
    procedure EmailThresholdLog(Email, UserName: string; ThresholdEffect: TThresholdEffect; CodeID: integer; Module: string);
    procedure PrepareCodeEmail(AllowGet: boolean; DealerCode: TDealerCode; ReleaseCode: string; SecDate: TDateTime; SecCode: string; ThirtyDay: boolean; UserCount: integer; Module: string);
    procedure PrepareEmailBody(EmbedStrings: TStringlist);
    procedure SMSLog(DealerCode: TDealerCode; ThirtyDay: boolean; Module: string);
    function ConvertDealerCode(DealerCode: TDealerCode): integer;
    function EmailThreshApplied(CodeID: integer; Module: string): boolean;
    function EmailThreshOverridden(CodeID: integer; Module: string): boolean;
    function EmailThreshUnavailable(CodeID: integer; Module: string): boolean;
    function Embolden(BoldText: string): string;
    function GetCodeDesc(CodeID: integer; Module: string): string;
    function GetDealerCodeDesc(DealerCode: TDealerCode; ThirtyDay: boolean; Module: string): string;
    function GetModuleID(Module: string): integer;
    function GetRelease(ReleaseIndex: integer): boolean;
  public
    WRData: TWRData;
    Pages: set of TNotePages;

    RequestRecipient: TEmailRecipient;
    ThreshAppliedRecipient: TEmailRecipient;
    ThreshOverriddenRecipient: TEmailRecipient;
    CodeUnavailableRecipient: TEmailRecipient;
    // AB - 3
    ESNSpecifiedRecipient : TEmailRecipient;

    // AB
    bUsingDummyESN : boolean;

    // AB 15/09/2003
    sLastDealerFilter : string;
    sLastCustomerFilter : string;

    InternalHQUser: boolean;
    DistributorUser: boolean;
    UserCode: string;
    UserID: integer;
    UserName: string;
    Security: IWebSec;
    ExpiryDays: integer;
    PWExpires: TDateTime;
    SMSPhone: string;
    Email: string;

    CustID: integer;
    CustName: string;
    CustRestricted: boolean;
    SecDate: string;
    DealerID: integer;
    DealerName: string;
    ESN: string;
    ESNID: integer;
    Version: string;

    PassPlugIn: string;
    PassMCM: string;
    PassDaily: string;
    PassDirectors: string;

    SendViaEmail: boolean;
    SendViaSMS: boolean;

    EntSecCode: string;
    EntRelCodeType: string;
    EntRelCode: string;
    Ent30SecCode: string;
    Ent30RelCodeType: string;
    Ent30UserCount: string;
    Ent30RelCode: string;
    EntCoySecCode: string;
    EntCoyCount: string;
    EntCoyRelCode: string;

    ModModule: string;
    ModSecCode: string;
    ModRelCodeType: string;
    ModRelCode: string;
    Mod30Module: string;
    Mod30SecCode: string;
    Mod30RelCodeType: string;
    Mod30UserCount: string;
    Mod30RelCode: string;

    PlugsModule: string;
    PlugsSecCode: string;
    PlugsRelCodeType: string;
    PlugsRelCode: string;
    Plugs30Module: string;
    Plugs30SecCode: string;
    Plugs30RelCodeType: string;
    Plugs30UserCount: string;
    Plugs30RelCode: string;

    VectDaily: string;
    VectSecCode: string;
    VectRelCodeType: string;
    VectRelCode: string;

    OtherResync: string;
    OtherResetEnt: string;
    OtherResetPlugIn: string;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdminLog(AdminID: integer; IDType: TIDType; ChangeDesc: string);
    procedure AuditLog(RelCode: string; CodeID: integer; SecDate: integer; FullRelease: integer; Counts: integer; Module: string);
    procedure DebugLog(DebugMsg: string);
    procedure InitRelCodes(RelCodeCombo: TIWComboBox);
    procedure InitUser;
    procedure ResetState;
    procedure ResyncCompanies;
    procedure ShowPages;
    function EmailPassword(UserCode: string): boolean;
    function EmailESN(const ssESN : ShortString) : boolean;
    function ExceededThreshold(CodeID: integer; Module: string): boolean;
    function GetDate(SecDate: integer): TDate;
    function GetExternalCode(SendSet: TSendSet; AllowGet: boolean; DealerCode: TDealerCode; SecDate: TDateTime; ThirtyDay: boolean = true; SecCode: string = ''; UserCount: integer = 0; Module: string = ''): string;
    function GetInternalCode(CodeID: integer; SecDate: TDateTime; ThirtyDay: boolean = true; SecCode: string = ''; UserCount: integer = 0; Module: string = ''): string;
    function GetESN(ESN: string): string;
    function GetPassword: string;
    function isDummyCust: boolean;
    function isNewerVersion(VersionStr: string): boolean;
    function isPasswordExpired: boolean;
    function isValidESN(ESNStr: string): boolean;
    function isValidEmail(Address: string): boolean;
    function isValidSendVia(SendSet: TSendSet): boolean;
  end;

  function UserSession: TUserSession;

implementation

{$R *.dfm}

uses IWInit, uWRIntEntx, uWRIntMods, uWRIntPlugs, uWRIntVect, uWRIntOther,
     uWRIntNone, uWRExtEntx, uWRExtTkit, uWRExtMods, uWRExtOther, uWRExtNone,
     uWRExtPlug, uWRExtVect,
     uPermissionIDs, uCodeIDs, ComObj, Variants, ActiveX;

//*** TWRServer ****************************************************************

procedure TWRServer.IWServerControllerBaseNewSession(ASession: TIWApplication; var VMainForm: TIWAppForm);
begin
  ASession.Data:= TUserSession.Create(ASession);
end;

//*** TUserSession *************************************************************

//*** Startup and Shutdown *****************************************************

constructor TUserSession.Create(AOwner: TComponent);
begin
  {A security object is owned by each user session;}

  inherited;

  WRData:= TWRData.Create(AOwner);
  fStoreCodes:= TStringlist.Create;
  Randomize;

  try
    Security:= CoWebSec_.Create;
  except
  end;
end;

procedure TUserSession.InitUser;
begin
  {Initialises session information for the user once the user has successfully
   logged in;}

  // AB
  bUsingDummyESN := FALSE;

  // AB 15/09/2003
  sLastDealerFilter := '';
  sLastCustomerFilter := '';

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select userid, username, pwexpires, expirydays, email, smsphone, customsendvia ');
    Sql.Add('from users where usercode = :pusercode ');
    ParamByName('pusercode').AsString:= UserCode;
    Open;

    UserID:= FieldByName('UserID').AsInteger;
    UserName:= FieldByName('UserName').AsString;
    ExpiryDays:= FieldByName('ExpiryDays').AsInteger;
    PWExpires:= FieldByName('PWExpires').AsDateTime;
    SMSPhone:= Trim(FieldByName('SMSPhone').AsString);
    Email:= Trim(FieldByName('Email').AsString);

    if FieldByName('CustomSendVia').IsNull then
      SendViaEmail:= true
    else
    begin
      case FieldByName('CustomSendVia').AsInteger of
        1: SendViaEmail:= true;
        2: SendViaSMS:= true;
        3: begin
             SendViaEmail:= true;
             SendViaSMS:= true;
           end;
      end; // case FieldByName('CustomSendVia').AsInteger of...
    end;
  end; // with WRData, qyPrimary do...
end;

destructor TUserSession.Destroy;
begin
  {Ensure the security object and member objects are freed;}

  try
    if Assigned(Security) then Security:= nil;
  except
  end;

  try
    if Assigned(fStoreCodes) then fStoreCodes.Free;
  except
  end;

  inherited;
end;

//*** TUserSession Methods *****************************************************

procedure TUserSession.ShowPages;
begin
  {Generate the first page the user has permissions to view; Internal users have
   access to internal pages and external users and dealers are restricted to
   external pages alone; The 'None' pages are available should a user be unable
   to view any; Note the modules page in the external version is available if
   the user has the Show All Modules permission, otherwise the Toolkit page is
   displayed instead;}

  if InternalHQUser then
  begin
    if npEnterprise in Pages then TfrmIntEntx.Create(RWebApplication).Show
    else if npEnterprise in Pages then TfrmIntEntx.Create(RWebApplication).Show
    else if npModules in Pages then TfrmIntMods.Create(RWebApplication).Show
    else if npPlugIns in Pages then TfrmIntPlugs.Create(RWebApplication).Show
    else if npVectron in Pages then TfrmIntVect.Create(RWebApplication).Show
    else if (npOther in Pages) and isNewerVersion(version431) then TfrmIntOther.Create(RWebApplication).Show
    else TfrmIntNone.Create(RWebApplication).Show;
  end
  else
  begin
    if npEnterprise in Pages then TfrmExtEntx.Create(RWebApplication).Show
    else if npModules in Pages then
    begin
      if Security.Validate(UserCode, pidShowAllModules) = 0 then TfrmExtMods.Create(RWebApplication).Show
      else TfrmExtTkit.Create(RWebApplication).Show
    end
    else if npPlugIns in Pages then TfrmExtPlugs.Create(RWebApplication).Show
    else if npVectron in Pages then TfrmExtVect.Create(RWebApplication).Show
    else if (npOther in Pages) and isNewerVersion(version431) then TfrmExtOther.Create(RWebApplication).Show
    else TfrmExtNone.Create(RWebApplication).Show;
  end;
end;

function TUserSession.EmailPassword(UserCode: string): boolean;
var
MsgIndex: integer;
EmbedStrings: TStringList;
begin
  {Emails a user their new password with details of when it expires;}

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select * from users where usercode = :pusercode ');
    ParamByName('pusercode').AsString:= UserCode;
    Open;

    EmbedStrings:= TStringList.Create;
    with EmbedStrings do
    try

      Add(FieldByName('UserName').AsString + ' (' + FieldByName('Email').AsString + ')');
      Add('');
      Add('Your new password for the Exchequer Release Codes system is ' + Embolden(FieldByName('UserPassword').AsString));
      Add('');
      Add('This password will expire on ' + Embolden(FormatDateTime('dd/mm/yyyy', FieldByName('PWExpires').AsDateTime)) + '.');
      Add('');
      Add('This is an unmonitored email address. Please do not reply to this address.');

      PrepareEmailBody(EmbedStrings);

    finally
      Free;
    end;

    with msgMain do
    begin
      Subject:= 'Password Notification';

      for MsgIndex:= 0 to Recipients.Count - 1 do Recipients[MsgIndex].Free;
      Recipients.Clear;

      with Recipients.Add do
      begin
        Address:= FieldByName('Email').AsString;
        Name:= FieldByName('UserName').AsString;
        Text:= Name + ' <' + Address + '>';
      end;

      SMTPer.Connect;
      try

        SMTPer.Send(msgMain);
        Result:= true;

        EmailPasswordLog(FieldByName('Email').AsString, FieldByName('UserName').AsString);

      except
        Result:= false;
      end;
      SMTPer.Disconnect;
    end;
  end;
end;

function TUserSession.EmailESN(const ssESN : ShortString) : boolean;
var
  siMsgIndex : SmallInt;
  slEmbedStrings : TStringList;
begin
  // AB - 3
  slEmbedStrings := TStringList.Create;
  with slEmbedStrings do
  begin
    try
      Add('A new ESN ('+ssESN+') has been requested for '+ trim(UserSession.CustName) + ', by ' + UserSession.UserName );
      Add('');
      Add('This is an unmonitored email address. Please do not reply to this address.');

      PrepareEmailBody(slEmbedStrings);
    finally
      Free;
    end; // try...finally
  end; // with slEmbedStrings do

  with WRData do
  begin
    with msgMain do
    begin
      Subject := 'ESN Update Notification';

      for siMsgIndex := 0 to (Recipients.Count - 1) do Recipients[siMsgIndex].Free;
      Recipients.Clear;

      with Recipients.Add do
      begin
        Address := ESNSpecifiedRecipient.Address;
        Name := ESNSpecifiedRecipient.Name;
        Text := Name + ' <' + Address + '>';
      end;
    end; // with msgMain do...

    SMTPer.Connect;
    try
      SMTPer.Send(msgMain);
      Result := true;
      EmailESNLog(ESNSpecifiedRecipient.Address, UserName);
    except
      Result := false;
    end; // try...except
    SMTPer.Disconnect;
  end; // with WRData do...
end;

function TUserSession.EmailThreshApplied(CodeID: integer; Module: string): boolean;
var
  MsgIndex: integer;
begin
  {Emails the threshold-applied-recipient notification that a threshold has been
   applied;}

  with WRData, msgMain do
  begin
    ContentType:= 'text';
    Subject:= 'Threshold Applied';

    for MsgIndex:= 0 to MessageParts.Count - 1 do MessageParts[MsgIndex].Free;
    for MsgIndex:= 0 to Recipients.Count - 1 do Recipients[MsgIndex].Free;
    MessageParts.Clear;
    Recipients.Clear;
    Body.Clear;

    Body.Add('');
    Body.Add('A ' + GetCodeDesc(CodeID, Module) + ' threshold has been applied for ' + CustName + '.');
    Body.Add('');
    Body.Add('The user ' + UserName + ' of ' + DealerName + ' has not received this code.');
    Body.Add('');
    Body.Add(FormatDateTime('dd/mm/yyyy hh:mm:nn', Now));
    Body.Add('');
    Body.Add('This is an unmonitored email address. Please do not reply to this address.');

    with Recipients.Add do
    begin
      Address:= ThreshAppliedRecipient.Address;
      Name:= ThreshAppliedRecipient.Name;
      Text:= Name + ' <' + Address + '>';
    end;

    SMTPer.Connect;
    try

      SMTPer.Send(msgMain);
      Result:= true;

      EmailThresholdLog(ThreshAppliedRecipient.Address, ThreshAppliedRecipient.Name, teApplied, CodeID, Module);

    except
      Result:= false;
    end;
    SMTPer.Disconnect;
  end;
end;

function TUserSession.EmailThreshOverridden(CodeID: integer; Module: string): boolean;
var
MsgIndex: integer;
begin
  {Emails the threshold-overridden-recipient notification of just that;}

  with WRData, msgMain do
  begin
    ContentType:= 'text';
    Subject:= 'Threshold Overridden';

    for MsgIndex:= 0 to MessageParts.Count - 1 do MessageParts[MsgIndex].Free;
    for MsgIndex:= 0 to Recipients.Count - 1 do Recipients[MsgIndex].Free;
    MessageParts.Clear;
    Recipients.Clear;
    Body.Clear;

    Body.Add('');
    Body.Add('A ' + GetCodeDesc(CodeID, Module) + ' threshold has been overridden for ' + CustName + '.');
    Body.Add('');
    Body.Add('The user was ' + UserName + ' of ' + DealerName + '.');
    Body.Add('');
    Body.Add(FormatDateTime('dd/mm/yyyy hh:mm:nn', Now));
    Body.Add('');
    Body.Add('This is an unmonitored email address. Please do not reply to this address.');

    with Recipients.Add do
    begin
      Address:= ThreshOverriddenRecipient.Address;
      Name:= ThreshOverriddenRecipient.Name;
      Text:= Name + ' <' + Address + '>';
    end;

    SMTPer.Connect;
    try

      SMTPer.Send(msgMain);
      Result:= true;

      EmailThresholdLog(ThreshOverriddenRecipient.Address, ThreshOverriddenRecipient.Name, teOverridden, CodeID, Module);

    except
      Result:= false;
    end;
    SMTPer.Disconnect;
  end;
end;

function TUserSession.EmailThreshUnavailable(CodeID: integer; Module: string): boolean;
var
MsgIndex: integer;
begin
  {Emails the code-unavailable-recipient notification of just that;}

  with WRData, msgMain do
  begin
    ContentType:= 'text';
    Subject:= 'Release Code Unavailable';

    for MsgIndex:= 0 to MessageParts.Count - 1 do MessageParts[MsgIndex].Free;
    for MsgIndex:= 0 to Recipients.Count - 1 do Recipients[MsgIndex].Free;
    MessageParts.Clear;
    Recipients.Clear;
    Body.Clear;

    Body.Add('');
    Body.Add('A ' + GetCodeDesc(CodeID, Module) + ' was made unavailable for ' + CustName + '.');
    Body.Add('');
    Body.Add('The user ' + UserName + ' of ' + DealerName + ' has not received this code.');
    Body.Add('');
    Body.Add(FormatDateTime('dd/mm/yyyy hh:mm:nn', Now));
    Body.Add('');
    Body.Add('This is an unmonitored email address. Please do not reply to this address.');

    with Recipients.Add do
    begin
      Address:= CodeUnavailableRecipient.Address;
      Name:= CodeUnavailableRecipient.Name;
      Text:= Name + ' <' + Address + '>';
    end;

    SMTPer.Connect;
    try

      SMTPer.Send(msgMain);
      Result:= true;

      EmailThresholdLog(CodeUnavailableRecipient.Address, CodeUnavailableRecipient.Name, teCodeUnavailable, CodeID, Module);

    except
      Result:= false;
    end;
    SMTPer.Disconnect;
  end;
end;

function TUserSession.GetInternalCode(CodeID: integer; SecDate: TDateTime; ThirtyDay: boolean; SecCode: string; UserCount: integer; Module: string): string;
var
CodeGenerator: TCodeGenerator;
ModuleID: integer;
begin
  {Instantiates a CodeGenerator object and supplies the necessary parameters to
   generate a password or release code;}

  Result:= '';

  CodeGenerator:= TCodeGenerator.Create(ESN, Version);
  with CodeGenerator, WRData do
  try

    if CodeID in [cidModRel, cidModUCRel] then ModuleID:= GetModuleID(Module)
    else if CodeID in [cidPlugRel, cidPlugUCRel] then ModuleID:= StrToIntDef(Module, 0)
    else ModuleID:= 0;

    Result:= GetCode(CodeID, SecDate, ThirtyDay, SecCode, UserCount, ModuleID);
    if Result = '' then RWebApplication.ShowMessage(LastErrorMsg);

  finally
    if Assigned(CodeGenerator) then FreeAndNil(CodeGenerator);
  end;
end;

function TUserSession.GetExternalCode(SendSet: TSendSet; AllowGet: boolean; DealerCode: TDealerCode; SecDate: TDateTime; ThirtyDay: boolean; SecCode: string; UserCount: integer; Module: string): string;
var
CodeGenerator: TCodeGenerator;
ReleaseCode, DisplayResult, BuildMsg: string;
ModuleID, NewCustomSendVia, MaxID: integer;
begin
  {Emails and/or SMSes the required release code if the user has the necessary
   get permissions, otherwise emails an internal request message;}

  Result:= '';

  CodeGenerator:= TCodeGenerator.Create(ESN, Version);
  with CodeGenerator, WRData do
  try

    if DealerCode in [dcToolkit, dcToolkitUC] then ModuleID:= GetModuleID(tidToolkit)
    else if DealerCode in [dcModules, dcModulesUC] then ModuleID:= GetModuleID(Module)
    else if DealerCode in [dcPlugIn, dcPlugInRel] then ModuleID:= StrToIntDef(Module, 0)
    else ModuleID:= 0;

//                GetCode(CodeID,                        SecDate, ThirtyDay, SecCode, UserCount, ModuleID)
    ReleaseCode:= GetCode(ConvertDealerCode(DealerCode), SecDate, ThirtyDay, SecCode, UserCount, ModuleID);
    if LastErrorMsg = '' then
    begin

      DisplayResult:= '';
      if stEmail in SendSet then with msgMain do
      begin
        Subject:= GetDealerCodeDesc(DealerCode, ThirtyDay, Module) + ' for ' + CustName;
        PrepareCodeEmail(AllowGet, DealerCode, ReleaseCode, SecDate, SecCode, ThirtyDay, UserCount, Module);

        SMTPer.Connect;
        try
          SMTPer.Send(msgMain);
          EmailCodeLog(AllowGet, DealerCode, ThirtyDay, Module);

          if AllowGet then DisplayResult:= 'The Release Code was emailed successfully.' + #13#10#13#10
          else DisplayResult:= 'The Release Code has been requested successfully.' + #13#10#13#10;
          Result:= ReleaseCode;
        except
          if AllowGet then DisplayResult:= 'The Release Code failed to email.' + #13#10#13#10
          else DisplayResult:= 'The Release Code was unable to be requested.' + #13#10#13#10;
        end;
        SMTPer.Disconnect;
      end;

      if stSMS in SendSet then
      begin
        if AllowGet then
        begin

          if SMSPhone <> '' then with WRData.qyPrimary do
          begin
            BuildMsg:= '';

            case DealerCode of
              dcSystem:
              begin
                if ThirtyDay then BuildMsg:= CustName + ' 30Day Entx Release Code: '
                else BuildMsg:= CustName + ' Full Entx Release Code: ';
              end;
              dcSystemUC: BuildMsg:= CustName + ' 30Day System UC Release Code: ';
              dcToolkit: BuildMsg:= CustName + ' Toolkit Release Code: ';
              dcToolkitUC: BuildMsg:= CustName + ' Toolkit UC Release Code: ';
              dcModules: BuildMsg:= CustName + ' ' + Module + ' Release Code: ';
              dcModulesUC: BuildMsg:= CustName + ' ' + Module + ' UC Release Code: ';
              dcResync: BuildMsg:= CustName + ' Resync Password: ';
              dcResetEnt: BuildMsg:= CustName + ' Reset Enterprise Password: ';
              dcPlugIn: BuildMsg:= CustName + ' ' + Module + ' Plug-In Password: ';
              dcPlugInRel : BuildMsg := CustName + ' ' + Module + ' Plug-In Release Code: ';
              dcMCM: BuildMsg:= 'MCM Password: ';
              dcDaily: BuildMsg:= 'Daily System Password: ';
              dcDirectors: BuildMsg:= 'Directors Password: ';
              dcVectronRel : BuildMsg := 'Vectron Release Code: ';
              dcVectronDaily : BuildMsg := 'Vectron Daily Password: ';
            end;

            BuildMsg:= BuildMsg + ReleaseCode;

            case DealerCode of
              dcSystemUC, dcToolkitUC, dcModulesUC: BuildMsg:= BuildMsg + ' for ' + IntToStr(UserCount) + ' users';
              dcPlugIn, dcMCM,
              dcDaily, dcDirectors,
              dcVectronDaily : BuildMsg:= BuildMsg + ' valid for ' + FormatDateTime('dd/mm/yy', SecDate);
            end;

            BuildMsg:= BuildMsg + ' (c) Exchequer Software';

            Close;
            Sql.Clear;
            Sql.Add('select max(smsid) from smspending ');
            Open;

            MaxID:= Fields[0].AsInteger;

            Close;
            Sql.Clear;
            Sql.Add('insert into smspending (smsid, smsphone, smssent, smstext) ');
            Sql.Add('values (:psmsid, :psmsphone, 0, :psmstext) ');
            ParamByName('psmsid').AsInteger:= Succ(MaxID);
            ParamByName('psmsphone').AsString:= SMSPhone;
            ParamByName('psmstext').AsString:= BuildMsg;
            ExecSql;

            SMSLog(DealerCode, ThirtyDay, Module);

            DisplayResult:= DisplayResult + 'The Release Code was SMSed successfully.';
            Result:= ReleaseCode;

          end
          else DisplayResult:= DisplayResult + 'Your SMS phone number is unavailable. Please contact your distributor to update your SMS details.';

        end
        else DisplayResult:= DisplayResult + 'You do not have the necessary permissions to receive this release code via SMS.';
      end;

      if Result <> '' then with WRData, qyPrimary do
      begin
        NewCustomSendVia:= 0;
        if stEmail in SendSet then inc(NewCustomSendVia, 1);
        if stSMS in SendSet then inc(NewCustomSendVia, 2);

        Close;
        Sql.Clear;
        Sql.Add('update users set customsendvia = :pcustomsendvia ');
        Sql.Add('where userid = :puserid ');
        ParamByName('pcustomsendvia').AsInteger:= NewCustomSendVia;
        ParamByName('puserid').AsInteger:= UserID;
        ExecSql;
      end;

      RWebApplication.ShowMessage(DisplayResult);
    end
    else RWebApplication.ShowMessage(LastErrorMsg);

  finally
    if Assigned(CodeGenerator) then FreeAndNil(CodeGenerator);
  end;
end;

procedure TUserSession.PrepareCodeEmail(AllowGet: boolean; DealerCode: TDealerCode; ReleaseCode: string; SecDate: TDateTime; SecCode: string; ThirtyDay: boolean; UserCount: integer; Module: string);
var
MsgIndex: integer;
EmbedStrings: TStringList;
begin
  EmbedStrings:= TStringList.Create;
  with EmbedStrings do
  try

    Add(DealerName + ' - ' + UserName + ' (' + Email + ')');
    Add('');
    Add('Thank you for your security request at ' + FormatDateTime('hh:nn', Now) + ' on ' + FormatDateTime('dd/mm/yyyy', Now) + '.');
    Add('');
    Add('To confirm the details provided:');
    Add('');
    Add('Customer Name: ' + Embolden(CustName));
    Add('Enterprise version: ' + Embolden(Version));
    Add('ESN: ' + Embolden(ESN));
    Add('Requested for: ' + Embolden(FormatDateTime('dd/mm/yyyy', SecDate)));
    if DealerCode in [dcSystem, dcSystemUC, dcToolkit, dcToolkitUC, dcModules, dcModulesUC] then Add('Security Code: ' + Embolden(SecCode));
    if DealerCode in [dcSystemUC, dcToolkitUC, dcModulesUC] then Add('User Count: ' + Embolden(IntToStr(UserCount)));
    Add('');
    Add('The ' + GetDealerCodeDesc(DealerCode, ThirtyDay, Module) + ' is: ' + Embolden(ReleaseCode));
    if (DealerCode = dcResync) and isNewerVersion(version5) then
    begin
      Add('');
      Add('Following resynchronisation of Enterprise systems, please return to {Webrel-link} and update your customer record with the new ESN number created.');
    end;
    Add('');
    Add('This is an unmonitored email address. Please do not reply to this address.');

    PrepareEmailBody(EmbedStrings);

  finally
    Free;
  end;

  with WRData, msgMain do
  begin
    for MsgIndex:= 0 to Recipients.Count - 1 do Recipients[MsgIndex].Free;
    Recipients.Clear;

    with Recipients.Add do
    begin
      if AllowGet then
      begin
        Address:= Email;
        Name:= UserName;
      end
      else
      begin
        Address:= RequestRecipient.Address;
        Name:= RequestRecipient.Name;
      end;
      Text:= Name + ' <' + Address + '>';
    end;
  end;
end;

procedure TUserSession.PrepareEmailBody(EmbedStrings: TStringlist);
var
msgIndex, BodyIndex: integer;
begin
  with WRData, msgMain do
  begin
    ContentType:= 'text/html; charset=windows-1252';

    for MsgIndex:= 0 to MessageParts.Count - 1 do MessageParts[MsgIndex].Free;
    MessageParts.Clear;
    Body.Clear;

    Body.Add('<html>');
    Body.Add('<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">');
    Body.Add('  <p>&nbsp;</p>');
    Body.Add('  <table width="780" border="0" cellspacing="0" cellpadding="0" align="center">');
    Body.Add('    <tr>');
    Body.Add('      <td width="10" bgcolor="eeeeee" valign="top"><img src="http://www.exchequer.com/images/zip_transparent.gif" width="10" height="10"></td>');
    Body.Add('      <td width="760" bgcolor="eeeeee" valign="top"><img src="http://www.exchequer.com/images/zip_transparent.gif" width="10" height="10"></td>');
    Body.Add('      <td width="10" bgcolor="eeeeee" valign="top"><img src="http://www.exchequer.com/images/zip_transparent.gif" width="10" height="10"></td>');
    Body.Add('    </tr>');
    Body.Add('    <tr>');
    Body.Add('      <td width="10" bgcolor="eeeeee" valign="top">&nbsp;</td>');
    Body.Add('      <td width="760" valign="top">');
    Body.Add('      <table width="760" border="0" cellspacing="0" cellpadding="0">');
    Body.Add('        <tr>');
    Body.Add('          <td valign="top">');
    Body.Add('            <table width="760" border="0" cellspacing="0" cellpadding="0">');
    Body.Add('              <tr valign="top">');
    Body.Add('                <td><img src="http://www.exchequer.com/images/html_news/TOPBAR1.GIF" width="760" height="42"></td>');
    Body.Add('              </tr>');
    Body.Add('            </table>');
    Body.Add('          </td>');
    Body.Add('        </tr>');
    Body.Add('      </table>');
    Body.Add('      <table width="760" border="0" cellspacing="0" cellpadding="0" height="100%">');
    Body.Add('        <tr>');
    Body.Add('          <td width="130" valign="top" height="269" background="http://www.exchequer.com/images/structure/nav_background.gif">');
    Body.Add('            <img src="http://www.exchequer.com/images/html_news/side.gif"><img src="http://www.exchequer.com/images/sub_pages/grey_blend1.jpg">');
    Body.Add('          </td>');
    Body.Add('          <td rowspan="2" valign="top" width="30">');
    Body.Add('            <p>&nbsp;</p>');
    Body.Add('            <p>&nbsp;</p>');
    Body.Add('            <p>&nbsp;</p>');
    Body.Add('            <p>&nbsp;</p>');
    Body.Add('          </td>');
    Body.Add('          <td rowspan="2" valign="top" width="537">');
    Body.Add('            <p>&nbsp;</p>');
    Body.Add('            <title></title>');
    Body.Add('            <font face="Arial, Helvetica, sans-serif" size="2" color="#666666">');
    Body.Add('            <table width="500" border="0" cellspacing="0" cellpadding="2">');

    for BodyIndex:= 0 to EmbedStrings.Count - 1 do
    begin
      if EmbedStrings[BodyIndex] = '' then Body.Add('<tr>&nbsp</tr>')
      else Body.Add('<tr>' + EmbedStrings[BodyIndex] + '</tr>');
    end;

    Body.Add('                <tr>&nbsp</tr>');
    Body.Add('                <tr>&nbsp</tr>');
    Body.Add('              </tr>');
    Body.Add('            </table>');
    Body.Add('            </font>');
    Body.Add('            <td rowspan="2" valign="top" width="63">&nbsp;</td>');
    Body.Add('          </tr>');
    Body.Add('        </table>');
    Body.Add('      </td>');
    Body.Add('      <td width="10" valign="top" bgcolor="eeeeee">&nbsp;</td>');
    Body.Add('    </tr>');
    Body.Add('    <tr>');
    Body.Add('      <td width="10" bgcolor="eeeeee" valign="top"><img src="http://www.exchequer.com/images/zip_transparent.gif" width="10" height="10"></td>');
    Body.Add('      <td width="760" bgcolor="eeeeee" valign="top"><img src="http://www.exchequer.com/images/zip_transparent.gif" width="10" height="10"></td>');
    Body.Add('      <td width="10" bgcolor="eeeeee" valign="top"><img src="http://www.exchequer.com/images/zip_transparent.gif" width="10" height="10"></td>');
    Body.Add('    </tr>');
    Body.Add('    <tr>');
    Body.Add('      <td width="10" valign="top">&nbsp;</td>');
    Body.Add('      <td width="760" valign="top">');
    Body.Add('        <div align="center">');
    Body.Add('          <p class="copyright"><br>');
//    Body.Add('          <font face="Arial, Helvetica, sans-serif" size="1" color="#999999">copyright &copy; 2003 Exchequer Software Ltd</font></p>');
    Body.Add('          <font face="Arial, Helvetica, sans-serif" size="1" color="#999999">copyright &copy; 2004 Exchequer Software Ltd</font></p>');
    Body.Add('        </div>');
    Body.Add('      </td>');
    Body.Add('      <td width="10" valign="top">&nbsp;</td>');
    Body.Add('    </tr>');
    Body.Add('  </table>');
    Body.Add('</body>');
    Body.Add('</html>');
  end;
end;

procedure TUserSession.EmailCodeLog(AllowGet: boolean; DealerCode: TDealerCode; ThirtyDay: boolean; Module: string);
var
EmailLog: TextFile;
begin
  AssignFile(EmailLog, 'C:\Development\Webrel\email.log');

  try

    if FileExists('C:\Development\Webrel\email.log') then Append(EmailLog) else Rewrite(EmailLog);
    if AllowGet then WriteLn(EmailLog, FormatDateTime('dd/mm/yy hh:nn:ss', Now) + ' - ' + Email + ' (' + UserName + ') - ' + CustName + ' ' + GetDealerCodeDesc(DealerCode, ThirtyDay, Module) + '.')
    else WriteLn(EmailLog, FormatDateTime('dd/mm/yy hh:nn:ss', Now) + ' - ' + RequestRecipient.Address + ' (' + RequestRecipient.Name + ') - ' + CustName + ' ' + GetDealerCodeDesc(DealerCode, ThirtyDay, Module) + ' requested by ' + UserName + '.');

  finally
    CloseFile(EmailLog);
  end;
end;

procedure TUserSession.EmailESNLog(Email: string; UserName: string);
var
  EmailLog: TextFile;
begin
  AssignFile(EmailLog, 'C:\Development\Webrel\email.log');

  try
    if FileExists('C:\Development\Webrel\email.log') then
      Append(EmailLog)
    else
      Rewrite(EmailLog);
    WriteLn(EmailLog, FormatDateTime('dd/mm/yy hh:nn:ss', Now) + ' - ' + Email + ' (' + UserName + ') - New ESN sent out.');
  finally
    CloseFile(EmailLog);
  end;
end;

procedure TUserSession.EmailPasswordLog(Email: string; UserName: string);
var
EmailLog: TextFile;
begin
  AssignFile(EmailLog, 'C:\Development\Webrel\email.log');

  try

    if FileExists('C:\Development\Webrel\email.log') then Append(EmailLog) else Rewrite(EmailLog);
    WriteLn(EmailLog, FormatDateTime('dd/mm/yy hh:nn:ss', Now) + ' - ' + Email + ' (' + UserName + ') - New Password sent out.');

  finally
    CloseFile(EmailLog);
  end;
end;

procedure TUserSession.EmailThresholdLog(Email, UserName: string; ThresholdEffect: TThresholdEffect; CodeID: integer; Module: string);
var
EmailLog: TextFile;
begin
  AssignFile(EmailLog, 'C:\Development\Webrel\email.log');

  try

    if FileExists('C:\Development\Webrel\email.log') then Append(EmailLog) else Rewrite(EmailLog);

    case ThresholdEffect of
      teApplied: WriteLn(EmailLog, FormatDateTime('dd/mm/yy hh:nn:ss', Now) + ' - ' + Email + ' (' + UserName + ')' + ' - ' + GetCodeDesc(CodeID, Module) + ' threshold applied.');
      teOverridden: WriteLn(EmailLog, FormatDateTime('dd/mm/yy hh:nn:ss', Now) + ' - ' + Email + ' (' + UserName + ')' + ' - ' + GetCodeDesc(CodeID, Module) + ' threshold overridden.');
      teCodeUnavailable: WriteLn(EmailLog, FormatDateTime('dd/mm/yy hh:nn:ss', Now) + ' - ' + Email + ' (' + UserName + ')' + ' - ' + GetCodeDesc(CodeID, Module) + ' was unavailable.');
    end;

  finally
    CloseFile(EmailLog);
  end;
end;

procedure TUserSession.SMSLog(DealerCode: TDealerCode; ThirtyDay: boolean; Module: string);
var
SMSLog: TextFile;
begin
  AssignFile(SMSLog, 'C:\Development\Webrel\sms.log');

  try

    if FileExists('C:\Development\Webrel\sms.log') then Append(SMSLog) else Rewrite(SMSLog);
    WriteLn(SMSLog, FormatDateTime('dd/mm/yy hh:nn:ss', Now) + ' - ' + SMSPhone + ' (' + UserName + ') - ' + CustName + ' ' + GetDealerCodeDesc(DealerCode, ThirtyDay, Module) + '.')

  finally
    CloseFile(SMSLog);
  end;
end;

procedure TUserSession.ResyncCompanies;
var
MaxID: integer;
begin
  {Check if the current ESN is active; If so, deactivate the current ESNID and
   add a relevant note; Insert a new unspecified ESN into the ESNs table for the
   current customer;}

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select active from esns where esnid = :pesnid ');
    ParamByName('pesnid').AsInteger:= ESNID;
    Open;

    if FieldByName('Active').AsBoolean then
    begin
      Close;
      Sql.Clear;
      Sql.Add('update esns set active = 0, esnnotes = :pesnnotes ');
      Sql.Add('where esnid = :pesnid ');
      ParamByName('pesnnotes').AsString:= 'Deactivated for a Companies Resync. ';
      ParamByName('pesnid').AsInteger:= ESNID;
      ExecSql;

      Close;
      Sql.Clear;
      Sql.Add('select max(esnid) from esns ');
      Open;
      MaxID:= Fields[0].AsInteger;

      Close;
      Sql.Clear;
      Sql.Add('insert into esns (esnid, custid, esn, version, esnnotes, unspecified, active) ');
      Sql.Add('values (:pesnid, :pcustid, ''000-000-000-000-000-000-000'', :pversion, ''Added for a Companies Resync. '', 1, 1) ');
      ParamByName('pesnid').AsInteger:= MaxID + 1;
      ParamByName('pcustid').AsInteger:= CustID;
      ParamByName('pversion').AsString:= Version;
      ExecSql;
    end;
  end;
end;

procedure TUserSession.ResetState;
begin
  {Reset all the state-holding session variables;}
  bUsingDummyESN := FALSE;

  fStoreCodes.Clear;

  PassPlugIn:= '';
  PassMCM:= '';
  PassDaily:= '';
  PassDirectors:= '';

  EntSecCode:= '';
  EntRelCodeType:= '';
  EntRelCode:= '';
  Ent30SecCode:= '';
  Ent30RelCodeType:= '';
  Ent30UserCount:= '';
  Ent30RelCode:= '';
  EntCoySecCode:= '';
  EntCoyCount:= '';
  EntCoyRelCode:= '';

  ModModule:= '';
  ModSecCode:= '';
  ModRelCodeType:= '';
  ModRelCode:= '';
  Mod30Module:= '';
  Mod30SecCode:= '';
  Mod30RelCodeType:= '';
  Mod30UserCount:= '';
  Mod30RelCode:= '';

  PlugsModule:= '';
  PlugsSecCode:= '';
  PlugsRelCodeType:= '';
  PlugsRelCode:= '';
  Plugs30Module:= '';
  Plugs30SecCode:= '';
  Plugs30RelCodeType:= '';
  Plugs30UserCount:= '';
  Plugs30RelCode:= '';

  VectSecCode:= '';
  VectRelCodeType:= '';
  VectRelCode:= '';

  OtherResync:= '';
  OtherResetEnt:= '';
  OtherResetPlugIn:= '';
end;

//*** Helper Functions *********************************************************

function UserSession: TUserSession;
begin
  {Accessor function for the UserSession;}

  Result:= TUserSession(RWebApplication.Data);
end;

function TUserSession.ExceededThreshold(CodeID: integer; Module: string): boolean;
var
Threshold, Period, ModuleID, ThresholdIndex: integer;
NextAvailable: TDateTime;
begin
  {If the Customer ID is 0, this customer is the dummy customer; Thresholds do
   not apply to the dummy customer, so return false and exit;}

  Result:= CustID <> 0;
  if not Result then Exit;

  with WRData.qyPrimary do
  begin
    Close;
    Sql.Clear;

    if Module = '' then
    begin
      {Will use the first record retrieved;}

      Sql.Add('select threshold, period from thresholds ');
      Sql.Add('where codeid = :pcodeid and custid in (0, :pcustid) ');
      Sql.Add('order by custid desc ');
      ParamByName('pcodeid').AsInteger:= CodeID;
      ParamByName('pcustid').AsInteger:= CustID;
      Open;

      Threshold:= FieldByName('Threshold').AsInteger;
      Period:= FieldByName('Period').AsInteger;

      Close;
      Sql.Clear;
      Sql.Add('select auditstamp from auditlog ');
      Sql.Add('where custid = :pcustid and codeid = :pcodeid ');
      Sql.Add('and auditstamp > :pperiod ');
      Sql.Add('order by auditstamp desc ');
    end
    else
    begin
      Sql.Add('select moduleid from modules where modulename = :pmodulename ');
      ParamByName('pmodulename').AsString:= Trim(Module);
      Open;

      ModuleID:= FieldByName('ModuleID').AsInteger;

      Close;
      Sql.Clear;
      Sql.Add('select threshold, period from thresholds ');
      Sql.Add('where custid in (0, :pcustid) ');
      Sql.Add('and moduleid = :pmoduleid ');
      Sql.Add('order by custid desc ');
      ParamByName('pcustid').AsInteger:= CustID;
      ParamByName('pmoduleid').AsInteger:= ModuleID;
      Open;

      Threshold:= FieldByName('Threshold').AsInteger;
      Period:= FieldByName('Period').AsInteger;

      Close;
      Sql.Clear;
      Sql.Add('select a.auditstamp ');
      Sql.Add('from auditlog a inner join auditmodules b on a.auditid = b.auditid ');
      Sql.Add('where a.custid = :pcustid and a.codeid = :pcodeid ');
      Sql.Add('and a.auditstamp > :pperiod and b.moduleid = :pmoduleid ');
      Sql.Add('order by auditstamp desc ');
      ParamByName('pmoduleid').AsInteger:= ModuleID;
    end;
    ParamByName('pcustid').AsInteger:= CustID;
    ParamByName('pcodeid').AsInteger:= CodeID;
    ParamByName('pperiod').AsDateTime:= Date - Period + 1;
    Open;

    if RecordCount < Threshold then Result:= false
    else if (Threshold > 0) and (Period > 0) then with Security do
    begin
      if Validate(UserCode, pidOverrideThresholds) = 0 then
      begin
        {Once Intraweb has a proper message dialog, set the result here to the
         outcome of an 'Are you sure?' dialog;}

        Result:= false;
        if ThreshOverriddenRecipient.Active then EmailThreshOverridden(CodeID, Module);
        RWebApplication.ShowMessage('This code can only be obtained ' + IntToStr(Threshold) + ' times every ' + IntToStr(Period) + ' days - You are overriding this threshold.');
      end
      else
      begin
        for ThresholdIndex:= 1 to Threshold - 1 do Next;
        NextAvailable:= Fields[0].AsDateTime + Period;
        if ThreshAppliedRecipient.Active then EmailThreshApplied(CodeID, Module);
        RWebApplication.ShowMessage('This code can only be obtained ' + IntToStr(Threshold) + ' times every ' + IntToStr(Period) + ' days. The limit has currently been exceeded.' + #13#10#13#10 + 'This code is next available on ' + FormatDateTime('dd/mm/yyyy', NextAvailable) + '.')
      end;
    end
    else
    begin
      if CodeUnavailableRecipient.Active then EmailThreshUnavailable(CodeID, Module);
      RWebApplication.ShowMessage('This release code is not available.');
    end;
  end;
end;

procedure TUserSession.AdminLog(AdminID: integer; IDType: TIDType; ChangeDesc: string);
var
SafeFile: TextFile;
SafeName: string;
begin
  {Insert a record into the AdminLog table; If the auditing fails, write to an
   audit file in the WebRel directory;}

  with WRData.qyAdminLog do
  try

    ParamByName('pidadministered').AsInteger:= AdminID;
    ParamByName('pidtype').AsInteger:= ord(IDType);
    ParamByName('pchangedesc').AsString:= ChangeDesc;
    ParamByName('pauditstamp').AsDateTime:= Now;

    if IDType = itLogin then ParamByName('puserid').AsInteger:= 0
    else ParamByName('puserid').AsInteger:= UserID;

    Prepare;
    ExecSql;

  except
    try
      SafeName:= 'C:\Development\WebRel\Admin.log';
      AssignFile(SafeFile, SafeName);
      if FileExists(SafeName) then System.Append(SafeFile) else ReWrite(SafeFile);
      WriteLn(SafeFile, IntToStr(UserID) + ',' + IntToStr(AdminID) + ',' + IntToStr(ord(IDType)) + ',' + DateTimeToStr(Now) + ',' + ChangeDesc + ',');
    finally
      CloseFile(SafeFile);
    end;
  end;
end;

procedure TUserSession.AuditLog(RelCode: string; CodeID: integer; SecDate: integer; FullRelease: integer; Counts: integer; Module: string);
var
SafeFile: TextFile;
SafeName: string;
AuditID, ModuleID: integer;
begin
  {No auditing occurs for Dummy customers; If a release code already exists in
   the release code store, the code has been requested accidentally; Do not log
   the occurrence to avoid thresholds being applied prematurely; If the code
   has yet to be released for this ESN/version/date combination, insert a record
   into the AuditLog table; If the auditing fails, write to an audit file in the
   WebRel directory; If a module/plugin is involved, add an entry to the
   AuditModules table storing the AuditID and the relevant ModuleID from the
   Modules table;}

  if isDummyCust then Exit;

  if fStoreCodes.IndexOf(RelCode) >= 0 then Exit else fStoreCodes.Add(RelCode);

  with WRData.qyAuditLog do
  try

    ParamByName('pUserID').AsInteger:= UserID;
    ParamByName('pDealerID').AsInteger:= DealerID;
    ParamByName('pCustID').AsInteger:= CustID;
    ParamByName('pESNID').AsInteger:= ESNID;
    ParamByName('pCodeID').AsInteger:= CodeID;
    ParamByName('pSecDate').AsDate:= GetDate(SecDate);
    ParamByName('pFullRelease').AsBoolean:= GetRelease(FullRelease);
    ParamByName('pCounts').AsInteger:= Counts;
    ParamByName('pAuditStamp').AsDateTime:= Now;
    Prepare;
    ExecSql;

  except
    try
      SafeName:= 'C:\Development\WebRel\Audit.log';
      AssignFile(SafeFile, SafeName);
      if FileExists(SafeName) then System.Append(SafeFile) else ReWrite(SafeFile);
      WriteLn(SafeFile, IntToStr(UserID) + ',' + IntToStr(DealerID) + ',' + IntToStr(CustID) + ',' + IntToStr(ESNID) + ',' + IntToStr(CodeID) + ',' + DateToStr(GetDate(SecDate)) + ',' + BoolToStr(GetRelease(FullRelease)) + ',' + IntToStr(Counts) + ',' + DateTimeToStr(Now) + ',' + Module + ',');
    finally
      CloseFile(SafeFile);
    end;
  end;

  if Module <> '' then with WRData.qyPrimary do
  try

    Close;
    Sql.Clear;
    Sql.Add('select @@identity from auditlog ');
    Open;
    AuditID:= Fields[0].AsInteger;

    Close;
    Sql.Clear;
    Sql.Add('select moduleid from modules where modulename = :pmodulename ');
    ParamByName('pModuleName').AsString:= Module;
    Open;
    ModuleID:= FieldByName('ModuleID').AsInteger;

    Close;
    Sql.Clear;
    Sql.Add('insert into auditmodules (auditid, moduleid) values (:pauditid, :pmoduleid) ');
    ParamByName('pauditid').AsInteger:= AuditID;
    ParamByName('pmoduleid').AsInteger:= ModuleID;
    ExecSql;

  except
  end;
end;

procedure TUserSession.InitRelCodes(RelCodeCombo: TIWComboBox);
begin
  {Add all the release code types to the Release Code drop-down except for the
   plug-in and module codes; Then add the individual plug-in and module names
   prepending the respective descriptor;}

  RelCodeCombo.Items.Clear;
  RelCodeCombo.ItemIndex:= -1;

  with WRData.qyAudit do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select codedesc from codetypes where codeid not in (8, 9, 10, 11) ');
    Open;

    while not eof do
    begin
      RelCodeCombo.Items.Add(FieldByName('CodeDesc').AsString);
      Next;
    end;

    Close;
    Sql.Clear;
    Sql.Add('select modulename, plugin, usercount from modules ');
    Open;

    while not eof do
    begin
      if FieldByName('PlugIn').AsBoolean then
      begin
        RelCodeCombo.Items.Add('Plug-In - ' + FieldByName('ModuleName').AsString);
        if FieldByName('UserCount').AsBoolean then RelCodeCombo.Items.Add('Plug-In - User Count - ' + FieldByName('ModuleName').AsString);
      end
      else
      begin
        RelCodeCombo.Items.Add('Module - ' + FieldByName('ModuleName').AsString);
        if FieldByName('UserCount').AsBoolean then RelCodeCombo.Items.Add('Module - User Count - ' + FieldByName('ModuleName').AsString);
      end;
      Next;
    end;
  end;
end;

function TUserSession.ConvertDealerCode(DealerCode: TDealerCode): integer;
begin
  {Converts a dealer code to a CodeID for use by the Code Generator;}

  Result:= -1;

  case DealerCode of
    dcPlugIn: Result:= cidPlugIn;
    dcMCM: Result:= cidMCM;
    dcDaily: Result:= cidDaily;
    dcDirectors: Result:= cidDirectors;
    dcSystem: Result:= cidEntRel;
    dcSystemUC: Result:= cidEntUCRel;
    dcToolkit, dcModules: Result:= cidModRel;
    dcToolkitUC, dcModulesUC: Result:= cidModUCRel;
    dcResync: Result:= cidResync;
    dcResetEnt: Result:= cidResetEnt;
    dcVectronRel : Result := cidVectRel; 
    dcVectronDaily : Result := cidVectDaily;
    dcPlugInRel : Result := cidPlugRel;
  end;
end;

function TUserSession.GetCodeDesc(CodeID: integer; Module: string): string;
begin
  {}

  Result:= '';

  case CodeID of
    cidPlugIn: Result:= 'Plug-In Password';
    cidMCM: Result:= 'MCM Password';
    cidDaily: Result:= 'Daily System Password';
    cidDirectors: Result:= 'Directors Password';
    cidEntRel: Result:= 'Enterprise System Release Code';
    cidEntUCRel: Result:= 'Enterprise User Count Release Code';
    cidEntCoyRel: Result:= 'Enterprise Company Counts Release Code';
    cidModRel: Result:= Module + ' Module Release Code';
    cidModUCRel: Result:= Module + ' Module User Count Release Code';
    cidPlugRel: Result:= Module + ' Plug-In Release Code';
    cidPlugUCRel: Result:= Module + ' Plug-In User Count Release Code';
    cidVectRel: Result:= 'Vectron Release Code';
    cidResync: Result:= 'Resync Companies Password';
    cidResetEnt: Result:= 'Reset Enterprise User Counts Password';
    cidResetPlug: Result:= 'Reset Plug-In User Counts';
    cidVectDaily: Result:= 'Vectron Daily Password';
  end;
end;

function TUserSession.GetDealerCodeDesc(DealerCode: TDealerCode; ThirtyDay: boolean; Module: string): string;
begin
  {Generates the email message string from the enumerated dealer code and the
   user count;}

  Result:= '';

  case DealerCode of
    dcPlugIn: Result:= 'Plug-In Password';
    dcPlugInRel :
    begin
      if ThirtyDay then Result := '30-Day ' + Module + ' Plug-In Release Code'
      else Result := 'Full ' + Module + ' Plug-In Release Code';
    end;
    dcMCM: Result:= 'MCM Password';
    dcDaily: Result:= 'Daily System Password';
    dcDirectors: Result:= 'Directors Password';
    dcSystem:
    begin
      if ThirtyDay then Result:= 'Enterprise 30-Day System Release Code'
      else Result:= 'Enterprise Full System Release Code';
    end;
    dcSystemUC: Result:= '30-Day Enterprise User Count Release Code';
    dcToolkit: Result:= '30-Day Toolkit Release Code';
    dcToolkitUC: Result:= '30-Day Toolkit User Count Release Code';
    dcModules:
    begin
      if ThirtyDay then Result:= '30-Day ' + Module + ' Release Code'
      else Result:= 'Full ' + Module + ' Release Code';
    end;
    dcModulesUC:
    begin
      if ThirtyDay then Result:= '30-Day ' + Module + ' User Count Release Code'
      else Result:= 'Full ' + Module + ' User Count Release Code';
    end;
    dcResync: Result:= 'Resync Companies Password';
    dcResetEnt: Result:= 'Reset Enterprise User Counts Password';
    dcVectronRel :
    begin
      if ThirtyDay then Result := 'Vectron 30-Day System Release Code'
      else Result := 'Vectron Full System Release Code';
    end;
    dcVectronDaily : Result := 'Vectron Daily Password';
  end;
end;

function TUserSession.GetDate(SecDate: integer): TDate;
begin
  {Matches the ItemIndex of the security date drop-down with an actual date;}

  Result:= 0;

  case SecDate of
    0: Result:= Date - 1;
    1: Result:= Date;
    2: Result:= Date + 1;
    3: Result:= Date + 2;
  end;
end;

function TUserSession.GetESN(ESN: string): string;
var
BuildStr: string;
ThreeIndex: integer;
begin
  {Hyphenates unhyphenated ESNs;}

  Result:= '';
  BuildStr:= '';

  if Length(ESN) = 21 then
  begin
    for ThreeIndex:= 0 to 5 do
    BuildStr:= BuildStr + Copy(ESN, ThreeIndex * 3 + 1, 3) + '-';
    Result:= BuildStr + Copy(ESN, 19, 21);
  end
  else Result:= ESN;
end;

function TUserSession.GetPassword: string;
var
CharIndex, RandomNo: integer;
BuildStr: string;
begin
  {Generates a random 8 character password;}

  BuildStr:= '';
  CharIndex:= 0;

  while CharIndex < 8 do
  begin
    RandomNo:= Random(36);
    if not(RandomNo in [18, 24]) then
    begin
      if RandomNo < 10 then BuildStr:= BuildStr + Chr(RandomNo + 48)
      else BuildStr:= BuildStr + Chr(RandomNo + 55);
      inc(CharIndex);
    end;
  end;

  Result:= BuildStr;
end;

function TUserSession.GetModuleID(Module: string): integer;
begin
  {Returns the ModuleID for a given Module string;}

  Result:= 0;

  if Module = tidMultiCurrency then Result:= eidMultiCurrency
  else if Module = tidJobCosting then Result:= eidJobCosting
  else if Module = tidReportWriter then Result:= eidReportWriter
  else if Module = tidToolkit then Result:= eidToolkit
  else if Module = tidTeleSales then Result:= eidTeleSales
  else if Module = tidStkAnalysis then Result:= eidStkAnalysis
  else if Module = tidEBusiness then Result:= eidEBusiness
  else if Module = tidPaperless then Result:= eidPaperless
  else if Module = tidOLESave then Result:= eidOLESave
  else if Module = tidCommitment then Result:= eidCommitment
  else if Module = tidTradeCounter then Result:= eidTradeCounter
  else if Module = tidStdWorksOrders then Result:= eidStdWorksOrders
  else if Module = tidProWorksOrders then Result:= eidProWorksOrders
  else if Module = tidSentimail then Result:= eidSentimail
  else if Module = tidUserProfiles then Result:= eidUserProfiles
  else if Module = tidCISRCT then Result := eidCIS
  else if Module = tidAppsVals then Result := eidAppsVals
  else if Module = tidFullStock then Result := eidFullStock
  else if Module = tidVisualRW then Result := eidVisualRW
  else if Module = tidGoodsReturns then Result := eidGoodsReturns;
end;

function TUserSession.GetRelease(ReleaseIndex: integer): boolean;
begin
  {Matches the ItemIndex of the release type drop-down to a boolean;}

  Result:= ReleaseIndex = 1;
end;

function TUserSession.isDummyCust: boolean;
begin
  {Determines whether the customer in use is the dummy customer;}

  Result:= (UpperCase(CustName) = 'DUMMY') and (CustID = 0) and (ESNID = 0) and (DealerID = 1);
end;

function TUserSession.isNewerVersion(VersionStr: string): boolean;
begin
  {Controls which functionality is available on the Other tab, or whether it is
   displayed at all; The Other tab is unnecessary for versions prior to v4.31;}

  if VersionStr = version5 then Result:= (Version <> version430) and (Version <> version430c) and (Version <> version431)
  else if VersionStr = version431 then Result:= (Version <> version430) and (Version <> version430c)
  else if VersionStr = version430c then Result:= Version <> version430
  else Result:= true;
end;

procedure TUserSession.DebugLog(DebugMsg: string);
var
DebugFile: TextFile;
LocString: string;
begin
  {Logs an error message to the WebRel directory;}

  LocString:= 'C:\development\webrel\errors.txt';
  AssignFile(DebugFile, LocString);
  try
    if FileExists(LocString) then Append(DebugFile) else Rewrite(DebugFile);
    WriteLn(DebugFile, FormatDateTime('dd-mm-yyyy hh:nn:ss', Now) + ' - ' + DebugMsg);
  finally
    CloseFile(DebugFile);
  end;
end;

function TUserSession.Embolden(BoldText: string): string;
begin
  Result:= '<font color="#336699" weight="800">' + BoldText + '</font>';
end;

//*** Validation Functions *****************************************************

function TUserSession.isPasswordExpired: boolean;
begin
  {The administrator password never expires; For other users, check whether their
   password expiry field has elapsed; If so change the password and set the next
   expiry date to the current date plus the user's expiry days value; Send the
   user their new password;}

  if Security.isAdministrator(UserCode) = 0 then Result:= false
  else Result:= Date >= PWExpires;

  if Result then with WRData.qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('update users set userpassword = :puserpassword, pwexpires = :ppwexpires ');
    Sql.Add('where userid = :puserid ');
    ParamByName('puserpassword').AsString:= GetPassword;
    ParamByName('ppwexpires').AsDateTime:= Date + ExpiryDays;
    ParamByName('puserid').AsInteger:= UserID;
    ExecSql;

    EmailPassword(UserCode);
  end;
end;

function TUserSession.isValidEmail(Address: string): boolean;
var
CharPos, CharIndex, AtCount: integer;
begin
  {An address is considered invalid if it has more than @ sign, no @ sign, the @
   sign is the first character in the address, or within 3 characters from the
   last character in the address; The address is also invalid if the . is not
   present, within 3 characters of the start of the address, or is the last
   character;}

  Result:= true;
  AtCount:= 0;

  for CharIndex:= 1 to Length(Address) do
  begin
    if Address[CharIndex] = '@' then inc(AtCount);
    if AtCount > 1 then Result:= false;
  end;

  CharPos:= Pos('@', Address);
  if (CharPos <= 1) or (CharPos >= Length(Address) - 2) then Result:= false;

  CharPos:= Pos('.', Address);
  if (CharPos <= 3) or (CharPos >= Length(Address)) then Result:= false;

  if not Result then RWebApplication.ShowMessage('The email address is invalid. Please enter a valid email address.');
end;

function TUserSession.isValidESN(ESNStr: string): boolean;
var
TestESN: string;
ByteIndex: integer;
ESNByte: integer;
begin
  {Ensure the hyphenated ESN is numeric and satisfies the array[1..7] of byte
   type;}

  Result:= true;

  TestESN:= GetESN(ESNStr);
  for ByteIndex:= 0 to 6 do
  begin
    ESNByte:= StrToIntDef(Copy(TestESN, Succ(ByteIndex * 4), 3), -1);
    if (ESNByte < 0) or (ESNByte > 255) then Result:= false;
  end;
end;

function TUserSession.isValidSendVia(SendSet: TSendSet): boolean;
begin
  {Ensures at least one send mode has been selected;}

  Result:= false;

  if (stEmail in SendSet) or (stSMS in SendSet) then Result:= true
  else RWebApplication.ShowMessage('You must choose to send via email or SMS or both.');
end;

//******************************************************************************

end.

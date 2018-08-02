unit oUserIntf;

// Interface Implemented in oUserIntf unit
// Generic interface for objects which implement a specific User Details

interface

uses Classes, SysUtils, VarConst, PasswordComplexityConst, VarRec2U;

type
  IUserDetails = Interface['{7D09FE42-B775-4048-99AC-EFB6783118D4}']

    // --- Internal Methods to implement Public Properties ---
    function GetIndex: Integer;
    function GetMode: TUserObjectMode;
    function GetCopyUserName: String30;
    function GetUserPassDetailRec: tPassDefType;
    //Get User Access Settings and Used
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
    {HV 17/10/2017 2018-R1 ABSEXCH-19284: User Profile Highlight PII fields flag (GDPR)}
    function GetHighlightPIIFields: Boolean;
    procedure SetHighlightPIIFields(AValue: Boolean);
    function GetHighlightPIIColour: LongInt;
    procedure SetHighlightPIIColour(AValue: LongInt);
    function GetUserStatusDescription: String;

    // ------------------ Public Properties ------------------
    // Validation routine - runs through the list of fields validating the current value, FieldSet
    // allows the validation of a specific field, e.g. during OnExit, or pass in Empty for all
    // fields to be validated
    function Validate(AOwner: TComponent; const AFieldSet: TUserFieldsSet = []): Integer;
    // Returns an error description for an error code returned by Validate
    function ValidationErrorDescription(const AValidationError: Integer): String;
    //Procedure to set All AccessSettings True for New user
    procedure SetAccessSettingsYes(APermission : Boolean);
    //Edit User
    function EditUser: IUserDetails;
    function Save: Integer;
    function SaveErrorDescription(const AStatus: Integer): String;
    //Reset Passowrd by EMail or Changes Password Dialog
    function ResetPassword(ASendEmail, AUpdateInDB: Boolean; AMsgType: Integer = 1): Integer;
    function ResetPasswordErrorDescription(const AStatus: Integer): String;

    //routines for authenticating User
    function AuthenticateUser(const AUserName, APassword: String): Integer;
    function AuthenticationErrorDescription(const AAuthError: Integer): String;
    // ------------------ Public Properties ------------------
    //Accessing list through a index from InterfaceList object.
    property udIndex: Integer Read GetIndex;
    property udMode : TUserObjectMode Read GetMode;
    //For Copy User need to store that user for fatch data like Access Settings, Emain Sign
    property udCopyUserName: String30 Read GetCopyUserName;
    //tPassDefType Fields
    property udUserName: String30 Read GetUserName Write SetUserName;
    property udPwdExpMode: Byte Read GetPwdExpMode Write SetPwdExpMode;
    property udPwdExpDays: SmallInt Read GetPwdExpDays Write SetPwdExpDays;
    property udPwdExpDate: LongDate Read GetPwdExpDate Write SetPwdExpDate;
    property udDirCust: String10 Read GetDirCust Write SetDirCust;
    property udDirSupp: String10 Read GetDirSupp Write SetDirSupp;
    property udMaxSalesAuth: Double Read GetMaxSalesAuth Write SetMaxSalesAuth;
    property udMaxPurchAuth: Double Read GetMaxPurchAuth Write SetMaxPurchAuth;
    property udCCDep: CCDepType Read GetCCDept Write SetCCDept;
    property udLocation: String10 Read GetLocation Write SetLocation;
    property udSalesBank: LongInt Read GetSalesBank Write SetSalesBank;
    property udPurchBank: LongInt Read GetPurchBank Write SetPurchBank;
    property udRepPrint: String50 Read GetRepPrint Write SetRepPrint;
    property udFormPrint: String50 Read GetFormPrint Write SetFormPrint;
    property udOrPRNS1: Boolean Read GetOrPRNS1 Write SetOrPRNS1;
    property udOrPRNS2: Boolean Read GetOrPRNS2 Write SetOrPRNS2;
    property udCCDepRules: Byte Read GetCCDepRules Write SetCCDepRules;
    property udLocRules: Byte Read GetLocRules Write SetLocRules;
    property udEmailAddr: String100 Read GetEmailAddr Write SetEmailAddr;
    property udPwdTimeOut: SmallInt Read GetPwdTimeOut Write SetPwdTimeOut;
    property udLoaded: Boolean Read GetLoaded Write SetLoaded;
    property udFullName: String50 Read GetFullName Write SetFullName;          //UserName
    property udUcPr: Byte Read GetUcPr Write SetUcPr;
    property udUcYr: Byte Read GetUcYr Write SetUcYr;
    property udUDispPrMonth: Boolean Read GetUDispPrMonth Write SetUDispPrMonth;
    property udShowGlCodes: Boolean Read GetShowGlCodes Write SetShowGlCodes;
    property udShowStockCodes: Boolean Read GetShowStockCodes Write SetShowStockCodes;
    property udShowProductType: Boolean Read GetShowProductType Write SetShowProductType;
    property udUserStatus: TUserStatus Read GetUserStatus Write SetUserStatus;
    property udPwdSalt: String16 Read GetPwdSalt Write SetPwdSalt;
    property udPwdHash: String64 Read GetPwdHash Write SetPwdHash;
    property udWindowUserId: String100 Read GetWindowUserId Write SetWindowUserId;
    property udSecurityQuesId: LongInt Read GetSecurityQuesId Write SetSecurityQuesId;
    property udSecurityQuesAns: String139 Read GetSecurityQuesAns Write SetSecurityQuesAns;
    property udForcePwdChange: Boolean Read GetForcePwdChange Write SetForcePwdChange;
    property udLoginFailCount: LongInt Read GetLoginFailCount Write SetLoginFailCount;
    {HV 17/10/2017 2018-R1 ABSEXCH-19284: User Profile Highlight PII fields flag (GDPR)}
    property udHighlightPIIFields: Boolean Read GetHighlightPIIFields Write SetHighlightPIIFields;
    property udHighlightPIIColour: LongInt Read GetHighlightPIIColour Write SetHighlightPIIColour;
    property udUserStatusDescription: String Read GetUserStatusDescription;

    property udUserPassDetailRec: tPassDefType Read GetUserPassDetailRec;
    property udUserAccessRec: EntryRecType Read GetUserAccessRec Write SetUserAccessRec;
  end; //IUserDetails

  // Generic interface for objects which implement a specific User List
  IUserDetailList = Interface['{40076B7A-366F-4DC6-B83E-E67C499B3536}']
    // --- Internal Methods to implement Public Properties ---
    function GetCount: Integer;
    function GetUsers(aIndex: Integer): IUserDetails;
    // ------------------ Public Properties ------------------
    property Count: Integer Read GetCount;
    property Users[aIndex: Integer]: IUserDetails Read GetUsers; default;

    // Reloads the cached TaxRegion settings
    procedure Refresh;
    function AddUser: IUserDetails;
    function CopyUser(const aICopyUserDetail: IUserDetails): IUserDetails;
    function DeleteUser(AUserName: String; var ADeleteMsg: String): Integer;
    function FindUserByUserName(AUserName: String30): IUserDetails;
    function FindUserByWinUserID(AUserName, AWinUserID: String30): IUserDetails;
    function DeleteCustomSetting(AUserName: String; var ADeleteMsg: String): Integer;
  end; //IUserDetailList

implementation

end.

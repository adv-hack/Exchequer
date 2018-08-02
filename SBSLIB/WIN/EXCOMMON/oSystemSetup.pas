Unit oSystemSetup;

Interface

Uses Classes, SysUtils, Graphics;

Type
  // Enumeration of the System Setup Fields in SystemSetup.Dat
  //
  // New Fields are inserted by GEUpgrde.Dll - default values need to be added into the
  // DefaultSystemSetupFields array within MultComp\Upgrades\AddSystemSetupFields.pas
  //
  // CJS 2015-12-17 - ABSEXCH-17082 - Intrastat - Add new Intrastat System Setup entries
  // CJS 2016-03-31 - ABSEXCH-17380 - new Tax Home Region system-setup field
  // SS  25/05/2017 2017-R2: ABSEXCH-18573: Add Currency Tolerance Editable field under system set-up.
  // TG  28-06-2017 2017 R2: ABSEXCH- 18840: User Authentication Configuration - Database Changes (2.5)  from 26 to 33.
  // HV  14-11-2017 2018 R1, ABSEXCH-19344: GDPR - New SystemSetup Rows Database Changes from 34 to 54
  TSystemSetupFieldIds = ( siDataVersionNo = 0,
                           siSettlementWriteOffCtrlGL = 1,
                           siPPDRedDays = 2,
                           siPPDAmberDays = 3,
                           siPPDExpiredBackgroundColour = 4,
                           siPPDExpiredFontColour = 5,
                           siPPDExpiredFontStyle = 6,
                           siPPDRedBackgroundColour = 7,
                           siPPDRedFontColour = 8,
                           siPPDRedFontStyle = 9,
                           siPPDAmberBackgroundColour = 10,
                           siPPDAmberFontColour = 11,
                           siPPDAmberFontStyle = 12,
                           siPPDGreenBackgroundColour = 13,
                           siPPDGreenFontColour = 14,
                           siPPDGreenFontStyle = 15,
                           siShowDeliveryTerms = 16,
                           siShowModeOfTransport = 17,
                           siLastClosedArrivalsDate = 18,
                           siLastClosedDispatchesDate = 19,
                           siLastReportPeriodYear = 20,
                           siLastReportFromDate = 21,
                           siLastReportToDate = 22,
                           siLastReportMode = 23,
                           siTaxHomeRegion = 24,
                           siCurrImportTol = 25,
                           siAuthenticationMode = 26,
                           siMinimumPasswordLength = 27,
                           siRequireUppercase = 28,
                           siRequireLowercase =29,
                           siRequireNumeric = 30,
                           siRequireSymbol = 31,
                           siSuspendUsersAfterLoginFailures =32,
                           siSuspendUsersLoginFailureCount =33,
                           siAnonymised = 34,
                           siAnonymisedDate = 35,
                           siAnonymisedTime = 36,
                           siGDPRTraderRetentionPeriod = 37,
                           siGDPRTraderDisplayPIITree = 38,
                           siGDPRTraderAnonNotesOption = 39,
                           siGDPRTraderAnonLettersOption = 40,
                           siGDPRTraderAnonLinksOption = 41,
                           siGDPREmployeeRetentionPeriod = 42,
                           siGDPREmployeeDisplayPIITree = 43,
                           siGDPREmployeeAnonNotesOption = 44,
                           siGDPREmployeeAnonLettersOption = 45,
                           siGDPREmployeeAnonLinksOption = 46,
                           siNotificationWarningColour = 47,
                           siNotificationWarningFontColour = 48,
                           siGDPRCompanyAnonLocations = 49,
                           siGDPRCompanyAnonCostCentres = 50,
                           siGDPRCompanyAnonDepartment = 51,
                           siGDPRCompanyNotesOption = 52,
                           siGDPRCompanyLettersOption = 53,
                           siGDPRCompanyLinksOption = 54
                         );

  //------------------------------

  SystemSetupInternalSettingsPPDColourRecType = Record
    pcrBackgroundColour : TColor;
    pcrFontColour       : TColor;
    pcrFontStyle        : Integer;
  End; // SystemSetupInternalSettingsPPDColourRecType

  pSystemSetupInternalSettingsPPDColourRecType = ^SystemSetupInternalSettingsPPDColourRecType;

  // Internal Record Structure - required to be public for the Auditing subsystem
  SystemSetupInternalSettingsRecType = Record
    isSettlementWriteOffCtrlGL : LongInt;

    isPPDRedDays               : Integer;
    isPPDAmberDays             : Integer;
    isPPDExpiredColours        : SystemSetupInternalSettingsPPDColourRecType;
    isPPDRedColours            : SystemSetupInternalSettingsPPDColourRecType;
    isPPDAmberColours          : SystemSetupInternalSettingsPPDColourRecType;
    isPPDGreenColours          : SystemSetupInternalSettingsPPDColourRecType;
    // CJS 2015-12-17 - ABSEXCH-17082 - Intrastat - Add new Intrastat System Setup entries
    isShowDeliveryTerms        : Boolean;
    isShowModeOfTransport      : Boolean;
    // MH 05/02/2016 2016-R1 ABSEXCH-17239: Changed to sized ShortStrings as having them declared
    // as STRING was causing Access Violations after going through the Control Codes dialog. Very
    // complex issue - see JIRA for details
    isLastClosedArrivalsDate   : String[8];   // YYYYMMDD
    isLastClosedDispatchesDate : String[8];   // YYYYMMDD
    isLastReportPeriodYear     : String[4];   // MMYY
    isLastReportFromDate       : String[8];   // YYYYMMDD
    isLastReportToDate         : String[8];   // YYYYMMDD
    isLastReportMode           : Integer;
    isTaxHomeRegion            : Integer;

    //SS:25/05/2017 2017-R2:ABSEXCH-18573:Add Currency Tolerance Editable field under system set-up.
    isCurrImportTol            : Double;

    //TG 28-06-2017 2017 R2: ABSEXCH- 18840 User Authentication Configuration - Database Changes (2.5)
    isAuthenticationMode: String[20];
    isMinimumPasswordLength: Integer;
    isRequireUppercase: Boolean;
    isRequireLowercase: Boolean;
    isRequireNumeric: Boolean;
    isRequireSymbol: Boolean;
    isSuspendUsersAfterLoginFailures: Boolean;
    isSuspendUsersLoginFailureCount: Integer;
    
    // HV 14-11-2017 2018 R1, ABSEXCH-19344: GDPR - New SystemSetup Rows Database Changes from 34 to 54
    isAnonymised: Boolean;
    isAnonymisedDate: String[8];
    isAnonymisedTime: String[6];
    isGDPRTraderRetentionPeriod: Integer;
    isGDPRTraderDisplayPIITree: Boolean;
    isGDPRTraderAnonNotesOption: Integer;
    isGDPRTraderAnonLettersOption: Integer;
    isGDPRTraderAnonLinksOption: Integer;
    isGDPREmployeeRetentionPeriod: Integer;
    isGDPREmployeeDisplayPIITree: Boolean;
    isGDPREmployeeAnonNotesOption: Integer;
    isGDPREmployeeAnonLettersOption: Integer;
    isGDPREmployeeAnonLinksOption: Integer;
    isNotificationWarningColour: Integer;
    isNotificationWarningFontColour: Integer;
    isGDPRCompanyAnonLocations: Boolean;
    isGDPRCompanyAnonCostCentres: Boolean;
    isGDPRCompanyAnonDepartment: Boolean;
    isGDPRCompanyNotesOption: Integer;
    isGDPRCompanyLettersOption: Integer;
    isGDPRCompanyLinksOption: Integer;

    // NOTE: Do not declare fields as STRING/ANSISTRING or any form of POINTER or INTERFACE in this
    // structure as copies of it are made using pointers and Move during the auditing - this screws
    // the reference counting mechanisms causing Access Violations
  End; // SystemSetupInternalSettingsRecType

  pSystemSetupInternalSettingsRecType = ^SystemSetupInternalSettingsRecType;

  //------------------------------

  // Generic interface for objects which implement a specific import type
  ISystemSetupControlCodes = Interface
    ['{E1921F87-5DF7-4ABC-912E-F45EC56B3073}']
    // --- Internal Methods to implement Public Properties ---
    Function GetssSettlementWriteOffCtrlGL : LongInt;

    // ------------------ Public Properties ------------------
    Property ssSettlementWriteOffCtrlGL : LongInt Read GetssSettlementWriteOffCtrlGL;
  End; // ISystemSetupControlCodes

  //------------------------------

  //SS:25/05/2017 2017-R2:ABSEXCH-18573:Add Currency Tolerance Editable field under system set-up.
  // Interface for object which accesses the Currency Setup  fields.

  ISystemSetupImportTolCurrency = Interface
  ['{E96BF007-5A9E-4C69-8691-4514D3DC98AE}']

    // --- Internal Methods to implement Public Properties ---
    function GetssCurrImportTol : real;

    // ------------------ Public Properties ------------------
    property ssCurrImportTol : real read GetssCurrImportTol;

  end;

  //------------------------------

   //TG 28-06-2017 2017 R2: ABSEXCH- 18840 User Authentication Configuration - Database Changes (2.5)
  // Interface for Authentication Configuration Options

  ISystemSetupPasswordAuthentication = interface
  ['{CFABB98D-98F5-4599-B87B-A8FBAB52E286}']

  // --- Internal Methods to implement Public Properties ---

  	function GetAuthenticationMode: String;
    function GetMinimumPasswordLength: Integer;
  	function GetRequireUppercase: Boolean;
  	function GetRequireLowercase: Boolean;
  	function GetRequireNumeric: Boolean;
  	function GetRequireSymbol: Boolean;
  	function GetSuspendUsersAfterLoginFailures: Boolean;
  	function GetSuspendUsersLoginFailureCount: Integer;

  // ------------------ Public Properties ------------------
  	property AuthenticationMode: String read GetAuthenticationMode ;
  	property MinimumPasswordLength: Integer read GetMinimumPasswordLength ;
  	property RequireUppercase: Boolean read GetRequireUppercase ;
  	property RequireLowercase: Boolean read GetRequireLowercase ;
  	property RequireNumeric: Boolean read GetRequireNumeric ;
 	  property RequireSymbol: Boolean read GetRequireSymbol ;
  	property SuspendUsersAfterLoginFailures: Boolean read GetSuspendUsersAfterLoginFailures ;
  	property SuspendUsersLoginFailureCount: Integer read GetSuspendUsersLoginFailureCount ;
  end;
  //--------------------------------------------------------

  ISystemSetupPPDColours = Interface
    ['{9FCA0F80-9356-4192-9024-CCCE9A0C9EE7}']
    // --- Internal Methods to implement Public Properties ---
    Function GetBackgroundColour : TColor;
    Function GetFontColour : TColor;
    Function GetFontStyle : TFontStyles;

    // ------------------ Public Properties ------------------
    Property poBackgroundColour : TColor Read GetBackgroundColour;
    Property poFontColour : TColor Read GetFontColour;
    Property poFontStyle : TFontStyles Read GetFontStyle;
  End; // ISystemSetupPPDColours

  // Generic interface for objects which implement a specific import type
  ISystemSetupPPD = Interface
    ['{88CAC547-3608-4977-A9A7-4283D7D349FF}']
    // --- Internal Methods to implement Public Properties ---
    Function GetPPDRedDays : Integer;
    Function GetPPDAmberDays : Integer;
    Function GetPPDExpiredColours : ISystemSetupPPDColours;
    Function GetPPDRedColours : ISystemSetupPPDColours;
    Function GetPPDAmberColours : ISystemSetupPPDColours;
    Function GetPPDGreenColours : ISystemSetupPPDColours;

    // ------------------ Public Properties ------------------
    Property PPDRedDays : Integer Read GetPPDRedDays;
    Property PPDAmberDays : Integer Read GetPPDAmberDays;
    Property PPDExpiredColours : ISystemSetupPPDColours Read GetPPDExpiredColours;
    Property PPDRedColours : ISystemSetupPPDColours Read GetPPDRedColours;
    Property PPDAmberColours : ISystemSetupPPDColours Read GetPPDAmberColours;
    Property PPDGreenColours : ISystemSetupPPDColours Read GetPPDGreenColours;
  End; // ISystemSetupPPD

  //------------------------------

  // CJS 2015-12-17 - ABSEXCH-17082 - Intrastat - Add new Intrastat System Setup entries
  // Interface for object which accesses the Intrastat fields
  ISystemSetupIntrastat = Interface
    ['{978842C2-4D1C-4F30-995D-3FB40FFC28F0}']
    // --- Internal Methods to implement Public Properties ---
    Function GetShowDeliveryTerms: Boolean;
    Function GetShowModeOfTransport: Boolean;
    Function GetLastClosedArrivalsDate: String;
    Function GetLastClosedDispatchesDate: String;
    Function GetLastReportPeriodYear: String;
    Function GetLastReportFromDate: String;
    Function GetLastReportToDate: String;
    Function GetLastReportMode: Integer;

    // ------------------ Public Properties ------------------
    Property isShowDeliveryTerms: Boolean Read GetShowDeliveryTerms;
    Property isShowModeOfTransport: Boolean Read GetShowModeOfTransport;
    Property isLastClosedArrivalsDate: String Read GetLastClosedArrivalsDate;
    Property isLastClosedDispatchesDate: String Read GetLastClosedDispatchesDate;
    Property isLastReportPeriodYear: String Read GetLastReportPeriodYear;
    Property isLastReportFromDate: String Read GetLastReportFromDate;
    Property isLastReportToDate: String Read GetLastReportToDate;
    Property isLastReportMode: Integer Read GetLastReportMode;
  end; // ISystemSetupIntrastat

  //------------------------------
  // HV 14-11-2017 2018 R1, ABSEXCH-19344: GDPR - New SystemSetup Rows Database Changes
  // Interface for GDPR Configuration
  ISystemSetupGDPR = interface['{87629EE6-FD9A-49D8-9F11-7505C02B4922}']
  // --- Internal Methods to implement Public Properties ---
    function GetAnonymised: Boolean;
    function GetAnonymisedDate: String;
    function GetAnonymisedTime: String;
    function GetGDPRTraderRetentionPeriod: Integer;
    function GetGDPRTraderDisplayPIITree: Boolean;
    function GetGDPRTraderAnonNotesOption: Integer;
    function GetGDPRTraderAnonLettersOption: Integer;
    function GetGDPRTraderAnonLinksOption: Integer;
    function GetGDPREmployeeRetentionPeriod: Integer;
    function GetGDPREmployeeDisplayPIITree: Boolean;
    function GetGDPREmployeeAnonNotesOption: Integer;
    function GetGDPREmployeeAnonLettersOption: Integer;
    function GetGDPREmployeeAnonLinksOption: Integer;
    function GetNotificationWarningColour: Integer;
    function GetNotificationWarningFontColour: Integer;
    function GetGDPRCompanyAnonLocations: Boolean;
    function GetGDPRCompanyAnonCostCentres: Boolean;
    function GetGDPRCompanyAnonDepartment: Boolean;
    function GetGDPRCompanyNotesOption: Integer;
    function GetGDPRCompanyLettersOption: Integer;
    function GetGDPRCompanyLinksOption: Integer;

  // ------------------ Public Properties ------------------
    property Anonymised: Boolean Read GetAnonymised;
    property AnonymisedDate: String Read GetAnonymisedDate;
    property AnonymisedTime: String Read GetAnonymisedTime;
    property GDPRTraderRetentionPeriod: Integer Read GetGDPRTraderRetentionPeriod;
    property GDPRTraderDisplayPIITree: Boolean Read GetGDPRTraderDisplayPIITree;
    property GDPRTraderAnonNotesOption: Integer Read GetGDPRTraderAnonNotesOption;
    property GDPRTraderAnonLettersOption: Integer Read GetGDPRTraderAnonLettersOption;
    property GDPRTraderAnonLinksOption: Integer Read GetGDPRTraderAnonLinksOption;
    property GDPREmployeeRetentionPeriod: Integer Read GetGDPREmployeeRetentionPeriod;
    property GDPREmployeeDisplayPIITree: Boolean Read GetGDPREmployeeDisplayPIITree;
    property GDPREmployeeAnonNotesOption: Integer Read GetGDPREmployeeAnonNotesOption;
    property GDPREmployeeAnonLettersOption: Integer Read GetGDPREmployeeAnonLettersOption;
    property GDPREmployeeAnonLinksOption: Integer Read GetGDPREmployeeAnonLinksOption;
    property NotificationWarningColour: Integer Read GetNotificationWarningColour;
    property NotificationWarningFontColour: Integer Read GetNotificationWarningFontColour;
    property GDPRCompanyAnonLocations: Boolean Read GetGDPRCompanyAnonLocations;
    property GDPRCompanyAnonCostCentres: Boolean Read GetGDPRCompanyAnonCostCentres;
    property GDPRCompanyAnonDepartment: Boolean Read GetGDPRCompanyAnonDepartment;
    property GDPRCompanyNotesOption: Integer Read GetGDPRCompanyNotesOption;
    property GDPRCompanyLettersOption: Integer Read GetGDPRCompanyLettersOption;
    property GDPRCompanyLinksOption: Integer Read GetGDPRCompanyLinksOption;
  end; //ISystemSetupGDPR

  //------------------------------

  // CJS 2016-03-31 - ABSEXCH-17380 - new Tax Home Region system-setup field
  ISystemSetupMultiRegionTax = Interface
    ['{C0228FF6-9E97-43B7-A143-3ACCD420B369}']
    // --- Internal Methods to implement Public Properties ---
    Function GetHomeRegion: Integer;

    // ------------------ Public Properties ------------------
    Property mrtHomeRegion: Integer read GetHomeRegion;
  end;

  //------------------------------

  // Generic interface for objects which implement a specific import type
  ISystemSetup = Interface
    ['{8481C2AB-B05E-43BD-98CA-B9BFD5E9BBF6}']
    // --- Internal Methods to implement Public Properties ---
    Function GetAuditData : pSystemSetupInternalSettingsRecType;
    Function GetControlCodes : ISystemSetupControlCodes;
    Function GetPPD : ISystemSetupPPD;

    // CJS 2015-12-17 - ABSEXCH-17082 - Intrastat - Add new Intrastat System Setup entries
    Function GetIntrastat : ISystemSetupIntrastat;

    // CJS 2016-03-31 - ABSEXCH-17380 - new Tax Home Region system-setup field
    Function GetMultiRegionTax : ISystemSetupMultiRegionTax;

    //SS:25/05/2017 2017-R2:ABSEXCH-18573:Add Currency Tolerance Editable field under system set-up.b
    function GetCurrencySetup :  ISystemSetupImportTolCurrency;
    
    //TG 28-06-2017 2017 R2: ABSEXCH- 18840 User Authentication Configuration - Database Changes (2.5)
    function GetPasswordAuthentication : ISystemSetupPasswordAuthentication;

    //HV 14-11-2017 2018 R1, ABSEXCH-19344: GDPR - New SystemSetup Rows Database Changes
    function GetGDPR : ISystemSetupGDPR;

    // ------------------ Public Properties ------------------
    Property AuditData : pSystemSetupInternalSettingsRecType Read GetAuditData;
    Property ControlCodes : ISystemSetupControlCodes Read GetControlCodes;
    Property PPD : ISystemSetupPPD Read GetPPD;
    Property Intrastat: ISystemSetupIntrastat read GetIntrastat;
    Property MultiRegionTax: ISystemSetupMultiRegionTax read GetMultiRegionTax;
    
    //SS:25/05/2017 2017-R2:ABSEXCH-18573:Add Currency Tolerance Editable field under system set-up.
    property CurrencySetup : ISystemSetupImportTolCurrency read  GetCurrencySetup;
    //TG 28-06-2017 2017 R2: ABSEXCH- 18840 User Authentication Configuration - Database Changes (2.5)
    property PasswordAuthentication : ISystemSetupPasswordAuthentication read GetPasswordAuthentication;
    //HV 14-11-2017 2018 R1, ABSEXCH-19344: GDPR - New SystemSetup Rows Database Changes
    property GDPR: ISystemSetupGDPR read GetGDPR;        
    // ------------------- Public Methods --------------------
    // Reloads the cached SystemSetup settings
    Procedure Refresh;

    // Updates a specified setting
    Function UpdateValue (Const FieldIdx : TSystemSetupFieldIds;
                          Const OriginalValue : ShortString;
                          Const NewValue : ShortString) : Integer;
  End; // ISystemSetup

//------------------------------

// Singleton to provide access to the SystemSetup properties
Function SystemSetup (Const ForceRefresh : Boolean = False) : ISystemSetup;

// Utility conversion functions - primarily for updating the data
Function FontStyleToInternal (Const FontStyle : TFontStyles) : Integer;

//------------------------------

Implementation

Uses DB, oSystemSetupBtrieveFile, GlobVar, VarConst, SQLUtils, SQLCallerU, ADOConnect,
      VAOUtil;

Type
  TSystemSetupControlCodes = Class(TInterfacedObject, ISystemSetupControlCodes)
  Private
    FSettings : pSystemSetupInternalSettingsRecType;
  Protected
    // ISystemSetupControlCodes methods
    Function GetssSettlementWriteOffCtrlGL : LongInt;
  Public
    Constructor Create (Const SettingsPtr : pSystemSetupInternalSettingsRecType);
    Destructor Destroy; Override;
  End; // TSystemSetupControlCodes

  
  //------------------------------
  //SS:25/05/2017 2017-R2:ABSEXCH-18573:Add Currency Tolerance Editable field under system set-up.
  TSystemSetupImportTolCurrency = Class(TInterfacedObject, ISystemSetupImportTolCurrency)
  Private
    FSettings : pSystemSetupInternalSettingsRecType;
  Protected
    // ISystemSetupImportTolCurrency methods
    function GetssCurrImportTol : Real;
  Public
    Constructor Create (Const SettingsPtr : pSystemSetupInternalSettingsRecType);
    Destructor Destroy; Override;
  End; // TSystemSetupControlCodes

  //------------------------------
  //------------------------------

  //TG 28-06-2017 2017 R2: ABSEXCH- 18840 User Authentication Configuration - Database Changes (2.5)
  TSystemSetupPasswordAuthentication = class(TInterfacedObject, ISystemSetupPasswordAuthentication)
  private
    FSettings: pSystemSetupInternalSettingsRecType;
  protected
  	// ISystemSetupPasswordAuthentication methods
  	function GetAuthenticationMode: String;
  	function GetMinimumPasswordLength: Integer;
  	function GetRequireUppercase: Boolean;
  	function GetRequireLowercase: Boolean;
  	function GetRequireNumeric: Boolean;
  	function GetRequireSymbol: Boolean;
  	function GetSuspendUsersAfterLoginFailures: Boolean;
  	function GetSuspendUsersLoginFailureCount: Integer;

  Public
    Constructor Create (Const SettingsPtr : pSystemSetupInternalSettingsRecType);
    Destructor Destroy; Override;
  end;  // TSystemSetupPasswordAuthentication
  //-----------------------------------

  TSystemSetupPPDColours = Class(TInterfacedObject, ISystemSetupPPDColours)
  Private
    FSettings : pSystemSetupInternalSettingsPPDColourRecType;
  Protected
    // ISystemSetupPPDColours methods
    Function GetBackgroundColour : TColor;
    Function GetFontColour : TColor;
    Function GetFontStyle : TFontStyles;
  Public
    Constructor Create (Const SettingsPtr : pSystemSetupInternalSettingsPPDColourRecType);
    Destructor Destroy; Override;
  End; // TSystemSetupControlCodes

  //------------------------------

  TSystemSetupPPD = Class(TInterfacedObject, ISystemSetupPPD)
  Private
    FSettings : pSystemSetupInternalSettingsRecType;

    FExpiredColours : ISystemSetupPPDColours;
    FRedColours : ISystemSetupPPDColours;
    FAmberColours : ISystemSetupPPDColours;
    FGreenColours : ISystemSetupPPDColours;
  Protected
    // ISystemSetupPPD methods
    Function GetPPDRedDays : Integer;
    Function GetPPDAmberDays : Integer;
    Function GetPPDExpiredColours : ISystemSetupPPDColours;
    Function GetPPDRedColours : ISystemSetupPPDColours;
    Function GetPPDAmberColours : ISystemSetupPPDColours;
    Function GetPPDGreenColours : ISystemSetupPPDColours;
  Public
    Constructor Create (Const SettingsPtr : pSystemSetupInternalSettingsRecType);
    Destructor Destroy; Override;
  End; // TSystemSetupPPD

  //------------------------------
  //HV 14-11-2017 2018 R1, ABSEXCH-19344: GDPR - New SystemSetup Rows Database Changes
  TSystemSetupGDPR = class(TInterfacedObject, ISystemSetupGDPR)
  private
    FSettings: pSystemSetupInternalSettingsRecType;
  protected
   //ISystemSetupGDPR Methods
    function GetAnonymised: Boolean;
    function GetAnonymisedDate: String;
    function GetAnonymisedTime: String;
    function GetGDPRTraderRetentionPeriod: Integer;
    function GetGDPRTraderDisplayPIITree: Boolean;
    function GetGDPRTraderAnonNotesOption: Integer;
    function GetGDPRTraderAnonLettersOption: Integer;
    function GetGDPRTraderAnonLinksOption: Integer;
    function GetGDPREmployeeRetentionPeriod: Integer;
    function GetGDPREmployeeDisplayPIITree: Boolean;
    function GetGDPREmployeeAnonNotesOption: Integer;
    function GetGDPREmployeeAnonLettersOption: Integer;
    function GetGDPREmployeeAnonLinksOption: Integer;
    function GetNotificationWarningColour: Integer;
    function GetNotificationWarningFontColour: Integer;
    function GetGDPRCompanyAnonLocations: Boolean;
    function GetGDPRCompanyAnonCostCentres: Boolean;
    function GetGDPRCompanyAnonDepartment: Boolean;
    function GetGDPRCompanyNotesOption: Integer;
    function GetGDPRCompanyLettersOption: Integer;
    function GetGDPRCompanyLinksOption: Integer;
  public
    constructor Create(const ASettingsPtr : pSystemSetupInternalSettingsRecType);
    destructor Destroy; override;
  end;
  //------------------------------

  TSystemSetupIntrastat = Class(TInterfacedObject, ISystemSetupIntrastat)
  Private
    FSettings : pSystemSetupInternalSettingsRecType;
  Protected
    // ISystemSetupIntrastat methods
    Function GetShowDeliveryTerms: Boolean;
    Function GetShowModeOfTransport: Boolean;
    Function GetLastClosedArrivalsDate: String;
    Function GetLastClosedDispatchesDate: String;
    Function GetLastReportPeriodYear: String;
    Function GetLastReportFromDate: String;
    Function GetLastReportToDate: String;
    Function GetLastReportMode: Integer;
  Public
    Constructor Create (Const SettingsPtr : pSystemSetupInternalSettingsRecType);
    Destructor Destroy; Override;
  End; // TSystemSetupIntrastat

  //------------------------------

  // CJS 2016-03-31 - ABSEXCH-17380 - new Tax Home Region system-setup field
  TSystemSetupMultiRegionTax = Class(TInterfacedObject, ISystemSetupMultiRegionTax)
  Private
    FSettings : pSystemSetupInternalSettingsRecType;
  Protected
    // ISystemSetupMultiRegionTax methods
    Function GetHomeRegion : Integer;
  Public
    Constructor Create(Const SettingsPtr: pSystemSetupInternalSettingsRecType);
    Destructor Destroy; override;
  End; // TSystemSetupMultiRegionTax

  //------------------------------

  TSystemSetup = Class(TInterfacedObject, ISystemSetup)
  Private
    FSystemSettingsRec : SystemSetupInternalSettingsRecType;

    FControlCodesObj : TSystemSetupControlCodes;
    FControlCodesIntf : ISystemSetupControlCodes;

    FPPDObj : TSystemSetupPPD;
    FPPDIntf : ISystemSetupPPD;

    FIntrastatObj : TSystemSetupIntrastat;
    FIntrastatIntf : ISystemSetupIntrastat;

    // CJS 2016-03-31 - ABSEXCH-17380 - new Tax Home Region system-setup field
    FMultiRegionTaxObj : TSystemSetupMultiRegionTax;
    FMultiRegionTaxIntf : ISystemSetupMultiRegionTax;

    //SS:25/05/2017 2017-R2:ABSEXCH-18573:Add Currency Tolerance Editable field under system set-up.
    FCurrencySetupObj : TSystemSetupImportTolCurrency;
    FCurrencySetupIntf : ISystemSetupImportTolCurrency;

    //TG 28-06-2017 2017 R2: ABSEXCH- 18840 User Authentication Configuration - Database Changes (2.5)
    FPasswordAuthenticationObj : TSystemSetupPasswordAuthentication ;
    FPasswordAuthenticationIntf : ISystemSetupPasswordAuthentication ;

    //HV 14-11-2017 2018 R1, ABSEXCH-19344: GDPR - New SystemSetup Rows Database Changes
    FGDPRObj : TSystemSetupGDPR;
    FGDPRIntf : ISystemSetupGDPR;

    // ISystemSetup methods
    Function GetAuditData : pSystemSetupInternalSettingsRecType;
    Function GetControlCodes : ISystemSetupControlCodes;
    Function GetPPD : ISystemSetupPPD;

    // CJS 2015-12-17 - ABSEXCH-17082 - Intrastat - Add new Intrastat System Setup entries
    Function GetIntrastat : ISystemSetupIntrastat;

    // CJS 2016-03-31 - ABSEXCH-17380 - new Tax Home Region system-setup field
    Function GetMultiRegionTax : ISystemSetupMultiRegionTax;

     //SS:25/05/2017 2017-R2:ABSEXCH-18573:Add Currency Tolerance Editable field under system set-up.b
    function GetCurrencySetup :  ISystemSetupImportTolCurrency;

    //TG 28-06-2017 2017 R2: ABSEXCH- 18840 User Authentication Configuration - Database Changes (2.5)
    function GetPasswordAuthentication :  ISystemSetupPasswordAuthentication ;

    //HV 14-11-2017 2018 R1, ABSEXCH-19344: GDPR - New SystemSetup Rows Database Changes
    function GetGDPR: ISystemSetupGDPR;

    // Reloads the cached SystemSetup settings
    Procedure Refresh;

    // Updates a specified setting
    Function UpdateValue (Const FieldIdx : TSystemSetupFieldIds;
                          Const OriginalValue : ShortString;
                          Const NewValue : ShortString) : Integer;

  Protected
    // Internal Methods
    Procedure LoadSettings; Virtual; Abstract;
    Function UpdateFieldValue(Const FieldIdx : TSystemSetupFieldIds;
                              Const OriginalValue : ShortString;
                              Const NewValue : ShortString) : Integer; Virtual; Abstract;

    // Takes the setting read from the DB and decodes it and applies it to the internal record
    // structure for use by the object interface
    Procedure ApplySetting (Const FieldId : Integer; Const FieldValue : ShortString);
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TSystemSetup

  //------------------------------

  TSystemSetupPerv = Class(TSystemSetup)
  Private
    FSystemSetupFile : TSystemSetupBtrieveFile;
  Protected
    Procedure LoadSettings; Override;
    Function UpdateFieldValue(Const FieldIdx : TSystemSetupFieldIds;
                              Const OriginalValue : ShortString;
                              Const NewValue : ShortString) : Integer; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TSystemSetupPerv

  //------------------------------

  TSystemSetupSQL = Class(TSystemSetup)
  Private
  Protected
    Procedure LoadSettings; Override;
    Function UpdateFieldValue(Const FieldIdx : TSystemSetupFieldIds;
                              Const OriginalValue : ShortString;
                              Const NewValue : ShortString) : Integer; Override;
  Public
  End; // TSystemSetupPerv

  //------------------------------

Var
  SystemSetupIntf : ISystemSetup;
  OpenCompanyPath : ShortString;

//=========================================================================

// Singleton to provide access to the SystemSetup properties
Function SystemSetup (Const ForceRefresh : Boolean = False) : ISystemSetup;
Begin // SystemSetup
  // If the singleton doesn't exist or the company path has changed then
  // create a new singleton
  If (Not Assigned(SystemSetupIntf)) Or (SetDrive <> OpenCompanyPath) Then
  Begin
    // Create the correct version for the data edition
    If SQLUtils.UsingSQL Then
      SystemSetupIntf := TSystemSetupSQL.Create
    Else
      SystemSetupIntf := TSystemSetupPerv.Create;

    // Load the data
    SystemSetupIntf.Refresh;

    // Update the path so we can detect changes automatically
    OpenCompanyPath := SetDrive;
  End // If (Not Assigned(SystemSetupIntf)) Or (SetDrive <> OpenCompanyPath)
  Else
    // Check to see if the data should be refreshed
    If ForceRefresh Then
      SystemSetupIntf.Refresh;

  Result := SystemSetupIntf;
End; // SystemSetup

//=========================================================================

Constructor TSystemSetupControlCodes.Create (Const SettingsPtr : pSystemSetupInternalSettingsRecType);
Begin // Create
  Inherited Create;
  FSettings := SettingsPtr;
End; // Create

//------------------------------

Destructor TSystemSetupControlCodes.Destroy;
Begin // Destroy
  FSettings := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TSystemSetupControlCodes.GetssSettlementWriteOffCtrlGL : LongInt;
Begin // GetssSettlementWriteOffCtrlGL
  Result := FSettings.isSettlementWriteOffCtrlGL
End; // GetssSettlementWriteOffCtrlGL

//=========================================================================



{ TSystemSetupImportTolCurrency }

constructor TSystemSetupImportTolCurrency.Create(
  const SettingsPtr: pSystemSetupInternalSettingsRecType);
Begin
  Inherited Create;
  FSettings := SettingsPtr;
End;


destructor TSystemSetupImportTolCurrency.Destroy;
Begin
  FSettings := NIL;
  Inherited Destroy;
End;



function TSystemSetupImportTolCurrency.GetssCurrImportTol: Real;
begin
  Result := FSettings.isCurrImportTol;
end;

//=========================================================================


Constructor TSystemSetupPPDColours.Create (Const SettingsPtr : pSystemSetupInternalSettingsPPDColourRecType);
Begin // Create
  Inherited Create;
  FSettings := SettingsPtr;
End; // Create

//------------------------------

Destructor TSystemSetupPPDColours.Destroy;
Begin // Destroy
  FSettings := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TSystemSetupPPDColours.GetBackgroundColour : TColor;
Begin // GetBackgroundColour
  Result := FSettings.pcrBackgroundColour;
End; // GetBackgroundColour

//------------------------------

Function TSystemSetupPPDColours.GetFontColour : TColor;
Begin // GetFontColour
  Result := FSettings.pcrFontColour;
End; // GetFontColour

//------------------------------

Function TSystemSetupPPDColours.GetFontStyle : TFontStyles;
Begin // GetFontStyle
  // Convert the internal representation and return a Delphi TFontStyles type
  Result := [];
  If ((FSettings.pcrFontStyle And 1) = 1) Then
    Result := Result + [fsBold];
  If ((FSettings.pcrFontStyle And 2) = 2) Then
    Result := Result + [fsUnderline];
  If ((FSettings.pcrFontStyle And 4) = 4) Then
    Result := Result + [fsItalic];
  If ((FSettings.pcrFontStyle And 8) = 8) Then
    Result := Result + [fsStrikeout];
End; // GetFontStyle

//=========================================================================

Constructor TSystemSetupPPD.Create (Const SettingsPtr : pSystemSetupInternalSettingsRecType);
Begin // Create
  Inherited Create;
  FSettings := SettingsPtr;

  FExpiredColours := TSystemSetupPPDColours.Create (@FSettings.isPPDExpiredColours);
  FRedColours := TSystemSetupPPDColours.Create (@FSettings.isPPDRedColours);
  FAmberColours := TSystemSetupPPDColours.Create (@FSettings.isPPDAmberColours);
  FGreenColours := TSystemSetupPPDColours.Create (@FSettings.isPPDGreenColours);
End; // Create

//------------------------------

Destructor TSystemSetupPPD.Destroy;
Begin // Destroy
  FExpiredColours := NIL;
  FRedColours := NIL;
  FAmberColours := NIL;
  FGreenColours := NIL;
  FSettings := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TSystemSetupPPD.GetPPDRedDays : Integer;
Begin // GetPPDRedDays
  Result := FSettings.isPPDRedDays
End; // GetPPDRedDays

//------------------------------

Function TSystemSetupPPD.GetPPDAmberDays : Integer;
Begin // GetPPDAmberDays
  Result := FSettings.isPPDAmberDays
End; // GetPPDAmberDays

//------------------------------

Function TSystemSetupPPD.GetPPDExpiredColours : ISystemSetupPPDColours;
Begin // GetPPDExpiredColours
  Result := FExpiredColours
End; // GetPPDExpiredColours

//------------------------------

Function TSystemSetupPPD.GetPPDRedColours : ISystemSetupPPDColours;
Begin // GetPPDRedColours
  Result := FRedColours
End; // GetPPDRedColours

//------------------------------

Function TSystemSetupPPD.GetPPDAmberColours : ISystemSetupPPDColours;
Begin // GetPPDAmberColours
  Result := FAmberColours
End; // GetPPDAmberColours

//------------------------------

Function TSystemSetupPPD.GetPPDGreenColours : ISystemSetupPPDColours;
Begin // GetPPDGreenColours
  Result := FGreenColours
End; // GetPPDGreenColours

//=========================================================================

Constructor TSystemSetup.Create;
Begin // Create
  Inherited Create;

  FillChar(FSystemSettingsRec, SizeOF(FSystemSettingsRec), #0);

  FControlCodesObj := NIL;
  FControlCodesIntf := NIL;

  FPPDObj := NIL;
  FPPDIntf := NIL;

  FIntrastatObj := NIL;
  FIntrastatIntf := NIL;

  FCurrencySetupObj  := nil;
  FCurrencySetupIntf := nil;

  //TG 28-06-2017 2017 R2: ABSEXCH- 18840 User Authentication Configuration - Database Changes (2.5)
  // initializing to nil
  FPasswordAuthenticationObj := nil;
  FPasswordAuthenticationIntf := nil;

  //HV 14-11-2017 2018 R1, ABSEXCH-19344: GDPR - New SystemSetup Rows Database Changes
  FGDPRObj := nil;
  FGDPRIntf := nil;


End; // Create

//------------------------------

Destructor TSystemSetup.Destroy;
Begin // Destroy
  FControlCodesObj := NIL;
  FControlCodesIntf := NIL;

  FPPDObj := NIL;
  FPPDIntf := NIL;

  FIntrastatObj := NIL;
  FIntrastatIntf := NIL;

  FCurrencySetupObj  := nil;
  FCurrencySetupIntf := nil;

  //TG 28-06-2017 2017 R2: ABSEXCH- 18840 User Authentication Configuration - Database Changes (2.5)
  FPasswordAuthenticationObj := nil;
  FPasswordAuthenticationIntf := nil;

  //HV 14-11-2017 2018 R1, ABSEXCH-19344: GDPR - New SystemSetup Rows Database Changes
  FGDPRObj := nil;
  FGDPRIntf := nil;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Reloads the cached SystemSetup settings
Procedure TSystemSetup.Refresh;
Begin // Refresh
  FillChar(FSystemSettingsRec, SizeOF(FSystemSettingsRec), #0);
  LoadSettings;
End; // Refresh

//-------------------------------------------------------------------------

// Updates a specified setting
//
//    0   AOK
//    1   Field Value not found
//    2   Field Value already changed by another user
// 1000+  Error updating Field Value
//
Function TSystemSetup.UpdateValue (Const FieldIdx : TSystemSetupFieldIds;
                                   Const OriginalValue : ShortString;
                                   Const NewValue : ShortString) : Integer;
Begin // UpdateValue
  // Check for changes
  If (OriginalValue <> NewValue) Then
  Begin
    Result := UpdateFieldValue(FieldIdx, OriginalValue, NewValue);
    If (Result = 0) Then
      // Refresh settings
      ApplySetting (Ord(FieldIdx), NewValue);
  End // If (OriginalValue <> NewValue)
  Else
    // No changed reqd
    Result := 0;
End; // UpdateValue

//-------------------------------------------------------------------------

// Takes the setting read from the DB and decodes it and applies it to the internal record
// structure for use by the object interface
Procedure TSystemSetup.ApplySetting (Const FieldId : Integer; Const FieldValue : ShortString);

  //------------------------------

  Function ToInt (Const StrVal : ShortString) : Integer;
  Begin // ToInt
    Result := StrToIntDef(StrVal, 0);
  End; // ToInt

  //------------------------------

  Function ToColour(Const StrVal : ShortString) : TColor;
  Begin // ToColour
    Result := TColor(ToInt(StrVal));
  End; // ToColour

  //------------------------------

  Function ToBoolean(Const StrVal : ShortString) : Boolean;
  Begin // ToBoolean
    Result := Not (ToInt(StrVal) = 0);
  End; // ToBoolean

  //------------------------------

  //SS:25/05/2017 2017-R2:ABSEXCH-18573:Add Currency Tolerance Editable field under system set-up.
  Function ToDouble (Const StrVal : ShortString) : Double;
  Begin // ToInt
    Result := StrToFloatDef(StrVal, 0);
  End; // ToInt

  //------------------------------

Begin // ApplySetting
  Case TSystemSetupFieldIds(FieldId) Of
    siSettlementWriteOffCtrlGL   : FSystemSettingsRec.isSettlementWriteOffCtrlGL := ToInt(FieldValue);

    siPPDRedDays                 : FSystemSettingsRec.isPPDRedDays := ToInt(FieldValue);
    siPPDAmberDays               : FSystemSettingsRec.isPPDAmberDays := ToInt(FieldValue);
    siPPDExpiredBackgroundColour : FSystemSettingsRec.isPPDExpiredColours.pcrBackgroundColour := ToColour(FieldValue);
    siPPDExpiredFontColour       : FSystemSettingsRec.isPPDExpiredColours.pcrFontColour := ToColour(FieldValue);
    siPPDExpiredFontStyle        : FSystemSettingsRec.isPPDExpiredColours.pcrFontStyle := ToInt(FieldValue);
    siPPDRedBackgroundColour     : FSystemSettingsRec.isPPDRedColours.pcrBackgroundColour := ToColour(FieldValue);
    siPPDRedFontColour           : FSystemSettingsRec.isPPDRedColours.pcrFontColour := ToColour(FieldValue);
    siPPDRedFontStyle            : FSystemSettingsRec.isPPDRedColours.pcrFontStyle := ToInt(FieldValue);
    siPPDAmberBackgroundColour   : FSystemSettingsRec.isPPDAmberColours.pcrBackgroundColour := ToColour(FieldValue);
    siPPDAmberFontColour         : FSystemSettingsRec.isPPDAmberColours.pcrFontColour := ToColour(FieldValue);
    siPPDAmberFontStyle          : FSystemSettingsRec.isPPDAmberColours.pcrFontStyle := ToInt(FieldValue);
    siPPDGreenBackgroundColour   : FSystemSettingsRec.isPPDGreenColours.pcrBackgroundColour := ToColour(FieldValue);
    siPPDGreenFontColour         : FSystemSettingsRec.isPPDGreenColours.pcrFontColour := ToColour(FieldValue);
    siPPDGreenFontStyle          : FSystemSettingsRec.isPPDGreenColours.pcrFontStyle := ToInt(FieldValue);

    // CJS 2015-12-17 - ABSEXCH-17082 - Intrastat - Add new Intrastat System Setup entries
    siShowDeliveryTerms                 : FSystemSettingsRec.isShowDeliveryTerms := ToBoolean(FieldValue);
    siShowModeOfTransport               : FSystemSettingsRec.isShowModeOfTransport := ToBoolean(FieldValue);
    siLastClosedArrivalsDate   : FSystemSettingsRec.isLastClosedArrivalsDate := FieldValue;
    siLastClosedDispatchesDate : FSystemSettingsRec.isLastClosedDispatchesDate := FieldValue;
    siLastReportPeriodYear     : FSystemSettingsRec.isLastReportPeriodYear := FieldValue;
    siLastReportFromDate       : FSystemSettingsRec.isLastReportFromDate := FieldValue;
    siLastReportToDate         : FSystemSettingsRec.isLastReportToDate := FieldValue;
    siLastReportMode           : FSystemSettingsRec.isLastReportMode := ToInt(FieldValue);

    // CJS 2016-03-31 - ABSEXCH-17380 - new Tax Home Region system-setup field
    siTaxHomeRegion : FSystemSettingsRec.isTaxHomeRegion := ToInt(FieldValue);

    //SS:25/05/2017 2017-R2:ABSEXCH-18573:Add Currency Tolerance Editable field under system set-up.
    siCurrImportTol : FSystemSettingsRec.isCurrImportTol := ToDouble(FieldValue);

    //TG 28-06-2017 2017 R2: ABSEXCH- 18840 User Authentication Configuration - Database Changes (2.5)
    siAuthenticationMode : FSystemSettingsRec.isAuthenticationMode := FieldValue;
    siMinimumPasswordLength : FSystemSettingsRec.isMinimumPasswordLength := ToInt(FieldValue);
    siRequireUppercase : FSystemSettingsRec.isRequireUppercase := ToBoolean(FieldValue);
    siRequireLowercase : FSystemSettingsRec.isRequireLowercase := ToBoolean(FieldValue);
    siRequireNumeric : FSystemSettingsRec.isRequireNumeric := ToBoolean(FieldValue);
    siRequireSymbol : FSystemSettingsRec.isRequireSymbol := ToBoolean(FieldValue);
    siSuspendUsersAfterLoginFailures : FSystemSettingsRec.isSuspendUsersAfterLoginFailures := ToBoolean(FieldValue);
    siSuspendUsersLoginFailureCount : FSystemSettingsRec.isSuspendUsersLoginFailureCount := ToInt(FieldValue);

    //HV 14-11-2017 2018 R1, ABSEXCH-19344: GDPR - New SystemSetup Rows Database Changes
    siAnonymised: FSystemSettingsRec.isAnonymised := ToBoolean(FieldValue);
    siAnonymisedDate: FSystemSettingsRec.isAnonymisedDate := FieldValue;
    siAnonymisedTime: FSystemSettingsRec.isAnonymisedTime := FieldValue;
    siGDPRTraderRetentionPeriod: FSystemSettingsRec.isGDPRTraderRetentionPeriod := ToInt(FieldValue);
    siGDPRTraderDisplayPIITree: FSystemSettingsRec.isGDPRTraderDisplayPIITree := ToBoolean(FieldValue);
    siGDPRTraderAnonNotesOption: FSystemSettingsRec.isGDPRTraderAnonNotesOption := ToInt(FieldValue);
    siGDPRTraderAnonLettersOption: FSystemSettingsRec.isGDPRTraderAnonLettersOption := ToInt(FieldValue);
    siGDPRTraderAnonLinksOption: FSystemSettingsRec.isGDPRTraderAnonLinksOption := ToInt(FieldValue);
    siGDPREmployeeRetentionPeriod: FSystemSettingsRec.isGDPREmployeeRetentionPeriod := ToInt(FieldValue);
    siGDPREmployeeDisplayPIITree: FSystemSettingsRec.isGDPREmployeeDisplayPIITree := ToBoolean(FieldValue);
    siGDPREmployeeAnonNotesOption: FSystemSettingsRec.isGDPREmployeeAnonNotesOption := ToInt(FieldValue);
    siGDPREmployeeAnonLettersOption: FSystemSettingsRec.isGDPREmployeeAnonLettersOption := ToInt(FieldValue);
    siGDPREmployeeAnonLinksOption: FSystemSettingsRec.isGDPREmployeeAnonLinksOption := ToInt(FieldValue);
    siNotificationWarningColour: FSystemSettingsRec.isNotificationWarningColour := ToInt(FieldValue);
    siNotificationWarningFontColour: FSystemSettingsRec.isNotificationWarningFontColour := ToInt(FieldValue);
    siGDPRCompanyAnonLocations: FSystemSettingsRec.isGDPRCompanyAnonLocations := ToBoolean(FieldValue);
    siGDPRCompanyAnonCostCentres: FSystemSettingsRec.isGDPRCompanyAnonCostCentres := ToBoolean(FieldValue);
    siGDPRCompanyAnonDepartment: FSystemSettingsRec.isGDPRCompanyAnonDepartment := ToBoolean(FieldValue);
    siGDPRCompanyNotesOption: FSystemSettingsRec.isGDPRCompanyNotesOption := ToInt(FieldValue);
    siGDPRCompanyLettersOption: FSystemSettingsRec.isGDPRCompanyLettersOption := ToInt(FieldValue);
    siGDPRCompanyLinksOption: FSystemSettingsRec.isGDPRCompanyLinksOption := ToInt(FieldValue);
  End; // Case TSystemSetupFieldIds(FieldId)
End; // ApplySetting

//-------------------------------------------------------------------------

Function TSystemSetup.GetAuditData : pSystemSetupInternalSettingsRecType;
Begin // GetAuditData
  Result := @FSystemSettingsRec
End; // GetAuditData

//------------------------------

Function TSystemSetup.GetControlCodes : ISystemSetupControlCodes;
Begin // GetControlCodes
  If (Not Assigned(FControlCodesObj)) Then
  Begin
    FControlCodesObj := TSystemSetupControlCodes.Create(@FSystemSettingsRec);
    // Take a local reference to prevent the object self-destructing when the returned reference is NIL'd
    FControlCodesIntf := FControlCodesObj;
  End; // If (Not Assigned(FControlCodesObj))

  Result := FControlCodesIntf;
End; // GetControlCodes

//------------------------------

Function TSystemSetup.GetPPD : ISystemSetupPPD;
Begin // GetPPD
  If (Not Assigned(FPPDObj)) Then
  Begin
    FPPDObj := TSystemSetupPPD.Create(@FSystemSettingsRec);
    // Take a local reference to prevent the object self-destructing when the returned reference is NIL'd
    FPPDIntf := FPPDObj;
  End; // If (Not Assigned(FPPDObj))

  Result := FPPDIntf;
End; // GetPPD

//------------------------------

function TSystemSetup.GetIntrastat: ISystemSetupIntrastat;
begin
  If (Not Assigned(FIntrastatObj)) Then
  Begin
    FIntrastatObj := TSystemSetupIntrastat.Create(@FSystemSettingsRec);
    // Take a local reference to prevent the object self-destructing when the returned reference is NIL'd
    FIntrastatIntf := FIntrastatObj;
  End; // If (Not Assigned(FIntrastatObj))

  Result := FIntrastatIntf;
end; // GetIntrastat

//------------------------------

// CJS 2016-03-31 - ABSEXCH-17380 - new Tax Home Region system-setup field
function TSystemSetup.GetMultiRegionTax: ISystemSetupMultiRegionTax;
begin
  if (Not Assigned(FMultiRegionTaxObj)) Then
  Begin
    FMultiRegionTaxObj := TSystemSetupMultiRegionTax.Create(@FSystemSettingsRec);
    // Take a local reference to prevent the object self-destructing when the returned reference is NIL'd
    FMultiRegionTaxIntf := FMultiRegionTaxObj;
  End; // If (Not Assigned(FMultiRegionTaxObj))
  Result := FMultiRegionTaxIntf;
end;

//=========================================================================

Constructor TSystemSetupPerv.Create;
Begin // Create
  Inherited Create;

  FSystemSetupFile := TSystemSetupBtrieveFile.Create;
End; // Create

//------------------------------

Destructor TSystemSetupPerv.Destroy;
Begin // Destroy
  FSystemSetupFile.CloseFile;
  FSystemSetupFile.Free;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TSystemSetupPerv.LoadSettings;
Var                                
  Res : Integer;
Begin // LoadSettings
   //SS:10/10/2017:ABSEXCH-19378:Importer: When Running the Job: It gives error related to Invalid User Name or Password.
  {$IFDEF IMPV6}
    Res := FSystemSetupFile.OpenFile (VAOInfo.vaoSubCompanyDir + SystemSetupFileName);
  {$ELSE}
    Res := FSystemSetupFile.OpenFile (SetDrive + SystemSetupFileName);
  {$ENDIF}

  If (Res = 0) Then
  Begin
    FSystemSetupFile.Index := ssIdxId;

    Res := FSystemSetupFile.GetFirst;
    While (Res = 0) Do
    Begin
      ApplySetting (FSystemSetupFile.SystemSetup.sysId, FSystemSetupFile.SystemSetup.sysValue);
      Res := FSystemSetupFile.GetNext;
    End; // While (Res = 0)
  End; // If (Res = 0)
End; // LoadSettings

//-------------------------------------------------------------------------

// Updates the specified Field Value
//
//    0   AOK
//    1   Field Value not found
//    2   Field Value already changed by another user
// 1000+  Error updating Field Value
//
Function TSystemSetupPerv.UpdateFieldValue(Const FieldIdx : TSystemSetupFieldIds;
                                           Const OriginalValue : ShortString;
                                           Const NewValue : ShortString) : Integer;
Var
  Res : Integer;
Begin // UpdateFieldValue
  // Reread value from DB to check for changes by another user
  Res := FSystemSetupFile.GetEqual(FSystemSetupFile.BuildIDKey(Ord(FieldIdx)));
  If (Res = 0) Then
  Begin
    If (FSystemSetupFile.SystemSetup.sysValue = OriginalValue) Then
    Begin
      // Note: Need to use the With construct as the Setter is on the object not the field
      With FSystemSetupFile.SystemSetup Do
        sysValue := NewValue;
      Res := FSystemSetupFile.Update;
      If (Res = 0) Then
        Result := 0
      Else
        Result := 1000 + Res;
    End // If (FSystemSetupFile.SystemSetup.sysValue = OriginalValue)
    Else
      // Error - someone else has changed the value
      Result := 2;
  End // If (Res = 0)
  Else
    // Error - cannot find
    Result := 1;
End; // UpdateFieldValue

//=========================================================================

Procedure TSystemSetupSQL.LoadSettings;
Var
  FID : TIntegerField;
  FValue : TStringField;
  sCompanyCode : ANSIString;
Begin // LoadSettings
  With TSQLCaller.Create(GlobalADOConnection) Do
  Begin
    Try
      //SS:10/10/2017:ABSEXCH-19378:Importer: When Running the Job: It gives error related to Invalid User Name or Password.
      {$IFDEF IMPV6}
        sCompanyCode := GetCompanyCode(VAOInfo.vaoSubCompanyDir);
      {$ELSE}
        sCompanyCode := GetCompanyCode(SetDrive);
      {$ENDIF}
	  
	  // PL 19/12/2017 2018R1 : ABSEXCH-19566 Local Drive Workstation Setup gives Access violation and run time error.
      if sCompanyCode = '' then
        Exit;

        Select('SELECT sysId, sysValue FROM [COMPANY].SystemSetup', sCompanyCode);
        If (ErrorMsg = '') And (Records.RecordCount > 0) Then
        Begin
          Records.First;

          // Use typecast references to the fields to avoid variant performance hits
          FID := Records.FieldByName('sysId') As TIntegerField;
          FValue := Records.FieldByName('sysValue') As TStringField;

          While (Not Records.EOF) Do
          Begin
            ApplySetting (FId.Value, FValue.Value);
            Records.Next;
          End; // While (Not Records.EOF)
        End; // If (ErrorMsg = '') And (Records.RecordCount > 0)
    Finally
      Free;
    End; // Try..Finally
  End; // With TSQLCaller.Create(GlobalADOConnection)
End; // LoadSettings

//-------------------------------------------------------------------------

// Updates the specified Field Value
//
//    0   AOK
//    1   Field Value not found
//    2   Field Value already changed by another user
// 1000+  Error updating Field Value
//
Function TSystemSetupSQL.UpdateFieldValue(Const FieldIdx : TSystemSetupFieldIds;
                                          Const OriginalValue : ShortString;
                                          Const NewValue : ShortString) : Integer;
Var
  sSQL, sCompanyCode : ANSIString;
  iStatus : Integer;
Begin // UpdateFieldValue
  With TSQLCaller.Create(GlobalADOConnection) Do
  Begin
    Try
      sCompanyCode := GetCompanyCode(SetDrive);

      // Update the value property for the specified ID only if it is still the same as the original value
      sSQL := 'UPDATE [COMPANY].SystemSetup ' +
                 'SET sysValue=' + QuotedStr(NewValue) + ' ' +
               'WHERE SysId=' + IntToStr(Ord(FieldIdx)) + ' ' +
                 'AND sysValue=' + QuotedStr(OriginalValue);

      // iStatus: 0=success, -1=failure
      iStatus := ExecSQL(sSQL, sCompanyCode);
      If (iStatus = 0) Then
      Begin
        If (LastRecordCount = 1) Then
          // AOK
          Result := 0
        Else
          Result := 2;
      End // If (iStatus = 0)
      Else
        // Unknown SQL Error
        Result := 1000 + iStatus;
    Finally
      Free;
    End; // Try..Finally
  End; // With TSQLCaller.Create(GlobalADOConnection)
End; // UpdateFieldValue

//=========================================================================

Function FontStyleToInternal (Const FontStyle : TFontStyles) : Integer;
Begin // FontStyleToInternal
  Result := 0;

  If (fsBold In FontStyle) Then
    Result := Result + 1;
  If (fsUnderline In FontStyle) Then
    Result := Result + 2;
  If (fsItalic In FontStyle) Then
    Result := Result + 4;
  If (fsStrikeOut In FontStyle) Then
    Result := Result + 8;
End; // FontStyleToInternal

//=========================================================================

{ TSystemSetupIntrastat }

constructor TSystemSetupIntrastat.Create(
  const SettingsPtr: pSystemSetupInternalSettingsRecType);
begin
  Inherited Create;
  FSettings := SettingsPtr;
end;

destructor TSystemSetupIntrastat.Destroy;
begin
  FSettings := nil;
  inherited;
end;

function TSystemSetupIntrastat.GetLastClosedArrivalsDate: String;
begin
  Result := FSettings.isLastClosedArrivalsDate;
end;

function TSystemSetupIntrastat.GetLastClosedDispatchesDate: String;
begin
  Result := FSettings.isLastClosedDispatchesDate;
end;

function TSystemSetupIntrastat.GetLastReportFromDate: String;
begin
  Result := FSettings.isLastReportFromDate;
end;

function TSystemSetupIntrastat.GetLastReportMode: Integer;
begin
  Result := FSettings.isLastReportMode;
end;

function TSystemSetupIntrastat.GetLastReportPeriodYear: String;
begin
  Result := FSettings.isLastReportPeriodYear;
end;

function TSystemSetupIntrastat.GetLastReportToDate: String;
begin
  Result := FSettings.isLastReportToDate;
end;

function TSystemSetupIntrastat.GetShowDeliveryTerms: Boolean;
begin
  Result := FSettings.isShowDeliveryTerms;
end;

function TSystemSetupIntrastat.GetShowModeOfTransport: Boolean;
begin
  Result := FSettings.isShowModeOfTransport;
end;

//=========================================================================

{ TSystemSetupMultiRegionTax }

constructor TSystemSetupMultiRegionTax.Create(
  const SettingsPtr: pSystemSetupInternalSettingsRecType);
begin
  Inherited Create;
  FSettings := SettingsPtr;
end;

//-------------------------------------------------------------------------

destructor TSystemSetupMultiRegionTax.Destroy;
begin
  FSettings := nil;
  inherited;
end;

//-------------------------------------------------------------------------

function TSystemSetupMultiRegionTax.GetHomeRegion: Integer;
begin
  Result := FSettings.isTaxHomeRegion;
end;


//SS:25/05/2017 2017-R2:ABSEXCH-18573:Add Currency Tolerance Editable field under system set-up.
function TSystemSetup.GetCurrencySetup: ISystemSetupImportTolCurrency;
Begin // GetCurrencySetup
  If (Not Assigned(FCurrencySetupObj)) Then
  Begin
    FCurrencySetupObj := TSystemSetupImportTolCurrency.Create(@FSystemSettingsRec);
    // Take a local reference to prevent the object self-destructing when the returned reference is NIL'd
    FCurrencySetupIntf := FCurrencySetupObj;
  End; // If (Not Assigned(FCurrencySetupObj))

  Result := FCurrencySetupIntf;
End; // GetCurrencySetup


//TG 28-06-2017 2017 R2: ABSEXCH- 18840 User Authentication Configuration - Database Changes (2.5)
function TSystemSetup.GetPasswordAuthentication : ISystemSetupPasswordAuthentication;
begin  //GetPasswordAuthentication
  if (not Assigned(FPasswordAuthenticationObj)) then
  Begin
    FPasswordAuthenticationObj := TSystemSetupPasswordAuthentication.Create(@FSystemSettingsRec);
    // Take a local reference to prevent the object self-destructing when the returned reference is NIL'd
    FPasswordAuthenticationIntf := FPasswordAuthenticationObj;
  End; // If (Not Assigned(FPasswordAuthenticationObj))

  Result := FPasswordAuthenticationIntf;
End;

constructor TSystemSetupPasswordAuthentication.Create(
  const SettingsPtr: pSystemSetupInternalSettingsRecType);
begin
  Inherited Create;
  FSettings := SettingsPtr;

end;

destructor TSystemSetupPasswordAuthentication.Destroy;
begin
  FSettings := nil;
  inherited;
end;

function TSystemSetupPasswordAuthentication.GetAuthenticationMode: string;
begin
  Result := FSettings.isAuthenticationMode;
end;

function TSystemSetupPasswordAuthentication.GetMinimumPasswordLength: Integer;
begin
  Result := FSettings.isMinimumPasswordLength;
end;

function TSystemSetupPasswordAuthentication.GetRequireUppercase: Boolean;
begin
  Result := FSettings.isRequireUppercase;
end;

function TSystemSetupPasswordAuthentication.GetRequireLowercase: Boolean;
begin
  Result := FSettings.isRequireLowercase;
end;

function TSystemSetupPasswordAuthentication.GetRequireNumeric: Boolean;
begin
  Result := FSettings.isRequireNumeric;
end;

function TSystemSetupPasswordAuthentication.GetRequireSymbol: Boolean;
begin
  Result := FSettings.isRequireSymbol;
end;

function TSystemSetupPasswordAuthentication.GetSuspendUsersAfterLoginFailures: Boolean;
begin
  Result := FSettings.isSuspendUsersAfterLoginFailures;
end;

function TSystemSetupPasswordAuthentication.GetSuspendUsersLoginFailureCount: Integer;
begin
  Result := FSettings.isSuspendUsersLoginFailureCount;
end;

//------------------------------------------------------------------------------
{ TSystemSetupGDPR }
//------------------------------------------------------------------------------

constructor TSystemSetupGDPR.Create(const ASettingsPtr: pSystemSetupInternalSettingsRecType);
begin
  inherited Create;
  FSettings := ASettingsPtr;
end;

//------------------------------------------------------------------------------

destructor TSystemSetupGDPR.Destroy;
begin
  FSettings := nil;  
  inherited;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetAnonymised: Boolean;
begin
  Result := FSettings.isAnonymised;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetAnonymisedDate: String;
begin
  Result := FSettings.isAnonymisedDate;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetAnonymisedTime: String;
begin
  Result := FSettings.isAnonymisedTime;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPRCompanyAnonCostCentres: Boolean;
begin
  Result := FSettings.isGDPRCompanyAnonCostCentres;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPRCompanyAnonDepartment: Boolean;
begin
  Result := FSettings.isGDPRCompanyAnonDepartment;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPRCompanyAnonLocations: Boolean;
begin
  Result := FSettings.isGDPRCompanyAnonLocations;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPRCompanyLettersOption: Integer;
begin
  Result := FSettings.isGDPRCompanyLettersOption;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPRCompanyLinksOption: Integer;
begin
  Result := FSettings.isGDPRCompanyLinksOption;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPRCompanyNotesOption: Integer;
begin
  Result := FSettings.isGDPRCompanyNotesOption;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPREmployeeAnonLettersOption: Integer;
begin
  Result := FSettings.isGDPREmployeeAnonLettersOption;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPREmployeeAnonLinksOption: Integer;
begin
  Result := FSettings.isGDPREmployeeAnonLinksOption;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPREmployeeAnonNotesOption: Integer;
begin
  Result := FSettings.isGDPREmployeeAnonNotesOption;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPREmployeeDisplayPIITree: Boolean;
begin
  Result := FSettings.isGDPREmployeeDisplayPIITree;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPREmployeeRetentionPeriod: Integer;
begin
  Result := FSettings.isGDPREmployeeRetentionPeriod;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPRTraderAnonLettersOption: Integer;
begin
  Result := FSettings.isGDPRTraderAnonLettersOption;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPRTraderAnonLinksOption: Integer;
begin
  Result := FSettings.isGDPRTraderAnonLinksOption;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPRTraderAnonNotesOption: Integer;
begin
  Result := FSettings.isGDPRTraderAnonNotesOption;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPRTraderDisplayPIITree: Boolean;
begin
  Result := FSettings.isGDPRTraderDisplayPIITree;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetGDPRTraderRetentionPeriod: Integer;
begin
  Result := FSettings.isGDPRTraderRetentionPeriod;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetNotificationWarningColour: Integer;
begin
  Result := FSettings.isNotificationWarningColour;
end;

//------------------------------------------------------------------------------

function TSystemSetupGDPR.GetNotificationWarningFontColour: Integer;
begin
  Result := FSettings.isNotificationWarningFontColour;
end;

//------------------------------------------------------------------------------

function TSystemSetup.GetGDPR: ISystemSetupGDPR;
begin
  if not Assigned(FGDPRObj) then
  begin
    FGDPRObj := TSystemSetupGDPR.Create(@FSystemSettingsRec);
    // Take a local reference to prevent the object self-destructing when the returned reference is NIL'd
    FGDPRIntf := FGDPRObj;
  end;
  Result := FGDPRIntf;
end;

//------------------------------------------------------------------------------

Initialization
  OpenCompanyPath := #255;
  SystemSetupIntf := NIL;
Finalization
  SystemSetupIntf := NIL;
  
End.

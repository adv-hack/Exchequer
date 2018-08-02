Unit AuditIntf;

Interface

Uses SysUtils, classes;

Const
  AuditFileExtension = '.EAF';
  LiveAuditFilename = 'LIVE.EAF';

Type
  //CA 11/02/2013 v7.0.2 : ABSEXCH-14003 : Added New Audit Files - atCISSetup, atCIS340Setup, atNCCSetup, atNCCJobSetup
  //CA 14/02/2013 v7.0.2 : ABSEXCH-14003 : Added New Audit Files - atSysVAT, atCurrencySetup, atSysSet
  //RB 24/11/2017 2018-R1 ABSEXCH-19467: GDPR Configuration window - Auditing
  //HV 02/02/2018 2017R1 ABSEXCH-19685: Auditing after successfully Anonymising entity (atAnonymisation)
  TAuditType = (atMissingLog, atArchive, atTrader, atCISSetup, atCIS340Setup, atNCCSetup, atNCCJobSetup,
                atSysVAT, atCurrencySetup, atSysSetup, atEDIRSysSetup, atSystemSetupTable, atIntrastatSettings, atLogin,
                atGDPRConfig, atAnonymisation);


  //------------------------------

  // Generic interface for objects which implement a specific import type
  IAuditSystemInformation = Interface
    ['{C4776AAB-00FF-4605-8F55-DFB3D7BFBCED}']
    // --- Internal Methods to implement Public Properties ---
    Function GetApplicationDescription : ShortString;
    Procedure SetApplicationDescription (Value : ShortString);
    Function GetApplicationVersion : ShortString;
    Procedure SetApplicationVersion (Value : ShortString);
    Function GetExchequerUser : ShortString;
    Procedure SetExchequerUser (Value : ShortString);
    Function GetCompanyDirectory : ShortString;
    Procedure SetCompanyDirectory (Value : ShortString);
    Function GetCompanyName : ShortString;
    Procedure SetCompanyName (Value : ShortString);

    // ------------------ Public Properties ------------------
    Property asApplicationDescription : ShortString Read GetApplicationDescription Write SetApplicationDescription;
    Property asApplicationVersion : ShortString Read GetApplicationVersion Write SetApplicationVersion;
    Property asExchequerUser : ShortString Read GetExchequerUser Write SetExchequerUser;
    Property asCompanyDirectory : ShortString Read GetCompanyDirectory Write SetCompanyDirectory;
    Property asCompanyName : ShortString Read GetCompanyName Write SetCompanyName;

    // ------------------- Public Methods --------------------

  End; // IAuditSystemInformation

  //------------------------------

  // Generic interface for objects which implement a specific import type
  IBaseAudit = Interface
    ['{0761E185-6DE1-4932-9237-147A123A4219}']
    // --- Internal Methods to implement Public Properties ---
    Function GetBeforeData : Pointer;
    Procedure SetBeforeData (Value : Pointer);
    Function GetAfterData : Pointer;
    Procedure SetAfterData (Value : Pointer);

    // ------------------ Public Properties ------------------
    Property BeforeData : Pointer Read GetBeforeData Write SetBeforeData;
    Property AfterData : Pointer Read GetAfterData Write SetAfterData;

    // ------------------- Public Methods --------------------
    Function WriteAuditEntry : LongInt;
  End; // IBaseAudit

// Singleton to store application information required by the Audit subsystem
Function AuditSystemInformation : IAuditSystemInformation;

// Returns a generic IBaseAudit interface for the specified audit type
//RB 25/09/2017 2017-R2 ABSEXCH-18984: 3.1 Exchequer Login Screen - Auditing
//Pass string to be audited(aDefaultValue) when there is no need of using record structure.
Function NewAuditInterface (Const AuditType : TAuditType; Const aDefaultValue: String = '') : IBaseAudit; overload;

//Function NewLoginAuditInterface (Const AuditType : TAuditType) : IBaseAuditLogin;

//HV 02/02/2018 2017R1 ABSEXCH-19685: Auditing after successfully Anonymising entity
Function NewAuditInterface(const AuditType : TAuditType; const ADefaultList: TStringList): IBaseAudit; overload;

// Returns the directory that the audit files are stored in
Function AuditDirectory : ShortString;

// Returns the path of the live audit file
Function LiveAuditFilePath : ShortString;

Implementation

Uses AuditTrader, AuditMissing, GlobVar, AuditArchive
    ,AuditCurrencySetup// CA 14/02/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for Currency Setup
     {$IFNDEF EXDLL}  // MH 13/02/2013 v7.0.2: Added IFDEF as this stopped CalcPrce from building
     {$IFNDEF COMPRICE}  // MH 13/02/2013 v7.0.2: Added IFDEF as this stopped CalcPrce from building
     {$IFNDEF SQLHELPER} // MH 12/02/2013 v7.0.2: Added IFDEF as this stopped SQLHelper from building
     {$IFNDEF OLE}  // MH 12/02/2013 v7.0.2: Added IFDEF as this stopped the OLE Server from building
     {$IFNDEF SENT}
     {$IFNDEF EBUS}
     {$IFNDEF SCHEDULER}
     {$IFNDEF OLEDATAQUERY}
       ,AuditEDI2RSetup   // CA 01/03/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for Email General Settings
       ,AuditSysSet       // CA 25/02/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for System Setup
       ,AuditNCCSetup     // CA 12/02/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for NCC Setup
       ,AuditNCCJobSetup  // CA 12/02/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for NCC Job Setup
       ,AuditCISSetup     // CA 11/02/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for CIS Setup
       ,AuditCIS340Setup  // CA 11/02/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for CIS Setup Part 2
       ,AuditSysVat       // CA 14/02/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for VAT Setup
     {$ENDIF}
     {$ENDIF}
     {$ENDIF}
     {$ENDIF}
     {$ENDIF}
     {$ENDIF}
     {$ENDIF}
     {$ENDIF}
     , AuditSystemSetupTable
     , AuditLogin
     , AuditAnonymisation 
     ;

Type
  TAuditSystemInformation = Class(TInterfacedObject, IAuditSystemInformation)
  Private
    FApplicationDescription : ShortString;
    FApplicationVersion : ShortString;
    FExchequerUser : ShortString;
    FCompanyDirectory : ShortString;
    FCompanyName : ShortString;

    Function GetApplicationDescription : ShortString;
    Procedure SetApplicationDescription (Value : ShortString);
    Function GetApplicationVersion : ShortString;
    Procedure SetApplicationVersion (Value : ShortString);
    Function GetExchequerUser : ShortString;
    Procedure SetExchequerUser (Value : ShortString);
    Function GetCompanyDirectory : ShortString;
    Procedure SetCompanyDirectory (Value : ShortString);
    Function GetCompanyName : ShortString;
    Procedure SetCompanyName (Value : ShortString);
  Public
    Constructor Create;
  End; // TAuditSystemInformation

Var
  iAuditSystemInfo : IAuditSystemInformation;

//=========================================================================

// Singleton to store application information required by the Audit subsystem
Function AuditSystemInformation : IAuditSystemInformation;
Begin // AuditSystemInformation
  If Not Assigned(iAuditSystemInfo) Then
    iAuditSystemInfo := TAuditSystemInformation.Create;
  Result := iAuditSystemInfo;
End; // AuditSystemInformation

//=========================================================================

Constructor TAuditSystemInformation.Create;
Begin // Create
  Inherited Create;

  FApplicationDescription := '';
  FApplicationVersion := '';
  FExchequerUser := '';
  FCompanyDirectory := '';
  FCompanyName := '';
End; // Create

//-------------------------------------------------------------------------

Function TAuditSystemInformation.GetApplicationDescription : ShortString;
Begin // GetApplicationDescription
  Result := FApplicationDescription;
End; // GetApplicationDescription

Procedure TAuditSystemInformation.SetApplicationDescription (Value : ShortString);
Begin // SetApplicationDescription
  FApplicationDescription := Value;
End; // SetApplicationDescription

//------------------------------

Function TAuditSystemInformation.GetApplicationVersion : ShortString;
Begin // GetApplicationVersion
  Result := FApplicationVersion;
End; // GetApplicationVersion

Procedure TAuditSystemInformation.SetApplicationVersion (Value : ShortString);
Begin // SetApplicationVersion
  FApplicationVersion := Value;
End; // SetApplicationVersion

//------------------------------

Function TAuditSystemInformation.GetExchequerUser : ShortString;
Begin // GetExchequerUser
  Result := FExchequerUser;
End; // GetExchequerUser

Procedure TAuditSystemInformation.SetExchequerUser (Value : ShortString);
Begin // SetExchequerUser
  FExchequerUser := Value;
End; // SetExchequerUser

//------------------------------

Function TAuditSystemInformation.GetCompanyDirectory : ShortString;
Begin // GetCompanyDirectory
  Result := FCompanyDirectory;
End; // GetCompanyDirectory

Procedure TAuditSystemInformation.SetCompanyDirectory (Value : ShortString);
Begin // SetCompanyDirectory
  FCompanyDirectory := IncludeTrailingPathDelimiter(Value);
End; // SetCompanyDirectory

//------------------------------

Function TAuditSystemInformation.GetCompanyName : ShortString;
Begin // GetCompanyName
  Result := FCompanyName;
End; // GetCompanyName

Procedure TAuditSystemInformation.SetCompanyName (Value : ShortString);
Begin // SetCompanyName
  FCompanyName := Value;
End; // SetCompanyName

//=========================================================================

// Returns a generic IBaseAudit interface for the specified audit type
Function NewAuditInterface (Const AuditType : TAuditType; Const aDefaultValue: String ='') : IBaseAudit;
Begin // NewAuditInterface
  Case AuditType Of
    atMissingLog   : Result := TMissingAudit.Create;

    atArchive      : Result := TAuditArchive.Create;

    atTrader       : Result := TTraderAudit.Create;

    { CJS 2013-03-05 - ABSEXCH-14003 - Currency Audit }
    atCurrencySetup : Result := TCurrencySetupAudit.Create;   // CA 15/02/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for VAT Setup

    {$IFNDEF EXDLL}  // MH 13/02/2013 v7.0.2: Added IFDEF as this stopped Toolkit DLL from building
    {$IFNDEF COMPRICE}  // MH 13/02/2013 v7.0.2: Added IFDEF as this stopped CalcPrce from building
    {$IFNDEF SQLHELPER}  // MH 12/02/2013 v7.0.2: Added IFDEF as this stopped SQLHelper from building
    {$IFNDEF OLE}  // MH 12/02/2013 v7.0.2: Added IFDEF as this stopped the OLE Server from building
    {$IFNDEF SENT}
    {$IFNDEF EBUS}
    {$IFNDEF SCHEDULER}
    {$IFNDEF OLEDATAQUERY}
    atCISSetup     : Result := TCISSetupAudit.Create;     // CA 11/02/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for CIS Setup

    atCIS340Setup  : Result := TCIS340SetupAudit.Create;  // CA 11/02/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for CIS Setup Part Two

    atNCCSetup     : Result := TNCCSetupAudit.Create;     // CA 12/02/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for NCC Setup

    atNCCJobSetup  : Result := TNCCJobSetupAudit.Create;  // CA 12/02/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for NCC Job Setup

    atSysVAT       : Result := TSysVatAudit.Create;       // CA 14/02/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for VAT Setup

    atSysSetup      : Result := TSysSetAudit.Create;          // CA 25/02/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for VAT Setup

    atEDIRSysSetup  : Result := TEDIRSetupAudit.Create;       // CA 01/03/2013 v7.0.2 : ABSEXCH-14003 : Added New AuditFile for VAT Setup
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}

    // MH 06/05/2015 v7.0.14 ABSEXCH-16284: Added new 'Settlement Write-Off' Control Code for PPD
    atSystemSetupTable : Result := TSystemSetupTableAudit.Create(atSystemSetupTable);

    // CJS 2016-03-02 - ABSEXCH-17345 - Audit for closing Intrastat Period
    atIntrastatSettings: Result := TSystemSetupTableAudit.Create(atIntrastatSettings);

    //RB 24/11/2017 2018-R1 ABSEXCH-19467: GDPR Configuration window - Auditing
    atGDPRConfig: Result := TSystemSetupTableAudit.Create(atGDPRConfig);

    //RB 25/09/2017 2017-R2 ABSEXCH-18984: 3.1 Exchequer Login Screen - Auditing
    atLogin : Result := TLoginAudit.Create(aDefaultValue);
  Else
    Raise Exception.Create ('NewAuditInterface: Unknown Audit Type (' + IntToStr(Ord(AuditType)) + ')');
  End; // Case AuditType
End; // NewAuditInterface

//-------------------------------------------------------------------------

function NewAuditInterface (const AuditType: TAuditType; const ADefaultList: TStringList): IBaseAudit;
begin
  case AuditType of
    atAnonymisation : Result := TAuditAnonymisation.Create(aDefaultList);
  end;
end;

//-------------------------------------------------------------------------

// Returns the directory that the audit files are stored in
Function AuditDirectory : ShortString;
Begin // AuditDirectory
  Result := AuditSystemInformation.asCompanyDirectory + 'Audit\';
End; // AuditDirectory

//-------------------------------------------------------------------------

// Returns the path of the live audit file
Function LiveAuditFilePath : ShortString;
Begin // LiveAuditFilePath
  Result := AuditDirectory + LiveAuditFilename;
End; // LiveAuditFilePath

//=========================================================================

Initialization
  iAuditSystemInfo := NIL;
Finalization
  iAuditSystemInfo := NIL;
End.

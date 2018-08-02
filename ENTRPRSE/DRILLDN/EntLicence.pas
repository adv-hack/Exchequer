unit EntLicence;

interface

Uses Classes, IniFiles, Registry, SysUtils, Windows,
     //Enterprise_TLB,   // Drill-Down COM Object Type Library
     LicRec;           // Exchequer Licence Structures

Type
  // NOTE: All Enumerations map directly onto the licencing constants in LicRec.Pas

  // Enumerated type to report the currency version of the Exchequer Installation
  TelCurrencyVersion = (cvPro=0, cvEuro=1, cvGlobal=2);

  // Enumerated type for accessing the module licencing
  TelEntModuleEnum = (modAccStk      = 1,             { Account Stock Analysis }
                      modImpMod      = 2,             { Import Module }
                      modJobCost     = 3,             { Job Costing }
                      modODBC        = 4,             { ODBC }
                      modRepWrt      = 5,             { Report Writer }
                      modTeleSale    = 6,             { Telesales }
                      modToolDLL     = 7,             { Toolkit DLL (Developer) }
                      modToolDLLR    = 8,             { Toolkit DLL (Runtime) }
                      modEBus        = 9,             { eBusiness }
                      modPaperless   = 10,            { Paperless Module }
                      modOLESave     = 11,            { OLE Save Functions }
                      modCommit      = 12,            { Commitment Accounting }
                      modTrade       = 13,            { Trade Counter }
                      modStdWOP      = 14,            { Standard Works Order Processing }
                      modProWOP      = 15,            { Professional Works Order Processing }
                      modElerts      = 16,            { Sentimail Module }
                      modEnhSec      = 17,            { Enhanced Security }
                      modCISRCT      = 18,            { Job Costing CIS / RCT }
                      modAppVal      = 19,            { Job Costing Applications & Valuations }
                      modFullStock   = 20,            { v5.61 - Full Stock (Description Only id net present) }
                      modVisualRW    = 21,            { v5.61 - Visual Report Writer }
                      modGoodsRet    = 22,            { v5.70 - Goods Returns }
                      modEBanking    = 23,            { v5.71 - E-Banking }
                      modOutlookDD   = 24,            { v5.71 - Outlook Dynamic Dashboard }
                      // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
                      modGDPR        = 25,            { 2018-R1 - GDPR }
                      modPervEncrypt = 26             { 2018-R1 - Pervasive File Encryption }
                      );

  // MH 03/04/2013 v7.0.3 ABSEXCH-14169
  TelEntUserCountsEnum = (mucCompanies    = LicRec.ucCompanies,       { Company Count for MCM }
                          mucToolkit30    = LicRec.ucToolkit30,       { Toolkit DLL - 30-day User Count }
                          mucToolkitFull  = LicRec.ucToolkitFull,     { Toolkit DLL - Full User Count }
                          mucTradeCounter = LicRec.ucTradeCounter,    { Trade Counter User Count }
                          mucElerts       = LicRec.ucElerts);         { Available Elerts }

  // Enumerated Type for Module Release status
  TelModuleReleaseStatus = (mrNone=0, mr30Day=1, mrFull=2);

  // Enumerated Type for the Exchequer Module Version
  TelModuleVersion = (mvBase=0, mvStock=1, mvSPOP=2);

  // Enumerated Type for the Licence Type
  TelLicenceType = (ltCustomer=0, ltResellerDemo=1, ltStandardDemo=2);

  // Enumeration for Product Type
  TelProductType = (ptExchequer=0, ptLITECust=1, ptLITEAcct=2);

  // Enumerated type for the P.SQL Workgroup Engine Licencing
  TelWorkgroupLicenceType = (wgeNotLicenced=0, wgeVersion8=1);

  // Enumeration for the v6.00 Database Type
  TelDatabaseType = (dbBtrieve=0, dbMSSQL=1);

  // MH 20/11/2012 v7.0 ABSEXCH-13735: Extended to support Small Business Edition
  TelExchequerEdition = (exStandard=0, exSmallBusiness=1);

  //------------------------------

  TEnterpriseLicence = Class(TObject)
  Private
    FLicence  : EntLicenceRecType;

    Procedure LoadLicencing;
    Procedure LoadLicencingFromDir (Const LicenceDir : ShortString);

    function GetCDKey : ShortString;
    function GetCurrencyVersion: TelCurrencyVersion;
    function GetFullESN : ShortString;
    function GetModules(Index: TelEntModuleEnum): TelModuleReleaseStatus;
    function GetModuleVersion: TelModuleVersion;
    function GetLicencee : ShortString;
    function GetLicenceType : TelLicenceType;
    function GetIsMultiCcy: Boolean;
    Function GetProductType : TelProductType;
    Function GetWorkgroupLicence : TelWorkgroupLicenceType;
    Function GetVersionDesc (Index : Integer) : ShortString;
    Function GetDatabaseType : TelDatabaseType;
    Function GetExchequerEdition : TelExchequerEdition;
    Function GetExchequerVersionDescription : ShortString;
    Function GetUserCounts (Index: TelEntUserCountsEnum): Integer;
  Public
    Constructor Create (Const LicenceDir : ShortString);

    Function IsClientServer : Boolean;
    Function IsLITE : Boolean;
    function IsSQL: Boolean;

    Property elCDKey : ShortString Read GetCDKey;
    Property elCurrencyVersion : TelCurrencyVersion Read GetCurrencyVersion;
    Property elFullESN : ShortString Read GetFullESN;
    Property elLicencee : ShortString Read GetLicencee;
    Property elLicence : EntLicenceRecType Read FLicence;
    Property elLicenceType : TelLicenceType Read GetLicenceType;
    Property elModules [Index : TelEntModuleEnum] : TelModuleReleaseStatus Read GetModules;
    Property elModuleVersion : TelModuleVersion Read GetModuleVersion;
    Property elIsMultiCcy : Boolean Read GetIsMultiCcy;
    Property elProductType : TelProductType Read GetProductType;
    Property elShortVersionDesc : ShortString Index 0 Read GetVersionDesc;
    Property elLongVersionDesc : ShortString Index 1 Read GetVersionDesc;
    Property elWorkgroupLicence : TelWorkgroupLicenceType Read GetWorkgroupLicence;
    Property elDatabaseType : TelDatabaseType Read GetDatabaseType;

    // MH 20/11/2012 v7.0 ABSEXCH-13735: Extended to support Small Business Edition
    Property elExchequerEdition : TelExchequerEdition Read GetExchequerEdition;

    // MH 03/04/2013 v7.0.3 ABSEXCH-14169
    Property elExchequerVersionDescription : ShortString Read GetExchequerVersionDescription;
    Property elUserCounts [Index : TelEntUserCountsEnum] : Integer Read GetUserCounts;
  End; { TEnterpriseLicence }


// Access function for a global EnterpriseLicence object which is
// automatically created by the routine the first time it is called.
Function EnterpriseLicence : TEnterpriseLicence;

// Creates and returns a new TEnterpriseLicence instance containing the licence
// from the specified directory
Function EnterpriseLicenceFromDir (Const LicenceDir : ShortString) : TEnterpriseLicence;

implementation

Uses EntLic,      // Exchequer Licence Read/Write functions
     {$IF Defined(COMP) Or Defined(RW_GUI)}
     VarFPosU,
     {$IFEND}
     VAOUtil,
     LicFuncU;    // Misc Licence related functions

Var
  oEntLicence : TEnterpriseLicence;

//=========================================================================

Function EnterpriseLicence : TEnterpriseLicence;
Begin { EnterpriseLicence }
  If (Not Assigned(oEntLicence)) Then
    oEntLicence := TEnterpriseLicence.Create('');

  Result := oEntLicence;
End; { EnterpriseLicence }

//=========================================================================

// Creates and returns a new TEnterpriseLicence instance containing the licence
// from the specified directory
Function EnterpriseLicenceFromDir (Const LicenceDir : ShortString) : TEnterpriseLicence;
Begin { EnterpriseLicence }
  Result := TEnterpriseLicence.Create(LicenceDir);
End; { EnterpriseLicence }

//=========================================================================

Constructor TEnterpriseLicence.Create (Const LicenceDir : ShortString);
Begin { Create }
  Inherited Create;

  If (LicenceDir = '') Then
    LoadLicencing
  Else
    LoadLicencingFromDir (LicenceDir);
End; { Create }

//-------------------------------------------------------------------------

Procedure TEnterpriseLicence.LoadLicencingFromDir (Const LicenceDir : ShortString);
Begin // LoadLicencingFromDir
  If Not ReadEntLic (LicenceDir + EntLicFName, FLicence) Then
    Raise Exception.Create ('Unable to read Licence Information');
End; // LoadLicencingFromDir

//-------------------------------------------------------------------------

Procedure TEnterpriseLicence.LoadLicencing;
Var
  {$IF Defined(COMP) Or Defined(RW_GUI)}
  TempPath : ShortString;
  {$IFEND}
  SvrPath  : ShortString;
Begin { LoadLicencing }
  // Initialise all licences to OFF
  //FCurrencyVersion := cvPro;
  FillChar (FLicence, SizeOf(FLicence), #0);

  // HM 11/08/04: Get path of main company directory to pickup the licencing dets
  SvrPath := VAOInfo.vaoCompanyDir;

(*** HM 11/08/04: Replaced as Registry lookup unsafe in VAO Mode
  // Identify directory containing Exchequer by looking up the Exchequer COM
  // Customisation in the Registry - makes this routine fairly generic
  With TRegistry.Create Do
    Try
      Access := KEY_READ;
      RootKey := HKEY_CLASSES_ROOT;

      SvrPath := '';
      If KeyExists ('Clsid\{95BEDB65-A8B0-11D3-A990-0080C87D89BD}\LocalServer32') Then
        If OpenKey('Clsid\{95BEDB65-A8B0-11D3-A990-0080C87D89BD}\LocalServer32', False) Then
          SvrPath := ReadString ('');

      CloseKey;
    Finally
      Free;
    End;
***)

//  If (SvrPath <> '') And FileExists (SvrPath) Then
  If (SvrPath <> '') And DirectoryExists (SvrPath) Then
    If FileExists (ExtractFilePAth(SvrPath) + EntLicFName) Then
    Begin
      {$IF Defined(COMP) Or Defined(RW_GUI)}
        // HM 29/01/04: Changed to reset ExMainCoPath as it causes problems within
        // the MCM where it is set as the ReadEntLic function automatically inserts
        // it into the path for opening the Licence File
        // MH 05/04/05: Extended for EntRW.Exe so duplicate .pas can be deleted
        TempPath := ExMainCoPath^;
        ExMainCoPath^ := '';
      {$IFEND}

      If Not ReadEntLic (ExtractFilePAth(SvrPath) + EntLicFName, FLicence) Then
        Raise Exception.Create ('Unable to read Licence Information');

      {$IF Defined(COMP) Or Defined(RW_GUI)}
        ExMainCoPath^ := TempPath;
      {$IFEND}
    End; // If FileExists (ExtractFilePAth(SvrPath) + EntLicFName)
End; { LoadLicencing }

//-------------------------------------------------------------------------

function TEnterpriseLicence.GetModules(Index: TelEntModuleEnum) : TelModuleReleaseStatus;
begin
  Result := TelModuleReleaseStatus(FLicence.licModules[Ord(Index)]);
end;

//------------------------------

function TEnterpriseLicence.GetCDKey : ShortString;
begin
  Result := FLicence.licCDKey;
end;

//------------------------------

function TEnterpriseLicence.GetCurrencyVersion: TelCurrencyVersion;
begin
  Result := TelCurrencyVersion(FLicence.licEntCVer);
end;

//------------------------------

function TEnterpriseLicence.GetFullESN : ShortString;
Begin
  Result := licESN7Str (FLicence.licISN, FLicence.licLicType)
End;

//------------------------------

function TEnterpriseLicence.GetModuleVersion: TelModuleVersion;
begin
  Result := TelModuleVersion(FLicence.licEntModVer);
end;

//------------------------------

function TEnterpriseLicence.GetLicencee : ShortString;
begin
  Result := Trim(FLicence.licCompany);
end;

//------------------------------


function TEnterpriseLicence.GetLicenceType : TelLicenceType;
begin
  Result := TelLicenceType(FLicence.licLicType);
end;

//------------------------------

function TEnterpriseLicence.GetIsMultiCcy: Boolean;
begin
  Result := (TelCurrencyVersion(FLicence.licEntCVer) In [cvEuro, cvGlobal]);
end;

//------------------------------

Function TEnterpriseLicence.GetProductType : TelProductType;
Begin // GetProductType
  Result := TelProductType(FLicence.licProductType);
End; // GetProductType

//------------------------------

Function TEnterpriseLicence.GetWorkgroupLicence : TelWorkgroupLicenceType;
begin
  Result := TelWorkgroupLicenceType(FLicence.licPSQLWGEVer);
end;

//------------------------------

Function TEnterpriseLicence.GetVersionDesc (Index : Integer) : ShortString;
Var
  CDLicInfo : CDLicenceRecType;
Begin // GetVersionDesc
  licCopyLicence (CDLicInfo, FLicence, False);
  Result := licCDEntVersion (CDLicInfo, Index = 0);
End; // GetVersionDesc

//------------------------------

Function TEnterpriseLicence.GetDatabaseType : TelDatabaseType;
Begin // GetDatabaseType
  {$IFDEF LIC600}
    Result := TelDatabaseType(FLicence.licEntDB);
  {$ELSE}
    Result := dbBtrieve;
  {$ENDIF}
End; // GetDatabaseType

//------------------------------

Function TEnterpriseLicence.GetExchequerEdition : TelExchequerEdition;
Begin // GetExchequerEdition
  Result := TelExchequerEdition(Ord(FLicence.licExchequerEdition));
End; // GetExchequerEdition

//------------------------------

// MH 03/04/2013 v7.0.3 ABSEXCH-14169
Function TEnterpriseLicence.GetExchequerVersionDescription : ShortString;
Begin // GetExchequerVersionDescription
  // Currency version + Core Modules
  Result := licCurrVerToStr (FLicence.licEntCVer) + '/' + licEntModsToStr (FLicence.licEntModVer);

  // Add Client Server flag
  If (Result[Length(Result)] <> '/') Then Result := Result + '/';
  If (FLicence.licEntClSvr = 1) Then Result := Result + 'CS';

  // Add User Count
  If (Result[Length(Result)] <> '/') Then Result := Result + '/';
  Result := Result + IntToStr(FLicence.licUserCnt);
End; // GetExchequerVersionDescription

//------------------------------

// MH 03/04/2013 v7.0.3 ABSEXCH-14169
Function TEnterpriseLicence.GetUserCounts (Index: TelEntUserCountsEnum): Integer;
Begin // GetUserCounts
  Result := FLicence.licUserCounts[Ord(Index)];
End; // GetUserCounts

//-------------------------------------------------------------------------

Function TEnterpriseLicence.IsLITE : Boolean;
Begin // IsLITE
  Result := TelProductType(FLicence.licProductType) In [ptLITECust, ptLITEAcct];
End; // IsLITE

//-------------------------------------------------------------------------

function TEnterpriseLicence.IsSQL: Boolean;
begin
  Result := (GetDatabaseType = dbMSSQL);
end;

//-------------------------------------------------------------------------

Function TEnterpriseLicence.IsClientServer : Boolean;
Begin // IsClientServer
  Result := (FLicence.licEntClSvr = 1);
End; // IsClientServer

//-------------------------------------------------------------------------

Initialization
  oEntLicence := NIL;
Finalization
  FreeAndNIL(oEntLicence);
end.

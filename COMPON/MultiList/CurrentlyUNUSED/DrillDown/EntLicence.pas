unit EntLicence;

interface

Uses Classes, IniFiles, Registry, SysUtils, Windows,
     Enterprise_TLB,   // Drill-Down COM Object Type Library
     LicRec;           // Enterprise Licence Structures

Type
  // NOTE: All Enumerations map directly onto the licencing constants in LicRec.Pas

  // Enumerated type to report the currency version of the Enterprise Installation
  TelCurrencyVersion = (cvPro=0, cvEuro=1, cvGlobal=2);

  // Enumerated type for accessing the module licencing
  TelEntModuleEnum = (modAccStk    = 1,             { Account Stock Analysis }
                      modImpMod    = 2,             { Import Module }
                      modJobCost   = 3,             { Job Costing }
                      modODBC      = 4,             { ODBC }
                      modRepWrt    = 5,             { Report Writer }
                      modTeleSale  = 6,             { Telesales }
                      modToolDLL   = 7,             { Toolkit DLL (Developer) }
                      modToolDLLR  = 8,             { Toolkit DLL (Runtime) }
                      modEBus      = 9,             { eBusiness }
                      modPaperless = 10,            { Paperless Module }
                      modOLESave   = 11,            { OLE Save Functions }
                      modCommit    = 12,            { Commitment Accounting }
                      modTrade     = 13,            { Trade Counter }
                      modStdWOP    = 14,            { Standard Works Order Processing }
                      modProWOP    = 15,            { Professional Works Order Processing }
                      modElerts    = 16,            { Sentimail Module }
                      modEnhSec    = 17,            { Enhanced Security }
                      modCISRCT    = 18,            { Job Costing CIS / RCT }
                      modAppVal    = 19);           { Job Costing Applications & Valuations }

  // Enumerated Type for Module Release status
  TelModuleReleaseStatus = (mrNone=0, mr30Day=1, mrFull=2);

  // Enumerated Type for the Enterprise Module Version
  TelModuleVersion = (mvBase=0, mvStock=1, mvSPOP=2);

  //------------------------------

  TEnterpriseLicence = Class(TObject)
  Private
    FLicence  : EntLicenceRecType;

    Procedure LoadLicencing;
    function GetModules(Index: TelEntModuleEnum): TelModuleReleaseStatus;
    function GetCurrencyVersion: TelCurrencyVersion;
    function GetModuleVersion: TelModuleVersion;
    function GetIsMultiCcy: Boolean;
  Public
    Constructor Create;

    Property elCurrencyVersion : TelCurrencyVersion Read GetCurrencyVersion;
    Property elModules [Index : TelEntModuleEnum] : TelModuleReleaseStatus Read GetModules;
    Property elModuleVersion : TelModuleVersion Read GetModuleVersion;

    Property elIsMultiCcy : Boolean Read GetIsMultiCcy;
  End; { TFunctionList }


// Access function for a global EnterpriseLicence object which is
// automatically created by the routine the first time it is called.
Function EnterpriseLicence : TEnterpriseLicence;


implementation

Uses EntLic;      // Enterprise Licence Read/Write functions


Var
  oEntLicence : TEnterpriseLicence;

//=========================================================================

Function EnterpriseLicence : TEnterpriseLicence;
Begin { EnterpriseLicence }
  If (Not Assigned(oEntLicence)) Then
    oEntLicence := TEnterpriseLicence.Create;

  Result := oEntLicence;
End; { EnterpriseLicence }

//=========================================================================

Constructor TEnterpriseLicence.Create;
Begin { Create }
  Inherited Create;

  LoadLicencing;
End; { Create }

//-------------------------------------------------------------------------

Procedure TEnterpriseLicence.LoadLicencing;
Var
  SvrPath : ShortString;
Begin { LoadLicencing }
  // Initialise all licences to OFF
  //FCurrencyVersion := cvPro;
  FillChar (FLicence, SizeOf(FLicence), #0);

  // Identify directory containing Enterprise by looking up the Enterprise COM
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

  If (SvrPath <> '') And FileExists (SvrPath) Then
    If FileExists (ExtractFilePAth(SvrPath) + EntLicFName) Then
      If Not ReadEntLic (ExtractFilePAth(SvrPath) + EntLicFName, FLicence) Then
        Raise Exception.Create ('Unable to read Enterprise Licence Information');
End; { LoadLicencing }

//-------------------------------------------------------------------------

function TEnterpriseLicence.GetModules(Index: TelEntModuleEnum) : TelModuleReleaseStatus;
begin
  Result := TelModuleReleaseStatus(FLicence.licModules[Ord(Index)]);
end;

//------------------------------

function TEnterpriseLicence.GetCurrencyVersion: TelCurrencyVersion;
begin
  Result := TelCurrencyVersion(FLicence.licEntCVer);
end;

//------------------------------

function TEnterpriseLicence.GetModuleVersion: TelModuleVersion;
begin
  Result := TelModuleVersion(FLicence.licEntModVer);
end;

//------------------------------

function TEnterpriseLicence.GetIsMultiCcy: Boolean;
begin
  Result := (TelCurrencyVersion(FLicence.licEntCVer) In [cvEuro, cvGlobal]);
end;

//------------------------------

Initialization
  oEntLicence := NIL;
Finalization
  FreeAndNIL(oEntLicence);
end.

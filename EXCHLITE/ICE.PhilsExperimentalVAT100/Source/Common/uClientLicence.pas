unit uClientLicence;
{
  TClientLicence

  This class holds the basic licence details as imported from the Client site.
  It allows the import routines to determine what set-up the Client is running,
  and make any necessary adjustments to the imported/exported data, such as
  switching between single and multi currency.

  The information is read from the ICETRACK.INI file which is created when a
  bulk import is received from a client.

  This class is only relevant when running in a Practice install.
}

interface

uses
  SysUtils,

  // Enterprise units
  GlobVar,
  EntLicence,

  // ICE units
  uConsts;

type
  TClientLicence = class(TObject)
  private
    FModules: array[Low(TelEntModuleEnum)..High(TelEntModuleEnum)] of TelModuleReleaseStatus; { 0-No, 1-30-Day, 2-Full }
    FCurrencyVersion: TelCurrencyVersion;
    FModuleVersion: TelModuleVersion;
    FIsMultiCcy: Boolean;
    FProductType: TelProductType;
    procedure LoadLicencing;
    procedure EnableFile(FileName: string; Enable: Boolean);
    function GetCurrencyVersion: TelCurrencyVersion;
    function GetDescription: string;
    function GetModules(Index: TelEntModuleEnum): TelModuleReleaseStatus;
    function GetModuleVersion: TelModuleVersion;
    function GetIsMultiCcy: Boolean;
    function GetProductType : TelProductType;
  public
    constructor Create;
    property elCurrencyVersion: TelCurrencyVersion read GetCurrencyVersion;
    property elDescription: string read GetDescription;
    property elModules[Index: TelEntModuleEnum]: TelModuleReleaseStatus read GetModules;
    property elModuleVersion: TelModuleVersion read GetModuleVersion;
    property elIsMultiCcy: Boolean read GetIsMultiCcy;
    property elProductType: TelProductType read GetProductType;
  end;

implementation

uses
  StrUtils,
  uCrypto,
  Inifiles;

// ===========================================================================
// TClientLicence
// ===========================================================================

constructor TClientLicence.Create;
begin
  inherited Create;
  LoadLicencing;
end;

// ---------------------------------------------------------------------------

procedure TClientLicence.EnableFile(FileName: string; Enable: Boolean);
var
  Attributes: Word;
begin
  if FileExists(FileName) then
  begin
    Attributes := FileGetAttr(FileName);
    if Enable then
    begin
//      Attributes := Attributes and not faReadOnly;
      uCrypto.TCrypto.DecryptFile(FileName);
    end
    else
    begin
      uCrypto.TCrypto.EncryptFile(FileName);
//      Attributes := Attributes or faReadOnly;
    end;
    FileSetAttr(FileName, Attributes);
  end;
end;

// ---------------------------------------------------------------------------

function TClientLicence.GetCurrencyVersion: TelCurrencyVersion;
begin
  Result := FCurrencyVersion;
end;

// ---------------------------------------------------------------------------

function TClientLicence.GetDescription: string;
{
  ------------------------------------------------------------------------------
  Copied from licCDEntVersion() in X:\SBSLib\Win\ExCommon\LicFuncU, and amended.
  ------------------------------------------------------------------------------
}
begin
  if (elProductType in [ptLITECust, ptLITEAcct]) then
  begin
    { 1=LITE Customer, 2=LITE Accountant }
    Result := IfThen(elProductType = ptLITECust, '', 'Practice ') +
              IfThen(elCurrencyVersion = cvPro, 'S/C', 'M/C');

    case elModuleVersion of
      mvStock: Result := Result + ' Stk';
      mvSPOP : Result := Result + ' SOP';
    end;
  end
  else
  begin
    { Currency version + Core Modules }
    case elCurrencyVersion of
      cvPro   : Result := 'Prof';
      cvEuro  : Result := 'Euro';
      cvGlobal: Result := 'Global';
    else
      Result := 'Invalid';
    end;
  end;
end;

// ---------------------------------------------------------------------------

function TClientLicence.GetIsMultiCcy: Boolean;
begin
  Result := FIsMultiCcy;
end;

// ---------------------------------------------------------------------------

function TClientLicence.GetModules(
  Index: TelEntModuleEnum): TelModuleReleaseStatus;
begin
  Result := FModules[Index];
end;

// ---------------------------------------------------------------------------

function TClientLicence.GetModuleVersion: TelModuleVersion;
begin
  Result := FModuleVersion;
end;

// ---------------------------------------------------------------------------

function TClientLicence.GetProductType: TelProductType;
begin
  Result := FProductType;
end;

// ---------------------------------------------------------------------------

procedure TClientLicence.LoadLicencing;
var
  Inifile: TInifile;
  Module: TelEntModuleEnum;
  ID: string;
  FileName: string;
begin
  FileName := IncludeTrailingPathDelimiter(SetDrive) + cICEFOLDER + '\ICETrack.dat';
  EnableFile(FileName, True);
  Inifile := TInifile.Create(FileName);
  try
    { Read basic licence/product details. }
    FCurrencyVersion := TelCurrencyVersion(Inifile.ReadInteger('VERSION', 'CurrencyVersion', 0));
    FModuleVersion   := TelModuleVersion(Inifile.ReadInteger('VERSION', 'ModuleVersion', 0));
    FProductType     := TelProductType(Inifile.ReadInteger('VERSION', 'ProductType', 0));
    FIsMultiCcy      := (elCurrencyVersion > cvPro);

    { Read list of installed modules. }
    for Module := Low(TelEntModuleEnum) to High(TelEntModuleEnum) do
    begin
      ID := IntToStr(Ord(Module));
      if Inifile.ReadBool('MODULES', ID, False) then
        FModules[Module] := mrFull
      else
        FModules[Module] := mrNone;
    end;

  finally
    Inifile.Free;
    EnableFile(FileName, False);
  end;
end;

// ---------------------------------------------------------------------------

end.

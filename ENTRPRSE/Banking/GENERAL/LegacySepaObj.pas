unit LegacySepaObj;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{This is a class which adds in some basic sepa functionality for validating BIC & IBAN. Classes which implement
legacy formats which have been tweaked to allow Sepa should descend from this class and override the WriteRec
method.}
interface

{$H-}

uses
  CustAbsU, NatW01, ExpObj, BaseSEPAExportClass;

type
  TLegacySepaObject = Class(TExportObject)
  protected
    FSepaObject : TBaseSEPAExportClass; //Use for validating BIC & IBAN
    function FormatDate(const ADate : string) : string;
  public
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils, EtDateU;

const
  Filler3 = ',,,';
  Filler5 = ',,,,,';


{ TLegacyObject }


constructor TLegacySepaObject.Create;
begin
  inherited;
  FSepaObject := TBaseSEPAExportClass.Create;
  FSepaObject.Log := Log;
  FSepaObject.LogPath := LogPath;
end;

destructor TLegacySepaObject.Destroy;
begin
  FSepaObject.LogPath := '';
  FSepaObject.Free;
  inherited;
end;

function TLegacySepaObject.FormatDate(const ADate: string): string;
//Convert from yyyymmdd to ddmmyyyy
begin
  Result := Copy(ADate, 7, 2) +
            Copy(ADate, 5, 2) +
            Copy(ADate, 1, 4);
end;

//Call functions on SEPA object to validate BIC/IBAN
function TLegacySepaObject.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  //Call GetEventData on SEPA object to populate its ProcControl object
  FSepaObject.GetEventData(EventData);
  Result := FSepaObject.ValidateRec(EventData);
  if not Result then
    failed := flBank;
end;

function TLegacySepaObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  //PR: 06/12/2013 ABSEXCH-14795 Pass sortcode & account to sepa object
  FSepaObject.UserBankSort := UserBankSort;
  FSepaObject.UserBankAcc := UserBankAcc;
  Result := FSepaObject.ValidateSystem(EventData);
  if not Result then
    Failed := flBank;
end;


end.

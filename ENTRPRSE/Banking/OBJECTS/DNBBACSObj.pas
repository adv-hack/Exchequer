unit DNBBACSObj;

interface

uses
  BaseSepaExportClass, BacConst, CustAbsU, XmlConst, IniFiles;

type
  TDNBBACSExportObject = Class(TBaseSEPAExportClass)
  protected
    FIniFile : TIniFile;
    procedure CreateXMLHelper; override;
    function FillAddress(PD : PPaymentData; Target : TAbsCustomer4) : Boolean; override;
    function GetStreetLine(const Target : TAbsCustomer) : integer;
  public
    constructor Create;
    destructor Destroy; override;
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
  end;

implementation

uses
  DNBBACSCreditClass, SysUtils, ExpObj;

{ TDNBSepaExportObject }

constructor TDNBBACSExportObject.Create;
begin
  inherited;
  FIniFileName := 'DNBBacs.ini';
end;

procedure TDNBBACSExportObject.CreateXMLHelper;
begin
  FXML := TDNBBACSCreditClass.Create;
  FIniFile := TIniFile.Create(DataPath + FIniFilename);
end;

destructor TDNBBACSExportObject.Destroy;
begin
  FreeAndNil(FIniFile);
  inherited;
end;

function TDNBBACSExportObject.GetStreetLine(const Target : TAbsCustomer) : integer;
begin
  Result := FIniFile.ReadInteger('Street', Target.acCode, -1);

  if Result = -1 then
    Result :=  FIniFile.ReadInteger('Street', 'Default', 1);
end;


function TDNBBACSExportObject.FillAddress(PD: PPaymentData; Target : TAbsCustomer4) : Boolean;
begin
  Result := True;
  with Target do
  begin
    PD.Street := acAddress[GetStreetLine(Target)];
    PD.Town := acAddress[4];
    PD.PostCode := acPostCode;
    PD.Country := 'GB';
  end;
end;


//Standard BACS validation
function TDNBBACSExportObject.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  TempStr : string;
  Target : TAbsCustomer;
begin
  Result := True;
  GetEventData(EventData);
  with EventData do
  begin
    Target := GetTarget(EventData);

    TempStr := Target.acBankAcc;
    if (Length(TempStr) <> DefaultACLength) or not AllDigits(TempStr) then
    begin
      Result := False;
      LogIt(Target.acCompany + ': Invalid account - ' + TempStr);
    end;
    TempStr := FormatSortCode(Target.acBankSort);
    if (Length(TempStr) <> DefaultSortLength) or not AllDigits(TempStr) then
    begin
      LogIt(Target.acCompany + ': Invalid sort code - ' + TempStr);
      Result := False;
    end;

    if (Trim(Target.acAddress[GetStreetLine(Target)]) = '') or (Trim(Target.acAddress[4]) = '')
        or (Trim(Target.acPostCode) = '') then
    begin
      Result := False;
      Failed := flAddress;
    end;
  end; {with EventData}
end;

end.

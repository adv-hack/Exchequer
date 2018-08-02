unit HSBCMT103PPXMLObj;

//------------------------------------------------------------------------------
//HV 09/05/2018 2018-R1.1 ABSEXCH-20015: Thomas Pink - HSBC-MT103 Priority Payments (XML Foramt)
//------------------------------------------------------------------------------

interface

uses
  BaseSEPAExportClass, BacConst, XmlConst, CustAbsU, SysUtils;

type

  THSBCMT103PPXMLExportObject = Class(TBaseSEPAExportClass)
  private
    function GetCompanyCountryCode(Const ACode: String): String;
    procedure GetDebtorsDataFromIni(const EventData: TAbsEnterpriseSystem);
  protected
    FCompanyCntryCode: String;
    procedure InitialiseXMLHelper(const EventData: TAbsEnterpriseSystem); override;
    procedure CreateXMLHelper; override;
    function FillAddress(PD: PPaymentData; Target: TAbsCustomer4):Boolean; override;
    function ReadIniFile: Boolean; override;
    function ValidateBIC(Const BIC: String): Boolean; override;
    function ValidateIBAN(Const IBAN: String): Boolean; override;
  public
    constructor Create;
  end;

implementation

uses
  HSBCMT103PPCreditXML, FileUtil, CountryCodes, CountryCodeUtils, ExpObj, IniFiles;

//------------------------------------------------------------------------------
{ THSBCMT103PPXMLExportObject }
//------------------------------------------------------------------------------

constructor THSBCMT103PPXMLExportObject.Create;
begin
  inherited;
end;

//------------------------------------------------------------------------------

procedure THSBCMT103PPXMLExportObject.CreateXMLHelper;
begin
  inherited;
  FXML := THSBCMT103PPCredit.Create;
end;

//------------------------------------------------------------------------------

function THSBCMT103PPXMLExportObject.FillAddress(PD: PPaymentData; Target: TAbsCustomer4): Boolean;
begin
  Result := True;
  with Target do
  begin
    PD.Street := SEPASafe(Trim(acAddress[1]));
    PD.BuildingNo := SEPASafe(Trim(acAddress[2]));
    PD.PostCode := SEPASafe(Trim(acPostCode));
    PD.Town := SEPASafe(Trim(acAddress[4]));
    PD.CtrySubDvsn := CountryCodeName(ifCountry2, Trim(TAbsCustomer8(Target).acCountry));
    PD.Country := TAbsCustomer8(Target).acCountry; 
    PD.Ref := Copy(SEPASafe(Trim(Target.acBankRef)), 1, 35);
  end;
end;

//------------------------------------------------------------------------------

function THSBCMT103PPXMLExportObject.GetCompanyCountryCode(Const ACode: String): String;
begin
  Result := DefaultCountryCode(ACode);
end;

//------------------------------------------------------------------------------

procedure THSBCMT103PPXMLExportObject.GetDebtorsDataFromIni(const EventData: TAbsEnterpriseSystem);
begin
  with TIniFile.Create(GetEnterpriseDirectory + 'HSBCMT103PP.ini') do
  try
    // Company Country Code Read from INI Files and used in XML format
    // If INI File not in location then used from General Settings;
    FXML.CompanyCountry := ReadString('Company', 'Country', GetCompanyCountryCode(EventData.Setup.ssUSRCntryCode));

    FXML.CompanyName := ReadString('Debtors Address', 'Debtor Name', '');
    FXML.CommpanyAddr[1] := ReadString('Debtors Address', 'Street Name', '');
    FXML.CommpanyAddr[2] := ReadString('Debtors Address', 'Building Number', '');
    FXML.CommpanyAddr[3] := ReadString('Debtors Address', 'Post Code', '');
    FXML.CommpanyAddr[4] := ReadString('Debtors Address', 'Town Name', '');
    FXML.CommpanyAddr[5] := ReadString('Debtors Address', 'Country/State/Region', '');
  finally
    Free;
  end;
end;

procedure THSBCMT103PPXMLExportObject.InitialiseXMLHelper(const EventData: TAbsEnterpriseSystem);
begin
  inherited InitialiseXMLHelper(EventData);
  FXML.OriginatorTag := Copy(SEPASafe(Trim(UserBankRef)), 1, 35);
  GetDebtorsDataFromIni(EventData);
end;

//------------------------------------------------------------------------------
//For this BACS we don't need to use UserID so we can ignore the UserID validations from INI file
function THSBCMT103PPXMLExportObject.ReadIniFile: Boolean;
begin
  Result := True;
end;

//------------------------------------------------------------------------------

function THSBCMT103PPXMLExportObject.ValidateBIC(Const BIC: String): Boolean;
begin
  //BIC must be either 8 or 11 chars
  Result := (Length(Trim(BIC)) = 6) and (AllDigits(BIC)) ;
end;

//------------------------------------------------------------------------------

function THSBCMT103PPXMLExportObject.ValidateIBAN(Const IBAN: String): Boolean;
begin
  //BIC must be either 8 or 11 chars
  Result := (Length(Trim(IBAN)) = 8) and (AllDigits(IBAN)) ;
end;

//------------------------------------------------------------------------------

end.

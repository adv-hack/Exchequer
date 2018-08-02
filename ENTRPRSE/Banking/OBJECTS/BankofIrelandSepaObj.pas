unit BankofIrelandSepaObj;

interface

uses
  BaseSEPAExportClass, BacConst, CustAbsU;

type

  TBankofIrelandSepaExportObject = Class(TBaseSEPAExportClass)
  protected
    procedure InitialiseXMLHelper(const EventData : TAbsEnterpriseSystem); override;
  public
    constructor Create;
  end;

implementation

uses
  XmlConst;

{ TBankofIrelandSepaExportObject }

constructor TBankofIrelandSepaExportObject.Create;
begin
  inherited;
  FIniFileName := BI_SEPA_INI;
end;

procedure TBankofIrelandSepaExportObject.InitialiseXMLHelper(const EventData : TAbsEnterpriseSystem);
begin
  inherited InitialiseXMLHelper(EventData);
  FXML.OriginatorTag := XML_PRIVATE_ID;
end;

end.

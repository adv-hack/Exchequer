unit BankOfAmericaSepaObj;

interface

uses
  BaseSepaExportClass, BacConst, CustAbsU;

type
  TBankofAmericaSepaExportObject = Class(TBaseSEPAExportClass)
  protected
    procedure CreateXMLHelper; override;
  public
    constructor Create;
  end;

implementation

uses
  BankofAmericaSepaCreditClass, SepaDebitClass;

{ TBankofAmericaSepaExportObject }

constructor TBankofAmericaSepaExportObject.Create;
begin
  inherited;
  FIniFileName := BOA_SEPA_INI;
end;

procedure TBankofAmericaSepaExportObject.CreateXMLHelper;
begin
  if IsReceipt then
    FXML := TSepaDebitClass.Create
  else
    FXML := TBankofAmericaSepaCreditClass.Create;
end;

end.

unit AbnSepaObj;

interface

uses
  BaseSepaExportClass, BacConst, CustAbsU;

type
  TABNSepaExportObject = Class(TBaseSEPAExportClass)
  protected
    procedure CreateXMLHelper; override;
  public
    constructor Create;
  end;

implementation

uses
  AbnSepaCreditClass, AbnSepaDebitClass;

{ TABNSepaExportObject }

constructor TABNSepaExportObject.Create;
begin
  inherited;
  FIniFileName := ABN_SEPA_INI;
end;

procedure TABNSepaExportObject.CreateXMLHelper;
begin
  if IsReceipt then
    FXML := TAbnSepaDebitClass.Create
  else
    FXML := TAbnSepaCreditClass.Create;
end;

end.

unit HSBCSepaObj;

interface

uses
  BaseSepaExportClass, BacConst, CustAbsU;

type
  THSBCSepaExportObject = Class(TBaseSEPAExportClass)
  protected
    procedure CreateXMLHelper; override;
  public
    constructor Create;
  end;

implementation

uses
  HSBCSepaCreditClass, SepaDebitClass;

{ THSBCSepaExportObject }

constructor THSBCSepaExportObject.Create;
begin
  inherited;
  FIniFileName := HSBC_SEPA_INI;
end;

procedure THSBCSepaExportObject.CreateXMLHelper;
begin
  if IsReceipt then
    FXML := TSepaDebitClass.Create
  else
    FXML := THSBCSepaCreditClass.Create;
end;

end.

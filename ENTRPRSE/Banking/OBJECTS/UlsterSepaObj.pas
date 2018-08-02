unit UlsterSepaObj;

interface

uses
  BaseSEPAExportClass, BacConst;

type
  TUlsterSepaExportObject = Class(TBaseSEPAExportClass)
  protected
    procedure CreateXMLHelper; override;
  public
    constructor Create;
  end;

implementation

{ TUlsterSepaExportObject }
uses
  UlsterSepaCreditXML, UlsterSEPADebitClass;


constructor TUlsterSepaExportObject.Create;
begin
  inherited;
  FIniFileName := ULSTER_SEPA_INI;
end;

procedure TUlsterSepaExportObject.CreateXMLHelper;
begin
  if IsReceipt then
    FXML := TUlsterSEPADebitClass.Create
  else
    FXML := TUlsterSEPACreditClass.Create;
end;

end.

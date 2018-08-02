unit DanskeSepaObj;

interface

uses
  BaseSEPAExportClass, BacConst;

type
  TDanskeSepaExportObject = Class(TBaseSEPAExportClass)
  protected
    procedure CreateXMLHelper; override;
  public
    constructor Create;
  end;

implementation

uses
  DanskeSepaCreditClass, DanskeSEPADebitClass;

{ TAibSepaExportObject }

constructor TDanskeSepaExportObject.Create;
begin
  inherited;
  FIniFileName := DANSKE_SEPA_INI;
end;

procedure TDanskeSepaExportObject.CreateXMLHelper;
begin
  if IsReceipt then
    FXML := TDanskeSEPADebitClass.Create
  else
    FXML := TDanskeSEPACreditClass.Create;
end;

end.

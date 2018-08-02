unit UniSepaObj;

interface

uses
  BaseSepaExportClass, BacConst, CustAbsU, ABNSepaObj;

type
  TUniSepaExportObject = Class(TBaseSEPAExportClass)
  protected
    procedure CreateXMLHelper; override; //PR: 12/12/2013 ABSEXCH-14850 Changed from InitialiseXMLHelper
  public
    constructor Create;
  end;

implementation

uses
  UniSepaCreditClass, UniSepaDebitClass;

constructor TUniSepaExportObject.Create;
begin
  inherited;
  FIniFileName := UNI_SEPA_INI;  //PR: 09/12/2013 ABSEXCH-14850 Added specific ini file.
end;

procedure TUniSepaExportObject.CreateXMLHelper;
begin
  if IsReceipt then
    FXML := TUniSepaDebitClass.Create
  else
    FXML := TUniSepaCreditClass.Create;

end;

end.

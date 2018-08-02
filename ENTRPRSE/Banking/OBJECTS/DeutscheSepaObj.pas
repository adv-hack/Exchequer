unit DeutscheSepaObj;

interface

uses
  BaseSEPAExportClass, BacConst, CustAbsU;

type
  TDeutscheSepaObject = Class(TBaseSEPAExportClass)
  protected
    function ReadIniFile : boolean; override;
    procedure CreateXMLHelper; override;
  end;

implementation

uses
  DeutscheSepaCreditClass;

{ TDeutscheSepaObject }

procedure TDeutscheSepaObject.CreateXMLHelper;
begin
  FXML := TDeutscheSEPACreditClass.Create;
end;

function TDeutscheSepaObject.ReadIniFile: boolean;
begin
  Result := True; //No user id
end;

end.

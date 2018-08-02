unit AibSepaObj;

interface

uses
  BaseSEPAExportClass, BacConst;

type
  TAibSepaExportObject = Class(TBaseSEPAExportClass)
  public
    constructor Create;
  end;

implementation

{ TAibSepaExportObject }

constructor TAibSepaExportObject.Create;
begin
  inherited;
  FIniFileName := AIB_SEPA_INI;
end;

end.

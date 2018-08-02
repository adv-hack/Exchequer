unit SetupSec;

interface

uses
  SetupU;

function CheckSecurity(var DLLParams: ParamRec): LongBool; StdCall; export;

implementation
uses
  LicRec, LicUtil;

function CheckSecurity(var DLLParams: ParamRec): LongBool;
Begin { WorkStationSetup }
  SetVariable(DLLParams,'LICRESULT','FALSE');
  case GetModuleLicence(modTrade) of
    luLicenced : SetVariable(DLLParams,'LICRESULT','TRUE');
    luNotLicenced : ShowNotLicencedMessage('Trade Counter');
    luError : ShowLicenceErrorMessage('Trade Counter');
  end;{case}
End; { WorkStationSetup }


end.


end.

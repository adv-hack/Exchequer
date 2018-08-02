{-----------------------------------------------------------------------------
 Unit Name: uGetBtrieveDetail
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
unit uGetBtrieveDetail;

interface


uses Windows, Sysutils, Classes, PervInfo, SetupU;



function SCD_GetBtrieveDetails (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{-----------------------------------------------------------------------------
  Procedure: SCD_GetBtrieveDetails
  Author:    vmoura

  get the btrieve detail
-----------------------------------------------------------------------------}
function SCD_GetBtrieveDetails (var DLLParams: ParamRec): LongBool;
var
  lBTR: IPervasiveInfo;
begin
  lBTR := PervasiveInfo;

  SetVariable(DLLParams,'BTRINST',  inttostr(Ord(lBTR.BtrieveInstalled)));
  SetVariable(DLLParams,'BTRCLTINST', inttostr(ord(lbtr.ClientInstalled)));
  SetVariable(DLLParams,'BTRSRVINST', inttostr(ord(lbtr.ServerInstalled)));

  SetVariable(DLLParams,'BTRWKGINST', inttostr(ord(lbtr.WorkgroupInstalled)));
  SetVariable(DLLParams,'BTRWKGVER', inttostr(ord(lbtr.WorkgroupVersion)));

  lBTR := nil;
end;

end.
